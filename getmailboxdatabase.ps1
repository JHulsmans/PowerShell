$ExchServer = @("srv1", "srv2", "srv3")
$total = 0
foreach ($S in $ExchServer) {
    Write-Output ---------------------------------------------------------------------------------
    Write-Output "server: " $S
    Get-mailboxdatabasecopystatus -server $S
    $M = (get-mailboxdatabasecopystatus -server $S | Where-Object {$_.status -eq "mounted"}).count
    Write-Output "mounted databases on server: "$M
    if ($M -eq $null) {
        Write-Output 0
    }
    $total = $total + $m
}
Write-Output ---------------------------------------------------------------------------------
Write-Output "total of mounted databases: "$total