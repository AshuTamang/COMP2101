Get-CimInstance win32_networkadapterconfiguration |
Where-Object {$_.ipenabled -eq "True" } | 
ft Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder