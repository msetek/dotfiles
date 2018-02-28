new-rails-app() {
    local -r appname="$1"
    if [[ -z $appname ]]; then
        echo "No project name given"
        return
    fi

    echo "Creating new rails application using the system ruby"
    echo "Ruby version used: $(ruby --version)"
    rails new "$appname"
    cd "$appname"

    echo "adding .ruby-version file"
    ruby --version |
        sed -E 's/ruby ([0-9]+.[0-9]+.[0-9]+).*/\1/' > .ruby-version

    echo "adding ruby version dependency to Gemfile"
    echo ruby \'$(cat "$appname/.ruby-version")\' >> Gemfile

    echo "adding Twitter Bootstrap styling"
    echo <<EOF >> Gemfile
# Twitter Bootstrap 

gem 'therubyracer'
gem 'less-rails', '~> 3.0'
gem 'twitter-bootstrap-rails'
EOF

    echo "adding Github repo"
    hub create -p "$appname"
    git add --all
    git commit -m "Initial app generation"
    git push -u origin master

    echo "The app $appname is now ready.."
    alias r="$PWD/bin/rails"
    echo "And the local rails command is aliased to r"
    echo "See https://github.com/seyhunak/twitter-bootstrap-rails for styling"
}

function __workspace_cd() {
    cd "$@"
    if [[ -x bin/rails ]]; then
        alias r="$PWD/bin/rails"
    fi
}

alias cd="__workspace_cd"
