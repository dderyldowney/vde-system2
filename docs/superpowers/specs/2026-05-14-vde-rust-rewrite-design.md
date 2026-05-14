# vde-system2 Rust Rewrite — Design Specification
<!-- @forge (Implementation Design Specification) -->

**Date**: 2026-05-14
**Status**: Approved
**Author**: dderyldowney + Claude Code

---

## 1. Purpose and Goal

A full parity rewrite of `vde-system` from zsh to Rust. The goal is **operational parity** — the same `vde` commands produce the same behavior and the same user experience. The internal code structure will differ completely from the zsh original; that is expected and intentional.

This project is also explicitly a **learning vehicle**. The author is learning Rust through this implementation, using Python as their primary reference language. Every implementation session will explain Rust syntax and semantics as new concepts appear, using Python analogies.

**Source of truth (read-only)**: `~/Documents/GitHub/dderyldowney/vde-system`
**Rust project**: `~/Documents/GitHub/dderyldowney/vde-system2`

---

## 2. Development Environment

All implementation work happens from inside the VDE Rust container — dogfooding the original system.

- **Source (read-only)**: `~/VDE/projects/rust/vde-system`
- **Rust project**: `~/VDE/projects/rust/vde-system2`
- **Enter container**: `vde enter rust` (SSH port 2219, VDE_ROOT `~/VDE`)
- **Inside container**: workspace is at `~/workspace/`, synced to `~/VDE/projects/rust/` on the host

---

## 3. Project Structure

A Cargo workspace with two crates. This is the standard professional layout for a Rust CLI tool of this size.

```text
vde-system2/
├── Cargo.toml                  ← workspace root
├── crates/
│   ├── vde-lib/                ← all library logic as modules
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── registry/       ← data model + JSON loading (START HERE)
│   │       │   ├── mod.rs
│   │       │   ├── types.rs    ← VmKind, VmType structs
│   │       │   └── load.rs     ← Registry, deserialization, HashMap index
│   │       ├── errors.rs       ← thiserror error types
│   │       ├── constants.rs    ← ports, paths, version strings
│   │       ├── naming.rs       ← container/image naming conventions
│   │       ├── docker/         ← bollard-based Docker operations
│   │       ├── ssh/            ← russh-based SSH operations
│   │       ├── health/         ← health checks
│   │       └── core/           ← lifecycle commands (init, create, rebuild…)
│   └── vde/                    ← binary — arg parsing and command routing only
│       ├── Cargo.toml
│       └── src/
│           └── main.rs
├── data/
│   ├── vm-types.json           ← cleaned-up registry (arrays, not strings)
│   └── vm-types.schema.json    ← updated JSON Schema (bundled with binary at runtime via include_str!)
├── tests/                      ← Behave end-to-end / Proof of Life suite
└── docs/
    └── superpowers/
        └── specs/
            └── 2026-05-14-vde-rust-rewrite-design.md  ← this file
```

### Why two crates instead of many?

Professional Rust CLI tools (ripgrep, bat, fd) use one library crate plus one binary crate. Many-crate workspaces are for frameworks that publish individual pieces to crates.io. For an application, a single `vde-lib` with Rust modules inside gives the same logical separation without the overhead of crate boundary APIs.

---

## 4. Crate Stack

| Crate | Version policy | Purpose |
| --- | --- | --- |
| `clap` (derive feature) | latest stable | CLI parsing — subcommands, flags, `--help`, `--version` |
| `tokio` (full features) | latest stable | Async runtime — Docker and SSH are inherently I/O-bound |
| `bollard` | latest stable | Docker Engine API (replaces vde-docker) |
| `serde` + `serde_json` | latest stable | JSON deserialization of vm-types.json |
| `jsonschema` | latest stable | Validate vm-types.json against vm-types.schema.json at startup (registry load time) |
| `thiserror` | latest stable | Typed error enum definitions in vde-lib |
| `error-stack` | latest stable | Rich error reports with context chain — replaces anyhow |
| `tracing` + `tracing-subscriber` | latest stable | Structured logging (replaces vde-log) |
| `russh` | latest stable | Async SSH, pure Rust, tokio-native (replaces vde-ssh) |
| `dirs` | latest stable | XDG-compliant home/config path resolution |

`anyhow` is **not** used — `error-stack` covers that role with better context chaining.

---

## 5. Data Model

### 5.1 JSON format changes from vde-system

The original `vm-types.json` used empty strings where proper types belong — a zsh artifact. The new format uses correct JSON types throughout.

| Field | Old format | New format |
| --- | --- | --- |
| `pkgs` | `""` or `"pkg1 pkg2"` | `[]` or `["pkg1", "pkg2"]` |
| `service_ports` | `""` or `"80,443"` | `[]` or `[80, 443]` |
| `custom_cmd` | `"zsh /vde/scripts/setup/python-init.zsh"` | renamed `setup_script: "scripts/setup/python-init.zsh"` |
| VM kind | implicit (which array) | explicit `kind` field on struct, set at load time |

The `vm-types.conf` pipe-delimited file is **not carried forward**. It was a zsh workaround for the inability to parse JSON natively. In Rust, `serde_json` handles JSON directly.

### 5.2 Rust structs

```rust
// In crates/vde-lib/src/registry/types.rs

pub enum VmKind {
    Language,   // ssh_port 2200-2399
    Service,    // ssh_port 2400-2499
}

pub struct VmType {
    pub kind:          VmKind,
    pub name:          String,           // "vde-python"
    pub aliases:       Vec<String>,      // ["py", "python3"]
    pub display:       String,           // "Python"
    pub pkgs:          Vec<String>,      // [] or ["python3-pip"]
    pub setup_script:  Option<PathBuf>,  // Some("scripts/setup/python-init.zsh")
    pub service_ports: Vec<u16>,         // [] or [80, 443]
    pub ssh_port:      u16,              // 2217
}
```

