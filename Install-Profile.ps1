#############################################
##   This script will install my profile   ##
#############################################

#region functions
function Install-Fonts {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FontFile
    )
    try {
        $font = $fontFile | split-path -Leaf
        If (!(Test-Path "c:\windows\fonts\$($font)")) {
            switch (($font -split "\.")[-1]) {
                "TTF" {
                    $fn = "$(($font -split "\.")[0]) (TrueType)"
                    break
                }
                "OTF" {
                    $fn = "$(($font -split "\.")[0]) (OpenType)"
                    break
                }
            }
            Copy-Item -Path $fontFile -Destination "C:\Windows\Fonts\$font" -Force
            New-ItemProperty -Name $fn -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $font
        }
    }
    catch {
        write-warning $_.exception.message
    }
}
#endregion

try {
    Install-Module .\PS-Menu\
}
catch {
    Write-Output "Failed to install the menu module."
}

# Install some default apps
try {
    $Menu = @("PowerShell Core","Windows Terminal","7-Zip","VSCode","ShareX","None")
    $Msg = "Please choose which apps you would like to install"
    $Selected = New-Menu -MenuItems $Menu -Multiselect -Message $Msg

    if ($Selected -contains "PowerShell Core") {
        Write-Output "Installing PWSH"
        winget install --id=Microsoft.PowerShell --exact --silent --accept-package-agreements --accept-source-agreements
    }
    
    if ($Selected -contains "Windows Terminal") {
        Write-Output "Installing WinTerm"
        winget install --id=Microsoft.WindowsTerminal --exact --silent --accept-package-agreements --accept-source-agreements
    }

    if ($Selected -contains "7-Zip") {
        Write-Output "Installing ShareX"
        winget install --id=7zip.7zip --exact --silent --accept-package-agreements --accept-source-agreements
    }
        
    if ($Selected -contains "VSCode") {
        Write-Output "Installing VSCode"
        winget install --id=Microsoft.VisualStudioCode --exact --silent --accept-package-agreements --accept-source-agreements
    }
    
    if ($Selected -contains "ShareX") {
        Write-Output "Installing ShareX"
        winget install --id=ShareX.ShareX --exact --silent --accept-package-agreements --accept-source-agreements
    }
    
}
catch {
    Write-Output "Error installing the apps"
    Write-Output $Error[0]
}

# Copy the PowerShell profiles
try {
    $MyDocs = [environment]::getfolderpath("mydocuments")
    Write-Output "Copying PoSH config"
    Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination "$MyDocs\WindowsPowerShell\"
    Write-Output "Copying PWSH config"
    Copy-Item -Path .\Microsoft.PowerShell_profile.ps1 -Destination "$MyDocs\PowerShell\"
}
catch {
    Write-Output "Error copying the PowerShell profiles"
    Write-Output $Error[0]
}

# Download and install the font
try {
    $FontMenu = New-Menu -MenuItems @("Yes","No") -Message "Would you like to download & install the JetBrains font for use with glyphs"
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    
    if ($FontMenu -Contains "Yes") {
        Write-Output "Downloading the font"
        Invoke-WebRequest "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf" -OutFile ".\JetBrains_Mono_Regular_Nerd_Complete_Windows.ttf"
        Install-Fonts -FontFile .\JetBrains_Mono_Regular_Nerd_Complete_Windows.ttf
        $Fonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families
        if (!($Fonts -Contains "JetBrainsMono NF")) {
            Write-Output "Error installing font."
            Write-Output "Please install the font manually."
        }
    }
}
catch {
    Write-Output "Error downloading and installing the font"
    Write-Output $Error[0]
}

# Copy settings & background images for terminal
try {
    $WinTermFolder = Get-ChildItem "$($Env:UserProfile)\appdata\local\packages" -Filter Microsoft.WindowsTerminal*
    $Images = Get-ChildItem -Filter *.png
    ForEach($Image in $Images) {
        Copy-Item -Path $Image.FullName -Destination "$($WinTermFolder.FullName)\roamingState"
    }
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