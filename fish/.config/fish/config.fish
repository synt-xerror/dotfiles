# ============================================================================
# INTERACTIVE SHELL CHECK
# ============================================================================

status is-interactive; or exit
set -U fish_greeting ""

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

if test -f ~/.secrets/env
    source ~/.secrets/env
end

set -gx EDITOR nvim
set -gx force_color_prompt yes
set -gx GPG_TTY (tty)
set -Ux GPG_PINENTRY_MODE loopback
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

# ============================================================================
# PATH
# ============================================================================

set -gx PATH $HOME/.local/share/gem/ruby/3.4.0/bin $HOME/.cargo/bin $HOME/.npm-global/bin $HOME/.local/bin $HOME/go/bin $PATH

# ============================================================================
# HISTORY (fish é automático, mas dá pra ajustar)
# ============================================================================

set -g fish_history 10000

# ============================================================================
# SSH AGENT
# ============================================================================

if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) >/dev/null
end

ssh-add ~/.ssh/key

# ============================================================================
# BINDS
# ============================================================================

# Em fish, binds são via bind
bind \ca beginning-of-line
bind \ce end-of-line

bind \cw backward-kill-word
bind \cu backward-kill-line
bind \ck kill-line

bind \cr history-search-backward

bind \eb backward-word
bind \ef forward-word

# Ctrl + setas
bind \e\[1\;5D backward-word
bind \e\[1\;5C forward-word
bind \e\[5D backward-word
bind \e\[5C forward-word

# Home / End
bind \e\[H beginning-of-line
bind \e\[F end-of-line
bind \e\[1\~ beginning-of-line
bind \e\[4\~ end-of-line

# ============================================================================
# PROMPT
# ============================================================================

function fish_prompt
    set_color normal

    if test $status -eq 0
        set color green
    else
        set color red
    end

    set_color $color
    echo -n (prompt_pwd) (fish_git_prompt) '$ '
    set_color normal
end

# ============================================================================
# ALIASES
# ============================================================================

function ddgr
  set -x BROWSER w3m
  command ddgr $argv
end

alias sshrc='source ~/.config/fish/config.fish'
alias shrc='$EDITOR ~/.config/fish/config.fish'

alias yay='echo "yay was removed"; echo "try paru"'

alias ..='cd ..'
alias ...='cd ../..'

alias volup="pactl set-sink-volume @DEFAULT_SINK@ +5%"
alias voldown="pactl set-sink-volume @DEFAULT_SINK@ -5%"

# Work directories
alias w='cd ~/work'
alias wa='cd ~/work/active'
alias ws='cd ~/work/stable'
alias wr='cd ~/work/archived'
alias wc='cd ~/work/clones'
alias we='cd ~/work/experiments'
alias wp='cd ~/work/paused'

# Projects
alias mync='cd ~/work/active/myneocities'
alias ncc='cd ~/work/active/neocities-c'
alias ngit='cd ~/work/active/neogities'

# Home shortcuts
alias desk='cd ~/desk'
alias dev='cd ~/dev'
alias dload='cd ~/dload'
alias doc='cd ~/doc'
alias mov='cd ~/mov'
alias pic='cd ~/pic'
alias scripts='cd ~/scripts'
alias song='cd ~/song'
alias tmp='cd ~/tmp'
alias vault='cd ~/vault'

# Git
alias gstt='git status'
alias glog='git log'
alias gstag='git diff --staged'
alias gch='git checkout'
alias gchb='git checkout -b'
alias gpo='git push origin'
alias gpu='git pull origin'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gtag='git tag'
alias gseto='git remote set-url --add origin'

# Sway
alias swayrc='nvim /home/syntax/.config/sway/config'

# Misc
alias life='emacs -nw ~/life/life.org'
alias icat='kitten icat'
alias bat='cat /sys/class/power_supply/BAT0/capacity'
alias vim='nvim'
alias vi='nvim'

# EZA
if type -q eza
    alias ls='eza -hF --group-directories-first'
    alias la='eza -lahF --group-directories-first'
    alias tree='eza --tree'
end

# PACMAN WRAPPER
function pacnews
    echo "Checking Arch news before upgrade..."
    command pacman $argv
end

# KEYBOARD & TERMINAL
type -q setterm; and setterm -blength 0 2>/dev/null
type -q setxkbmap; and setxkbmap br abnt2 2>/dev/null

# STARTUP
clear
if status is-interactive
    task read &
end
