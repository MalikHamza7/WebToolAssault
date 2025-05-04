#!/bin/bash
# Script to install all dependencies for Web Penetration Testing Toolkit

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}=== Web Penetration Testing Toolkit Dependencies Installer ===${RESET}"
echo -e "${YELLOW}This script will install all required tools for the Web Penetration Testing Toolkit.${RESET}"
echo -e "${YELLOW}Sudo access may be required for some installations.${RESET}"
echo ""

# Check if Go is installed
check_go() {
    if ! command -v go &> /dev/null; then
        echo -e "${RED}[!] Go is not installed. Please install Go first.${RESET}"
        echo -e "${YELLOW}Visit https://golang.org/doc/install for installation instructions.${RESET}"
        exit 1
    else
        echo -e "${GREEN}[+] Go is installed.${RESET}"
    fi
}

# Check if Python3 is installed
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}[!] Python3 is not installed. Please install Python3 first.${RESET}"
        exit 1
    else
        echo -e "${GREEN}[+] Python3 is installed.${RESET}"
    fi
}

# Install Go tools
install_go_tools() {
    echo -e "${BLUE}[*] Installing Go tools...${RESET}"
    
    echo -e "${YELLOW}[*] Installing subfinder...${RESET}"
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    
    echo -e "${YELLOW}[*] Installing httprobe...${RESET}"
    go install -v github.com/tomnomnom/httprobe@latest
    
    echo -e "${YELLOW}[*] Installing katana...${RESET}"
    go install -v github.com/projectdiscovery/katana/cmd/katana@latest
    
    echo -e "${YELLOW}[*] Installing nuclei...${RESET}"
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
    
    echo -e "${YELLOW}[*] Installing subzy...${RESET}"
    go install -v github.com/LukaSikic/subzy@latest
    
    echo -e "${YELLOW}[*] Installing gf...${RESET}"
    go install -v github.com/tomnomnom/gf@latest
    
    echo -e "${YELLOW}[*] Installing bxss...${RESET}"
    go install -v github.com/ethicalhackingplayground/bxss@latest
    
    echo -e "${GREEN}[+] Go tools installation completed.${RESET}"
}

# Install Python tools
install_python_tools() {
    echo -e "${BLUE}[*] Installing Python tools...${RESET}"
    
    # Create tools directory
    mkdir -p tools
    cd tools
    
    echo -e "${YELLOW}[*] Cloning dirsearch...${RESET}"
    if [ ! -d "dirsearch" ]; then
        git clone https://github.com/maurosoria/dirsearch.git
        cd dirsearch
        pip3 install -r requirements.txt
        cd ..
    else
        echo -e "${GREEN}[+] dirsearch is already installed.${RESET}"
    fi
    
    echo -e "${YELLOW}[*] Cloning Corsy...${RESET}"
    if [ ! -d "Corsy" ]; then
        git clone https://github.com/s0md3v/Corsy.git
        cd Corsy
        pip3 install -r requirements.txt
        cd ..
    else
        echo -e "${GREEN}[+] Corsy is already installed.${RESET}"
    fi
    
    echo -e "${YELLOW}[*] Cloning openredirex...${RESET}"
    if [ ! -d "openredirex" ]; then
        git clone https://github.com/devanshbatham/openredirex.git
        cd openredirex
        if [ -f "requirements.txt" ]; then
            pip3 install -r requirements.txt
        fi
        cd ..
    else
        echo -e "${GREEN}[+] openredirex is already installed.${RESET}"
    fi
    
    cd ..
    
    echo -e "${GREEN}[+] Python tools installation completed.${RESET}"
}

# Set up paths
setup_paths() {
    echo -e "${BLUE}[*] Setting up paths...${RESET}"
    
    # Add Go bin directory to PATH
    GO_BIN=$(go env GOPATH)/bin
    
    if [[ ":$PATH:" != *":$GO_BIN:"* ]]; then
        echo -e "${YELLOW}[*] Adding Go bin directory to PATH...${RESET}"
        echo "export PATH=\$PATH:$GO_BIN" >> ~/.bashrc
        echo "export PATH=\$PATH:$GO_BIN" >> ~/.zshrc
        export PATH=$PATH:$GO_BIN
    fi
    
    # Create symbolic links for Python tools
    echo -e "${YELLOW}[*] Creating symbolic links for Python tools...${RESET}"
    
    # Dirsearch
    if [ -f "tools/dirsearch/dirsearch.py" ]; then
        sudo ln -sf "$(pwd)/tools/dirsearch/dirsearch.py" /usr/local/bin/dirsearch
        sudo chmod +x /usr/local/bin/dirsearch
    fi
    
    # Corsy
    if [ -f "tools/Corsy/corsy.py" ]; then
        sudo ln -sf "$(pwd)/tools/Corsy/corsy.py" /usr/local/bin/corsy.py
        sudo chmod +x /usr/local/bin/corsy.py
    fi
    
    # Openredirex
    if [ -f "tools/openredirex/openredirex.py" ]; then
        sudo ln -sf "$(pwd)/tools/openredirex/openredirex.py" /usr/local/bin/openredirex
        sudo chmod +x /usr/local/bin/openredirex
    fi
    
    echo -e "${GREEN}[+] Paths setup completed.${RESET}"
}

# Create configuration files
create_config_files() {
    echo -e "${BLUE}[*] Creating configuration files...${RESET}"
    
    # Create directory for nuclei templates
    mkdir -p nuclei-templates
    
    # Create directory for gf patterns
    mkdir -p ~/.gf
    
    echo -e "${YELLOW}[*] Installing nuclei templates...${RESET}"
    nuclei -update-templates
    
    echo -e "${YELLOW}[*] Installing gf patterns...${RESET}"
    # Clone gf-patterns repository
    if [ ! -d "tools/gf-patterns" ]; then
        git clone https://github.com/1ndianl33t/Gf-Patterns.git tools/gf-patterns
        cp tools/gf-patterns/*.json ~/.gf/
    fi
    
    echo -e "${GREEN}[+] Configuration files created.${RESET}"
}

# Main function
main() {
    check_go
    check_python
    
    install_go_tools
    install_python_tools
    setup_paths
    create_config_files
    
    echo -e "${GREEN}[+] All dependencies have been installed successfully!${RESET}"
    echo -e "${YELLOW}[*] You may need to restart your terminal or source your shell configuration file.${RESET}"
    echo -e "${YELLOW}[*] Run 'source ~/.bashrc' or 'source ~/.zshrc' to update your PATH.${RESET}"
    echo -e "${BLUE}[*] You can now run the Web Penetration Testing Toolkit by executing './wptt.sh'${RESET}"
}

# Ask for confirmation
read -p "Do you want to install all dependencies? (y/n): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    main
else
    echo -e "${YELLOW}Installation cancelled.${RESET}"
    exit 0
fi
