__git_dir_in_repo() {
    local -r dirname=$1

    if [[ -z $dirname ]]; then
        git rev-parse > /dev/null
    else
        git -C "$dirname" rev-parse > /dev/null
    fi
}

__sort_versions_first() {
    cat
}

gitt() {
    if __git_dir_in_repo; then
        git tag -l | __sort_versions_first
    fi
}
