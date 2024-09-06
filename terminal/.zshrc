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

FZF_PLUGIN_HOME="${XDG_DATA_HOME:-$OH_MY_ZSH_HOME}/custom/plugins/fzf"
if [ ! -d "$FZF_PLUGIN_HOME" ]; then
	mkdir -p "$(dirname $FZF_PLUGIN_HOME)"
	git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_PLUGIN_HOME"
	$FZF_PLUGIN_HOME/install
fi

TASK_PLUGIN_HOME="${XDG_DATA_HOME:-$OH_MY_ZSH_HOME}/custom/plugins/task"
if [ ! -d "$TASK_PLUGIN_HOME" ]; then
	mkdir -p "$(dirname $TASK_PLUGIN_HOME)"
	git clone https://github.com/sawadashota/go-task-completions.git "$TASK_PLUGIN_HOME"	
fi

PNPM_PLUGIN_HOME="${OH_MY_ZSH_HOME:-$HOME}/custom/plugins/pnpm"
if [ ! -d "$PNPM_PLUGIN_HOME" ]; then
	mkdir -p "$(dirname $PNPM_PLUGIN_HOME)"
	git clone --depth=1 https://github.com/ntnyq/omz-plugin-pnpm.git "$PNPM_PLUGIN_HOME"	
fi

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions


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
	pnpm
	task
)

ASDF_PATH="${XDG_DATA_HOME:-${HOME}/.asdf}"
if [ ! -d "$ASDF_PATH" ]; then
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

. "$HOME/.asdf/asdf.sh"

# Load completions
autoload -U compinit
compinit -i

# Path to your oh-my-zsh installation.
export ZSH="$OH_MY_ZSH_HOME"

source $ZSH/oh-my-zsh.sh


# source ~/.local/share/zinit/plugins/Aloxaf---fzf-tab/fzf-tab.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ZOXIDE="${XDG_DATA_HOME:-${HOME}/.local/bin}"
# if [ ! -d "$ZOXIDE" ]; then
# 	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# fi

export PATH="$HOME/.local/bin:$PATH"


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
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
source <(fzf --zsh)
# eval "$(zoxide init --cmd cd zsh)"

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

# pnpm
export PNPM_HOME="/home/tiagoluizpoli/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# source ~/completion-for-pnpm.zsh

export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

PATH=~/.console-ninja/.bin:$PATH