//! Execute the locked Wire generator/runtime against independently declared JS values.

use super::*;
use crate::wire::serde_tests::{Report, reports};
use ic_wire::typescript::{RUNTIME, generate_payload_registry, native_schema, payload_limits};
use serde_json::json;
use std::{collections::BTreeMap, fs, path::Path, process::Command, string::String, vec::Vec};

const LIMITS: Limits = Limits {
    bytes: 4096,
    allocation: 65536,
    nodes: 2048,
    depth: 16,
};

#[test]
#[ignore = "requires the pinned Node runtime; run make typescript-check"]
fn generated_codecs_round_trip_between_rust_and_typescript() {
    let selected_node = std::env::var("IC_METRICS_NODE_VERSION")
        .expect("run make typescript-check to select ci/node-version.txt");
    let version = Command::new("node")
        .arg("--version")
        .output()
        .expect("prepare Node from ci/node-version.txt; see docs/hosts.md");
    assert!(version.status.success());
    assert_eq!(
        std::str::from_utf8(&version.stdout).unwrap().trim(),
        std::format!("v{}", selected_node.trim())
    );

    // Retain inputs, generated runtime and JS output on both success and failure.
    let directory =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("../../target/typescript-conformance");
    fs::create_dir_all(&directory).unwrap();
    fs::write(directory.join("wire-runtime.ts"), RUNTIME).unwrap();
    let mut metadata = payload_limits(LIMITS).unwrap();
    metadata["name"] = json!("MetricsReport");
    metadata["schema"] = native_schema::<Report>().unwrap();
    let generated = generate_payload_registry(
        &BTreeMap::new(),
        &[metadata],
        "./wire-runtime.ts",
        &BTreeMap::new(),
        |_| {},
    )
    .unwrap();
    fs::write(directory.join("reports.ts"), generated).unwrap();
    check_types(&directory);
    fs::write(
        directory.join("check.mjs"),
        include_str!("browser/check.mjs"),
    )
    .unwrap();
    let reports = reports();
    let cases: Vec<_> = reports
        .iter()
        .map(|(name, report)| {
            json!({"name": name, "bytes": native::encode(report, LIMITS).unwrap()})
        })
        .collect();
    fs::write(
        directory.join("rust.json"),
        serde_json::to_vec(&cases).unwrap(),
    )
    .unwrap();
    // A failed/partial run must not reuse output from an earlier execution.
    let output = directory.join("typescript.json");
    if output.exists() {
        fs::remove_file(&output).unwrap();
    }
    run_logged(
        Command::new("node")
            .args(["--experimental-transform-types", "check.mjs"])
            .current_dir(&directory),
        &directory,
        "node",
        "TypeScript conformance",
    );
    let encoded: Vec<Vec<u8>> = serde_json::from_slice(&fs::read(output).unwrap()).unwrap();
    assert_eq!(encoded.len(), reports.len());
    for ((name, report), bytes) in reports.iter().zip(encoded) {
        assert_eq!(
            native::decode::<Report>(&bytes, LIMITS).unwrap(),
            *report,
            "{name}"
        );
        assert_eq!(bytes, native::encode(report, LIMITS).unwrap(), "{name}");
    }
}

// Qualify the generated public client separately from runtime byte conformance.
fn check_types(directory: &Path) {
    let compiler = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../ci/typescript/node_modules/typescript/bin/tsc");
    assert!(
        compiler.is_file(),
        "prepare the locked TypeScript tools with npm ci --prefix ci/typescript"
    );
    fs::write(
        directory.join("consumer.ts"),
        include_str!("browser/consumer.ts"),
    )
    .unwrap();
    fs::write(
        directory.join("tsconfig.json"),
        include_str!("browser/tsconfig.json"),
    )
    .unwrap();
    run_logged(
        Command::new("node")
            .arg(compiler)
            .arg("--project")
            .arg(directory.join("tsconfig.json")),
        directory,
        "tsc",
        "generated Metrics client type check",
    );
}

fn run_logged(command: &mut Command, directory: &Path, name: &str, description: &str) {
    let checked = command.output().unwrap();
    fs::write(
        directory.join(std::format!("{name}.stdout")),
        &checked.stdout,
    )
    .unwrap();
    fs::write(
        directory.join(std::format!("{name}.stderr")),
        &checked.stderr,
    )
    .unwrap();
    assert!(
        checked.status.success(),
        "{description} failed: {}\n{}",
        String::from_utf8_lossy(&checked.stdout),
        String::from_utf8_lossy(&checked.stderr)
    );
}
