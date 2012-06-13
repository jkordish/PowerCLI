# Description: Go through AD and add all real users into a specific AD group to be used for vCenter
Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

$protected =@()
foreach ($vCenterAdmin in (Get-QADGroupMember "vCenter Admins" -Type user)){ $protected += $vCenterAdmin.Name}
foreach ($vCenterSCCMUser in (Get-QADGroupMember "vCenter SCCM User" -Type user)){ $protected += $vCenterSCCMUser.Name}

$users = (Get-QADUser -SizeLimit 0 -Enabled | Where-Object {$_.Name -like "*, *" -and $_.DN -notlike "*Service Account*" -and $_.DN -notlike "*TEMPLATE*" -and $_.Name -notlike "*test*"} | select Name)

foreach ($user in $users){
    if($protected -notcontains $user.Name){
        Write-Host "Adding " $user.Name " to vCenter ProdTest User"
        Add-QADGroupMember -Identity "vCenter ProdTest User" -Member $user.Name | Out-Null
    }
}
