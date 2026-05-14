# VDE Memory: Standing Watch
# @shared-law (Forge Component)

## SOVEREIGN BASELINE: 2.0.0 (PRE-RELEASE)
- vde-system2 is the complete Rust rewrite of vde-system (zsh), starting at version 2.0.0.
- vde-system 1.x (zsh) remains the active production line at version 1.5.5.
- Proof of Life: NOT YET CERTIFIED — Rust implementation in progress.
- **develop HEAD**: Bootstrap commit (governance framework established)

## BRANCHING MODEL (CRITICAL — MEMORIZE)
| Branch | Purpose | Users Clone? |
|--------|---------|--------------|
| `main` | Official releases only (immutable, frozen at release) | NO |
| `stable` | Official release + patches/updates (most current stable) | **YES** |
| `develop` | Bug fixes and new feature work | NO |

**Flow:** `develop` → `stable` → `main`

## INSTALLATION (ONCE FUNCTIONAL)
```bash
git clone -b stable https://github.com/dderyldowney/vde-system2.git VDE2
cd VDE2
cargo build --release
```

## CONVERSION ORDER (Bottom-Up)
1. ✅ Workspace scaffold (Cargo.toml, crate skeletons)
2. 🔲 Data model (VmKind, VmType structs)
3. 🔲 Registry loader (JSON deserialization, schema validation, HashMap index)
4. 🔲 Errors (thiserror + error-stack)
5. 🔲 Constants
6. 🔲 Naming
7. 🔲 Docker (bollard)
8. 🔲 SSH (russh)
9. 🔲 Health
10. 🔲 Core (lifecycle commands)
11. 🔲 CLI binary (clap)
12. 🔲 Proof of Life (Behave suite)

## DEVELOPER CONTEXT
- User is learning Rust through this project. Python is the primary reference language.
- Always explain Rust concepts with Python analogies.
- Go slow. Explain every new concept as it appears.
- Never assume prior Rust knowledge.
