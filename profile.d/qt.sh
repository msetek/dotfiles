if brew ls --versions 'qt@5.5' > /dev/null; then
    export PATH="$PATH:$(brew --prefix qt@5.5)/bin"
fi
