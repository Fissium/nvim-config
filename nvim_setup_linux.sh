#!/bin/bash
set -exu
set -o pipefail

# Whether to add the path of the installed executables to system PATH
ADD_TO_SYSTEM_PATH=true

# select which shell we are using
USE_ZSH_SHELL=true
USE_BASH_SHELL=false

if [[ ! -d "$HOME/tools/" ]]; then
    mkdir -p "$HOME/tools/"
fi

#######################################################################
#                Install node and js-based language server            #
#######################################################################
NODE_DIR=$HOME/tools/nodejs
NODE_SRC_NAME=/data/Downloads/nodejs.tar.gz
# when download speed is slow, we can also use its mirror site: https://mirrors.ustc.edu.cn/node/v16.17.0/
NODE_LINK="https://mirrors.ustc.edu.cn/node/v16.17.0/node-v16.17.0-linux-x64.tar.xz"
if [[ -z "$(command -v node)" ]]; then
    echo "Install Node.js"
    if [[ ! -f $NODE_SRC_NAME ]]; then
        echo "Downloading Node.js and renaming"
        wget $NODE_LINK -O "$NODE_SRC_NAME"
    fi

    if [[ ! -d "$NODE_DIR" ]]; then
        echo "Creating Node.js directory under tools directory"
        mkdir -p "$NODE_DIR"
        echo "Extracting to $HOME/tools/nodejs directory"
        tar xvf "$NODE_SRC_NAME" -C "$NODE_DIR" --strip-components 1
    fi

    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_BASH_SHELL" = true ]]; then
        echo "export PATH=\"$NODE_DIR/bin:\$PATH\"" >> "$HOME/.bash_profile"
    fi
    
    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_ZSH_SHELL" = true ]]; then
        echo "export PATH=\"$NODE_DIR/bin:\$PATH\"" >> "$HOME/.zshrc"
    fi
else
    echo "Node.js is already installed. Skip installing it."
fi

# Install pyright
"$NODE_DIR/bin/npm" install -g pyright

#######################################################################
#                            Ripgrep part                             #
#######################################################################
RIPGREP_DIR=$HOME/tools/ripgrep
RIPGREP_SRC_NAME=/data/Downloads/ripgrep.tar.gz
RIPGREP_LINK="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz"
if [[ -z "$(command -v rg)" ]] && [[ ! -f "$RIPGREP_DIR/rg" ]]; then
    echo "Install ripgrep"
    if [[ ! -f $RIPGREP_SRC_NAME ]]; then
        echo "Downloading ripgrep and renaming"
        wget $RIPGREP_LINK -O "$RIPGREP_SRC_NAME"
    fi

    if [[ ! -d "$RIPGREP_DIR" ]]; then
        echo "Creating ripgrep directory under tools directory"
        mkdir -p "$RIPGREP_DIR"
        echo "Extracting to $HOME/tools/ripgrep directory"
        tar zxvf "$RIPGREP_SRC_NAME" -C "$RIPGREP_DIR" --strip-components 1
    fi

    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_BASH_SHELL" = true ]]; then
        echo "export PATH=\"$RIPGREP_DIR:\$PATH\"" >> "$HOME/.bash_profile"
    fi
    
    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_ZSH_SHELL" = true ]]; then
        echo "export PATH=\"$RIPGREP_DIR:\$PATH\"" >> "$HOME/.zshrc"
    fi

    # set up manpath and zsh completion for ripgrep
    mkdir -p "$HOME/tools/ripgrep/doc/man/man1"
    mv "$HOME/tools/ripgrep/doc/rg.1" "$HOME/tools/ripgrep/doc/man/man1"

    if [[ "$USE_BASH_SHELL" = true ]]; then
        echo 'export MANPATH=$HOME/tools/ripgrep/doc/man:$MANPATH' >> "$HOME/.bash_profile"
    else
        echo 'export MANPATH=$HOME/tools/ripgrep/doc/man:$MANPATH' >> "$HOME/.zshrc"
        echo 'export FPATH=$HOME/tools/ripgrep/complete:$FPATH' >> "$HOME/.zshrc"
    fi
else
    echo "ripgrep is already installed. Skip installing it."
fi
#######################################################################
#                                Nvim install                         #
#######################################################################
NVIM_DIR=$HOME/tools/nvim
NVIM_SRC_NAME=/data/Downloads/nvim-linux64.tar.gz
NVIM_CONFIG_DIR=$HOME/.config/nvim
NVIM_LINK="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
if [[ ! -f "$NVIM_DIR/bin/nvim" ]]; then
    echo "Installing Nvim"
    echo "Creating nvim directory under tools directory"

    if [[ ! -d "$NVIM_DIR" ]]; then
        mkdir -p "$NVIM_DIR"
    fi

    if [[ ! -f $NVIM_SRC_NAME ]]; then
        echo "Downloading Nvim"
        wget "$NVIM_LINK" -O "$NVIM_SRC_NAME"
    fi
    echo "Extracting neovim"
    tar zxvf "$NVIM_SRC_NAME" --strip-components 1 -C "$NVIM_DIR"

    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_BASH_SHELL" = true ]]; then
        echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$HOME/.bash_profile"
    fi
    
    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_ZSH_SHELL" = true ]]; then
        echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$HOME/.zshrc"
    fi
else
    echo "Nvim is already installed. Skip installing it."
fi

echo "Done!"
