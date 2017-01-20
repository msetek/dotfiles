# Per user bash config files
for script in ~/.profile.d/*; do
  if [[ -r $script ]]; then
    source $script
  fi
done

# Bash completion
for script in $(brew --prefix)/etc/bash_completion.d/*; do
    source $script
done

# OPAM configuration
. /Users/martin/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
