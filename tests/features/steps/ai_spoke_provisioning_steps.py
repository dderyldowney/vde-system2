# @forge (AI Spoke Provisioning - Behave Step Definitions)
import json
import os
import stat
import subprocess
import tempfile
from pathlib import Path

from behave import given, then, when

SCRIPT_PATH = (
    Path(__file__).parent.parent.parent.parent / "scripts" / "ai" / "setup-claude-hooks.sh"
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


@then("~/.claude/settings.json exists")
def step_settings_exists(context):
    settings = Path(context.temp_home) / ".claude" / "settings.json"
    assert settings.exists(), f"settings.json not found at {settings}"


@then("settings.json contains a PostToolUse hook for Edit and Write")
def step_settings_has_hook(context):
    settings = Path(context.temp_home) / ".claude" / "settings.json"
    data = json.loads(settings.read_text())
    hooks = data["hooks"]["PostToolUse"]
    assert any(
        h["matcher"] == "Edit|Write" for h in hooks
    ), "No Edit|Write PostToolUse hook found"


@then("~/.claude/hooks/rust-compiler-feedback.sh exists")
def step_hook_exists(context):
    hook = Path(context.temp_home) / ".claude" / "hooks" / "rust-compiler-feedback.sh"
    assert hook.exists(), f"rust-compiler-feedback.sh not found at {hook}"


@then("rust-compiler-feedback.sh is executable")
def step_hook_executable(context):
    hook = Path(context.temp_home) / ".claude" / "hooks" / "rust-compiler-feedback.sh"
    mode = hook.stat().st_mode
    assert mode & stat.S_IXUSR, "rust-compiler-feedback.sh is not user-executable"


@then("~/.claude/settings.json is unchanged")
def step_settings_unchanged(context):
    settings = Path(context.temp_home) / ".claude" / "settings.json"
    assert settings.read_text() == context.first_settings, "settings.json changed on second run"


@then("~/.claude/hooks/rust-compiler-feedback.sh is unchanged")
def step_hook_unchanged(context):
    hook = Path(context.temp_home) / ".claude" / "hooks" / "rust-compiler-feedback.sh"
    assert hook.read_text() == context.first_hook, "hook script changed on second run"
