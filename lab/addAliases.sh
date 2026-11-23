#!/usr/bin/env bash
set -eu

# The base entrypoint calls this on every start. Keep aliases idempotent.
for node in 1 2 3 4 5 6; do
    alias_line="alias EOS${node}='sshpass -p admin ssh -o StrictHostKeyChecking=no admin@172.100.100.$((100 + node))'"
    for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if ! grep -Fqx "$alias_line" "$shell_rc" 2>/dev/null; then
            printf '%s\n' "$alias_line" >> "$shell_rc"
        fi
    done
done
