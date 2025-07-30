#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
OS=$(uname -s)
echo "Detected OS: $OS"

# Install on Linux
if [ "$OS" = "Linux" ]; then
    echo "Installing dependencies for Linux..."

    # Update package list
    sudo apt-get update

    # Install GCC
    if ! command_exists gcc; then
        echo "Installing GCC..."
        sudo apt-get install -y gcc
    else
        echo "GCC is already installed."
    fi

    # Install SWI-Prolog
    if ! command_exists swipl; then
        echo "Installing SWI-Prolog..."
        sudo apt-get install -y swi-prolog
    else
        echo "SWI-Prolog is already installed."
    fi

    # Install GLPK
    if ! command_exists glpsol; then
        echo "Installing GLPK..."
        sudo apt-get install -y glpk-utils
    else
        echo "GLPK is already installed."
    fi

# Install on macOS
elif [ "$OS" = "Darwin" ]; then
    echo "Installing dependencies for macOS..."

    # Check if Homebrew is installed
    if ! command_exists brew; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install GCC
    if ! command_exists gcc; then
        echo "Installing GCC..."
        brew install gcc
    else
        echo "GCC is already installed."
    fi

    # Install SWI-Prolog
    if ! command_exists swipl; then
        echo "Installing SWI-Prolog..."
        brew install swi-prolog
    else
        echo "SWI-Prolog is already installed."
    fi

    # Install GLPK
    if ! command_exists glpsol; then
        echo "Installing GLPK..."
        brew install glpk
    else
        echo "GLPK is already installed."
    fi

# Install on Windows via WSL
elif [[ "$OS" =~ ^(CYGWIN|MINGW|MSYS) ]]; then
    echo "Installing dependencies for Windows via WSL..."

    # Update package list
    sudo apt-get update

    # Install GCC
    if ! command_exists gcc; then
        echo "Installing GCC..."
        sudo apt-get install -y gcc
    else
        echo "GCC is already installed."
    fi

    # Install SWI-Prolog
    if ! command_exists swipl; then
        echo "Installing SWI-Prolog..."
        sudo apt-get install -y swi-prolog
    else
        echo "SWI-Prolog is already installed."
    fi

    # Install GLPK
    if ! command_exists glpsol; then
        echo "Installing GLPK..."
        sudo apt-get install -y glpk-utils
    else
        echo "GLPK is already installed."
    fi

else
    echo "Unsupported OS detected."
    exit 1
fi

echo "All dependencies are installed."