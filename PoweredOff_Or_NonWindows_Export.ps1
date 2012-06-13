# Description: Output all VMs that are powered off or not Windows to a csv
# Add in the PowerCLI CMDLET
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Connect to the vCenter using passthru
Connect-VIServer 10.0.11.179 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

$ErrorView="CategoryView"

$results =@()

$work = (Get-Content "C:\Documents and Settings\joseph.kordish.da\Desktop\PoweredOff_Or_Not_Windows.csv")
# you can generate the csv file being used for $work with the following
# (Get-VM -Location "New Prod-Test"| Where-Object {$_.PowerState -eq "PoweredOff" -or $_.Guest.OSFullName -notmatch "Win*"}) | export-csv PoweredOff_Or_Not_Windows.csv -NoTypeInformation -UseCulture

foreach($vm in (get-vm -Name $work)){
    Clear-Variable row
    $row = "" | Select Name, IP, VLAN, OperatingSystem, SiteCode, Host, Cluster
    try{
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$vm.Guest.HostName)
        $regKey = $reg.OpenSubKey("SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\")
        $row.SiteCode = $regKey.GetValue("DynamicSiteName")}
    catch{
        $Error[0].Exception.Message.split(":")[1].replace("`"","").trim()
        $row.SiteCode = $Error[0].Exception.Message.split(":")[1].replace("`"","").trim()}
    $row.Name = $vm.Name
    $row.Host = $vm.VMHost.Name
    $row.OperatingSystem = $vm.Guest.OSFullName
    $row.Cluster = (Get-Cluster -VM $vm)
    $row.IP = ($vm.Guest | ForEach-Object {$_.IPAddress}) -join ","  
    $row.VLAN = ($vm | Get-NetworkAdapter | ForEach-Object {$_.NetworkName}) -join ","
    $results += $row
}
$results | export-csv c:\PoweredOff_Or_Non-Windows_Export_Data.csv -UseCulture -NoTypeInformation
#$results | Out-GridView
