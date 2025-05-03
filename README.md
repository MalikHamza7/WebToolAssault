# Web Penetration Testing Toolkit by Hamza

A comprehensive, interactive web penetration testing toolkit that guides users through a sequential penetration testing workflow with options to save results at each step.

![Web Penetration Testing Toolkit](https://img.shields.io/badge/Security-Penetration%20Testing-red)
![License](https://img.shields.io/badge/License-MIT-blue)
![Version](https://img.shields.io/badge/Version-1.0-orange)

## 📝 Overview

This toolkit provides a user-friendly, interactive command-line interface for conducting web penetration testing. It guides users through a comprehensive workflow of reconnaissance, enumeration, and vulnerability scanning while allowing them to save results at each step.

## ✨ Features

- Interactive command-line interface with colored output
- Sequential penetration testing workflow with multiple tools
- Option to save results at each step
- Results stored in separate text files named after the domain
- Verbose mode for detailed output
- Help command to display all available options
- User-friendly prompts and professional UI

## 🔧 Prerequisites

The toolkit depends on the following tools. Make sure to install them before using:

- [subfinder](https://github.com/projectdiscovery/subfinder)
- [httpx-toolkit](https://github.com/projectdiscovery/httpx)
- [katana](https://github.com/projectdiscovery/katana)
- [nuclei](https://github.com/projectdiscovery/nuclei)
- [dirsearch](https://github.com/maurosoria/dirsearch)
- [subzy](https://github.com/LukaSikic/subzy)
- [gf](https://github.com/tomnomnom/gf)
- [bxss](https://github.com/ethicalhackingplayground/bxss)
- [corsy.py](https://github.com/s0md3v/Corsy)
- [openredirex](https://github.com/devanshbatham/openredirex)

### Installation of Prerequisites

```bash
# Install Go tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install -v github.com/LukaSikic/subzy@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/ethicalhackingplayground/bxss@latest

# Install Python tools
git clone https://github.com/maurosoria/dirsearch.git
git clone https://github.com/s0md3v/Corsy.git
git clone https://github.com/devanshbatham/openredirex.git

# Install Python requirements
pip3 install -r dirsearch/requirements.txt
pip3 install -r Corsy/requirements.txt
pip3 install -r openredirex/requirements.txt
```

## 🚀 Usage

1. Clone the repository:
```bash
git clone https://github.com/hamza/web-penetration-testing-toolkit.git
cd web-penetration-testing-toolkit
```

2. Make the script executable:
```bash
chmod +x wptt.sh
```

3. Run the toolkit:
```bash
./wptt.sh
```

### Commands

- `help` - Display the help message
- `set domain [domain]` - Set the target domain
- `start` - Start the penetration testing workflow
- `verbose [on|off]` - Toggle verbose output
- `run [step_number]` - Run a specific step
- `save [step_number]` - Save results from a specific step
- `list steps` - List all available steps
- `exit` - Exit the toolkit

## 🔄 Workflow

The toolkit follows this workflow:

1. Subdomain Enumeration
2. Find Alive Subdomains
3. URL Crawling
4. Find Sensitive Files
5. Extract JavaScript Files
6. Scan for JavaScript Exposures
7. Directory Brute Force
8. XSS Vulnerability Testing
9. Subdomain Takeover Check
10. CORS Misconfiguration Check
11. Security Scan with Nuclei

At each step, you can choose to:
- Proceed to the next step
- Save results and stay on the current step
- Save results and return to the main menu

## 📁 Output

Results are stored in a directory named `results_[domain]`, with each command's output in a separate file.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.