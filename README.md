# leesamuel423 dotfiles

This directory contains the dotfiles for my system.

## Requirements

Ensure you have the following installed on your system

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Git

```bash
brew install git
```

### Stow

```bash
brew install stow
```

### Open WebUI
```bash
mkdir open-webui # in ~/
cd open-webui
python3.12 -m venv open-webui-env
source open-webui-env/bin/activate
pip install open-webui
```
- Note: requires node.js version between 18.13 and 22.x.x. See [open-webui](https://github.com/open-webui/open-webui) for more details
- If you don't want web-ui, comment out in .zshrc

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```bash
$ git clone git@github.com:leesamuel423/dotfiles.git
$ cd dotfiles
```

Then use GNU stow to create symlinks

```
$ stow .
```
