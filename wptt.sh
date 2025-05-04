#!/bin/bash
# Web Penetration Testing Toolkit by Hamza
# A comprehensive web penetration testing toolkit

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'
BOLD='\033[1m'

# Global variables
DOMAIN=""
RESULTS_DIR=""
VERBOSE=false
CURRENT_STEP=0
TOTAL_STEPS=11

# Function to display banner
display_banner() {
    clear
    python3 main.py
    echo -e "${BOLD}${BLUE}[*] Web Penetration Testing Toolkit ${WHITE}by Hamza${RESET}"
    echo -e "${CYAN}[*] Current Target: ${WHITE}${DOMAIN:-"No domain set"}${RESET}"
    echo -e "${CYAN}[*] Results Directory: ${WHITE}${RESULTS_DIR:-"Not created yet"}${RESET}"
    echo -e "${YELLOW}[*] Type 'help' to display available commands${RESET}"
    echo -e "${MAGENTA}───────────────────────────────────────────────────────────────────${RESET}"
}

# Function to display progress
display_progress() {
    echo -e "${BLUE}[*] Progress: ${WHITE}Step $CURRENT_STEP/$TOTAL_STEPS${RESET}"
    echo -e "${MAGENTA}───────────────────────────────────────────────────────────────────${RESET}"
}

# Function to display help
display_help() {
    echo -e "${WHITE}${BOLD}AVAILABLE COMMANDS:${RESET}"
    echo -e "${GREEN}help${RESET}                        - Display this help message"
    echo -e "${GREEN}set domain [domain]${RESET}         - Set the target domain"
    echo -e "${GREEN}start${RESET}                       - Start the penetration testing workflow"
    echo -e "${GREEN}verbose [on|off]${RESET}            - Toggle verbose output"
    echo -e "${GREEN}run [step_number]${RESET}           - Run a specific step"
    echo -e "${GREEN}save [step_number]${RESET}          - Save results from a specific step"
    echo -e "${GREEN}list steps${RESET}                  - List all available steps"
    echo -e "${GREEN}exit${RESET}                        - Exit the toolkit"
    echo -e "${MAGENTA}───────────────────────────────────────────────────────────────────${RESET}"
}

# Function to list all steps
list_steps() {
    echo -e "${WHITE}${BOLD}AVAILABLE STEPS:${RESET}"
    echo -e "${GREEN}1.${RESET} Subdomain Enumeration (subfinder)"
    echo -e "${GREEN}2.${RESET} Find Alive Subdomains (httprobe)"
    echo -e "${GREEN}3.${RESET} URL Crawling (katana)"
    echo -e "${GREEN}4.${RESET} Find Sensitive Files"
    echo -e "${GREEN}5.${RESET} Extract JavaScript Files"
    echo -e "${GREEN}6.${RESET} Scan for JavaScript Exposures"
    echo -e "${GREEN}7.${RESET} Directory Brute Force (dirsearch)"
    echo -e "${GREEN}8.${RESET} XSS Vulnerability Testing"
    echo -e "${GREEN}9.${RESET} Subdomain Takeover Check (subzy)"
    echo -e "${GREEN}10.${RESET} CORS Misconfiguration Check"
    echo -e "${GREEN}11.${RESET} Security Scan (nuclei)"
    echo -e "${MAGENTA}───────────────────────────────────────────────────────────────────${RESET}"
}

# Function to validate domain
validate_domain() {
    if [[ -z "$DOMAIN" ]]; then
        echo -e "${RED}[!] No domain set. Please use 'set domain example.com' first.${RESET}"
        return 1
    fi
    
    # Create results directory if it doesn't exist
    RESULTS_DIR="results_${DOMAIN//\./_}"
    mkdir -p "$RESULTS_DIR"
    
    echo -e "${GREEN}[+] Domain set: ${WHITE}${DOMAIN}${RESET}"
    echo -e "${GREEN}[+] Results will be stored in: ${WHITE}${RESULTS_DIR}${RESET}"
    return 0
}

# Function to save results
save_results() {
    local step_num="$1"
    local file="$2"
    local output_file="${RESULTS_DIR}/${file}"
    
    if [[ -f "$file" ]]; then
        cp "$file" "$output_file"
        echo -e "${GREEN}[+] Results saved to ${WHITE}${output_file}${RESET}"
    else
        echo -e "${RED}[!] No results file '${file}' found to save.${RESET}"
    fi
}

