# On a typical UNIX system, terminal windows would host non-login
# shells, because .bash_profile would have been executed on login and
# the shells would inherit the settings. That doesn't happen on Mac OS
# X, though, so Apple Terminal hosts login shells.

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Calendar Reminder Service

if [ -f ~/calendar.txt ]; then
    calendar -f ~/calendar.txt
fi

if [ $SECONDS -gt 0 ]; then
    echo "Huh. It took ${SECONDS} seconds to get here."
fi