### 5.3 Registry (runtime lookup structure)

```rust
// In crates/vde-lib/src/registry/load.rs

pub struct Registry {
    pub version: String,
    vms:         Vec<VmType>,           // owned storage
    by_alias:    HashMap<String, usize>, // alias/name → index into vms
}
```

The `by_alias` index is built once at load time. Every alias for every VM — plus the canonical `name` — gets an entry. Lookups for `"py"`, `"python3"`, or `"vde-python"` all resolve in O(1) with no iteration.

Public API:

```rust
registry.get("py")       // → Option<&VmType>
registry.all()           // → &[VmType]
registry.language_vms()  // → impl Iterator<Item = &VmType>
registry.service_vms()   // → impl Iterator<Item = &VmType>
```

---

## 6. Error Handling

Two-layer error strategy, standard in professional Rust:

- `thiserror` in `vde-lib` defines typed error enums (e.g., `RegistryError::InvalidPort`, `DockerError::ContainerNotFound`)
- `error-stack` wraps errors in `Report<E>` with context chain — each layer adds context before propagating

Example of what this produces when something goes wrong:

```text
failed to start container
├─ caused by: port 2217 is already bound
└─ context: starting vde-python (ssh_port=2217)
   └─ context: handling `vde start python`
```

This replaces both `vde-errors` and `anyhow`.

---

## 7. Testing Strategy

Three layers, matching professional Rust practice:

### Unit tests

Live inside the source file in a `#[cfg(test)]` block. Only compiled when running `cargo test` — stripped from release builds automatically. Test individual functions and pure logic.

```rust
// at the bottom of types.rs
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn language_vm_has_no_service_ports() { ... }
}
```

### Integration tests

Live in `crates/vde-lib/tests/`. Can only see the public API of `vde-lib` — enforces good API design. Test the registry load, alias resolution, schema validation.

### End-to-end / Proof of Life

The existing Behave BDD suite from `vde-system/tests/features/` is copied to `vde-system2/tests/` and run against the Rust binary. This is the Proof of Life contract — it tests CLI behavior at the boundary, language-agnostic.

### TDD discipline (Mandate 14)

Write a failing test first. Run it to see it fail (Red). Implement until it passes (Green). Refactor while keeping it green. No exceptions.

---

## 8. Code Quality Gates

Enforced at the workspace level in `Cargo.toml`. Every crate inherits these automatically:

```toml
[workspace.lints.rust]
missing_docs    = "warn"
unused_imports  = "deny"

[workspace.lints.clippy]
all      = "warn"
pedantic = "warn"
```

- `cargo fmt` — formatting (non-negotiable, no style debates)
- `cargo clippy --deny warnings` — CI gate, no warnings merge
- `cargo test` — all unit + integration tests pass
- `#[allow(clippy::...)]` requires a written comment explaining why, or the code gets fixed instead

The compiler's suggestions are treated as design feedback (per the Bidirectional Feedback principle) — when `rustc` or `clippy` pushes back, that is information about the design, not just noise to suppress.

---

## 9. Development Workflow

Follows the Strike Protocol from the original vde-system governance, adapted for the Rust project:

1. `gh issue create` — Signet (open an issue before any implementation)
2. `git checkout -b feat/<slug>` from `develop`
3. Write failing test first (TDD)
4. Implement until test passes
5. `cargo fmt && cargo clippy` — must be clean
6. `gh pr create` — Chronicle
7. Wait for explicit approval before merging

Commit messages follow Conventional Commits: `feat(registry):`, `fix(docker):`, `chore(deps):`, etc.

Branch strategy mirrors the original: `main` (production) ← `stable` ← `develop` ← feature branches.

---

## 10. Conversion Order

Work proceeds bottom-up through the dependency graph, starting with the data layer:

1. **Workspace scaffold** — `Cargo.toml`, both crate skeletons, workspace lints
2. **Data model** — `VmKind`, `VmType` structs with serde derives
3. **Registry loader** — JSON deserialization, schema validation, HashMap index
4. **Errors** — `thiserror` error types, `error-stack` integration
5. **Constants** — ports, paths, version strings
6. **Naming** — container/image name generation
7. **Docker** — bollard-based lifecycle operations (create, start, stop, remove)
8. **SSH** — russh-based entry and key management
9. **Health** — health checks, status reporting
10. **Core** — lifecycle command implementations (init, create, rebuild, enter, …)
11. **CLI binary** — clap subcommands wiring core operations to the terminal
12. **Proof of Life** — Behave suite green against the Rust binary

Each step: write failing tests → implement → clippy clean → PR.

---

## 11. What Is Not Carried Forward

| zsh artifact | Reason dropped |
| --- | --- |
| `vm-types.conf` (pipe-delimited) | Zsh workaround — `serde_json` handles JSON natively |
| `lib/vde-shell-compat` | Zsh compatibility shims — irrelevant in Rust |
| `lib/vde-function-trace` | Zsh function tracing — replaced by `tracing` spans |
| `lib/vde-pulse.zsh` | Zsh-specific heartbeat — reimplemented in async Rust |
| `bin/vde-enforce-uap.zsh` | Shebang/sleep enforcement — `cargo clippy` fills this role |
| `bin/check-zsh-shebang.zsh` | Not applicable to Rust |
| Shebang lines (`#!/usr/bin/env zsh`) | Not applicable to compiled binaries |

---

*Spec written: 2026-05-14*
*Next step: invoke writing-plans skill to create the implementation plan*