# Step 1: Subdomain Enumeration
step_subdomain_enumeration() {
    CURRENT_STEP=1
    display_progress
    
    echo -e "${BLUE}[*] Step 1: Subdomain Enumeration${RESET}"
    echo -e "${YELLOW}[*] Running: subfinder -d $DOMAIN -all -recursive > subdomain.txt${RESET}"
    
    if $VERBOSE; then
        subfinder -d "$DOMAIN" -all -recursive | tee subdomain.txt
    else
        subfinder -d "$DOMAIN" -all -recursive > subdomain.txt
    fi
    
    local count=$(wc -l < subdomain.txt)
    echo -e "${GREEN}[+] Found ${WHITE}${count}${GREEN} subdomains.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 2 (Find Alive Subdomains)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_alive_subdomains
            ;;
        2)
            save_results 1 "subdomain.txt"
            step_subdomain_enumeration
            ;;
        3)
            save_results 1 "subdomain.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_subdomain_enumeration
            ;;
    esac
}

# Step 2: Find Alive Subdomains using httprobe
step_alive_subdomains() {
    CURRENT_STEP=2
    display_progress
    
    echo -e "${BLUE}[*] Step 2: Find Alive Subdomains${RESET}"
    echo -e "${YELLOW}[*] Running: cat subdomain.txt | httprobe > subdomains_alive.txt${RESET}"
    
    if $VERBOSE; then
        cat subdomain.txt | httprobe | tee subdomains_alive.txt
    else
        cat subdomain.txt | httprobe > subdomains_alive.txt
    fi
    
    local count=$(wc -l < subdomains_alive.txt)
    echo -e "${GREEN}[+] Found ${WHITE}${count}${GREEN} alive subdomains.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 3 (URL Crawling)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_url_crawling
            ;;
        2)
            save_results 2 "subdomains_alive.txt"
            step_alive_subdomains
            ;;
        3)
            save_results 2 "subdomains_alive.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_alive_subdomains
            ;;
    esac
}

# Step 3: URL Crawling
step_url_crawling() {
    CURRENT_STEP=3
    display_progress
    
    echo -e "${BLUE}[*] Step 3: URL Crawling${RESET}"
    echo -e "${YELLOW}[*] Running: katana -list subdomains_alive.txt -jc -kf all -o allurls.txt${RESET}"
    
    if $VERBOSE; then
        katana -list subdomains_alive.txt -jc -kf all | tee allurls.txt
    else
        katana -list subdomains_alive.txt -jc -kf all -o allurls.txt
    fi
    
    local count=$(wc -l < allurls.txt)
    echo -e "${GREEN}[+] Found ${WHITE}${count}${GREEN} URLs.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 4 (Find Sensitive Files)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_find_sensitive_files
            ;;
        2)
            save_results 3 "allurls.txt"
            step_url_crawling
            ;;
        3)
            save_results 3 "allurls.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_url_crawling
            ;;
    esac
}

# Step 4: Find Sensitive Files
step_find_sensitive_files() {
    CURRENT_STEP=4
    display_progress
    
    echo -e "${BLUE}[*] Step 4: Find Sensitive Files${RESET}"
    echo -e "${YELLOW}[*] Running: cat allurls.txt | grep -E \".txt|.log|.cache|.secret|.db|.backup|.yml|.json|.gz|.rar|.zip|.config\" > sensitive_files.txt${RESET}"
    
    if $VERBOSE; then
        cat allurls.txt | grep -E ".txt|.log|.cache|.secret|.db|.backup|.yml|.json|.gz|.rar|.zip|.config" | tee sensitive_files.txt
    else
        cat allurls.txt | grep -E ".txt|.log|.cache|.secret|.db|.backup|.yml|.json|.gz|.rar|.zip|.config" > sensitive_files.txt
    fi
    
    local count=$(wc -l < sensitive_files.txt)
    echo -e "${GREEN}[+] Found ${WHITE}${count}${GREEN} potentially sensitive files.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 5 (Extract JavaScript Files)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_extract_js_files
            ;;
        2)
            save_results 4 "sensitive_files.txt"
            step_find_sensitive_files
            ;;
        3)
            save_results 4 "sensitive_files.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_find_sensitive_files
            ;;
    esac
}

