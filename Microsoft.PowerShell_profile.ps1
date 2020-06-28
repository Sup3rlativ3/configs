Add-WindowsPSModulePath
Import-Module WindowsPSModulePath

Import-Module posh-git
Import-Module oh-my-posh

function global:prompt {  # Multiple Write-Host commands with color
    Write-Host("[") -nonewline
    Write-Host((Get-Date).ToShortTimeString()) -nonewline -foregroundcolor Red
    Write-Host("] ") -nonewline
    Write-Host([Environment]::UserName) -nonewline 
    Write-Host("@") -NoNewline
    Write-Host([Environment]::MachineName) -NoNewline
    Write-Host(" ") -NoNewline
    Write-Host($(Split-Path $pwd -Leaf)) -nonewline -foregroundcolor Blue
    return " >"
}