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

cdroot() {
    local rootdir=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ -n $rootdir ]]; then
        cd $rootdir
    else
        echo "could not find the root dir. Not inside a project?"
    fi
}

git-cleanup() {
    git remote prune origin &&
        git branch -r |
            awk '{print $1}' |
            egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) |
            awk '{print $1}' |
            xargs git branch -d
}

findfile() {
    local filename="$1"
    if [[ -z $filename ]]; then
        echo "missing filename argument"
        return
    fi

    find . -type f -iname '*'"$filename"'*'
}

newrepo() {
    local reponame="$1"
    if [[ -z $reponame ]]; then
        echo "missing argument: repository name"
        return
    fi

    if [[ -d $reponame ]]; then
        echo "directory already exists"
    else
        if git init "$reponame"; then
            cd "$reponame"
            hub create "$reponame" -p
        else
            echo "Could not initialize repo $repname"
        fi
    fi
}

dude() {
    local manpage="$1"
    if [[ -z $manpage ]]; then
        echo "No manpage given"
        return
    fi
    man -t "$manpage" | open -f -a /Applications/Preview.app
}

alias be='bundle exec '

pwg ()
{
    pwsafe --list -l | grep -C3 -i "$1"
}

pw ()
{
    pwsafe -pE "$1" | pbcopy
}
