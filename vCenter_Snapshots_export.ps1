# Description: Export to CSV all VirtualMachines with a snapshot and their size
# Add in the PowerCLI CMDLET
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Connect to the vCenter using passthru
Connect-VIServer 10.49.11.178 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue


$results =@()

$vms = (Get-VM -Location "Development")

foreach ($vm in $vms)
{

$row = "" | Select Name, SnapshotName, Created, SizeMB, PowerState

$snapshots = Get-Snapshot -VM (Get-VM -Name $vm.Name)

    ForEach ($snapshot in $snapshots)
        {
            if( $snapshot -ne $null)
            {
                $row.Name = $vm.Name
                $row.SnapshotName = $snapshot.Name
                $row.Created = $snapshot.Created
                $row.SizeMB = $snapshot.SizeMB
                $row.PowerState = $vm.PowerState
                $results += $row
            }
        
            
        }
}

#$results | Export-Csv "C:\Users\joseph.kordish.da\Desktop\DevPoc_Snapshots_Export.csv" -UseCulture -NoTypeInformation
