## Quicksetup

Automate workspace installation. Purpose is to have portability of the current workspace setting into a new device should it be required hence no need to find repo by repo or configure from scratch.

### Installation

Run as normal user; provide root credentials upon asked.
```
sh -c "$(wget -q https://raw.githubusercontent.com/kagura-maru/quicksetup/refs/heads/main/qs.sh -O -)"
```

Additional Scripts are mentioned down below:

-----


## ffuf-gen.py
Download with:

```
curl -sO https://raw.githubusercontent.com/kagura-maru/quicksetup/refs/heads/main/scripts/ffuf-gen.py
```

Run with:

```
python ffuf-gen.py
```

Example
```
$> ffuf-gen.py 
1 - Directory Fuzzing
2 - Subdomain Fuzzing
3 - LFI Parameter Fuzzing
4 - Bruteforce Login #WIP

Choose Your Payload (1-4): 1
Insert target (e.g., http://example.com): http://10.48.177.93

Scan speed (1: slowest - 5: fastest)
Choose speed (default 3): 
Enable proxy at port 8080? (y/N): 
Use Browser's User-Agent? (Y/n): 

[!] Directory Fuzzing Mode
Wordlist path [Default: DirBuster-2.3]: 
Extensions (e.g., .php,.txt): 

==================================================
GENERATED COMMAND:
ffuf -t 40 -c -v -u http://10.48.177.93/FUZZ -w /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt -ic -r -o "dirfuzz_10.48.177.93_$(date +%H-%M_%d-%m-%Y).csv" -of csv -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
==================================================
```


## nmap-parser.py
Download with

```
curl -sO https://raw.githubusercontent.com/kagura-maru/quicksetup/refs/heads/main/scripts/nmap-parser.py
```

To run:

```
python nmap_parser.py
```

For Example:

```
$> nmap 10.48.177.93       
Starting Nmap 7.98 ( https://nmap.org ) at 2026-03-15 10:45 -0400
Nmap scan report for 10.48.177.93
Host is up (0.066s latency).
Not shown: 988 filtered tcp ports (no-response)
PORT     STATE SERVICE
53/tcp   open  domain
88/tcp   open  kerberos-sec
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
389/tcp  open  ldap
445/tcp  open  microsoft-ds
464/tcp  open  kpasswd5
593/tcp  open  http-rpc-epmap
636/tcp  open  ldapssl
3268/tcp open  globalcatLDAP
3269/tcp open  globalcatLDAPssl
5985/tcp open  wsman

Nmap done: 1 IP address (1 host up) scanned in 8.91 seconds
                                                                                                                               
$> nmap_parser.py   
Paste your scan results below (Press Ctrl+D or Ctrl+Z on Windows when finished):
53/tcp   open  domain
88/tcp   open  kerberos-sec
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
389/tcp  open  ldap
445/tcp  open  microsoft-ds
464/tcp  open  kpasswd5
593/tcp  open  http-rpc-epmap
636/tcp  open  ldapssl
3268/tcp open  globalcatLDAP
3269/tcp open  globalcatLDAPssl
5985/tcp open  wsman

Enter the Target IP for the new command: 10.48.177.93

==================================================
FINISHED NMAP COMMAND:
nmap -p53,88,135,139,389,445,464,593,636,3268,3269,5985 -sCV 10.48.177.93 -oN targeted_scan.txt
==================================================
```

