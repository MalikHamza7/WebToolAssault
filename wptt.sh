akeover vulnerabilities:${RESET}"
            cat subdomain_takeover.txt
        fi
    else
        echo -e "${GREEN}[+] No subdomain takeover vulnerabilities found.${RESET}"
        echo "No subdomain takeover vulnerabilities found" > subdomain_takeover.txt
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
    echo -e "${YELLOW}[*] Running: python3 corsy.py -i subdomains_alive.txt -t 10 --headers \"User-Agent: GoogleBot\nCookie: SESSION=Hacked\" > cors_misconfig.txt${RESET}"
    
    if $VERBOSE; then
        python3 corsy.py -i subdomains_alive.txt -t 10 --headers "User-Agent: GoogleBot\nCookie: SESSION=Hacked" | tee cors_misconfig.txt
    else
        python3 corsy.py -i subdomains_alive.txt -t 10 --headers "User-Agent: GoogleBot\nCookie: SESSION=Hacked" > cors_misconfig.txt
    fi
    
    # Check if the file exists and has content
    if [[ -f "cors_misconfig.txt" && -s "cors_misconfig.txt" ]]; then
        echo -e "${GREEN}[+] CORS misconfiguration check completed. Results saved to cors_misconfig.txt${RESET}"
        
        if $VERBOSE; then
            echo -e "${YELLOW}[*] CORS misconfiguration issues:${RESET}"
            cat cors_misconfig.txt
        fi
    else
        echo -e "${GREEN}[+] No CORS misconfiguration issues found.${RESET}"
        echo "No CORS misconfiguration issues found" > cors_misconfig.txt
    fi
    
    # Also run nuclei for CORS
    echo -e "${YELLOW}[*] Running: nuclei -list subdomains_alive.txt -t ~/Priv8-Nuclei/cors -o cors_nuclei.txt${RESET}"
    
    if $VERBOSE; then
        nuclei -list subdomains_alive.txt -t ~/Priv8-Nuclei/cors | tee cors_nuclei.txt
    else
        nuclei -list subdomains_alive.txt -t ~/Priv8-Nuclei/cors -o cors_nuclei.txt
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
            save_results 10 "cors_misconfig.txt"
            save_results 10 "cors_nuclei.txt"
            step_cors_check
            ;;
        3)
            save_results 10 "cors_misconfig.txt"
            save_results 10 "cors_nuclei.txt"
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
    
    echo -e "${BLUE}[*] Step 11: Security Scan with Nuclei${RESET}"
    echo -e "${YELLOW}[*] Running: nuclei -list subdomains_alive.txt -tags cves,osint,tech -o security_scan.txt${RESET}"
    
    if $VERBOSE; then
        nuclei -list subdomains_alive.txt -tags cves,osint,tech | tee security_scan.txt
    else
        nuclei -list subdomains_alive.txt -tags cves,osint,tech -o security_scan.txt
    fi
    
    # Also run additional checks
    echo -e "${YELLOW}[*] Running: cat allurls.txt | gf lfi | nuclei -tags lfi -o lfi_vulnerabilities.txt${RESET}"
    cat allurls.txt | gf lfi | nuclei -tags lfi -o lfi_vulnerabilities.txt
    
    echo -e "${YELLOW}[*] Running: cat allurls.txt | gf redirect | openredirex -p ~/openRedirect -o open_redirect.txt${RESET}"
    cat allurls.txt | gf redirect | openredirex -p ~/openRedirect -o open_redirect.txt
    
    echo -e "${GREEN}[+] Security scan completed.${RESET}"
    echo -e "${GREEN}[+] Results saved to:${RESET}"
    echo -e "${WHITE}   - security_scan.txt${RESET}"
    echo -e "${WHITE}   - lfi_vulnerabilities.txt${RESET}"
    echo -e "${WHITE}   - open_redirect.txt${RESET}"
    
    # Ask user what to do next
    echo -e "${YELLOW}[?] What would you like to do next?${RESET}"
    echo -e "   ${WHITE}1)${RESET} Save all results"
    echo -e "   ${WHITE}2)${RESET} Return to main menu"
    read -p "Enter your choice [1-2]: " choice
    
    case $choice in
        1)
            save_results 11 "security_scan.txt"
            save_results 11 "lfi_vulnerabilities.txt"
            save_results 11 "open_redirect.txt"
            echo -e "${GREEN}[+] All results saved.${RESET}"
            ;;
        2)
            return
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Please try again.${RESET}"
            step_security_scan
            ;;
    esac
}

