#!/usr/bin/env bash

set -uo pipefail

# --- Prompt helpers ---
ask_path() {
    local prompt="$1"
    local default="$2"
    local input
    read -rp "$prompt [$default]: " input </dev/tty
    echo "${input:-$default}"
}

ask_yes_no() {
    local prompt="$1"
    local answer
    while true; do
        read -rp "$prompt [y/N]: " answer </dev/tty
        case "${answer,,}" in
            y|yes) return 0 ;;
            n|no|"") return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

# --- Gather config ---
config_home=$(ask_path "Enter config home path" "$HOME")
config_src=$(ask_path "Enter config source path" "$(pwd)")
locations_src=$(ask_path "Enter path to locations config file" "$config_src/locations.config")

if [[ ! -f "$locations_src" ]]; then
    echo "Error: locations file not found: $locations_src" >&2
    exit 1
fi

# --- Process each location ---
while IFS= read -r location || [[ -n "$location" ]]; do
    # Skip empty lines and comments
    [[ -z "$location" || "$location" == \#* ]] && continue

    src="$config_src/$location"
    dst="$config_home/$location"

    if ask_yes_no "Link '$src' -> '$dst'?"; then
        if [[ -e "$dst" ]]; then
            # A real file or directory exists
            if ask_yes_no "Warning: '$dst' already exists. Rename it to '$dst.old' and continue?"; then
                mv "$dst" "$dst.old"
                echo "Renamed '$dst' to '$dst.old'"
            else
                echo "Skipping '$location'"
                continue
            fi
        elif [[ -L "$dst" ]]; then
            # A broken symlink exists
            if ask_yes_no "Warning: a (broken) symlink already exists at '$dst'. Delete it?"; then
                rm "$dst"
                echo "Deleted existing symlink '$dst'"
            else
                echo "Skipping '$location'"
                continue
            fi
        fi

        ln -s "$src" "$dst"
        echo "Linked '$src' -> '$dst'"
    fi

done < "$locations_src"

echo "Done$"
