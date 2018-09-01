#
# ~/.bashrc
#
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ ' originally in bashrc

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='[\[\033[01;32m\]\u\[\033[01;36m\]@\h\[\033[00m\]: \[\033[01;34m\]\W\[\033[00m\]]\$ '
else
    PS1='[\u@\h: \W]\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export VISUAL="nano"
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#profiles
if [ -f ~/profile ]; then
    . ~/profile
fi

#check for screen/tmux
if [ -n "$STY" ]; then 
	export PS1="(screen) $PS1"
elif [ -n "$TMUX" ]; then 
	export PS1="(tmux) $PS1"
else 
	exec fish
fi
