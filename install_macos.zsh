# Ensure that brew is installed
which brew > /dev/null 2> /dev/null
[[ $? != 0 ]] && echo "\nYou need to install Homebrew (see https://brew.sh)\n" && exit 0

# install curl:
which curl > /dev/null 2> /dev/null
[[ $? != 0 ]] && brew install curl

# install git:
which git > /dev/null 2> /dev/null
[[ $? != 0 ]] && brew install git

cat > ~/.zshrc <<- EOM
#!/usr/bin/env zsh

unalias -a;
export DEVHOME=$HOME/repos/.dev
source $DEVHOME/zsh/zsh_macos
EOM

# dirs and symlinks:
[[ -d ~/repos ]] || mkdir ~/repos
export DEVHOME=~/repos/.dev
[[ -d $DEVHOME ]] || git clone git@github.com:jamilraichouni/.dev.git $DEVHOME

# tool cfgs:
for TOOL in kitty nvim
do
  # remove already existing symlink to cfg:
  [[ -L ~/.config/$TOOL ]] && rm ~/.config/$TOOL

  # remove already existing symlink cfg dir:
  [[ -d ~/.config/$TOOL ]] && rm -rf ~/.config/$TOOL

  # create symlink:
  ln -s $DEVHOME/$TOOL ~/.config
done

# Nvim setup:

## ensure minimum setup in $HOME/.local/share/nvim:
nvim --headless -c 'q'

## install plugin manager 'packer':
mkdir -p ~/.local/share/nvim/site/pack/packer/start
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# other symlinks:
[[ -d ~/My\ Drive ]] && [[ ! -L ~/mydrive ]] && ln -s ~/My\ Drive ~/mydrive
