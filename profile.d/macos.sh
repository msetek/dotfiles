# various functions that are only needed on macOS

if [[ $OSTYPE =~ darwin ]]; then
    listening() {
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    }
fi
