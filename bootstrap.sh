#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "mkdir -p ${HOME}/Sources"
mkdir -p "${HOME}/Sources"

echo "installing homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

BREW_PREFIX=$(brew --prefix)

echo "brew installing stuff"
brew install git
brew install bash
brew install bash-completion2
brew install watchman
brew install node

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

echo "installing a few global npm packages"
npm install --global parcel-bundler fkill-cli

echo "installing apps with brew cask"
brew cask install discord
brew cask install google-chrome
brew cask install firefox
brew cask install itsycal
brew cask install visual-studio-code
brew cask install vlc
brew cask install webstorm
brew cask install telegram
brew cleanup

echo "cloning dotfiles"
git clone https://github.com/FokinAleksandr/dotfiles.git "${HOME}/Sources/dotfiles"

rsync --exclude ".git/" \
  --exclude ".DS_Store" \
  --exclude "bootstrap.sh" \
  --exclude ".macos" \
  --exclude "README.md" \
  -avh --no-perms "${HOME}/Sources/dotfiles/" ~;

source "${HOME}/Sources/dotfiles/.macos"
source ~/.bash_profile