# Step 5: Extract JavaScript Files
step_extract_js_files() {
    CURRENT_STEP=5
    display_progress
    
    echo -e "${BLUE}[*] Step 5: Extract JavaScript Files${RESET}"
    echo -e "${YELLOW}[*] Running: cat allurls.txt | grep -i \"\\.js$\" > js_files.txt${RESET}"
    
    if $VERBOSE; then
        cat allurls.txt | grep -i "\.js$" | tee js_files.txt
    else
        cat allurls.txt | grep -i "\.js$" > js_files.txt
    fi
    
    local count=$(wc -l < js_files.txt)
    echo -e "${GREEN}[+] Found ${WHITE}${count}${GREEN} JavaScript files.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 6 (Scan JavaScript Exposures)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_scan_js_exposures
            ;;
        2)
            save_results 5 "js_files.txt"
            step_extract_js_files
            ;;
        3)
            save_results 5 "js_files.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_extract_js_files
            ;;
    esac
}

# Step 6: Scan JavaScript Exposures
step_scan_js_exposures() {
    CURRENT_STEP=6
    display_progress
    
    echo -e "${BLUE}[*] Step 6: Scan JavaScript Exposures${RESET}"
    echo -e "${YELLOW}[*] Running: nuclei -list js_files.txt -t ~/nuclei-templates/exposures/ -o js_exposures.txt${RESET}"
    
    if $VERBOSE; then
        nuclei -list js_files.txt -t ~/nuclei-templates/exposures/ | tee js_exposures.txt
    else
        nuclei -list js_files.txt -t ~/nuclei-templates/exposures/ -o js_exposures.txt
    fi
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 7 (Directory Bruteforce)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_directory_bruteforce
            ;;
        2)
            save_results 6 "js_exposures.txt"
            step_scan_js_exposures
            ;;
        3)
            save_results 6 "js_exposures.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_scan_js_exposures
            ;;
    esac
}

# Step 7: Directory Bruteforce
step_directory_bruteforce() {
    CURRENT_STEP=7
    display_progress
    
    echo -e "${BLUE}[*] Step 7: Directory Bruteforce${RESET}"
    echo -e "${YELLOW}[*] Running: dirsearch -l subdomains_alive.txt -o directory_bruteforce.txt${RESET}"
    
    if $VERBOSE; then
        dirsearch -l subdomains_alive.txt | tee directory_bruteforce.txt
    else
        dirsearch -l subdomains_alive.txt -o directory_bruteforce.txt
    fi
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 8 (XSS Testing)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_xss_testing
            ;;
        2)
            save_results 7 "directory_bruteforce.txt"
            step_directory_bruteforce
            ;;
        3)
            save_results 7 "directory_bruteforce.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_directory_bruteforce
            ;;
    esac
}

# Step 8: XSS Testing
step_xss_testing() {
    CURRENT_STEP=8
    display_progress
    
    echo -e "${BLUE}[*] Step 8: XSS Testing${RESET}"
    echo -e "${YELLOW}[*] Running: cat allurls.txt | gf xss | bxss -payload xss_payloads.txt -header \"X-Forwarded-For: \${payload}\" > xss_results.txt${RESET}"
    
    if $VERBOSE; then
        cat allurls.txt | gf xss | bx
ss -payload xss_payloads.txt -header "X-Forwarded-For: \${payload}" | tee xss_results.txt
    else
        cat allurls.txt | gf xss | bxss -payload xss_payloads.txt -header "X-Forwarded-For: \${payload}" > xss_results.txt
    fi
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 9 (Subdomain Takeover)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_subdomain_takeover
            ;;
        2)
            save_results 8 "xss_results.txt"
            step_xss_testing
            ;;
        3)
            save_results 8 "xss_results.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_xss_testing
            ;;
    esac
}

# Step 9: Subdomain Takeover Check
step_subdomain_takeover() {
    CURRENT_STEP=9
    display_progress
    
    echo -e "${BLUE}[*] Step 9: Subdomain Takeover Check${RESET}"
    echo -e "${YELLOW}[*] Running: subzy run --targets subdomains_alive.txt > subdomain_takeover.txt${RESET}"
    
    if $VERBOSE; then
        subzy run --targets subdomains_alive.txt | tee subdomain_takeover.txt
    else
        subzy run --targets subdomains_alive.txt > subdomain_takeover.txt
    fi
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 10 (CORS Misconfiguration Check)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_cors_check
            ;;
        2)
            save_results 9 "subdomain_takeover.txt"
            step_subdomain_takeover
            ;;
        3)
            save_results 9 "subdomain_takeover.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_subdomain_takeover
            ;;
    esac
}

