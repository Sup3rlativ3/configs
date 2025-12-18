Import-Module Terminal-Icons

$ProfilePath = Get-Item $Profile
oh-my-posh --init --shell pwsh --config "$($ProfilePath.Directory)\SysOp.omp.json" | Invoke-Expression
