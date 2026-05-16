// Registry — owned VM list with HashMap alias index for O(1) lookup.
// @armor (Engine Core)

use std::collections::HashMap;

use crate::registry::types::{VmKind, VmType};

/// Runtime lookup index for all VM types.
pub struct Registry {
    /// Schema version from the source JSON.
    pub version: String,
    vms: Vec<VmType>,
    by_alias: HashMap<String, usize>,
}

impl Registry {
    /// Build a `Registry` from a version string and an owned list of `VmType`s.
    ///
    /// Every alias and the canonical name for each VM are indexed into `by_alias`
    /// at construction time so all subsequent lookups are O(1).
    #[must_use]
    pub fn new(version: String, vms: Vec<VmType>) -> Self {
        let mut by_alias: HashMap<String, usize> = HashMap::new();

        for (idx, vm) in vms.iter().enumerate() {
            by_alias.insert(vm.name.clone(), idx);
            for alias in &vm.aliases {
                by_alias.insert(alias.clone(), idx);
            }
        }

        Self {
            version,
            vms,
            by_alias,
        }
    }

    /// Look up a VM by any alias or its canonical name.
    #[must_use]
    pub fn get(&self, key: &str) -> Option<&VmType> {
        self.by_alias.get(key).map(|&idx| &self.vms[idx])
    }

    /// All VM types in insertion order.
    #[must_use]
    pub fn all(&self) -> &[VmType] {
        &self.vms
    }

    /// Iterator over language VMs only.
    pub fn language_vms(&self) -> impl Iterator<Item = &VmType> {
        self.vms.iter().filter(|vm| vm.kind == VmKind::Language)
    }

    /// Iterator over service VMs only.
    pub fn service_vms(&self) -> impl Iterator<Item = &VmType> {
        self.vms.iter().filter(|vm| vm.kind == VmKind::Service)
    }
}

#[cfg(test)]
mod tests {
    use std::path::PathBuf;

    use super::Registry;
    use crate::registry::types::{VmKind, VmType};

    fn make_python() -> VmType {
        VmType {
            kind: VmKind::Language,
            name: "vde-python".to_string(),
            aliases: vec!["py".to_string(), "python3".to_string()],
            display: "Python".to_string(),
            pkgs: vec![],
            setup_script: PathBuf::from("scripts/setup/python-init.zsh"),
            service_ports: vec![],
            ssh_port: 2217,
        }
    }

    fn make_postgres() -> VmType {
        VmType {
            kind: VmKind::Service,
            name: "vde-postgres".to_string(),
            aliases: vec!["postgres".to_string(), "pg".to_string()],
            display: "PostgreSQL".to_string(),
            pkgs: vec![],
            setup_script: PathBuf::from("scripts/setup/postgres-init.zsh"),
            service_ports: vec![5432],
            ssh_port: 2401,
        }
    }

    #[test]
    fn get_by_canonical_name() {
        let reg = Registry::new("1.0".to_string(), vec![make_python()]);
        assert!(reg.get("vde-python").is_some());
    }

    #[test]
    fn get_by_alias() {
        let reg = Registry::new("1.0".to_string(), vec![make_python()]);
        assert!(reg.get("py").is_some());
        assert!(reg.get("python3").is_some());
    }

    #[test]
    fn get_unknown_returns_none() {
        let reg = Registry::new("1.0".to_string(), vec![make_python()]);
        assert!(reg.get("java").is_none());
    }

    #[test]
    fn get_returns_correct_vm() {
        let reg = Registry::new("1.0".to_string(), vec![make_python()]);
        let vm = reg.get("py").unwrap();
        assert_eq!(vm.name, "vde-python");
        assert_eq!(vm.ssh_port, 2217);
    }

    #[test]
    fn all_returns_every_vm() {
        let reg = Registry::new("1.0".to_string(), vec![make_python(), make_postgres()]);
        assert_eq!(reg.all().len(), 2);
    }

    #[test]
    fn language_vms_filters_correctly() {
        let reg = Registry::new("1.0".to_string(), vec![make_python(), make_postgres()]);
        let langs: Vec<_> = reg.language_vms().collect();
        assert_eq!(langs.len(), 1);
        assert_eq!(langs[0].name, "vde-python");
    }

    #[test]
    fn service_vms_filters_correctly() {
        let reg = Registry::new("1.0".to_string(), vec![make_python(), make_postgres()]);
        let svcs: Vec<_> = reg.service_vms().collect();
        assert_eq!(svcs.len(), 1);
        assert_eq!(svcs[0].name, "vde-postgres");
    }

    #[test]
    fn version_is_stored() {
        let reg = Registry::new("2.0.0".to_string(), vec![]);
        assert_eq!(reg.version, "2.0.0");
    }

    #[test]
    fn empty_registry_returns_none() {
        let reg = Registry::new("1.0".to_string(), vec![]);
        assert!(reg.get("anything").is_none());
        assert!(reg.all().is_empty());
    }
}
