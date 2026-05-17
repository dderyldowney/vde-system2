#!/usr/bin/env zsh
# @forge (AI User Spoke Provisioning — Claude Code Rust Compiler Hook)
# Run once inside a Spoke, or once on the Host, to wire Claude Code hooks.
# Writes ~/.claude/settings.json and ~/.claude/hooks/rust-compiler-feedback.sh.
# Safe to re-run — idempotent.

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
# @shared-law (Rust Compiler Deep Tie-In)
# Fires after every Edit/Write. If the file is .rs, walks up to the Cargo
# workspace root and runs cargo check — surfaces all errors, warnings,
# notes, and help suggestions back to Claude before the next decision.

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
