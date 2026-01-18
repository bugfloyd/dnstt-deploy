# --- Configuration ---
# Path to your dnstt-client executable
$DnsttExe = ".\dnstt-client-windows-amd64.exe"
# Path to your public key file
$PubkeyFile = "server.pub"
# Input file containing IP addresses (one per line)
$DnsListFile = "ir_dns_servers.txt"
# Output file for successful DNS servers
$OutputFile = "working_dns_windows.txt"

# --- Get Domain from User ---
$Domain = Read-Host "Enter your tunneling domain (e.g., t.example.com)"
if ([string]::IsNullOrWhiteSpace($Domain)) {
    Write-Host "Error: Domain cannot be empty!" -ForegroundColor Red
    exit
}

# Clear previous results if the file exists
if (Test-Path $OutputFile) { Remove-Item $OutputFile }

# Load the list of DNS IPs from the text file
if (-not (Test-Path $DnsListFile)) {
    Write-Host "Error: $DnsListFile not found!" -ForegroundColor Red
    exit
}
$DnsServers = Get-Content $DnsListFile

Write-Host "Starting DNS Connectivity Check..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the process." -ForegroundColor Gray
Write-Host "-----------------------------------------------"

foreach ($DnsIP in $DnsServers) {
    # Trim potential whitespace or hidden characters
    $DnsIP = $DnsIP.Trim()
    if ([string]::IsNullOrWhiteSpace($DnsIP)) { continue }

    Write-Host -NoNewline "Testing DNS: $DnsIP ... "

    # 1. Start dnstt-client in the background
    # We use -WindowStyle Hidden to prevent pop-up windows
    $ArgumentList = "-udp ${DnsIP}:53 -pubkey-file $PubkeyFile $Domain 127.0.0.1:7000"
    $Process = Start-Process -FilePath $DnsttExe -ArgumentList $ArgumentList -PassThru -WindowStyle Hidden

    # 2. Wait for the handshake to establish (3 to 5 seconds)
    Start-Sleep -Seconds 3

    # 3. Test the connection via curl using the SOCKS5 proxy
    # We check if httpbin.org returns a 200 OK status code
    try {
        $curlOutput = curl.exe --socks5 127.0.0.1:7000 --max-time 5 -s -o NUL -w "%{http_code}" http://httpbin.org/ip
    }
    catch {
        $curlOutput = "000"
    }

    # 4. Evaluate the result
    if ($curlOutput -eq "200") {
        Write-Host "SUCCESS" -ForegroundColor Green
        Add-Content -Path $OutputFile -Value $DnsIP
    } else {
        Write-Host "FAILED (Code: $curlOutput)" -ForegroundColor Red
    }

    # 5. Terminate the dnstt-client process for this IP
    Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
}

Write-Host "-----------------------------------------------"
Write-Host "Check complete. Working IPs saved to: $OutputFile" -ForegroundColor Yellow
