export ZSH="/Users/antoine/.oh-my-zsh"

# ZSH customizations
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
	git npm golang gpg-agent docker docker-compose brew node 
	zsh-autosuggestions extract python
)

fpath+=~/.zfunc
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Flutter configuration
export PATH=$PATH:$HOME/flutter/bin
export PATH=$PATH:$HOME/.pub-cache/bin

# Golang configuration
export GOPATH=$(go env GOPATH)
export GOBIN=$GOPATH/bin
export PATH="$GOBIN:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# LOCAL BINARIES
export PATH="$PATH:$HOME/.local/bin"

# Rust
export PATH=$PATH:$HOME/.cargo/bin

# Starship
eval "$(starship init zsh)"

# Global export
HISTSIZE=1000
SAVEHIST=1000

# Aliases
alias ls="exa"
alias cat="bat"
alias dc="docker-compose"
alias src="source ~/.zshrc"

# enable bash completion
autoload -U +X bashcompinit && bashcompinit

# MinIO
complete -o nospace -C /usr/local/bin/mc mc

# Homebrew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi
