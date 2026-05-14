# Pull Request: Submission of Beskar
<!-- @forge (Governance Sentinel) -->

> **MANDATE**: PR Title MUST follow Conventional Commits: `type(scope): description` or `type!: description`.

### **I. Context (The Why)**
*Summary of the mission and intent.*

### **II. Signet Link (Mission Tracking)**
- [ ] **Unbreakable Link**: Closes # (Must use 'Closes #N' to auto-close the Signet)

### **III. The Trial of the Gauntlet (Test Plan)**
**Mandatory Evidence of the Heartbeat**:
- [ ] **Red Gauntlet**: *Describe/Link the failing test created.*
- [ ] **Green Victory**:
> **MANDATE**: Paste the **LITERAL TERMINAL OUTPUT** of `cargo test` below. Paraphrasing or summaries are forbidden.
```text
(Paste terminal output here)
```

### **IV. File Impact List (The Beskar Plates)**
*List of files created or modified in this strike.*

### **V. Architectural Tagging Report (@armor | @forge | @shared-law)**
> **MANDATE**: For EVERY strike, list each touched artifact and its classification.

| Artifact | Classification | Justification |
| :--- | :--- | :--- |
| (Path) | `@armor` / `@forge` / `@shared-law` | (Brief reason) |

### **VI. Refactoring Rationale (The Refiner's Fire)**
*Explain why the code was structured this way.*

### **VII. Discussion Summary (The Signet's Record)**
*Briefly summarize key decisions recorded on the Signet that guided this forge.*

### **VIII. Checklist of the Creed**
- [ ] **Focused Strike**: Scope is strictly limited to the Signet; no tangential changes.
- [ ] **Quality Gate**: `cargo clippy --deny warnings` passes.
- [ ] **Build Green**: `cargo build` succeeds.
- [ ] **Tests Pass**: `cargo test` is 100% green.
- [ ] **Proof of Life**: `proof-of-life-the-contract.feature` is certified (once available).
- [ ] **Dual-Gate Review**: Code-reviewer sub-agent has audited and approved.
- [ ] **Architectural Tags**: All new/modified `.rs` and `.md` files tagged on line 2 or 3.
- [ ] **Conventional Commit**: PR title follows `type(scope): description` format.

### **IX. Sentinel Clearance**
- [ ] kilo-code-bot: CLEAR
- [ ] sourcery-ai: CLEAR
- [ ] dependabot: CLEAR
- [ ] CodeQL: CLEAR
