// Registry module — VM type data model and runtime lookup index.
// @armor (Engine Core)

/// `VmKind` and `VmType` — the core data model.
pub mod types;

/// `Registry` — deserialization, `HashMap` alias index, and lookup API.
pub mod load;
