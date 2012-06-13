# Description: Virtual Machines hardening Script. A lot of DoD STIG options. Not entirely mine. 
# Add in the PowerCLI CMDLET
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Connect to the vCenter using passthru
Connect-VIServer x.x.x.x -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

# hat tip to Derek Seaman for this collection.

$ExtraOptions = @{
#<VMX11>
 "isolation.device.connectable.disable"="true";
 "isolation.device.edit.disable"="true";
#</VMX11>
 "isolation.tools.copy.disable"="true";
 "isolation.tools.paste.disable"="true";
 "isolation.tools.setGUIOptions.disable"="true";
 "Isolation.tools.Setinfo.disable"="true";
 "Isolation.tools.connectable.disable"="true";
 #<VMX01>
 "isolation.tools.diskShrink.disable"="true"
 "isolation.tools.diskWiper.disable"="true";
 #</VMX01>
 "isolation.tools.hgfs.disable"="true";
 "isolation.tools.commandDone.disable"="true";
 "isolation.tools.guestCopyPasteVersionSet.disable"="true";
 "isolation.tools.guestDnDVersionSet.disable"="true";
 "isolation.tools.guestlibGuestInfo.disable"="true";
 "isolation.tools.guestlibGetInfoDisable.disable"="true";
 #<VMX31>
 "tools.guestlib.enableHostInfo"="false"
 #</VMX31>
 "isolation.tools.haltReboot.disable"="true"; 
 "isolation.tools.haltRebootStatus.disable"="true";
 #<VMX24>
 "isolation.tools.hgfsServerSet.disable"="true";
 "isolation.tools.memSchedFakeSampleStats.disable"="true";
 "isolation.tools.getCreds.disable"="true"
 "isolation.tools.unity.push.update.disable"="true";
 "isolation.tools.ghi.launchmenu.change"="true";
 #</VMX24>
 "isolation.tools.imgCust.disable"="true";
 "isolation.tools.runProgramDone.disable"="true";
 "isolation.tools.StateLoggerControl.disable"="true";
 "isolation.tools.unifiedLoop.disable"="true";
 "isolation.tools.upgraderParameters.disable"="true";
 "isolation.tools.vixMessages.disable"="true";
 "isolation.tools.vmxCopyPasteVersionGet.disable"="true";
 "isolation.tools.vmxDnDVersionGet.disable"="true";
 "isolation.tools.setOption.disable"="true";
 "isolation.tools.log.disable"="true";
 #<VMX20>
 "log.rotateSize"="100000";
 "log.keepOld"="10";
 #</VMX20>
 #<VMX21>
 "Tools.setinfo.sizelimit"="1048576";
 #</VMX21>
 "tools.synchronize.restore"="false";
 "time.synchronize.resume.disk"="false";
 "time.synchronize.continue"="false";
 "time.synchronize.shrink"="false";
 "time.synchronize.tools.startup"="false";
 #<VMX12>
 "vmci0.unrestricted"="false";
 #</VMx12>
 #<VMX30>
 "guest.command.enable"="false";
 #</VMX30>
 "isolation.tools.dnd.disable"="true";
 #<VMX02>
 "RemoteDisplay.maxConnections"="1";
 #</VMX02>
 "Guest.command.enabled"="false";
 "devices.hotplug"="false";
 "vmxnet.noOprom"="true"
 #<VMX10>
 "floppyX.present"="false";
 "SerialX.present"="false";
 "parallelX.present"="false";
 "usb.present"="false";
 #</VMX10>
}
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
Foreach ($Option in $ExtraOptions.GetEnumerator()) {
    $OptionValue = New-Object VMware.Vim.optionvalue
    $OptionValue.Key = $Option.Key
    $OptionValue.Value = $Option.Value
    $vmConfigSpec.extraconfig += $OptionValue
}

# Get all VMs per the argument

#$vms = get-VM $args[0] | get-view
$vms = (Get-VM -Location "Production_Test" | get-view)


foreach($vm in $vms){
    $vm.ReconfigVM($vmConfigSpec)
}
