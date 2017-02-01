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

