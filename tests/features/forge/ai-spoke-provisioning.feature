# @forge (AI User Multi-Agent Spoke Provisioning - BDD Contract)
Feature: AI Spoke Multi-Agent Hook Provisioning
  As an AI-augmented VDE user
  I want to run a one-time provisioning script inside my environment
  So that all my AI coding agents surface Rust compiler feedback after every file edit

  Background:
    Given a temporary home directory

  # ── Claude Code ──────────────────────────────────────────────────────────────

  Scenario: Script wires Claude Code settings
    When I run the provisioning script
    Then ~/.claude/settings.json exists
    And settings.json contains a PostToolUse hook for Edit and Write

  Scenario: Script creates the Claude Code compiler feedback hook
    When I run the provisioning script
    Then ~/.claude/hooks/rust-compiler-feedback.sh exists
    And ~/.claude/hooks/rust-compiler-feedback.sh is executable

  # ── Gemini CLI ───────────────────────────────────────────────────────────────

  Scenario: Script wires Gemini CLI settings
    When I run the provisioning script
    Then ~/.gemini/settings.json exists
    And ~/.gemini/settings.json contains an AfterTool hook for write_file and replace

  Scenario: Script creates the Gemini CLI compiler feedback hook
    When I run the provisioning script
    Then ~/.gemini/hooks/rust-compiler-feedback.sh exists
    And ~/.gemini/hooks/rust-compiler-feedback.sh is executable

  # ── Cursor ───────────────────────────────────────────────────────────────────

  Scenario: Script wires Cursor hook config
    When I run the provisioning script
    Then ~/.cursor/hooks.json exists
    And ~/.cursor/hooks.json contains an afterFileEdit hook

  Scenario: Script creates the Cursor compiler feedback hook
    When I run the provisioning script
    Then ~/.cursor/hooks/rust-compiler-feedback.sh exists
    And ~/.cursor/hooks/rust-compiler-feedback.sh is executable

  # ── Windsurf ─────────────────────────────────────────────────────────────────

  Scenario: Script wires Windsurf hook config
    When I run the provisioning script
    Then ~/.codeium/windsurf/hooks.json exists
    And ~/.codeium/windsurf/hooks.json contains a post_write_code hook

  Scenario: Script creates the Windsurf compiler feedback hook
    When I run the provisioning script
    Then ~/.codeium/windsurf/hooks/rust-compiler-feedback.sh exists
    And ~/.codeium/windsurf/hooks/rust-compiler-feedback.sh is executable

  # ── Cline ────────────────────────────────────────────────────────────────────

  Scenario: Script creates the Cline PostToolUse hook
    When I run the provisioning script
    Then ~/Documents/Cline/Rules/Hooks/PostToolUse exists
    And ~/Documents/Cline/Rules/Hooks/PostToolUse is executable

  # ── Idempotency ──────────────────────────────────────────────────────────────

  Scenario: Script is idempotent
    Given the provisioning script has already been run once
    When I run the provisioning script
    Then ~/.claude/settings.json is unchanged
    And ~/.claude/hooks/rust-compiler-feedback.sh is unchanged
