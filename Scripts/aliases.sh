#!/bin/bash

gittyp() {
    flatpak run com.github.Murmele.Gittyup
}

if command_exist lsd; then
	alias ll="lsd -Al"
	alias l="lsd -A"
fi

alias rm=trash
alias rm_="/usr/bin/rm"


