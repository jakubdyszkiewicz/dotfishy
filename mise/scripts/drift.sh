#!/bin/bash
# Reports how this machine drifted from ~/.dotfishy:
#   - uncommitted or unpushed changes in the repo (dotfiles are symlinks, so edits land there)
#   - dotfile links that an app replaced with a plain file
#   - macOS: brew formulae / casks / App Store apps installed by hand but not declared,
#     and declared packages that are missing
# With --summary, exits 1 when something drifted. Always writes a one-line summary to ~/.cache/dotfishy-drift,
# which fish shows when a new shell starts (see fish/conf.d/drift.fish).
#
# Usage: mise run dotfishy:drift         # full report
#        drift.sh --summary        # just the one-line summary
set -uo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfishy-drift"
summary_only=false
[ "${1:-}" = --summary ] && summary_only=true
cd "$HOME" # outside the repo, so mise reads only the global config

report=""
parts=()
section() { # title, newline-separated items
    [ -n "$2" ] || return 0
    local n
    n=$(printf '%s\n' "$2" | wc -l | tr -d ' ')
    parts+=("$n $1")
    report+="== $1 ($n)"$'\n'"$2"$'\n\n'
}

# Repo
section "uncommitted in ~/.dotfishy" "$(git -C "$root" status --short)"
section "unpushed commits" "$(git -C "$root" log --oneline '@{u}..' 2>/dev/null)"

# Dotfile links ("applied" = link in place)
section "dotfiles not linked" "$(mise dot status --json 2>/dev/null |
    jq -r '.files[] | select(.state != "applied") | "\(.target) (\(.state))"')"

# Packages (macOS)
if [ -d /opt/homebrew/Cellar ]; then
    status_json="$(mise bootstrap packages status --json 2>/dev/null)"
    declared() { jq -r --arg m "$1" '.[$m].packages[]?.package' <<< "$status_json" | sed 's#.*/##' | sort -u; }

    # Formulae installed on request. Read the receipts: `brew leaves` hides formulae from
    # untrusted taps. Skip Cellar symlinks (old names Homebrew left behind after a rename).
    # Like `brew leaves`, skip formulae another installed formula depends on.
    receipts=(); for d in /opt/homebrew/Cellar/*; do [ -L "$d" ] || receipts+=("$d"/*/INSTALL_RECEIPT.json); done
    deps="$(jq -r '.runtime_dependencies[]?.full_name' "${receipts[@]}" 2>/dev/null | sed 's#.*/##' | sort -u)"
    on_request="$(for r in "${receipts[@]}"; do
        jq -e '.installed_on_request' "$r" > /dev/null 2>&1 && basename "$(dirname "$(dirname "$r")")"
    done | sort -u)"
    section "brew formulae not declared" "$(comm -23 <(comm -23 <(echo "$on_request") <(echo "$deps")) <(declared brew))"
    section "brew casks not declared" "$(comm -23 <(ls /opt/homebrew/Caskroom | sort -u) <(declared brew-cask))"
    if command -v mas > /dev/null; then
        section "App Store apps not declared" "$(mas list | while read -r id rest; do
            declared mas | grep -qx "$id" || echo "$id ${rest%%  *}"
        done)"
    fi
    section "declared but missing" "$(jq -r 'to_entries[] | .key as $m | .value.packages[]?
        | select(.desired_state == "present" and .state != "installed") | "\($m):\(.package) (\(.state))"' <<< "$status_json")"
fi

summary=""
if [ ${#parts[@]} -gt 0 ]; then
    summary="dotfishy drift: $(IFS=,; echo "${parts[*]}" | sed 's/,/, /g') - run \`mise run dotfishy:drift\`"
fi
mkdir -p "$(dirname "$cache")"
printf '%s' "$summary" > "$cache"

if $summary_only; then
    [ -n "$summary" ] && echo "$summary"
elif [ -n "$report" ]; then
    printf '%s' "$report"
    cat <<'EOF'
Fix: commit (or revert) repo changes; `mise bootstrap packages use brew:foo` to declare a
package (brew-cask:foo, mas:<id>), or uninstall it; `mise bootstrap` to restore links.
EOF
else
    echo "No drift: this machine matches ~/.dotfishy."
fi
if $summary_only; then [ -z "$summary" ]; fi
