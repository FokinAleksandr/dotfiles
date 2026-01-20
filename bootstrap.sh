#!/usr/bin/env bash
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "cloning dotfiles"
rm -rf "${HOME}/Sources/dotfiles"
git clone https://github.com/FokinAleksandr/dotfiles.git "${HOME}/Sources/dotfiles"

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude "bootstrap.sh" \
  --exclude ".macos" \
  --exclude "README.md" \
  -avh --no-perms "${HOME}/Sources/dotfiles/" ~;

source "${HOME}/Sources/dotfiles/.macos"

mkdir ~/.nvm
source ~/.zshrc

echo "brew installing stuff"
brew install git
brew install mc
brew install nvm

echo "installing node 18"
nvm install 22
