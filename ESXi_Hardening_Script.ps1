# Description: Random actions to harden the ESXi server
Get-VMHost | Foreach { Stop-VMHostService -Confirm:$false -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} ) } 
