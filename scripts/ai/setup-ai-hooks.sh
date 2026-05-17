#!/usr/bin/env zsh
# @forge (AI User Multi-Agent Spoke Provisioning — Compiler Feedback Hooks)
# Run once inside a Spoke, or once on the Host, to wire Rust compiler feedback
# hooks for all supported AI coding agents. Idempotent — safe to re-run.
#
# Wired:    Claude Code, Gemini CLI, Cursor, Windsurf, Cline
# No hooks: Kilo Code, GitHub Copilot (pre-only), Aider, Continue

# ── Claude Code ───────────────────────────────────────────────────────────────

mkdir -p ~/.claude/hooks

cat > ~/.claude/settings.json << 'SETTINGS'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/rust-compiler-feedback.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS

cat > ~/.claude/hooks/rust-compiler-feedback.sh << 'HOOK'
#!/usr/bin/env zsh
# @shared-law (Rust Compiler Deep Tie-In — Claude Code)
input=$(cat)
file_path=$(echo "$input" | python3 -c \
  "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" \
  2>/dev/null)
[[ "$file_path" == *.rs ]] || exit 0
dir=$(dirname "$file_path")
cargo_root=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
    [[ -f "$dir/Cargo.toml" ]] && { cargo_root="$dir"; break; }
    dir=$(dirname "$dir")
done
[[ -n "$cargo_root" ]] || exit 0
cd "$cargo_root" && cargo check 2>&1
HOOK

chmod +x ~/.claude/hooks/rust-compiler-feedback.sh

# ── Gemini CLI ────────────────────────────────────────────────────────────────
# Gemini requires JSON on stdout. cargo check output is returned as
# additionalContext, which Gemini injects back into the conversation.

mkdir -p ~/.gemini/hooks

cat > ~/.gemini/settings.json << 'SETTINGS'
{
  "hooks": {
    "AfterTool": [
      {
        "matcher": "write_file|replace",
        "hooks": [
          {
            "name": "rust-compiler-feedback",
            "type": "command",
            "command": "~/.gemini/hooks/rust-compiler-feedback.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS

cat > ~/.gemini/hooks/rust-compiler-feedback.sh << 'HOOK'
#!/usr/bin/env zsh
# @shared-law (Rust Compiler Deep Tie-In — Gemini CLI)
# Gemini requires only final JSON on stdout; all other output must go to stderr.
input=$(cat)
file_path=$(echo "$input" | python3 -c \
  "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" \
  2>/dev/null)
[[ "$file_path" == *.rs ]] || exit 0
dir=$(dirname "$file_path")
cargo_root=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
    [[ -f "$dir/Cargo.toml" ]] && { cargo_root="$dir"; break; }
    dir=$(dirname "$dir")
done
[[ -n "$cargo_root" ]] || exit 0
output=$(cd "$cargo_root" && cargo check 2>&1)
python3 -c "
import sys, json
out = sys.stdin.read()
print(json.dumps({'hookSpecificOutput': {'additionalContext': out}}))
" <<< "$output"
HOOK

chmod +x ~/.gemini/hooks/rust-compiler-feedback.sh

# ── Cursor ────────────────────────────────────────────────────────────────────

mkdir -p ~/.cursor/hooks

cat > ~/.cursor/hooks.json << 'SETTINGS'
{
  "version": 1,
  "hooks": {
    "afterFileEdit": [
      {
        "command": "~/.cursor/hooks/rust-compiler-feedback.sh"
      }
    ]
  }
}
SETTINGS

cat > ~/.cursor/hooks/rust-compiler-feedback.sh << 'HOOK'
#!/usr/bin/env zsh
# @shared-law (Rust Compiler Deep Tie-In — Cursor)
# Tries multiple known field paths; works regardless of exact payload format.
input=$(cat)
file_path=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_input', {}).get('file_path', '') or
      d.get('input',      {}).get('path',      '') or
      d.get('file_path',  '')                      or
      d.get('path',       ''))" 2>/dev/null)
[[ "$file_path" == *.rs ]] || exit 0
dir=$(dirname "$file_path")
cargo_root=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
    [[ -f "$dir/Cargo.toml" ]] && { cargo_root="$dir"; break; }
    dir=$(dirname "$dir")
done
[[ -n "$cargo_root" ]] || exit 0
cd "$cargo_root" && cargo check 2>&1
HOOK

chmod +x ~/.cursor/hooks/rust-compiler-feedback.sh

# ── Windsurf ──────────────────────────────────────────────────────────────────

mkdir -p ~/.codeium/windsurf/hooks

cat > ~/.codeium/windsurf/hooks.json << 'SETTINGS'
{
  "hooks": {
    "post_write_code": [
      {
        "command": "~/.codeium/windsurf/hooks/rust-compiler-feedback.sh"
      }
    ]
  }
}
SETTINGS

cat > ~/.codeium/windsurf/hooks/rust-compiler-feedback.sh << 'HOOK'
#!/usr/bin/env zsh
# @shared-law (Rust Compiler Deep Tie-In — Windsurf)
# Tries multiple known field paths; works regardless of exact payload format.
input=$(cat)
file_path=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_input', {}).get('file_path', '') or
      d.get('input',      {}).get('path',      '') or
      d.get('file_path',  '')                      or
      d.get('path',       ''))" 2>/dev/null)
[[ "$file_path" == *.rs ]] || exit 0
dir=$(dirname "$file_path")
cargo_root=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
    [[ -f "$dir/Cargo.toml" ]] && { cargo_root="$dir"; break; }
    dir=$(dirname "$dir")
done
[[ -n "$cargo_root" ]] || exit 0
cd "$cargo_root" && cargo check 2>&1
HOOK

chmod +x ~/.codeium/windsurf/hooks/rust-compiler-feedback.sh

# ── Cline ─────────────────────────────────────────────────────────────────────
# Cline's hook IS the script — no config file, just a named executable.

mkdir -p ~/Documents/Cline/Rules/Hooks

cat > ~/Documents/Cline/Rules/Hooks/PostToolUse << 'HOOK'
#!/usr/bin/env zsh
# @shared-law (Rust Compiler Deep Tie-In — Cline)
# Tries multiple known field paths; works regardless of exact payload format.
input=$(cat)
file_path=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_input', {}).get('file_path', '') or
      d.get('input',      {}).get('path',      '') or
      d.get('file_path',  '')                      or
      d.get('path',       ''))" 2>/dev/null)
[[ "$file_path" == *.rs ]] || exit 0
dir=$(dirname "$file_path")
cargo_root=""
while [[ "$dir" != "/" && "$dir" != "." ]]; do
    [[ -f "$dir/Cargo.toml" ]] && { cargo_root="$dir"; break; }
    dir=$(dirname "$dir")
done
[[ -n "$cargo_root" ]] || exit 0
cd "$cargo_root" && cargo check 2>&1
HOOK

chmod +x ~/Documents/Cline/Rules/Hooks/PostToolUse
