autoload -U colors && colors

export ZSH=/usr/share/oh-my-zsh/
#export ZSH="/home/$USER/.oh-my-zsh"
ZSH_THEME="arrow"
plugins=(git)

if [ -f $ZSH/oh-my-zsh.sh ]; then
  source $ZSH/oh-my-zsh.sh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# zsh-autocomplete from marlonrichert
#source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# For a better Prompt
precmd() { print "" }
#PS1='%B%(?.%K{73}.%K{167}) %k %F{195}%4~ / %k%b%f '
#PS2='%K{167} %K{235} -> %k '
RPROMPT='%K{234} %K{235} %F{230}%D{%H:%M} %K{167} %k'

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
#
# End of lines added by compinstall
#
PATH=$PATH:$HOME/.local/bin
#eval "$(starship init zsh)"

## My Stuff
neofetch
# Stupid: urxvt -fn "xft:zekton rg:size=10"
