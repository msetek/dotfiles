# Various convenience functions

ndir() {
    mkdir -p "$1" && cd "$1"
}

ec() {
    emacsclient -n "$1"
}

tre() {
    local args
    if [[ -d node_modules ]]; then
        args="-I node_modules"
    fi

    tree $args
}
