#!/usr/bin/env python3
"""
Web Penetration Testing Toolkit Helper Module
This module provides helper functions for the bash script.
"""

import os
import sys
import argparse
import subprocess
from datetime import datetime

def banner():
    """Display a fancy banner for the tool."""
    print("""
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                                                      ┃
    ┃   █░█░█ █▀▀ █▄▄ ▀█▀ █▀█ █▀█ █░░   ▄▀█ █▀ █▀ ▄▀█ █░█ █░░ ▀█▀         ┃
    ┃   ▀▄▀▄▀ ██▄ █▄█ ░█░ █▄█ █▄█ █▄▄   █▀█ ▄█ ▄█ █▀█ █▄█ █▄▄ ░█░         ┃
    ┃                                                                      ┃
    ┃                  Penetration Testing Toolkit by Hamza                ┃
    ┃                                                                      ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    """)

def create_results_directory(domain):
    """Create a directory for storing results if it doesn't exist."""
    results_dir = f"results_{domain.replace('.', '_')}"
    if not os.path.exists(results_dir):
        os.makedirs(results_dir)
    return results_dir

def save_results(content, filename, results_dir):
    """Save content to a file in the results directory."""
    filepath = os.path.join(results_dir, filename)
    with open(filepath, 'w') as f:
        f.write(content)
    return filepath

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="Web Penetration Testing Toolkit Helper")
    parser.add_argument("-d", "--domain", help="Target domain for testing")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output")
    return parser.parse_args()

def check_dependencies():
    """Check if all required tools are installed."""
    tools = [
        "subfinder", "httpx-toolkit", "katana", "nuclei", "dirsearch", 
        "subzy", "gf", "bxss", "corsy.py", "openredirex"
    ]
    
    missing_tools = []
    
    for tool in tools:
        try:
            subprocess.run(["which", tool], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        except subprocess.CalledProcessError:
            missing_tools.append(tool)
    
    return missing_tools

def main():
    """Main function to run the Python helper."""
    args = parse_arguments()
    
    banner()
    
    if args.domain:
        results_dir = create_results_directory(args.domain)
        print(f"[+] Results will be saved in: {results_dir}")
    
    missing_tools = check_dependencies()
    if missing_tools:
        print("\n[!] Warning: The following tools are not installed or not in PATH:")
        for tool in missing_tools:
            print(f"  - {tool}")
        print("\nPlease install these tools to use all features of the toolkit.")

if __name__ == "__main__":
    main()