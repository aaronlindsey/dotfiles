#!/bin/bash

set -o errexit -o pipefail -o nounset

# Uncomment this line for debugging
# set -o xtrace

# List of config files to install in ~/
DOTFILES=(
    git/gitconfig
    idea/ideavimrc
    sh/aliases
    sh/inputrc
    sh/zshrc
    tmux/tmux
    tmux/tmux.conf
    vim/gvimrc
    vim/vim
    vim/vimrc
)

# List of directories to symlink under ~/.config
CONFIG_DIRS=(
    config/ghostty
)

# Path to AGENTS.md
AGENTS_MD=agents/AGENTS.md

# Whether to force overwrite existing files
FORCE=false

safe_symlink() {
    local source=${1}
    local target=${2}

    if [ ! -e "${source}" ]; then
        echo "Error: ${source} not found"
        return 1
    fi

    # find absolute path to source
    local source=$(cd "$(dirname "${source}")" && pwd)/$(basename "${source}")

    if [ -e "${target}" ] && ! "${FORCE}"; then
        ls -al "${target}"
        printf "Warning: ${target} already exists. Are you sure you want to overwrite it? [Y/n] "
        read opt
        case ${opt} in
            y*|Y*|"") ;;
            *) echo "Skipping..."; return 0 ;;
        esac

        if [ ! -h "${target}" ]; then
            local backup=${target}.backup
            echo "Creating a backup of non-symlink to be safe: ${backup}"
            cp -a "${target}" "${backup}"
        fi
    fi

    rm -rf "${target}"
    ln -s "${source}" "${target}"
}

main() {
    if [ $# -gt 0 ]; then
        if [ "$1" = "-f" ]; then
            FORCE=true
        else
            echo "Usage: $0 [-f]" >&2
            exit 1
        fi
    fi

    local path

    for path in "${DOTFILES[@]}"; do
        local target=${HOME}/.$(basename "${path}")
        safe_symlink "${path}" "${target}"
    done

    for path in "${CONFIG_DIRS[@]}"; do
        local target=${HOME}/.config/$(basename "${path}")
        safe_symlink "${path}" "${target}"
    done

    mkdir -p "${HOME}/.codex" "${HOME}/.claude"
    safe_symlink "${AGENTS_MD}" "${HOME}/.codex/AGENTS.md"
    safe_symlink "${AGENTS_MD}" "${HOME}/.claude/CLAUDE.md"
}

main $@
