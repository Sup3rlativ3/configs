[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Import-Module posh-git
Import-Module oh-my-posh

# Import-Module ExchangeOnlineManagement
# Import-Module AzureAD
# Import-Module NTFSSecurity

Import-Module Terminal-Icons

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Test-ADCredential {
    [CmdletBinding()]
    param ( [string]$Username,
        [string]$Password
)
    Param
    (
        [Parameter(Mandatory=$true)][string]$UserName,
        [Parameter(Mandatory=$true)][string]$Password
    )
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
        $DS.ValidateCredentials($UserName, $Password)
    }

function Lockout-Account {
    [CmdletBinding()]
param (
    [Parameter()]
    [String]$Username,
    [String]$ComputerName,
    [int]$Times
)
$Pass = "MyFakePassword"
$Password = ConvertTo-SecureString $Pass -AsPlainText -Force
$y = 1..$times
foreach($x in $y)
    {
        Invoke-Command -ComputerName $ComputerName {Get-Process} -Credential (New-Object System.Management.Automation.PSCredential ($Username, $Password)) -ErrorAction SilentlyContinue
    }
}

function global:prompt {  # Multiple Write-Host commands with color
    if(Test-Administrator){
        Write-Host "[A]" -ForegroundColor White -BackgroundColor Red -NoNewline
        Write-Host(" ") -NoNewline
    }
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
