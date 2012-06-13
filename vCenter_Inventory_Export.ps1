# Description: Export to CSV VirtualMachines info for inventory.
# Add in the PowerCLI CMDLET
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Connect to the vCenter using passthru
Connect-VIServer 10.49.100.179 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue


$results =@()

$vms = (Get-VM -Location "Development")

foreach($vm in $vms){
    $row = "" | Select Name, HostName, PowerState, IP, VLAN, OperatingSystem, Host, Cluster
    $row.Name = $vm.Name
    $row.HostName = $vm.Guest.HostName
    $row.OperatingSystem = $vm.Guest.OSFullName
    $row.PowerState = $vm.PowerState
    $row.IP = ($vm.Guest | ForEach-Object {$_.IPAddress} | Where-Object {$_.split(".").length -eq 4}) -join ","  
    $row.VLAN = ($vm | Get-NetworkAdapter | ForEach-Object {$_.NetworkName}) -join ","
    $row.Cluster = (Get-Cluster -VM $vm)
    $row.Host = $vm.VMHost.Name
    $results += $row
}

#$results | Export-Csv "C:\Users\joseph.kordish.da\Desktop\DEV_and_POC_Invetory_Export.csv" -UseCulture -NoTypeInformation

----- Another example ----- 

# Description: Export to CSV VirtualMachines info. Real Simple!
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer 10.0.11.179

$vmlist = get-vm -Location Production_Test

$Report =@()
    foreach ($vm in $vmlist) {
        $row = "" | Select Name, IP, Notes, Key, Value, Key1, Value1, Key2, Value2
        $row.name = $vm.Name
        $row.IP = $vm.Guest.IPAddress[0]
        $row.Notes = $vm | select -ExpandProperty Notes
        $customattribs = $vm | select -ExpandProperty CustomFields
        $row.Key = $customattribs[0].Key
        $row.Value = $customattribs[0].value
        $row.Key1 = $customattribs[1].Key
        $row.Value1 = $customattribs[1].value    
        $row.Key2 = $customattribs[2].Key
        $row.Value2 = $customattribs[2].value        
	$Report += $row
    }

$Report | Export-Csv "c:\vms-with-notes-and-attributes.csv" -NoTypeInformation -UseCulture
