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

macos_dock
configure_emacs

echo "Configuration completed"
