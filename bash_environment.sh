# The PATH

function path_prepend {
    if [ -d "$1" ]; then
        PATH="$1:$PATH"
    else
        echo "warning: will not append '$1' to PATH, does not exist"
    fi
}

path_prepend /opt/local/sbin
path_prepend /opt/local/bin
path_prepend /Applications/MacPorts/Emacs.app/Contents/MacOS/bin
path_prepend "${HOME}/bin"

export PATH

export DISPLAY=0 # without this, emacsclient creates a TTY frame

export EDITOR="emacsclient --create-frame --alternate-editor=nano"

export AWS_DEFAULT_PROFILE=benzado

# Regarding shell history,
# - commands starting with a space will not be recorded
# - duplicate commands will be removed from history

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=10000

# Enable color output from `ls` like a civilized person.

export CLICOLOR=1

# Sets the prompt using a random color. I like to do this to make
# different terminal windows more easily recognizable.

# 0: Black        1: Red          2: Green        3: Yellow
# 4: Blue         5: Magenta      6: Cyan         7: White

# Hat Tip: The Bash $PS1 Generator
# <http://www.kirsle.net/wizards/ps1.html>

PS_COLOR=$(tput setaf $((RANDOM % 5 + 1)))
PS_BEGIN="\[$(tput bold)${PS_COLOR}\]"
PS_END="\[$(tput sgr0)\]"

export PS1="$PS_BEGIN[\u:\W]\\$ $PS_END"
export PS2="$PS_BEGIN> $PS_END"

unset PS_COLOR
unset PS_BEGIN
unset PS_END

if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then
    if [ -e /opt/local/share/git/git-prompt.sh ]; then
        source /opt/local/share/git/git-prompt.sh

        GIT_PS1=$PS1
        GIT_FORMAT="$(tput setaf 7)git: %s\n"

        function prompt_command {
            update_terminal_cwd;

            local GIT_PS1_SHOWDIRTYSTATE=1
            local GIT_PS1_SHOWCOLORHINTS=1
            __git_ps1 '' "$GIT_PS1" "$GIT_FORMAT"
        }

        # Don't export this since subshells won't have the
        # prompt_command function.
        PROMPT_COMMAND='prompt_command;'

        # Technically, we CAN also export the prompt_command function,
        # but then we also need to export __git_ps1 and everything it
        # depends on, which isn't really feasible.
    fi
fi
