export ZSH="$HOME/.oh-my-zsh"

# ZSH customizations
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
	git npm golang docker docker-compose python node zsh-autosuggestions yarn
)

# Completion modules    
zfunc=$HOME/.zfunc
if [[ ! -d $zfunc ]]; then
  mkdir -p $zfunc
fi
if type rustup 1> /dev/null; then
  if [[ ! -f $zfunc/_cargo ]]; then
    rustup completions zsh cargo > $zfunc/_cargo
  fi
  if [[ ! -f $zfunc/_rustup ]]; then
    rustup completions zsh > $zfunc/_rustup
  fi
fi
if type pip 1> /dev/null; then
  if [[ ! -f $zfunc/_pip ]]; then    
    pip completion --zsh > $zfunc/pip.zsh
  fi
  
  source $zfunc/pip.zsh
fi
if type pip3 1> /dev/null; then
  if [[ ! -f $zfunc/_pip ]]; then    
    pip3 completion --zsh > $zfunc/pip3.zsh
  fi
  
  source $zfunc/pip3.zsh
fi
if type flutter 1> /dev/null; then
  if [[ ! -f $zfunc/_flutter ]]; then
    flutter zsh-completion --suppress-analytics > $zfunc/flutter.zsh
  fi

  source $zfunc/flutter.zsh
fi
fpath=($zfunc $fpath)

# SSH
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
    echo "succeeded"
    chmod 600 ${SSH_ENV}
    . ${SSH_ENV} > /dev/null
    /usr/bin/ssh-add
}

if [[ $(uname -s) == "Linux" ]]; then  
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  
  export PATH=$PATH:/usr/local/go/bin

  # add installed homebrew openssl library for rust
  if [[ -d "/home/linuxbrew/.linuxbrew/Cellar/openssl@1.1/1.1.1o" ]]; then
    export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/Cellar/openssl@1.1/1.1.1o/lib:$LD_LIBRARY_PATH
  fi

  alias vpn-up="wg-quick up wg0"
  alias vpn-down="wg-quick down wg0"

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
  export FPATH="${FPATH}:$(brew --prefix)/share/zsh/site-functions"
fi

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Flutter configuration
export PATH=$PATH:$HOME/flutter/bin
export PATH=$PATH:$HOME/.pub-cache/bin

# Golang configuration
export GOPATH=$(go env GOPATH)
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export GOPROXY=direct

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
alias http="xh"
alias https="xhs"
alias vim="nvim"

# MinIO
complete -o nospace -C /usr/local/bin/mc mc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# enable bash completion
autoload -Uz bashcompinit; bashcompinit
autoload -Uz compinit; compinit
