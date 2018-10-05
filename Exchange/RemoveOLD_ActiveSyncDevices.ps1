$DevicesToRemove = Get-ActiveSyncDevice -result unlimited | Get-ActiveSyncDeviceStatistics | Where-Object {$_.LastSuccessSync -le (Get-Date).AddDays("-30")}

$DevicesToRemove | ForEach-Object {Remove-ActiveSyncDevice ([string]$_.Guid) -confirm:$false}