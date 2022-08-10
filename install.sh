#!/bin/bash

set -o errexit -o pipefail -o nounset

# Uncomment this line for debugging
# set -o xtrace

# List of config files to install in ${HOME}
DOTFILES=(
    git/gitconfig
    idea/ideavimrc
    sh/aliases
    sh/zshrc
    tmux/tmux.conf
    vim/gvimrc
    vim/vim
    vim/vimrc
)

safe_symlink() {
    local source=${1}
    local target=${2}
    local force=${3}

    if [ ! -e "${source}" ]; then
        echo "Error: ${source} not found"
        return 1
    fi

    # find absolute path to source
    local source=$(cd "$(dirname "${source}")" && pwd)/$(basename "${source}")

    if [ -e "${target}" ] && ! "${force}"; then
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
    local force=false
    if [ $# -gt 0 ]; then
        if [ "$1" = "-f" ]; then
            force=true
        else
            echo "Usage: $0 [-f]" >&2
            exit 1
        fi
    fi

    local path
    for path in "${DOTFILES[@]}"; do
        local target=${HOME}/.$(basename "${path}")
        safe_symlink "${path}" "${target}" "${force}"
    done
}

main $@
