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
        echo "Ignoring the node_modules dir"
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

pwg () {
    pwsafe --list -l | grep -C3 -i "$1"
}

pw () {
    pwsafe -pE "$1" | pbcopy
}

findf() {
    local fname="$1"

    find . -type f -iname "*${fname}*" 
}

top10() {
    history |
        awk '{CMD[$2]++;count++;} END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a;}' |
        grep -v "./" |
        column -c3 -s " " -t |
        sort -nr |
        nl |
        head -n10
}

favicon() {
    convert "$1"  -background white \
            \( -clone 0 -resize 16x16 -extent 16x16 \) \
            \( -clone 0 -resize 32x32 -extent 32x32 \) \
            \( -clone 0 -resize 48x48 -extent 48x48 \) \
            \( -clone 0 -resize 64x64 -extent 64x64 \) \
            -delete 0 -alpha off -colors 256 favicon.ico
}

alias l='ls -1aF '
alias b='bat --plain '
alias bb='bat '
alias agg='ag --ignore node_modules --ignore dist '

