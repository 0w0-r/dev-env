# exit for non-interactive shell
[[ $- != *i* ]] && return

# Load Zinit (plugin manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins
zinit ice lucid atload'FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"'
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice lucid atload'ZSH_AUTOSUGGEST_USE_ASYNC=1'
zinit light zsh-users/zsh-autosuggestions

# Load starship prompt
if ! command -v starship >/dev/null 2>&1; then
    # 安装 starship
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
starship preset bracketed-segments -o ~/.config/starship.toml
eval "$(starship init zsh)"

alias ls='ls --color=auto'


# History settings
HISTSIZE=20000
SAVEHIST=50000
HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
mkdir -p ${HISTFILE:h}
setopt \
  INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS \
  HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS \
  HIST_IGNORE_SPACE HIST_VERIFY

zstyle ':completion::*:-command-::' ignored-patterns \
       '*.@(pdf|exe|dll|dylib)(|.~)'
zstyle ':completion::*:sh:|*:bash:|*:zsh:' tag-order \
       'files:-file:file' 'aliases:-alias:alias' \
       'functions:-function:function' 'builtins:-builtin:builtin' \
       'commands:-command:command'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${ZDOT_DIR:-$HOME}/.zsh_cache

# Directory stack settings
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars
alias d='dirs -v | head -10'


# Disable correction
unsetopt correct_all correct prompt_cr prompt_sp



# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none






