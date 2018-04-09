# only run liquidprompt for interactive shells
if [[ -f /usr/local/share/liquidprompt && $- = *i* ]]; then
    . /usr/local/share/liquidprompt
fi
