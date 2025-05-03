#!/bin/bash

# Web Penetration Testing Toolkit by Hamza

# ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Global variables
VERBOSE=false
DOMAIN=""
CURRENT_STEP=0

# Display banner
display_banner() {
    clear
    echo -e "${BLUE}"
    echo "==============================================="
    echo "    Web Penetration Testing Toolkit (WPTT)"
    echo "==============================================="
    echo -e "${WHITE}Created by Hamza${RESET}"
    echo ""
}

# Validate domain
validate_domain() {
    if [[ -z "$DOMAIN" ]]; then
        echo -e "${RED}[!] No domain set. Use 'set domain <target>' first.${RESET}"
        return 1
    fi
    return 0
}

# Display help
display_help() {
    echo -e "${YELLOW}Available Commands:${RESET}"
    echo -e "${WHITE}  help${RESET}                  - Show this help message"
    echo -e "${WHITE}  list steps${RESET}           - List available steps"
    echo -e "${WHITE}  set domain <target>${RESET} - Set target domain"
    echo -e "${WHITE}  start${RESET}                - Start from step 1"
    echo -e "${WHITE}  run <step>${RESET}           - Run specific step"
    echo -e "${WHITE}  save <step>${RESET}          - Save output of specific step"
    echo -e "${WHITE}  verbose on|off${RESET}       - Toggle verbose mode"
    echo -e "${WHITE}  clear${RESET}                - Clear screen and show banner"
    echo -e "${WHITE}  exit${RESET}                 - Exit toolkit"
}

# List steps
list_steps() {
    echo -e "${YELLOW}Steps:${RESET}"
    echo -e "${WHITE}  1) Subdomain Enumeration"
    echo -e "  2) Alive Subdomains Check"
    echo -e "  3) URL Crawling"
    echo -e "  4) Sensitive Files Search"
    echo -e "  5) JS File Extraction"
    echo -e "  6) JS Exposure Scan"
    echo -e "  7) Directory Bruteforce"
    echo -e "  8) XSS Testing"
    echo -e "  9) Subdomain Takeover Check"
    echo -e " 10) CORS Misconfiguration Check"
    echo -e " 11) Security Scan${RESET}"
}

# Save results
save_results() {
    step=$1
    file=$2
    mkdir -p results/$DOMAIN/step_$step
    cp $file results/$DOMAIN/step_$step/
    echo -e "${GREEN}[+] Saved $file to results/$DOMAIN/step_$step/${RESET}"
}

# Main entry
main() {
    display_banner

    while true; do
        echo -en "${WHITE}wptt> ${RESET}" 
        read -e command args

        case $command in
            help)
                display_help
                ;;
            "list"|"list steps")
                list_steps
                ;;
            set)
                if [[ "$args" =~ domain\ (.+) ]]; then
                    DOMAIN="${BASH_REMATCH[1]}"
                    echo -e "${GREEN}[+] Target domain set to: $DOMAIN${RESET}"
                else
                    echo -e "${RED}[!] Usage: set domain <target>${RESET}"
                fi
                ;;
            start)
                echo -e "${GREEN}[+] Starting from step 1...${RESET}"
                ./main.py --domain "$DOMAIN" --start
                ;;
            run)
                echo -e "${YELLOW}[*] Running specific step is not implemented yet.${RESET}"
                ;;
            save)
                echo -e "${YELLOW}[*] Saving specific step is not implemented yet.${RESET}"
                ;;
            verbose)
                if [[ "$args" == "on" ]]; then
                    VERBOSE=true
                    echo -e "${GREEN}[+] Verbose mode enabled${RESET}"
                elif [[ "$args" == "off" ]]; then
                    VERBOSE=false
                    echo -e "${GREEN}[+] Verbose mode disabled${RESET}"
                else
                    echo -e "${RED}[!] Usage: verbose on|off${RESET}"
                fi
                ;;
            clear)
                display_banner
                ;;
            exit)
                echo -e "${GREEN}[+] Thank you for using WPTT. Goodbye!${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Unknown command: $command${RESET}"
                echo -e "${YELLOW}[*] Type 'help' to see available commands${RESET}"
                ;;
        esac
    done
}

# Make Python script executable
chmod +x main.py

# Start main loop
main
