#/usr/bin/env bash

readonly BUNDLEDIR=$(dirname $(grealpath --canonicalize-existing --logical "$BASH_SOURCE"))

macos_dock() {
    # Configure the dock
    echo "Configure the macOS dock"
    defaults write com.apple.dock autohide -bool true
    killall "Dock" &> /dev/null
}

brew_cask_installed() {
    brew cask info $1 &> /dev/null
}

install_dotfile() {
    local -r DOTFILE="$BUNDLEDIR/$1"
    local -r HOMEFILE="$HOME/.$1"

    [[ -e "$DOTFILE" ]] || return

    if [[ -L "$HOMEFILE" && ! -d $DOTFILE ]]; then
        ln -svf "$DOTFILE" "$HOMEFILE"
    else
	      rm -rv "$HOMEFILE" &> /dev/null
	      ln -sv "$DOTFILE" "$HOMEFILE"
    fi
}

install_dotfiles() {
    pushd "$BUNDLEDIR" > /dev/null
    for dotfile in *; do
        [[ "$dotfile" == "setup.sh" ]] && continue
        [[ "$dotfile" == "README.md" ]] && continue
        install_dotfile $dotfile
    done
    popd > /dev/null
}

configure_emacs() {
    if brew_cask_installed emacs && [[ -f "$BUNDLEDIR/spacemacs" ]]; then
        # install spacemacs
        [[ -d ~/.emacs.d ]] && return

	      echo "Installing spacemacs"
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

	      # first-time setup
	      echo "First-time setup of spacemacs"
	      if [[ ! -f ~/.spacemacs ]]; then
	          emacs -batch -l ~/.emacs.d/init.el
	      fi

        # configure spacemacs
        install_dotfile spacemacs
    fi
}

anyenv_install() {
    local -r NAME="$1"
    local -r ENV="$2"
    local -r VERSION="$3"

    echo "Install $NAME"
    anyenv install "$ENV"
    eval "$(anyenv init -)"
    "$ENV" install "$VERSION"
    "$ENV" global "$VERSION"
    eval "$(anyenv init -)"

}

configure_anyenv() {

    if [[ ! -d ~/.anyenv ]]; then
        git clone https://github.com/riywo/anyenv ~/.anyenv

        export PATH="$HOME/.anyenv/bin:$PATH"
        eval "$(anyenv init -)"

        anyenv_install "Ruby" "rbenv" "2.3.1"
        anyenv_install "Perl" "plenv" "5.24.0"
    fi

    # if [[ ! -e ~/.profile.d/anyenv.sh ]]; then
    #     echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.profile.d/anyenv.sh
    #     echo 'eval "$(anyenv init -)"' >> ~/.profile.d/anyenv.sh
    # fi

    # anyenv install pyenv
    # anyenv install ndenv
    # anyenv install jenv
    # anyenv install scalaenv
    # anyenv install sbtenv
    # anyenv install hsenv
}

configure_bash() {
    [[ -r ~/.bash_profile ]] && return

    cat <<'EOF' >> ~/.bash_profile
for script in ~/.profile.d/*.sh; do
  if [[ -r $script ]]; then
    source $script
  fi
done
EOF
}

macos_dock
install_dotfiles
configure_bash
configure_emacs
configure_anyenv

echo "Configuration completed"
