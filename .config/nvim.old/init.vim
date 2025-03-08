set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
luafile ~/.config/nvim/pydev.lua
luafile ~/.config/nvim/cmds.lua

