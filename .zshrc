export ZSH="$HOME/.oh-my-zsh"

# ZSH customizations
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
	git npm golang gpg-agent docker docker-compose brew extract python rust node
)

FPATH="${FPATH}:~/.zfunc"

# SSH
SSH_ENV=$HOME/.ssh/environment

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
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  if [ -f "${SSH_ENV}" ]; then
      . ${SSH_ENV} > /dev/null
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          start_agent;
      }
  else
      start_agent;
  fi
fi

# Homebrew
if type brew &>/dev/null
then
  FPATH="${FPATH}:$(brew --prefix)/share/zsh/site-functions"
fi

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
export PATH=$PATH:$GOBIN

# LOCAL BINARIES
export PATH=$PATH:$HOME/.local/bin

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

# enable bash completion
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
