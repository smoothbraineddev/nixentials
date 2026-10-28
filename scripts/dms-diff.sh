# Shows DMS settings changed in the running shell but not in the Nix config. settings.json
# is a read-only store link, so DMS keeps UI changes in memory and loses them on restart.
# Diffs the live state (dms ipc) against the generated file, one block per top-level key,
# grouped by the .nix files that set the key. DMS_DIFF_DIRS holds the directories to search,
# one per line, set by homeModules.dms-diff.

managed="${XDG_CONFIG_HOME:-$HOME/.config}/DankMaterialShell/settings.json"
opt="programs.dank-material-shell.settings"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
live="$tmp/live.json"
dms ipc call settings dump >"$live"

keys=$(jq -rn --slurpfile a "$managed" --slurpfile b "$live" '
  ($a[0]) as $a | ($b[0]) as $b
  | ($a | keys) + ($b | keys) | unique[] as $k
  | select(($a | has($k)) != ($b | has($k)) or $a[$k] != $b[$k]) | $k
')

if [[ -z "$keys" ]]; then
  echo "No drift: the running DMS matches the Nix config."
  exit 0
fi

# Values print as Nix so +lines paste straight into the .nix files.
# Arrays and objects expand to one element or attribute per line at every depth, so an
# inserted widget inside a bar is a single +line instead of a changed bar.
render() {
  jq -r --arg k "$1" '
    def str: tojson | gsub("\\$\\{"; "\\${");
    def name: if test("^[A-Za-z_][A-Za-z0-9_-]*$") then . else str end;
    def nix($i):
      ($i + "  ") as $j
      | if type == "object" then
          if length == 0 then "{ }"
          else "{\n" + (to_entries | sort_by(.key) | map($j + "\(.key | name) = \(.value | nix($j));") | join("\n")) + "\n" + $i + "}" end
        elif type == "array" then
          if length == 0 then "[ ]"
          else "[\n" + (map($j + nix($j)) | join("\n")) + "\n" + $i + "]" end
        elif type == "string" then str
        else tojson end;
    if has($k) | not then empty
    else "\($k | name) = \(.[$k] | nix(""));" end
  ' "$2"
}

# The files to search, with a short label each: nixentials' own as nixentials:<path>, the
# rest with the home directory as ~.
mapfile -t dirs <<<"$DMS_DIFF_DIRS"
label() {
  case $1 in
    "$NIXENTIALS_SETTINGS"/*) printf 'nixentials:modules/dms-settings/%s' "${1#"$NIXENTIALS_SETTINGS"/}" ;;
    "$HOME"/*) printf '%s/%s' "~" "${1#"$HOME"/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

# <file(s)>\t<key>, sorted so keys from the same file print together.
pairs=$(while read -r key; do
  files=$(for d in "${dirs[@]}"; do
    [[ -n $d ]] || continue
    grep -lE "^\s*([A-Za-z0-9_-]+\.)*\"?$key\"?\s*=" "$d"/*.nix 2>/dev/null || true
  done | while read -r f; do label "$f"; echo; done | paste -sd' ' -)
  printf '%s\t%s\n' "${files:-not set in Nix}" "$key"
done <<<"$keys" | sort)

bold="" reset=""
[[ -t 1 ]] && bold=$'\033[1m' reset=$'\033[0m'

current=""
while IFS=$'\t' read -r files key; do
  if [[ $files != "$current" ]]; then
    [[ -n $current ]] && echo
    printf '%s== %s%s\n' "$bold" "$files" "$reset"
    current=$files
  fi
  render "$key" "$managed" >"$tmp/nix"
  render "$key" "$live" >"$tmp/live"
  diff -u --color=auto --label "$opt.$key (nix)" --label "$opt.$key (live)" "$tmp/nix" "$tmp/live" || true
done <<<"$pairs"
