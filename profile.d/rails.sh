new-rails-app() {
    local appname="$1"
    if [[ -z $appname ]]; then
        echo "No project name given."
        echo "Usually, the project name looks like 'blog' or 'big_idea'."
        echo "The project name will also be the name of the project directory."
        read -p "What do you want to call the project? " appname
        if [[ -z $appname ]]; then
            echo "You must give a name. Aborting"
            return
        fi
    fi

    echo "Updating rails"
    gem update rails
    rbenv rehash
    echo "Installed rails version: $(rails -v)"
    echo "Ruby version used: $(ruby --version)"

    echo 'Choose the type of rails application:'
    select apptype in api-only komponent classic; do
        case $apptype in
            api-only)
                rails new "$appname" --database=postgresql --api
                cd "$appname"
                break
                ;;
            classic)
                rails new "$appname" --database=postgresql
                cd "$appname"
                break
                ;;
            komponent)
                echo 'Installing Yarn'
                npm install -g yarn
                nodenv rehash
                printf "\nGenerating rails app\n"
                rails new "$appname"        \
                      --database=postgresql \
                      --skip-coffee         \
                      --skip-sprockets      \
                      --skip-turbolinks     \
                      --webpack
                cd "$appname"

                printf "\nSetting up spring binstubs\n"
                bundle exec spring binstub --all

                printf "\nAllowing webpack-dev-server host as allowed origin for connect-src\n"
                echo <<EOF >> config/initializers/content_security_policy.rb
Rails.application.config.content_security_policy do |policy|
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end
EOF
                printf "\nAdding the komponent gem\n"
                echo "gem 'komponent'" >> Gemfile
                bundle install

                printf "\nInstalling komponent\n"
                bundle exec spring stop # we need to do this due to some bug in spring
                bundle exec rails generate komponent:install
                break
                ;;
        esac
    done

    echo "adding ruby version dependency to Gemfile"
    echo ruby \'$(cat .ruby-version)\' >> Gemfile

    if [[ $apptype == classic ]]; then
        echo "adding Twitter Bootstrap styling"
        echo <<EOF >> Gemfile
# Twitter Bootstrap 

gem 'therubyracer'
gem 'less-rails', '~> 3.0'
gem 'twitter-bootstrap-rails'
EOF
    fi

    read -p 'Do you want to add a Github repo? (yes/no): '
    if [[ $REPLY == yes ]]; then
        echo "adding Github repo"
        hub create -p "$appname"
        git add --all
        git commit -m "Initial app generation"
        git push -u origin master
    fi

    echo 'Set up the database'
    $PWD/bin/rails db:create db:migrate

    echo "The app $appname is now ready.."
    alias r="$PWD/bin/rails"
    echo "And the local rails command is aliased to r"
    if [[ $apptype == classic ]]; then
        echo "See https://github.com/seyhunak/twitter-bootstrap-rails for styling"
    elif [[ $apptype == komponent ]]; then
        echo "See https://github.com/komposable/komponent for how to proceed"
    fi
}

function __workspace_cd() {
    cd "$@"
    if [[ -x bin/rails ]]; then
        alias r="$PWD/bin/rails"
    fi
}

alias cd="__workspace_cd"
