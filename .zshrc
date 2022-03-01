export ZSH="${HOME}/.oh-my-zsh"

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

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    echo succeeded
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    /usr/bin/ssh-add
}

if [[ $(uname -s) == "Linux" ]]; then
  if [ -f "${SSH_ENV}" ]; then
      . ${SSH_ENV} > /dev/null
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          start_agent;
      }
  else
      start_agent;
  fi
fi


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


# MinIO
complete -o nospace -C /usr/local/bin/mc mc

# Homebrew
if type brew &>/dev/null
then
  brew_prefix=$(brew --prefix)
  export HOMEBREW_PREFIX="${brew_prefix}";
  export HOMEBREW_CELLAR="${brew_prefix}/Cellar";
  export HOMEBREW_REPOSITORY="${brew_prefix}/Homebrew";
  export PATH="${brew_prefix}/bin:${brew_prefix}/sbin${PATH+:$PATH}";
  export MANPATH="${brew_prefix}/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="${brew_prefix}/share/info:${INFOPATH:-}";
  FPATH="${brew_prefix}/share/zsh/site-functions:${FPATH}"
fi

# enable bash completion
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

