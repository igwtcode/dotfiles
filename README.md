# my dotfiles

### Setup Symlinks:
```bash
# to setup all symlinks at once
stow .
```

### Tmux
once everything has been installed, it's time to run TPM, install first:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

then run `Ctrl+I` to install all plugins

### Homebrew:
```bash
cd homebrew

# Leaving a machine
brew leaves > leaves.txt

# Fresh installation
xargs brew install < leaves.txt
```
