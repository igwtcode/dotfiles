setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

export HISTORY_TIME_FORMAT="%Y-%m-%d %T "
HISTFILE=~/.zsh_history
HISTSIZE=6000
SAVEHIST=9000

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias exit=' exit'
alias pwd=' pwd'
alias bg=' bg'
alias fg=' fg'
alias lazygit=' lazygit'
alias clear=' clear'
alias nvim=' nvim'
alias bat=' bat'
alias hist=' history -E'
alias lg=lazygit
alias c=clear
alias v=nvim
alias b=bat
alias src='source $HOME/.zshrc'
alias lt='eza --group-directories-first --ignore-glob ".git|.DS_Store" -laTL'
alias ll='eza --group-directories-first --ignore-glob ".DS_Store" -l'
alias lla='ll -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

export EDITOR=nvim
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

nvim_mason=$HOME/.local/share/nvim/mason/bin
rancher_desktop=$HOME/.rd/bin
export GOPATH=$HOME/go/bin
export PATH=$GOPATH:$nvim_mason:$rancher_desktop:$PATH
unset nvim_mason
unset rancher_desktop

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
eval "$(starship init zsh)"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

# Reevaluate the prompt string each time it's displaying a prompt
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit
complete -C "$(brew --prefix)/bin/aws_completer" aws

# pull all git branches
git_pull_all_branches() {
  local current_branch=$(git branch --show-current)
  git fetch origin

  # Get a list of all remote branches (stripped of the 'origin/' prefix)
  for branch in $(git branch -r | grep -v '\->' | sed 's/origin\///'); do
    if ! git show-ref --verify --quiet refs/heads/$branch; then
      git branch --track "$branch" "origin/$branch"
    fi
    echo
    git checkout $branch && git pull origin $branch
  done

  git switch $current_branch
}

# pull all repos with a name filter in directory
pull_tracking() {
  for x in $(ls -1 |grep -i '.modul.tracking'); do echo -e "\n---------\n==> $x\n" && cd $x && git_pull_all_branches && cd .. ; done
}
