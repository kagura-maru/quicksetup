#!/usr/bin/env python3

# The code has been vibecoded with Claude Sonnet 4.6
# Spend quicker time to run -sC -sV on the opened ports specifically without having nmap to probe on non-opened ports that might take a bit longer time.
# To ease the share of the script during engagement/CTF

import re

def parse_nmap_ports():
    print("Paste your scan results below (Press Ctrl+D or Ctrl+Z on Windows when finished):")
    
    # Read multiline input from terminal
    lines = []
    try:
        while True:
            line = input()
            lines.append(line)
    except EOFError:
        pass
    
    data = "\n".join(lines)
    
    # Regex: looks for digits immediately followed by /tcp or /udp
    # Example: 80/tcp -> matches '80'
    ports = re.findall(r'(\d+)/(?:tcp|udp)', data)
    
    if not ports:
        print("\n[!] No open ports found in the provided text.")
        return

    # Join ports with commas
    parsed_ports = ",".join(ports)
    
    # Generate the target command
    target_ip = input("\nEnter the Target IP for the new command: ")
    nmap_cmd = f"nmap -p{parsed_ports} -sCV {target_ip} -oN targeted_scan.txt"

    print("\n" + "="*50)
    print("FINISHED NMAP COMMAND:")
    print(nmap_cmd)
    print("="*50)

if __name__ == "__main__":
    parse_nmap_ports()
