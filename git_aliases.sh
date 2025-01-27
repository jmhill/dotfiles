#!/bin/sh

git config --global alias.l "log --pretty=format:'%C(#cccc00)%h %Cred%ad %Creset%<(60,trunc)%s%C(auto)%d %C(magenta)%<(15,trunc)%an' --date=format:'%y%m%d'"

git config --global branch.sort -committerdate

git config --global alias.b "branch --format='%(color:#cccc00)%(objectname:short) %(color:red)%(committerdate:short) %(color:bold white)%(refname:short)'"
