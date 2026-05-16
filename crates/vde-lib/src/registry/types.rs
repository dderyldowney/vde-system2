// VmKind and VmType — the core data model for the VM registry.
// @armor (Engine Core)

use std::path::PathBuf;

/// Whether a VM is a language environment or a backing service.
#[derive(Debug, PartialEq, Clone)]
pub enum VmKind {
    /// A language VM (`ssh_port` 2200–2399). e.g. vde-python, vde-rust.
    Language,
    /// A service VM (`ssh_port` 2400–2499). e.g. vde-postgres, vde-redis.
    Service,
}

/// A single VM type entry from the registry.
#[derive(Debug, Clone)]
pub struct VmType {
    /// Whether this is a language or service VM.
    pub kind: VmKind,
    /// Canonical name. e.g. "vde-python".
    pub name: String,
    /// All aliases including the canonical name. e.g. `["py", "python3"]`.
    pub aliases: Vec<String>,
    /// Human-readable display name. e.g. "Python".
    pub display: String,
    /// System packages to install at image build time.
    pub pkgs: Vec<String>,
    /// Path to the hydration script, relative to the project root. Required — every VM is hydrated via its init script.
    pub setup_script: PathBuf,
    /// Exposed service ports (empty for language VMs).
    pub service_ports: Vec<u16>,
    /// The SSH port assigned to this VM.
    pub ssh_port: u16,
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn vm_kind_variants_exist() {
        let _lang = VmKind::Language;
        let _svc = VmKind::Service;
    }

    #[test]
    fn vm_kind_is_equal_to_itself() {
        assert_eq!(VmKind::Language, VmKind::Language);
        assert_eq!(VmKind::Service, VmKind::Service);
    }

    #[test]
    fn vm_kind_variants_are_distinct() {
        assert_ne!(VmKind::Language, VmKind::Service);
    }

    #[test]
    fn vm_type_can_be_constructed() {
        let vm = VmType {
            kind: VmKind::Language,
            name: "vde-python".to_string(),
            aliases: vec!["py".to_string(), "python3".to_string()],
            display: "Python".to_string(),
            pkgs: vec![],
            setup_script: PathBuf::from("scripts/setup/python-init.zsh"),
            service_ports: vec![],
            ssh_port: 2217,
        };
        assert_eq!(vm.name, "vde-python");
        assert_eq!(vm.ssh_port, 2217);
        assert!(vm.pkgs.is_empty());
        assert!(vm.service_ports.is_empty());
        assert_eq!(
            vm.setup_script,
            PathBuf::from("scripts/setup/python-init.zsh")
        );
    }

    #[test]
    fn language_vm_has_no_service_ports() {
        let vm = VmType {
            kind: VmKind::Language,
            name: "vde-python".to_string(),
            aliases: vec![],
            display: "Python".to_string(),
            pkgs: vec![],
            setup_script: PathBuf::from("scripts/setup/python-init.zsh"),
            service_ports: vec![],
            ssh_port: 2217,
        };
        assert!(vm.service_ports.is_empty());
    }

    #[test]
    fn service_vm_has_service_ports() {
        let vm = VmType {
            kind: VmKind::Service,
            name: "vde-postgres".to_string(),
            aliases: vec!["postgres".to_string(), "pg".to_string()],
            display: "PostgreSQL".to_string(),
            pkgs: vec![],
            setup_script: PathBuf::from("scripts/setup/postgres-init.zsh"),
            service_ports: vec![5432],
            ssh_port: 2401,
        };
        assert!(!vm.service_ports.is_empty());
        assert_eq!(vm.service_ports[0], 5432);
    }

    #[test]
    fn vm_type_stores_setup_script_path() {
        let vm = VmType {
            kind: VmKind::Language,
            name: "vde-python".to_string(),
            aliases: vec![],
            display: "Python".to_string(),
            pkgs: vec!["python3-pip".to_string()],
            setup_script: PathBuf::from("scripts/setup/python-init.zsh"),
            service_ports: vec![],
            ssh_port: 2217,
        };
        assert_eq!(
            vm.setup_script,
            PathBuf::from("scripts/setup/python-init.zsh")
        );
        assert!(!vm.pkgs.is_empty());
    }
}
