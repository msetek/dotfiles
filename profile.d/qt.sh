if brew ls --versions 'qt@5.12' > /dev/null; then
    export PATH="$PATH:$(brew --prefix qt@5.12)/bin"
fi
