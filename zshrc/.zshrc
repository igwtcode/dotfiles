setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

HISTFILE=~/.zsh_history
HISTSIZE=6000
SAVEHIST=9000

alias src='source $HOME/.zshrc'
alias tr='eza --group-directories-first --ignore-glob ".git|.DS_Store" -laTL'
alias ll='eza --group-directories-first --ignore-glob ".DS_Store" -l'
alias lla='ll -A'
alias lg='lazygit'
alias v=nvim
alias c=clear
alias b=bat
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

export HOMEBREW_NO_ANALYTICS=1
export EDITOR=nvim
export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

nvim_mason=$HOME/.local/share/nvim/mason/bin
export GOPATH=$HOME/go/bin
export PATH=$GOPATH:$nvim_mason:$PATH
unset nvim_mason

eval "$(/opt/homebrew/bin/brew shellenv)"
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
complete -C '/opt/homebrew/bin/aws_completer' aws

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

# list all chrome profiles on macOS
list_chrome_profiles() {
  cd ~/Library/Application\ Support/Google/Chrome
  for d in *Profile*; do
      echo -n "$d: "
      jq -r .profile.name "$d/Preferences"
  done
  cd -
}

# create AppleScript shortcuts for each chrome profile on macOS
setup_chrome_profiles_shortcut() {
  # Directory to store the AppleScript files
  local applescript_dir="$HOME/Documents/chrome-profiles"
  # Clean up old profiles
  if [ -d "$applescript_dir" ]; then
    rm -r "$applescript_dir"
  fi
  # Create the directory
  mkdir -p "$applescript_dir"
  # Loop over each profile directory
  cd ~/Library/Application\ Support/Google/Chrome
  for d in *Profile*; do
    profile_name=$(jq -r .profile.name "$d/Preferences" | tr -d ' ')
    if [ "$profile_name" != "null" ] && [ "$profile_name" != "Guest" ] && [ "$profile_name" != "SystemProfile" ] && [ "$profile_name" != "Person1" ]; then
      echo "Creating AppleScript for profile: $profile_name"
      # Create the AppleScript file
      applescript_path="$applescript_dir/$profile_name.applescript"
      echo "do shell script \"open -na 'Google Chrome' --args --profile-directory='$d'\"" > "$applescript_path"
      # Convert the AppleScript file to an app
      osacompile -o "$applescript_dir/$profile_name.app" "$applescript_path"
      # Remove the AppleScript file
      rm "$applescript_path"
    fi
  done
  cd -
}
