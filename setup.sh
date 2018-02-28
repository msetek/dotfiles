#/usr/bin/env bash

readonly BUNDLEDIR=$(dirname $(grealpath --canonicalize-existing --logical "$BASH_SOURCE"))

macos_dock() {
    # Configure the dock
    echo "Configure the macOS dock"
    defaults write com.apple.dock autohide -bool true
    killall "Dock" &> /dev/null
}

macos_full_keyboard_access() {
    echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
}

macos_hide_desktop_icons() {
    echo "Hiding all desktop icons"
    defaults write com.apple.finder CreateDesktop false
    killall Finder &> /dev/null
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
    echo "Link up dotfiles"
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

    # anyenv install pyenv
    # anyenv install ndenv
    # anyenv install jenv
    # anyenv install scalaenv
    # anyenv install sbtenv
    # anyenv install hsenv
}

configure_postgres() {
    brew services start postgresql
    createdb $USER
}

ssh_fix_config() {
    if grep -e '^\ *SendEnv LANG LC_\*' /etc/ssh/ssh_config > /dev/null; then
        echo "Patch /etc/ssh/ssh_config"
        sudo patch -p0 <<'EOF'
--- /etc/ssh/ssh_config.orig    2016-07-28 02:59:24.000000000 +0200
+++ /etc/ssh/ssh_config 2016-07-28 02:59:35.000000000 +0200
@@ -19,7 +19,7 @@
 
 # Apple:
  Host *
-   SendEnv LANG LC_*
+#   SendEnv LANG LC_*
 #   AskPassGUI yes
EOF
    fi
}

add_login_item() {
    local -r ITEM_NAME="$1"
    local -r ITEM_PATH="$2"
    osascript -e "tell application \"System Events\" to make new login item with properties { path: \"$ITEM_PATH\", name: \"$ITEM_NAME\" } at end"
}

add_login_items() {
    add_login_item 'Spectacle' '/Applications/Spectacle.app'
    add_login_item 'Jumpcut' '/Applications/Jumpcut.app'
    add_login_item 'Alfred 3' '/Applications/Alfred 3.app'
}

logout_user() {
    osascript -e 'tell app "System Events" to log out'
}

macos_dock
macos_full_keyboard_access
macos_hide_desktop_icons
install_dotfiles
configure_emacs
configure_anyenv
ssh_fix_config
add_login_items

echo "Configuration completed"
logout_user
