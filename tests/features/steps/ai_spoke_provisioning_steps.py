# @forge (AI Spoke Multi-Agent Provisioning — Behave Step Definitions)
import json
import os
import stat
import subprocess
import tempfile
from pathlib import Path

from behave import given, then, when

SCRIPT_PATH = (
    Path(__file__).parent.parent.parent.parent / "scripts" / "ai" / "setup-ai-hooks.sh"
)


@given("a temporary home directory")
def step_temp_home(context):
    context.temp_home = tempfile.mkdtemp()
    context.env = {**os.environ, "HOME": context.temp_home}


@given("the provisioning script has already been run once")
def step_already_run(context):
    step_temp_home(context)
    _run_script(context)
    settings = Path(context.temp_home) / ".claude" / "settings.json"
    hook = Path(context.temp_home) / ".claude" / "hooks" / "rust-compiler-feedback.sh"
    context.first_settings = settings.read_text()
    context.first_hook = hook.read_text()


@when("I run the provisioning script")
def step_run_script(context):
    _run_script(context)


def _run_script(context):
    result = subprocess.run(
        ["zsh", str(SCRIPT_PATH)],
        env=context.env,
        capture_output=True,
        text=True,
    )
    context.result = result


def _home(context, *parts):
    return Path(context.temp_home).joinpath(*parts)


def _is_executable(path):
    return bool(path.stat().st_mode & stat.S_IXUSR)


# ── Claude Code ───────────────────────────────────────────────────────────────

@then("~/.claude/settings.json exists")
def step_claude_settings_exists(context):
    p = _home(context, ".claude", "settings.json")
    assert p.exists(), f"Not found: {p}"


@then("settings.json contains a PostToolUse hook for Edit and Write")
def step_claude_settings_has_hook(context):
    p = _home(context, ".claude", "settings.json")
    data = json.loads(p.read_text())
    hooks = data["hooks"]["PostToolUse"]
    assert any(h["matcher"] == "Edit|Write" for h in hooks), "No Edit|Write PostToolUse hook"


@then("~/.claude/hooks/rust-compiler-feedback.sh exists")
def step_claude_hook_exists(context):
    p = _home(context, ".claude", "hooks", "rust-compiler-feedback.sh")
    assert p.exists(), f"Not found: {p}"


@then("~/.claude/hooks/rust-compiler-feedback.sh is executable")
def step_claude_hook_executable(context):
    p = _home(context, ".claude", "hooks", "rust-compiler-feedback.sh")
    assert _is_executable(p), "Not executable"


# ── Gemini CLI ────────────────────────────────────────────────────────────────

@then("~/.gemini/settings.json exists")
def step_gemini_settings_exists(context):
    p = _home(context, ".gemini", "settings.json")
    assert p.exists(), f"Not found: {p}"


@then("~/.gemini/settings.json contains an AfterTool hook for write_file and replace")
def step_gemini_settings_has_hook(context):
    p = _home(context, ".gemini", "settings.json")
    data = json.loads(p.read_text())
    hooks = data["hooks"]["AfterTool"]
    assert any("write_file" in h["matcher"] for h in hooks), "No write_file AfterTool hook"


@then("~/.gemini/hooks/rust-compiler-feedback.sh exists")
def step_gemini_hook_exists(context):
    p = _home(context, ".gemini", "hooks", "rust-compiler-feedback.sh")
    assert p.exists(), f"Not found: {p}"


@then("~/.gemini/hooks/rust-compiler-feedback.sh is executable")
def step_gemini_hook_executable(context):
    p = _home(context, ".gemini", "hooks", "rust-compiler-feedback.sh")
    assert _is_executable(p), "Not executable"


# ── Cursor ────────────────────────────────────────────────────────────────────

@then("~/.cursor/hooks.json exists")
def step_cursor_config_exists(context):
    p = _home(context, ".cursor", "hooks.json")
    assert p.exists(), f"Not found: {p}"


@then("~/.cursor/hooks.json contains an afterFileEdit hook")
def step_cursor_config_has_hook(context):
    p = _home(context, ".cursor", "hooks.json")
    data = json.loads(p.read_text())
    assert "afterFileEdit" in data["hooks"], "No afterFileEdit hook"


@then("~/.cursor/hooks/rust-compiler-feedback.sh exists")
def step_cursor_hook_exists(context):
    p = _home(context, ".cursor", "hooks", "rust-compiler-feedback.sh")
    assert p.exists(), f"Not found: {p}"


@then("~/.cursor/hooks/rust-compiler-feedback.sh is executable")
def step_cursor_hook_executable(context):
    p = _home(context, ".cursor", "hooks", "rust-compiler-feedback.sh")
    assert _is_executable(p), "Not executable"


# ── Windsurf ──────────────────────────────────────────────────────────────────

@then("~/.codeium/windsurf/hooks.json exists")
def step_windsurf_config_exists(context):
    p = _home(context, ".codeium", "windsurf", "hooks.json")
    assert p.exists(), f"Not found: {p}"


@then("~/.codeium/windsurf/hooks.json contains a post_write_code hook")
def step_windsurf_config_has_hook(context):
    p = _home(context, ".codeium", "windsurf", "hooks.json")
    data = json.loads(p.read_text())
    assert "post_write_code" in data["hooks"], "No post_write_code hook"


@then("~/.codeium/windsurf/hooks/rust-compiler-feedback.sh exists")
def step_windsurf_hook_exists(context):
    p = _home(context, ".codeium", "windsurf", "hooks", "rust-compiler-feedback.sh")
    assert p.exists(), f"Not found: {p}"


@then("~/.codeium/windsurf/hooks/rust-compiler-feedback.sh is executable")
def step_windsurf_hook_executable(context):
    p = _home(context, ".codeium", "windsurf", "hooks", "rust-compiler-feedback.sh")
    assert _is_executable(p), "Not executable"


# ── Cline ─────────────────────────────────────────────────────────────────────

@then("~/Documents/Cline/Rules/Hooks/PostToolUse exists")
def step_cline_hook_exists(context):
    p = _home(context, "Documents", "Cline", "Rules", "Hooks", "PostToolUse")
    assert p.exists(), f"Not found: {p}"


@then("~/Documents/Cline/Rules/Hooks/PostToolUse is executable")
def step_cline_hook_executable(context):
    p = _home(context, "Documents", "Cline", "Rules", "Hooks", "PostToolUse")
    assert _is_executable(p), "Not executable"


# ── Idempotency ───────────────────────────────────────────────────────────────

@then("~/.claude/settings.json is unchanged")
def step_settings_unchanged(context):
    p = _home(context, ".claude", "settings.json")
    assert p.read_text() == context.first_settings, "settings.json changed on second run"


@then("~/.claude/hooks/rust-compiler-feedback.sh is unchanged")
def step_hook_unchanged(context):
    p = _home(context, ".claude", "hooks", "rust-compiler-feedback.sh")
    assert p.read_text() == context.first_hook, "hook changed on second run"
