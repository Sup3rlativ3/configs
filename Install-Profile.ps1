#############################################
##   This script will install my profile   ##
#############################################

# Install some default apps
try {
    winget install --id=Microsoft.PowerShell --exact --scope User --silent --accept-package-agreements --accept-source-agreements
    winget install --id=Microsoft.WindowsTerminal --exact --scope User --silent --accept-package-agreements --accept-source-agreements
    winget install --id=7zip.7zip --exact --silent --accept-package-agreements --accept-source-agreements
    winget install --id=Microsoft.VisualStudioCode --exact --silent --accept-package-agreements --accept-source-agreements
    winget install --id=ShareX.ShareX --exact --silent --accept-package-agreements --accept-source-agreements
}
catch {
    Write-Output "Error installing the apps"
    Write-Output $Error[0]
}

# Copy the PowerShell profiles
try {
    Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination "C:\Users\$($Env:Username)\WindowsPowerShell\"
    Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination "C:\Users\$($Env:Username)\PowerShell\"
}
catch {
    Write-Output "Error copying the PowerShell profiles"
    Write-Output $Error[0]
}

# Download the font
# !! Must install manually !!
try {
    git clone "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" .
}
catch {
    Write-Output "Error downloading the font"
    Write-Output $Error[0]
}

# Copy settings & background images for terminal
try {
    $WinTermFolder = Get-ChildItem "C:\users\$($Env:Username)\appdata\local\packages" -Filter Microsoft.WindowsTerminal*
    Get-ChildItem -Filter *.png | Copy-Item "$($WinTermFolder.FullName)\roamingState"
    Copy-Item -Path .\Settings.json -Destination "$($WinTermFolder.FullName)\LocalState"
}
catch {
    Write-Output "Error copying images"
    Write-Output $Error[0]
}

# Install modules
try {
    pwsh -command "Install-Module posh-git, oh-my-posh, Terminal-Icons -Force"
    Install-Module posh-git, oh-my-posh, Terminal-Icons -Force
}
catch {
    Write-Output "Error installing powershell modules"
    Write-Output $Error[0]
}