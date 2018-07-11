function Get-Installed-Framework-Versions() {
    $installedFrameworks = @()
    if (Is-Key-Present "HKLM:\Software\Microsoft\.NETFramework\Policy\v1.0" "3705") { $installedFrameworks += "Installed .Net Framework 1.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v1.1.4322" "Install") { $installedFrameworks += "Installed .Net Framework 1.1" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727" "Install") { $installedFrameworks += "Installed .Net Framework 2.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup" "InstallSuccess") { $installedFrameworks += "Installed .Net Framework 3.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.5" "Install") { $installedFrameworks += "Installed .Net Framework 3.5" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install") { $installedFrameworks += "Installed .Net Framework 4.0c" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") { $installedFrameworks += "Installed .Net Framework 4.0" }   
     
    return $installedFrameworks
}

function Get-Framework-Versions-And-Handle-Operation() {
    $version = Get-Framework40-Family-Version;
    if ($version -ge 1) { 
    }
    else {
        Download-And-Install-Framework
    }
}

function Get-Framework40-Family-Version() {
    $result = -1
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install" -or Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") {
        # .net 4.0 is installed
        $result = 0
        $version = Get-Framework-Value "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Release"
        
        if ($version -ge 461808 -Or $version -ge 461814) {
            # .net 4.7.2
            Write-Host "Installed .Net Framework 4.7.2"
            $result = 9
        }
        elseif ($version -ge 461308 -Or $version -ge 461310) {
            # .net 4.7.1
            Write-Host "Installed .Net Framework 4.7.1"
            $result = 8
        }
        elseif ($version -ge 460798 -Or $version -ge 460805) {
            # .net 4.7
            Write-Host "Installed .Net Framework 4.7"
            $result = 7
        }
        elseif ($version -ge 394802 -Or $version -ge 394806) {
            # .net 4.6.2
            Write-Host "Installed .Net Framework 4.6.2"
            $result = 6
        }
        elseif ($version -ge 394254 -Or $version -ge 394271) {
            # .net 4.6.1
            Write-Host "Installed .Net Framework 4.6.1"
            $result = 5
        }
        elseif ($version -ge 393295 -Or $version -ge 393297) {
            # .net 4.6
            Write-Host "Installed .Net Framework 4.6"
            $result = 4
        }
        elseif ($version -ge 379893) {
            # .net 4.5.2
            Write-Host "Installed .Net Framework 4.5.2"
            $result = 3
        }
        elseif ($version -ge 378675) {
            # .net 4.5.1
            Write-Host "Installed .Net Framework 4.5.1"
            $result = 2
        }
        elseif ($version -ge 378389) {
            # .net 4.5
            Write-Host "Installed .Net Framework 4.5"
            $result = 1
        }   
    }
    else {
        # .net framework 4 family isn't installed
        $result = -1
    }
    
    return $result
}

# All .Net Frameworks possible to download here: https://www.microsoft.com/net/download/dotnet-framework-runtime
function Download-And-Install-Framework() {
    # net 4.0   -> http://download.microsoft.com/download/1/B/E/1BE39E79-7E39-46A3-96FF-047F95396215/dotNetFx40_Full_setup.exe
    # net 4.5   -> http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe
    # net 4.5.2 -> http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe
    # net 4.6   -> http://download.microsoft.com/download/1/4/A/14A6C422-0D3C-4811-A31F-5EF91A83C368/NDP46-KB3045560-Web.exe => except win 10
    # net 4.7.2 -> https://download.microsoft.com/download/3/3/2/332D9665-37D5-467A-84E1-D07101375B8C/NDP472-KB4054531-Web.exe
    $url = "https://download.microsoft.com/download/3/3/2/332D9665-37D5-467A-84E1-D07101375B8C/NDP472-KB4054531-Web.exe"
    $output = "$PSScriptRoot\netFrameworkInstaller.exe"
    $start_time = Get-Date
       
    Invoke-WebRequest -Uri $url -OutFile $output  
    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"  
      
    Start-Process netFrameworkInstaller.exe 
    # -NoNewWindow -Wait
}
 
function Is-Key-Present([string]$path, [string]$key) {
    if (!(Test-Path $path)) { return $false }
    if ((Get-ItemProperty $path).$key -eq $null) { return $false }
    return $true
}

function Get-Framework-Value([string]$path, [string]$key) {
    if (!(Test-Path $path)) { return "-1" }
    
    return (Get-ItemProperty $path).$key  
}

# print all installed net frameworks
Get-Installed-Framework-Versions

# in case .net framework family 4 is present in system, script start application otherwise 
# download and install predefined framework
Get-Framework-Versions-And-Handle-Operation
