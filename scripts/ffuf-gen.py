#!/usr/bin/env python3

# The code has been vibecoded with Claude Sonnet 4.6
# Spend quicker time to generate FFUF according to your need:
# 1 - Directory Fuzing
# 2 - Subdomain Enum
# 3 - LFI Param Fuzzing
# 4 - Brutefroce Login (WIP)
# To ease the share of the script during engagement/CTF


import os

# --- Helper Functions ---

def get_ua():
    choice = input("Use Browser's User-Agent? (Y/n): ").lower()
    if choice != 'n':
        return '-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"'
    return ""

def get_speed():
    print("\nScan speed (1: slowest - 5: fastest)")
    rates = {"1": "1", "2": "5", "3": "40", "4": "100", "5": "300"}
    choice = input("Choose speed (default 3): ")
    return rates.get(choice, "40")

def get_proxy():
    choice = input("Enable proxy at port 8080? (y/N): ").lower()
    return "-x http://127.0.0.1:8080" if choice == 'y' else ""

def get_output(label, target):
    # Clean target for filename (removes http/special chars)
    clean_name = target.replace("http://", "").replace("https://", "").replace("/", "_")
    # Bash-native date variable within the filename string
    return f'-o "{label}_{clean_name}_$(date +%H-%M_%d-%m-%Y).csv" -of csv'

# --- Main Program ---

print("1 - Directory Fuzzing")
print("2 - Subdomain Fuzzing")
print("3 - LFI Parameter Fuzzing")
print("4 - Bruteforce Login #WIP")

try:
    payload_category = int(input("\nChoose Your Payload (1-4): "))
except ValueError:
    print("Invalid selection.")
    exit()

# Shared inputs for all scans
target = input("Insert target (e.g., http://example.com): ").strip("/")
threads = get_speed()
proxy = get_proxy()
user_agent = get_ua()

payload = ["ffuf", "-t", threads, "-c", "-v"]

if payload_category == 1:
    print("\n[!] Directory Fuzzing Mode")
    wlist = input("Wordlist path [Default: DirBuster-2.3]: ") or "/usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
    ext = input("Extensions (e.g., .php,.txt): ")
    
    payload += ["-u", f"{target}/FUZZ", "-w", wlist, "-ic", "-r"]
    if ext: payload.append(f"-e {ext}")
    payload.append(get_output("dirfuzz", target))

elif payload_category == 2:
    print("\n[!] Subdomain Fuzzing Mode")
    # Strip protocol for subdomain fuzzing if user provided it
    clean_domain = target.replace("http://", "").replace("https://", "")
    wlist = input("Wordlist path [Default: subdomains-top1million]: ") or "/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    
    # -H "Host: FUZZ.domain.com" is the standard way to fuzz subdomains via vhosts
    payload += ["-u", target, "-w", wlist, "-H", f'"Host: FUZZ.{clean_domain}"']
    payload.append(get_output("subdomain", clean_domain))

elif payload_category == 3:
    print("\n[!] LFI Parameter Fuzzing Mode")
    wlist = input("Param Wordlist [Default: burp-parameter-names]: ") or "/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt"
    lfi_payload = "/etc/passwd" # Standard test payload
    
    # Fuzzing the parameter name: example.com/page.php?FUZZ=/etc/passwd
    payload += ["-u", f"{target}?FUZZ={lfi_payload}", "-w", wlist, "-fs", "0"] 
    payload.append(get_output("lfi_param", target))

elif payload_category == 4:
    print("Bruteforce Login is currently #WIP")
    exit()

# Add User Agent and Proxy if they exist
if user_agent: payload.append(user_agent)
if proxy: payload.append(proxy)

# Final result
print("\n" + "="*50)
print("GENERATED COMMAND:")
print(" ".join(payload))
print("="*50)
