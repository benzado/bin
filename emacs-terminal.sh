#!/bin/bash
export PATH=/opt/local/bin:/usr/local/bin:/usr/bin:/bin

emacsclient --tty --alternate-editor= $*

# tty: Create a new client frame on the current text terminal, instead
# of using an existing Emacs frame.

# alternate-editor: Specify a command to run if emacsclient fails to
# contact Emacs; if the empty string is given, emacsclient starts
# Emacs in daemon mode (as emacs --daemon) and then tries connecting
# again.