# Function to start workflow
start_workflow() {
    validate_domain || return
    step_subdomain_enumeration
}

# Main loop
main() {
    display_banner
    
    while true; do
        echo -e "${WHITE}wptt> ${RESET}" && read -e command
        
        case $command in
            help)
                display_help
                ;;
            list\ steps)
                list_steps
                ;;
            set\ domain\ *)
                DOMAIN=$(echo $command | cut -d' ' -f3)
                validate_domain
                display_banner
                ;;
            start)
                if validate_domain; then
                    start_workflow
                fi
                display_banner
                ;;
            verbose\ on)
                VERBOSE=true
                echo -e "${GREEN}[+] Verbose mode enabled${RESET}"
                ;;
            verbose\ off)
                VERBOSE=false
                echo -e "${GREEN}[+] Verbose mode disabled${RESET}"
                ;;
            run\ [1-9]|run\ 1[0-1])
                step_num=$(echo $command | cut -d' ' -f2)
                if validate_domain; then
                    case $step_num in
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
                        *) echo -e "${RED}[!] Invalid step number.${RESET}" ;;
                    esac
                fi
                display_banner
                ;;
            save\ [1-9]|save\ 1[0-1])
                step_num=$(echo $command | cut -d' ' -f2)
                if validate_domain; then
                    case $step_num in
                        1) save_results 1 "subdomain.txt" ;;
                        2) save_results 2 "subdomains_alive.txt" ;;
                        3) save_results 3 "allurls.txt" ;;
                        4) save_results 4 "sensitive_files.txt" ;;
                        5) save_results 5 "js_files.txt" ;;
                        6) save_results 6 "js_exposures.txt" ;;
                        7) save_results 7 "directory_bruteforce.txt" ;;
                        8) save_results 8 "xss_results.txt" ;;
                        9) save_results 9 "subdomain_takeover.txt" ;;
                        10) 
                            save_results 10 "cors_misconfig.txt"
                            save_results 10 "cors_nuclei.txt"
                            ;;
                        11)
                            save_results 11 "security_scan.txt"
                            save_results 11 "lfi_vulnerabilities.txt"
                            save_results 11 "open_redirect.txt"
                            ;;
                        *) echo -e "${RED}[!] Invalid step number.${RESET}" ;;
                    esac
                fi
                ;;
            clear)
                display_banner
                ;;
            exit)
                echo -e "${GREEN}[+] Thank you for using Web Penetration Testing Toolkit by Hamza. Goodbye!${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Unknown command: ${command}${RESET}"
                echo -e "${YELLOW}[*] Type 'help' to see available commands${RESET}"
                ;;
        esac
    done
}

# Ensure dependencies are installed
check_dependencies() {
    missing=()
    for tool in subfinder httpx-toolkit katana nuclei dirsearch subzy gf bxss; do
        if ! command -v $tool &> /dev/null; then
            missing+=($tool)
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}[!] The following tools are missing: ${missing[*]}${RESET}"
        echo -e "${YELLOW}[*] Please install the missing tools to use the toolkit properly.${RESET}"
        return 1
    fi
    
    return 0
}

# Check if Python script exists
if [[ ! -f "main.py" ]]; then
    echo -e "${RED}[!] main.py not found. Please ensure it exists in the same directory.${RESET}"
    exit 1
fi

# Make scripts executable
chmod +x main.py

# Run main function
main
