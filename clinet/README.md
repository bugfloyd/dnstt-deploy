# 🚀 DNSTT Connectivity Guide (SOCKS5 only)

**Languages:** [English](README.md) | [فارسی](README-fa.md)

Follow these steps to find a working DNS server and establish a secure tunnel connection.

## 📦 Step 1: Download

1. Download [dnstt client](https://dnstt.network), [`ir_dns_servers.txt`](https://dnstt.network/ir_dns_servers.txt) and [`dns-validator-windows.ps1`](dns-validator-windows.ps1) into a single folder on your desktop.
   *Ensure `dnstt-client-windows-amd64.exe`, `ir_dns_servers.txt`, and `dns-validator-windows.ps1` are in the same directory.*
2. Create a `server.pub` file in the same directory and paste your public key into it.

## 🔍 Step 2: Find a Working DNS

Before connecting, you must find a DNS server that works with your ISP.

1. Right-click the "Start" button and select "Terminal" or "PowerShell".
2. Navigate to your folder using the `cd` command (e.g., `cd C:\Users\YourName\Desktop\dnstt`).
3. Run the checker script by typing:
```powershell
   Set-ExecutionPolicy Bypass -Scope Process
   .\dns-validator-windows.ps1
```


4. Wait for the script to finish. It will generate a file named `working_dns_windows.txt` containing only the IPs that successfully connected.

> Note: Your `ir_dns_servers.txt` must be clean. It should contain only raw IP addresses (e.g., `217.218.127.104`), one per line. [example here](ir_dns_servers.txt).

## 🛠️ Step 3: Establish the Tunnel

1. Open "Command Prompt (CMD)" as "Administrator".
2. Navigate to your folder using the `cd` command (e.g., `cd C:\Users\YourName\Desktop\dnstt`).
3. Pick a "SUCCESS" IP from the previous step.
4. Replace `t.example.com` in the command below with your donmain name.
5. Replace `DNS_SERVER_IP` in the command below with your working IP and run it:

   dnstt-client-windows-amd64.exe -udp DNS_SERVER_IP:53 -pubkey-file server.pub t.example.com 127.0.0.1:7000

6. Keep this window open. Your tunnel is now active on port `7000`.

## 🌐 Step 4: Configure Your Apps

To use the internet through this tunnel, configure your apps to use a "SOCKS5 Proxy":

Proxy Address: `127.0.0.1`
Port: `7000`

## Examples:

Telegram: Settings > Advanced > Connection Type > Use custom proxy > SOCKS5.
Browser (SwitchyOmega): Create a new SOCKS5 profile with the address and port above.

---
# Linux and MacOS

If you are using Linux or MacOS, there is a [bash script](dns-validator.sh) that will do the same thing for you.

---

## ⚠️ Troubleshooting & Debugging

### Port is Busy?

If you see an error saying port `7000` is already in use, or if the connection fails to start, a previous instance might be stuck in the background.

**To fix this:**

1. Open CMD as Administrator.
2. Find the process ID (PID) using the port:

   netstat -ano | findstr :7000

3. Kill the process using the PID found at the end of the line (replace `1234` with your actual PID):

   taskkill /F /PID 1234


### No IPs are working?

Ensure your firewall or antivirus is not blocking `dnstt-client-windows-amd64.exe`. You may also try updating your `ir_dns_servers.txt` with more recent servers.

### Clean [ir_dns_servers.txt](ir_dns_servers.txt)

If you are using a fresh `ir_dns_servers.txt`, you may need to clean it of any comments or empty lines.
