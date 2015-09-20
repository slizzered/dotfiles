case "$0" in
          -sh|sh|*/sh)	modules_shell=sh ;;
       -ksh|ksh|*/ksh)	modules_shell=ksh ;;
       -zsh|zsh|*/zsh)	modules_shell=zsh ;;
    -bash|bash|*/bash)	modules_shell=bash ;;
esac
module() { eval `/usr/local/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }
#module() { eval `/bin/modulecmd $modules_shell $*`; }

setopt ALL_EXPORT 		# export all parameters automatically

# --------------------------------------------------------------------
# History & Environment # --------------------------------------------------------------------

HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=50000
HOSTNAME=`hostname`

PAGER='less'
EDITOR='vim'


setopt APPEND_HISTORY		# append history file, don't overwrite 
setopt SHARE_HISTORY		# 
setopt HIST_IGNORE_DUPS		# ignore duplicates in history
setopt HIST_IGNORE_ALL_DUPS 	# ignore duplicates in history, remove old
setopt INC_APPEND_HISTORY 	# write history entries immediately
setopt EXTENDED_HISTORY         # puts timestamps in the history


# --------------------------------------------------------------------
# General Options
# --------------------------------------------------------------------

setopt AUTO_CD			# automatically cd to a directory
unsetopt BEEP			# NOOOOOOOOOO! Don't beep!


setopt LONG_LIST_JOBS		# List jobs in the long format
unsetopt BG_NICE		# don't nice background jobs
setopt NOTIFY			# Status of background jobs immediately

#bindkey -v			# use vi style editor
#bindkey -e			# use emacs-style editor (since the vi-mode sucks in ZSH)

setopt PUSHD_TO_HOME		# act like `pushd $HOME' without arguments
setopt PUSHD_SILENT		# Don't print the directory stack after pushd or popd
setopt AUTO_PUSHD		# Make cd push the old directory onto the directory stack


setopt EXTENDED_GLOB 		# `#',`~' and `^' characters are patterns for filename generation
setopt GLOB_DOTS		# don't require . on filename recognition

setopt RC_QUOTES 		# Allow " to signify a single quote within singly quoted strings. 

setopt MAIL_WARNING		# print warning message if a mail file has been accessed


# --------------------------------------------------------------------
# Command Completion and Correction
# --------------------------------------------------------------------


setopt CORRECT			# correct spelling
setopt CORRECT_ALL		# correct the spelling of all arguments in a line


setopt AUTO_MENU		# use menu completion
### - OR -
#setopt MENU_COMPLETE		# tab through possibilities

setopt ALWAYS_TO_END            # move cursor to the end of the word on completion 
setopt COMPLETE_IN_WORD		# enable completition in the middle of words
setopt CDABLE_VARS 		# expand expression as if it were preceded by a `~' on cd
setopt AUTO_LIST		# list choices on an ambiguous completion

setopt AUTO_PARAM_SLASH		# If the parameter content is a directory, add a trailing slash


# --------------------------------------------------------------------
# Fortune
# --------------------------------------------------------------------

if [ `which fortune` ]; then
	#echo ""
	#fortune -s archer
fi


# --------------------------------------------------------------------
# Prompts & Colors
# --------------------------------------------------------------------

autoload colors zsh/terminfo

if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done

PR_NO_COLOR="%{$terminfo[sgr0]%}"

PR_USER_COLOR=$PR_CYAN
if [[ "`whoami`" = "root" ]]; then
	PR_USER_COLOR=$PR_LIGHT_RED
else
	PR_USER_COLOR=$PR_LIGHT_GREEN
fi

PS1="$PR_USER_COLOR% [%n@%m %2~$VCSPROMPT$PR_USER_COLOR]%(!.#.$)$PR_NO_COLOR "
PS2="$PR_WHITE%_$PR_NO_COLOR>"



# --------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------

alias sudo='nocorrect sudo'
alias git='nocorrect git'
alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'
alias kedpm='kedpm -c'
alias history='fc -ldErn -$HISTSIZE'
alias wifi='sudo wifi-menu'
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias lt='ls -lht --color=auto'
alias ltr='ls -lhtr --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto -n'
alias egrep='egrep --color=auto -n'
alias pacman-classic='/usr/bin/pacman'
alias srm='/usr/bin/trash-put'
alias mkdir='/bin/mkdir -p '
alias trash-restore='restore-trash'
alias dmesg="dmesg -T"
alias accumulate=' paste -sd+ - | bc'



# prevent VIM from freezing when I press CTRL-S 
alias vim="stty stop '' -ixoff ; vim"
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

# make SSH-agent work
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# use ssh-add to insert a key once it is needed 
#ssh-add -l >/dev/null || 
#eval "$(ssh-agent -s)" > /dev/null
alias ssh='ssh-add -l >/dev/null || ssh-addall && unalias ssh; ssh'


# --------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------

pacman() {
	case $1 in
		(-Ss | -Si | -Sql | -Q* | -T | -G)
			/usr/bin/pacman "$@" ;;
		(-R* | -U | *)
			/usr/bin/sudo /usr/bin/pacman "$@" ;;
	esac
}

ssh-addall() {
	ssh-add $(ls  ~/.ssh/*id_* | grep -v ".pub")
}

zpool(){
	case $1 in
		(add)
			/usr/bin/sudo /usr/bin/zpool -n "$@" ;;
		*)
			/usr/bin/sudo /usr/bin/zpool "$@" ;;
	esac
}

zfs(){
	case $1 in
		(destroy)
			/usr/bin/sudo /usr/bin/zfs -n "$@" ;;
		*)
			/usr/bin/sudo /usr/bin/zfs "$@" ;;
	esac
}

mkgo() {
	mkdir -p "$1" && cd "$1"
}

# --------------------------------------------------------------------
# Exports
# --------------------------------------------------------------------

export AWT_TOOLKIT=MToolkit
export PATH=$PATH:/home/carli/.cabal/bin
export EDITOR=/usr/bin/vim
export VISUAL=vim
export PYTHONDOCS=/usr/share/doc/python/html
# for arch-wiki-lite package with browser support!
export wiki_browser=firefox

# for steamVlinux (otherwise, pulseaudio is assumed...)
export SDL_AUDIODRIVER=alsa



# --------------------------------------------------------------------
# X11 settings
# --------------------------------------------------------------------

if [[ -n $DISPLAY ]]; then
	xhost + > /dev/null 2>&1
	xmodmap -e 'keycode 151 = Menu'
	xmodmap -e 'keycode 115 = End'
fi

# --------------------------------------------------------------------
# Key bindings
# --------------------------------------------------------------------

bindkey '^?' backward-delete-char			# correct behaviour of BACKSPACE in VI-Mode
bindkey "^H" backward-delete-char			# delete the character behind with ctrl+h
bindkey "^X" kill-whole-line				# delete the whole line with ctrl+x
bindkey '^[OH' beginning-of-line			# change to start of line on START
bindkey '^[OF' end-of-line				# change to end of line on END
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

bindkey '^[[5~' up-line-or-history			# pgup, go up one line
bindkey '^[[6~' down-line-or-history			# pgdown, go down one line

#bindkey '^[[A' up-line-or-history
#bindkey '^[[B' down-line-or-history

bindkey "^r" history-incremental-search-backward	# search backwards with ctrl+r
bindkey "^t" history-incremental-search-forward 	# search forward with ctrl+t

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward


bindkey ' ' magic-space    				# do history expansion on space
bindkey '^I' complete-word 				# complete on tab, leave expansion to _expand

bindkey    '^[[3~'          delete-char			# delete one character behind the cursor on DEL 
bindkey    '^[3;5'         delete-char			# same



# --------------------------------------------------------------------
# Completion parameters
# --------------------------------------------------------------------

autoload -Uz compinit
compinit


zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles

# force rehash of tab completion for NEW commands (see also below)
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1	# Because we didn't really complete anything
}


# list of completers to use
zstyle ':completion:*::::' completer _oldlist _expand _force_rehash _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
# zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#

#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
#zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

#ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort mpc mpd dropbox trine \
		eclipse 






# --------------------------------------------------------------------
# Autoload zsh modules
# --------------------------------------------------------------------


zmodload -a zsh/stat stat		# provide a stat builtin
zmodload -a zsh/zpty zpty		# zpty builtin (start command in new pseudo pty)
zmodload -a zsh/zprof zprof		
#zmodload -ap zsh/mapfile mapfile

#zmodload -a zsh/complist complist	# Colored completion list

