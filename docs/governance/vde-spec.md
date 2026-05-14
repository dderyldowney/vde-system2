# VDE-SPEC
# @shared-law (Sovereign Law)
# VDE-SPEC 2.0.0 (The Rust Rewrite)

**Date**: 2026-05-14
**Status**: PRE-RELEASE — Proof of Life not yet certified
**Reference**: ARCHITECTURE 2.0.0
**Identity**: The Covert

## 1. Absolute Mandates (The Rule Spine & The Gospel)

- **The Mandalorian Code**: The VDE is a Mandalorian Forge. All agents operate as Mandalorian Armorer-Architects, bound by the **Creed** and the **Contract**. This is the Supreme Law.
- **The Sovereign Charter (The Law of the Two Projects)**: The VDE ecosystem is architected as two distinct projects, as codified in `docs/governance/sovereign-charter.md`:
    1. **Project 1: The Armor (`@armor`)**: The physical VDE Engine product. AI-blind and Hub-blind. Written in Rust. Responsible for container orchestration, SSH bridges, and the core VM registry.
    2. **Project 2: The Forge (`@forge`)**: The universal Development AI-Governance system. Enforces the Rule Spine, handles the GitHub lifecycle, and executes BDD verification tests.
- **The Unyielding Tetrad (The System Spine)**: Empirically verify the four core pillars before any mission ignition:
    1. **Pillar I: Rust** (The Voice) — `rustc`, `cargo`, `clippy`, `rustfmt` present and functional.
    2. **Pillar II: Git** (The Chronicler) — Minimum version 2.30. Enforces Conventional Commits.
    3. **Pillar III: Docker** (The World-Forge) — Version 20.10+. Manages Spoke lifecycles.
    4. **Pillar IV: SSH** (The Transversal Bridge) — Requires the `vde_student` identity active in the SSH agent.
- **The Proof of Life Contract (Mandate L)**: The Heartbeat. ALL Spokes must reliably execute: `init`, `create`, `rebuild`, `start`, `enter`, `stop`, `remove`, `add`, `uninstall`. Failure is a Protocol Blockade.
- **The Creed-frame**: The narrative fuel in `data/vde_core/` guides all thematic world-building.
- **The Gospel Authority**: The Sovereign Artifact Set (Section 3) is the Gospel of the Forge. These documents are the limiting, or expanding, decision makers on the WHAT and HOW of all creation.
- **The Use-Case Creed**: The Forge exists solely to serve the Foundlings (Students) and Reinforcements (New Hires). All technical work MUST improve their onboarding and educational experience.
- **The Mandate of Architectural Tagging**: ALL artifacts MUST be tagged on line 2 or 3 (@armor, @forge, or @shared-law). See `docs/governance/sovereign-charter.md` for syntax.
- **Language of the Tribe**: The Armor (`crates/`) is written in **Rust ONLY**. Forge tooling may use Zsh. Bash is forbidden everywhere.
- **The Quality Gate**: Every Rust change MUST pass `cargo fmt && cargo clippy --deny warnings && cargo test` before commit.
- **Registry Authority**: `data/vm-types.json` and `data/vm-types.schema.json` are the sole sources of truth. `vm-types.conf` is not carried forward.
- **Born Ready (BTO)**: Every container image MUST be fully functional at build time. No runtime `apt` calls.
- **The AI-Blind Runtime (Core Tenet)**: The Forge SHALL NOT be active during student runtime. The Armor must be 100% deterministic, autonomous, and AI-blind.
- **Pure Relative Pathing**: All artifacts MUST be executed relative to the project root to ensure portability.
- **The Rule of One**: This SPEC is the unique and absolute authority on the project version and Sovereign Artifact Set state.

## 2. Technical Inventory Control (SemVer)

- **Standard**: MAJOR.MINOR.STEP-spN (SemVer 2.0.0 compliant).
- **Current Version**: 2.0.0 (pre-release).
- **Versioning**: MAJOR/MINOR are user-decided architectural shifts. STEP represents incremental progress. spN is reserved for security patches.
- **Tagging Authority**: The agent is FORBIDDEN from creating, pushing, or proposing ANY git tags. Only the User decides version and release timing.
- **Chronicle Standard**: All commits MUST adhere to the **Conventional Commits** specification.

## 3. The Sovereign Artifact Set (The Gospel of the Forge)

Before any tag is struck, these documents MUST be in perfect agreement with the Forge state:
1. `docs/architecture/overview.md`
2. `docs/architecture/data-flow.md`
3. `docs/changelogs/current.md`
4. `docs/governance/vde-spec.md` (The Gospel Lead)
5. `USE_CASES.md`
6. `VDE_ANALYSIS.md`
7. `PROJECT_STATUS.md`
8. `docs/governance/sovereign-charter.md`
9. `docs/api/library-api.md`

## 4. The Sovereign Branching Strategy

1. **`main` (Production)**: Reserved for certified releases. GitHub Releases and version tags EXCLUSIVELY here.
2. **`stable`**: Last certified release plus patches. `develop` merges into `stable`.
3. **`develop` (The Anvil)**: Primary integration branch and repository default.
4. **Feature Branches**: All work on `feat/`, `fix/`, `chore/` branches from `develop`.
5. **The Ritual**: Every mission begins with a Signet (Issue) and ends with a Chronicle (PR).
6. **The Release Ritual**: `develop` → `stable` → `main`. Only `main` receives version tags.

## 5. The Chronicle Mandates (GitHub Workflow)

- **PR Title Validation**: All PRs MUST use Conventional Commit titles.
- **Unbreakable Link**: Every PR MUST be linked to its Issue using `Closes #N`.
- **Evidence Mandate**: PR body MUST include literal terminal output of successful `cargo test` runs.
- **Issue Bodies**: MUST document what is wrong (the Sovereign Reason).
- **PR Bodies**: MUST include (1) what was wrong, (2) the fix, (3) files involved.

## 6. Security & Infrastructure

- **Identity Isolation**: The `vde_student` SSH identity is confined to `~/.ssh/vde/`.
- **Static Guards**: Pre-commit hook verifies secret scanning and architectural tagging.
- **Pre-Push Gate**: `cargo test` must pass before any push.

---
Version: 2.0.0
**Status**: PRE-RELEASE
**Reference**: RESOL'NARE 2.0.0
---
