PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local exit_code="$?"

    PS1="\h:\W \u $exit_code \$ "
}
