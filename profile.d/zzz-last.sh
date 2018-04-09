# Set up override path
if [[ ! -d ~/bin/overrides ]]; then
    mkdir ~/bin/overrides
fi

export PATH=~/bin/overrides:$PATH

# Support having bash 4 installed without it being the default or coming first
# Also, let it be known as bash4 in the path
if [[ -x /usr/local/bin/bash ]]; then
    ln -s -f /bin/bash ~/bin/overrides/bash
    ln -s -f /usr/local/bin/bash ~/bin/overrides/bash4
fi
