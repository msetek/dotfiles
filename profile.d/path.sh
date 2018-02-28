__show_path() {
    echo $PATH | tr ':' '\n'
}

__path_present() {
    local -r path=$1
    __show_path | fgrep --quiet "$path"
}

__append_path() {
    local -r p=$1

    if ! __path_present "$p"; then
        if [[ -x $p && -r $p ]]; then
            export PATH="$PATH:$p"
        fi
    fi
}

path() {
    if [[ $# -eq 0 ]]; then
        __show_path
    else
        local path=
        for path in "$@"; do
            __append_path "$path"
        done
    fi
}