# Step 10: CORS Misconfiguration Check
step_cors_check() {
    CURRENT_STEP=10
    display_progress
    
    echo -e "${BLUE}[*] Step 10: CORS Misconfiguration Check${RESET}"
    echo -e "${YELLOW}[*] Running: python3 corsy.py -i subdomains_alive.txt -t 10 > cors_results.txt${RESET}"
    
    if $VERBOSE; then
        python3 corsy.py -i subdomains_alive.txt -t 10 | tee cors_results.txt
    else
        python3 corsy.py -i subdomains_alive.txt -t 10 > cors_results.txt
    fi
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Proceed to Step 11 (Security Scan)"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    echo -e "   ${WHITE}3)${RESET} Save results and return to main menu"
    read -p "Enter your choice [1-3]: " choice
    
    case $choice in
        1)
            step_security_scan
            ;;
        2)
            save_results 10 "cors_results.txt"
            step_cors_check
            ;;
        3)
            save_results 10 "cors_results.txt"
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_cors_check
            ;;
    esac
}

# Step 11: Security Scan
step_security_scan() {
    CURRENT_STEP=11
    display_progress
    
    echo -e "${BLUE}[*] Step 11: Security Scan${RESET}"
    echo -e "${YELLOW}[*] Running: nuclei -list subdomains_alive.txt -t ~/nuclei-templates/ -o security_scan.txt${RESET}"
    
    if $VERBOSE; then
        nuclei -list subdomains_alive.txt -t ~/nuclei-templates/ | tee security_scan.txt
    else
        nuclei -list subdomains_alive.txt -t ~/nuclei-templates/ -o security_scan.txt
    fi
    
    echo -e "${GREEN}[+] Security scan completed.${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Save results and return to main menu"
    echo -e "   ${WHITE}2)${RESET} Save results and stay on this step"
    read -p "Enter your choice [1-2]: " choice
    
    case $choice in
        1)
            save_results 11 "security_scan.txt"
            return
            ;;
        2)
            save_results 11 "security_scan.txt"
            step_security_scan
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_security_scan
            ;;
    esac
}

# Main loop
while true; do
    display_banner
    
    read -p "wptt> " cmd args
    
    case $cmd in
        help)
            display_help
            ;;
        "set")
            if [[ "$args" =~ ^domain\ (.+)$ ]]; then
                DOMAIN="${BASH_REMATCH[1]}"
                validate_domain
            else
                echo -e "${RED}[!] Invalid command. Use 'set domain example.com'${RESET}"
            fi
            ;;
        start)
            if validate_domain; then
                step_subdomain_enumeration
            fi
            ;;
        verbose)
            if [[ "$args" == "on" ]]; then
                VERBOSE=true
                echo -e "${GREEN}[+] Verbose mode enabled${RESET}"
            elif [[ "$args" == "off" ]]; then
                VERBOSE=false
                echo -e "${GREEN}[+] Verbose mode disabled${RESET}"
            else
                echo -e "${RED}[!] Invalid argument. Use 'verbose on' or 'verbose off'${RESET}"
            fi
            ;;
        run)
            if validate_domain; then
                case $args in
                    1) step_subdomain_enumeration ;;
                    2) step_alive_subdomains ;;
                    3) step_url_crawling ;;
                    4) step_find_sensitive_files ;;
                    5) step_extract_js_files ;;
                    6) step_scan_js_exposures ;;
                    7) step_directory_bruteforce ;;
                    8) step_xss_testing ;;
                    9) step_subdomain_takeover ;;
                    10) step_cors_check ;;
                    11) step_security_scan ;;
                    *) echo -e "${RED}[!] Invalid step number. Use 'list steps' to see available steps.${RESET}" ;;
                esac
            fi
            ;;
        list)
            if [[ "$args" == "steps" ]]; then
                list_steps
            else
                echo -e "${RED}[!] Invalid argument. Use 'list steps'${RESET}"
            fi
            ;;
        exit)
            echo -e "${GREEN}[+] Goodbye!${RESET}"
            exit 0
            ;;
        *)
            if [[ -n "$cmd" ]]; then
                echo -e "${RED}[!] Unknown command. Type 'help' for available commands.${RESET}"
            fi
            ;;
    esac
done
