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

    echo "Installing dotfile: $DOTFILE"

    if [[ -L "$HOMEFILE" && ! -d $DOTFILE ]]; then
        ln -svf "$DOTFILE" "$HOMEFILE"
    else
	      rm -rv "$HOMEFILE" &> /dev/null
	      ln -sv "$DOTFILE" "$HOMEFILE"
    fi
}

configure_emacs() {
    if brew_cask_installed emacs && [[ -f "$BUNDLEDIR/spacemacs" ]]; then
        # install spacemacs
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
    git clone https://github.com/riywo/anyenv ~/.anyenv
    echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(anyenv init -)"' >> ~/.bash_profile

    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"

    anyenv_install "Ruby" "rbenv" "2.3.1"
    anyenv_install "Perl" "plenv" "5.24.0"

    # anyenv install pyenv
    # anyenv install ndenv
    # anyenv install jenv
    # anyenv install scalaenv
    # anyenv install sbtenv
    # anyenv install hsenv
}

macos_dock
configure_emacs
configure_anyenv

echo "Configuration completed"
