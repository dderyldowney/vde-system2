# SOVEREIGN CHARTER
<!-- @shared-law (Sovereign Law) -->
# VDE Sovereign Charter: The Law of the Two Projects

This Charter defines the dual-mission architecture of the VDE. It is the foundational covenant that ensures the absolute integrity of the product and its governed evolution.

---

## I. The Sovereign Architecture Definition

The VDE ecosystem is architected as two distinct projects that operate independently but work in hierarchical harmony.

### 1. Project 1: The Armor (The VDE Engine Product) — @armor
**The Armor** is the physical, student-facing product — the core engine that enables the Virtual Development Environment.

*   **Individual Use**: Providing a robust, isolated, and standardized CLI for "Foundlings" (students) to ignite development Spokes (VMs). It handles container orchestration, network isolation, and workspace management.
*   **Target**: **Specific**. It serves *this* project (VDE) and its specialized container requirements.
*   **Sovereign Dependencies**: Depends **exclusively** on the **Unyielding Tetrad** (Rust, Git, Docker, SSH).
*   **AI-Blindness**: Designed to be **AI-unaware** and **Hub-blind**. Must function perfectly without any Project 2 components or `gh` CLI access.
*   **Architectural Tag**: `@armor`

### 2. Project 2: The Forge (Development AI-Governance System) — @forge
**The Forge** is the universal development, auditing, and governance rig.

*   **Individual Use**: Enforcing the **Rule Spine** (Mandalorian Creed) and Mandates during the development lifecycle. It owns "GitHub Life" — managing Issues, PRs, CI/CD, and release synchronization.
*   **Target**: **Universal**. It serves **"Any Thing"** — protocols that could theoretically serve any project to ensure governed development.
*   **Core Tools**: Uses the **GitHub CLI (`gh`)** as its foundational binary. Includes all agent instructions, Forge rules, and CI workflows.
*   **Architectural Tag**: `@forge`

### 3. The Spinal Cord (The Foundation) — @shared-law
**The Spinal Cord** represents the shared files and foundational pillars both projects rely upon.
*   **Architectural Tag**: `@shared-law`

---

## II. Operational Modes

1.  **Armor Mode**: Activated by "We are in Armor mode". Focus switches to Project 1 (@armor) files and runtime requirements.
2.  **Forge Mode**: Activated by "We are in Forge mode". Focus is @forge and @shared-law only. Primary mission is still the Armor product — we touch Forge to better build Armor, not for its own sake.

---

## III. The Hierarchical Component Outline

*   **VDE Sovereign System**
    *   **Project 1: The Armor (@armor)**
        *   **Code (Library)**: `crates/vde-lib/` — registry, docker, ssh, health, naming, core modules.
        *   **Code (Binary)**: `crates/vde/` — CLI entry point (arg parsing and command routing only).
        *   **Data**: `data/vm-types.json`, `data/vm-types.schema.json`.
        *   **Docs**: `docs/operations/installation.md`, `docs/guides/getting-started.md`, `docs/guides/foundling-guide.md`.
        *   **Tests**: Unit tests in `#[cfg(test)]` blocks, integration tests in `crates/vde-lib/tests/`.
        *   **Rituals**: Engine Ignition (`vde init`), Spoke Smelting (`vde rebuild`), Transversal Bridge (`vde enter`).
    *   **Project 2: The Forge (@forge)**
        *   **Governance**: `.gemini/instructions.md`, `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`.
        *   **Rules**: `.gemini/RULES/`.
        *   **Hooks**: `githooks/pre-commit`, `githooks/pre-push`.
        *   **Templates**: `templates/forge-mythos/`.
        *   **Tests**: `tests/features/` (BDD Features), `tests/features/steps/` (Step Definitions).
        *   **Rituals**: The Signet and Chronicle (GitHub Flow), Code Review Gates, AI-Agent Dispatch.
    *   **The Foundation (@shared-law)**
        *   **The Spinal Cord**: Foundational bridge and shared law.
        *   **Docs (The Gospel)**: `docs/architecture/overview.md`, `docs/architecture/data-flow.md`, `docs/changelogs/current.md`, `docs/governance/vde-spec.md`, `USE_CASES.md`, `VDE_ANALYSIS.md`, `PROJECT_STATUS.md`, `docs/governance/sovereign-charter.md`, `docs/api/library-api.md`.
        *   **Records**: `MEMORY.md`.
        *   **Infrastructure**: `Cargo.toml`, `.gitignore`, `.editorconfig`.

---

## IV. How They Work Together (The Symbiotic Covenant)

1.  **The Foundation Link**: The Forge builds the Armor. The Armor is the product; the Forge is the tool that shapes it.
2.  **The Shielded Product**: The resulting code (The Armor) is meticulously decoupled so it remains purely driven by the Tetrad.
3.  **The Forge Restriction**: The Forge SHALL NOT be active during student runtime. The Armor must be 100% autonomous, deterministic, and AI-blind.
4.  **The Decision Rule (Test of the Two Fires)**:
    - **Armor Strike (@armor)**: Satisfies a physical runtime requirement for the VDE product.
    - **Forge Strike (@forge)**: Satisfies a universal requirement for governed development or AI discipline.
    - **Shared-Law Strike (@shared-law)**: Modifies the foundational bridge used by both.
5.  **The Tagging Report**: For EVERY strike, produce an explicit Tagging Report in the PR body listing each touched artifact and its classification.

---

## V. Sovereign Tagging Specification

### 1. The Positioning Law
Architectural tags sit exclusively on **line 2 or 3**. Line 1 is reserved for shebangs, primary document headers, or JSON root structures.

### 2. The Literate Syntax Standard
| Language / Format | Syntax | Example |
| :--- | :--- | :--- |
| **Rust** | `// @tag (Effect)` | `// @armor (Engine Core)` |
| **Markdown** | `<!-- @tag (Effect) -->` | `<!-- @forge (Governance) -->` |
| **Zsh / Shell / ENV / Python** | `# @tag (Effect)` | `# @forge (Governance Sentinel)` |
| **TOML / Dockerfile / YAML** | `# @tag (Effect)` | `# @shared-law (Registry)` |
| **JSON / JSON-Schema** | `"@tag": "(Effect)",` | `"@shared-law": "(Data Schema)"` |
| **SQL** | `-- @tag (Effect)` | `-- @shared-law (Storage)"` |

### 3. Verification
Tag compliance is verified by the pre-commit hook (Mandate 24). Non-compliant artifacts are a Protocol Fracture.

---

**This is the Way.**
