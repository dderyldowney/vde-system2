# @forge (AI User Spoke Provisioning - BDD Contract)
Feature: AI Spoke Claude Code Hook Provisioning
  As an AI-augmented VDE user
  I want to run a one-time provisioning script inside my environment
  So that Claude Code surfaces Rust compiler feedback after every file edit

  Background:
    Given a temporary home directory

  Scenario: Script creates Claude Code settings
    When I run the provisioning script
    Then ~/.claude/settings.json exists
    And settings.json contains a PostToolUse hook for Edit and Write

  Scenario: Script creates the compiler feedback hook
    When I run the provisioning script
    Then ~/.claude/hooks/rust-compiler-feedback.sh exists
    And rust-compiler-feedback.sh is executable

  Scenario: Script is idempotent
    Given the provisioning script has already been run once
    When I run the provisioning script
    Then ~/.claude/settings.json is unchanged
    And ~/.claude/hooks/rust-compiler-feedback.sh is unchanged
