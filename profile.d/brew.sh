setup_bash_completion() {
    if hash brew &> /dev/null; then
        local -r completion_file="$(brew --prefix)/etc/bash_completion"
        if [[ ! -r $completion_file ]]; then
            echo "Installing missing bash completion.. Please wait"
            hash -r
            brew update && brew install bash-completion
        fi
        source "$(brew --prefix)/etc/bash_completion"
    else
        echo "No brew found.. bash-completion setup skipped" 2>&1
    fi
}

setup_bash_completion
unset setup_bash_completion

export PATH="/usr/local/sbin:$PATH"

