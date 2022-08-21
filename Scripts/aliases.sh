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


if ! command_exist nvim; then
    alias basrhc="vim ~/.bashrc"
    alias vimrc="vim ~/.vimrc"
    alias nvimrc="vim ~/.config/nvim/init.lua"
else
    alias basrhc="nvim ~/.bashrc"
    alias vimrc="nvim ~/.vimrc"
    alias nvimrc="nvim ~/.config/nvim/init.lua"
fi



