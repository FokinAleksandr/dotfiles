#!/usr/bin/env bash
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "mkdir -p ${HOME}/Sources"
mkdir -p "${HOME}/Sources"

echo "installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "brew installing stuff"
brew install git
brew install watchman
brew install node
brew install mc

echo "allow apps downloaded from anywhere"
sudo spctl --master-disable

echo "installing a few global npm packages"
npm install --global fkill-cli yarn

echo "installing apps with brew cask"
brew tap homebrew/cask-versions
brew install --cask zulu11
brew install --cask discord
brew install --cask google-chrome
brew install --cask firefox
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask webstorm
brew install --cask telegram
brew install --cask yandex-disk
brew install --cask zoom
brew install --cask postman
brew cleanup

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
source ~/.zshrc
