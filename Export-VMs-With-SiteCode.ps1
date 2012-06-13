# Description: Grab the MS SiteCode from a virtual machine - export to csv
# Add in the PowerCLI CMDLET
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Connect to the vCenter using passthru
Connect-VIServer 10.0.11.179 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

$results =@()

$vms = (Get-VM -Location "New Prod-Test" | Where-Object {$_.PowerState -eq "PoweredOn" -and $_.Guest.OSFullName -match "Win*"})

foreach($vm in $vms){
    Write-Host "Trying: "$vm.Guest.HostName
    try{
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $vm.Guest.Hostname)
        $regKey = $reg.OpenSubKey("SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\")
        $row.SiteCode = $regKey.GetValue("DynamicSiteName")}
    catch{
        $row.SiteCode = "Could Not Connect to Remote Registry!"}
    $row = "" | Select Name, IP, VLAN, OperatingSystem, SiteCode, Host, Cluster
    $row.Name = $vm.Guest.HostName
    $row.Host = $vm.VMHost.Name
    $row.OperatingSystem = $vm.Guest.OSFullName
    $row.Cluster = (Get-Cluster -VM $vm)
    $row.IP = ($vm.Guest | ForEach-Object {$_.IPAddress}) -join ","  
    $row.VLAN = ($vm | Get-NetworkAdapter | ForEach-Object {$_.NetworkName}) -join ","
    $results += $row
}
