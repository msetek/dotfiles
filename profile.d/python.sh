if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

python-latest() {
    echo "3.8.3"
}

pyenv-has-version() {
    local version=$1

    pyenv versions --bare | grep "^$version\$"
}

new-python-project() {
    local appname="$1"

    if [[ -z $appname ]]; then
        echo "No project name given."
        read -ep "What do you want to call the project? " appname
        if [[ -z $appname ]]; then
            echo "You must give the project a name. Aborting"
            return
        fi
    fi

    local latest_python="$(python-latest)"
    if ! pyenv-has-version "$latest_python" &>/dev/null; then
        echo "The latest version of python is not available in pyenv. Aborting"
        return
    fi


    if mkdir "$appname"; then
        cd $appname

        if pyenv local "$latest_python"; then

            cat > .envrc <<EOF
if [[ -f ".python-version" ]]; then
    layout_python3 # this is provided by direnv
fi
EOF
        fi

        direnv allow
    fi
}

python-site-packages() {
    python -c 'import re, sys; print(list(filter(re.compile("site-packages").search, sys.path))[0])'
}
