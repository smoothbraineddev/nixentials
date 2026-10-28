# Shows how the live Zen prefs (prefs.js) differ from the profile's user.js: values changed
# in the browser, new keys of Zen and its mods that user.js does not set yet, and prefs of
# mods that are no longer installed.

# --- Locate Zen profile ---
zen_dir=""
for base in "$HOME/.config/zen" "$HOME/.zen"; do
  [[ -f "$base/profiles.ini" ]] && zen_dir="$base" && break
done
if [[ -z "$zen_dir" ]]; then
  echo "No Zen profile directory found." >&2
  exit 1
fi

profile=$(awk -F= '
  /^\[Install/   { in_install=1; next }
  /^\[/          { if (in_install && p) exit; in_install=0 }
  in_install && $1=="Default" { p=$2 }
  /^\[Profile/   { in_profile=1; path=""; d=0; next }
  /^\[/          { if (in_profile && d && path) { fb=path }; in_profile=0 }
  in_profile && $1=="Path"    { path=$2 }
  in_profile && $1=="Default" && $2=="1" { d=1 }
  END { if (p) print p; else if (fb) print fb; else if (d && path) print path }
' "$zen_dir/profiles.ini" 2>/dev/null)

if [[ -z "$profile" ]]; then
  echo "Could not detect Zen profile." >&2
  exit 1
fi

profile_dir="$zen_dir/$profile"
user_js="$profile_dir/user.js"
prefs_js="$profile_dir/prefs.js"
themes_dir="$profile_dir/chrome/zen-themes"

if [[ ! -f "$prefs_js" ]]; then
  echo "No prefs.js found — launch Zen once first." >&2
  exit 1
fi
if [[ ! -f "$user_js" ]]; then
  echo "No user.js found in the profile — nothing declares its prefs." >&2
  exit 1
fi

# --- Parse user_pref("key", value); lines into key\tvalue ---
parse_prefs() {
  sed -n 's/^user_pref("\([^"]*\)", \(.*\));$/\1\t\2/p' "$1"
}

# --- Build set of pref keys belonging to installed mods ---
declare -A installed_mod_keys
if command -v jq &>/dev/null && [[ -d "$themes_dir" ]]; then
  for pref_file in "$themes_dir"/*/preferences.json; do
    [[ -f "$pref_file" ]] || continue
    while IFS= read -r prop; do
      [[ -n "$prop" ]] && installed_mod_keys["$prop"]=1
    done < <(jq -r '.[].property // empty' "$pref_file" 2>/dev/null)
  done
fi

# ============================================================
# 1. Prefs diff (user.js vs prefs.js)
# ============================================================
printf "\033[1;35m━━━ Preferences (user.js → prefs.js) ━━━\033[0m\n"

declare -A user_vals
while IFS=$'\t' read -r key val; do
  user_vals["$key"]="$val"
done < <(parse_prefs "$user_js")

changed=0
while IFS=$'\t' read -r key val; do
  if [[ -v user_vals["$key"] ]]; then
    if [[ "${user_vals[$key]}" != "$val" ]]; then
      if [[ $changed -eq 0 ]]; then
        printf "\n\033[1;33m  Changed\033[0m\n\n"
      fi
      printf "  \033[1m%s\033[0m\n" "$key"
      printf "    \033[31muser.js: %s\033[0m\n" "${user_vals[$key]}"
      printf "    \033[32m  prefs: %s\033[0m\n\n" "$val"
      changed=$((changed + 1))
    fi
  fi
done < <(parse_prefs "$prefs_js")

if [[ $changed -eq 0 ]]; then
  printf "\n  \033[32mAll user.js values match prefs.js.\033[0m\n"
fi

# ============================================================
# 2. New intentional keys + stale mod prefs
# ============================================================
intentional='^(zen\.|uc\.|mod\.|theme\.|psu\.|user-|border-shadow|tab-shadow)'
noise='^zen\.(mods\.(last-update|milestone)|session-store|updates\.|ui\.migration|keyboard\.shortcuts\.version|welcome-screen\.seen|urlbar\.suggestions-learner|workspaces\.active)'
# Patterns that indicate a key belongs to a mod (not a zen built-in)
mod_like='^(uc\.|mod\.|zen\.mods\.)'

new=0
stale=0
declare -a new_lines=()
declare -a stale_lines=()

while IFS=$'\t' read -r key val; do
  if [[ ! -v user_vals["$key"] ]]; then
    if [[ "$key" =~ $intentional ]] && [[ ! "$key" =~ $noise ]]; then
      if [[ "$key" =~ $mod_like ]] && [[ ! -v installed_mod_keys["$key"] ]]; then
        stale_lines+=("$(printf "  \033[2m%s\033[0m = %s" "$key" "$val")")
        stale=$((stale + 1))
      else
        new_lines+=("$(printf "  \033[1m%s\033[0m = %s" "$key" "$val")")
        new=$((new + 1))
      fi
    fi
  fi
done < <(parse_prefs "$prefs_js")

if [[ $new -gt 0 ]]; then
  printf "\n\033[1;36m  New intentional keys (not in user.js)\033[0m\n\n"
  printf '%s\n' "${new_lines[@]}"
else
  printf "\n  \033[36mNo new intentional keys found.\033[0m\n"
fi

if [[ $stale -gt 0 ]]; then
  printf "\n\033[1;31m  Stale mod prefs (mod not installed)\033[0m\n\n"
  printf '%s\n' "${stale_lines[@]}"
  printf "\n  \033[2mClean up via about:config or restart Zen to let user.js take effect.\033[0m\n"
fi
