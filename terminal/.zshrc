# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

OH_MY_ZSH_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_HOME" ]; then
	mkdir -p "$(dirname $OH_MY_ZSH_HOME)"
	git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_HOME"
fi
# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf---fzf-tab

# Load completions
autoload -U compinit && compinit

# Path to your oh-my-zsh installation.
export ZSH="$OH_MY_ZSH_HOME"

source $ZSH/oh-my-zsh.sh


source ~/.local/share/zinit/plugins/Aloxaf---fzf-tab/fzf-tab.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


plugins=(
	git
	docker
	docker-compose
	dotnet
	flutter
	git-commit
	aws
	dnf
	asdf
	yarn
	npm
	nats
	github
	node
	z
	bgnotify
	# These two plugins must be installed manually along the tool it self
	# pnpm
	# task
)



# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"

# Utils

# create directories recursively and cd into it.
mkdircd() {
    mkdir -p "$1" && cd "$1"
}

# ranger
# sudo apt install ranger
# cd into the last directory visited by ranger (when pressing "q" to leave the tool)
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}



# Aliases
# system replacements
alias ls='ls --color'

# custom
alias mkcd='mkdircd'
alias ranger='ranger_cd'
alias r='ranger_cd'