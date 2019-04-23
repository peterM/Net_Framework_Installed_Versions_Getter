# MIT License

# Copyright (c) 2015 Peter M. - (MalikP.)

# https://github.com/peterM/Net_Framework_Installed_Versions_Getter

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


param (
    [string]$processCommand = "cmd",
    [Int32]$requestVersion = -1,
    [bool]$execute = 0
)

function Get-Installed-Framework-Versions() {
    $installedFrameworks = @()
    if (Is-Key-Present "HKLM:\Software\Microsoft\.NETFramework\Policy\v1.0" "3705") { $installedFrameworks += "=> Installed .Net Framework 1.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v1.1.4322" "Install") { $installedFrameworks += "=> Installed .Net Framework 1.1" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727" "Install") { $installedFrameworks += "=> Installed .Net Framework 2.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup" "InstallSuccess") { $installedFrameworks += "=> Installed .Net Framework 3.0" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.5" "Install") { $installedFrameworks += "=> Installed .Net Framework 3.5" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install") { $installedFrameworks += "=> Installed .Net Framework 4.0c" }
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") { $installedFrameworks += "=> Installed .Net Framework 4.0" }   
     
    return $installedFrameworks
}

function Get-Framework-Versions-And-Handle-Operation($processCommand, $requestedVersion) {
    Write-Host "*****************]=- .net 4.x family -=[******************`n"  
    [console]::ForegroundColor = "green"
    $version = Get-Framework40-Family-Version;
    [console]::ResetColor()
    Write-Host "`n**********************************************************"

    # Write-Host "`nGet-Framework-Versions-And-Handle-Operation.requestedVersion -> " $requestedVersion 
    # Write-Host "Get-Framework-Versions-And-Handle-Operation.installedVersion -> " $version 
        
    # Write-Host $processCommand
    # Write-Host $requestedVersion  
    
    if ($version -ge $requestedVersion) { 
        # Write-Host "Get-Framework-Versions-And-Handle-Operation -> nothing about to happen."
    
        # start your application from here 

        if ($execute -eq 1){
            Start-Process $processCommand
        }
    }
    else {
        # Write-Host "Get-Framework-Versions-And-Handle-Operation -> Download & install.: " $requestVersion
        Download-And-Install-Framework $requestedVersion
    }
}

function Get-Framework40-Family-Version() {
    $result = -1
    if (Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install" -or Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") {
        # .net 4.0 is installed
        $result = 0
        $version = Get-Framework-Value "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Release"
        
        if($version -ge 528049) 
        {
            # .net 4.8 RTM (released 19.04.2019)
            Write-Host "=> Installed .Net Framework 4.8"
            $result = 12
        }
        elseif($version -ge 528033) 
        {
            # .net 4.8 preview build 3745
            Write-Host "=> Installed .Net Framework 4.8 preview build 3745"
            $result = 11
        }
        elseif ($version -ge 461808 -Or $version -ge 461814) {
            # .net 4.7.2
            Write-Host "=> Installed .Net Framework 4.7.2"
            $result = 10
        }
        elseif ($version -ge 461308 -Or $version -ge 461310) {
            # .net 4.7.1
            Write-Host "=> Installed .Net Framework 4.7.1"
            $result = 9
        }
        elseif ($version -ge 460798 -Or $version -ge 460805) {
            # .net 4.7
            Write-Host "=> Installed .Net Framework 4.7"
            $result = 8
        }
        elseif ($version -ge 394802 -Or $version -ge 394806) {
            # .net 4.6.2
            Write-Host "=> Installed .Net Framework 4.6.2"
            $result = 7
        }
        elseif ($version -ge 394254 -Or $version -ge 394271) {
            # .net 4.6.1
            Write-Host "=> Installed .Net Framework 4.6.1"
            $result = 6
        }
        elseif ($version -ge 393295 -Or $version -ge 393297) {
            # .net 4.6
            Write-Host "=> Installed .Net Framework 4.6"
            $result = 5
        }
        elseif ($version -ge 379893) {
            # .net 4.5.2
            Write-Host "=> Installed .Net Framework 4.5.2"
            $result = 4
        }
        elseif ($version -ge 378675) {
            # .net 4.5.1
            Write-Host "=> Installed .Net Framework 4.5.1"
            $result = 3
        }
        elseif ($version -ge 378389) {
            # .net 4.5
            Write-Host "=> Installed .Net Framework 4.5"
            $result = 2
        }   
    }
    else {
        # .net framework 4 family isn't installed
        $result = -1
    }
    
    return $result
}

# All .Net Frameworks possible to download here: https://dotnet.microsoft.com/download/dotnet-framework
function Download-And-Install-Framework($requestedVersion) {
    
    # default is .net framework 4.8
    Write-Host "Input: " $requestedVersion
    Write-Host "default is .net framework 4.8"

    $suffix="4_8"
    $url = "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe"
    
    if ($requestedVersion -eq 0)
    {
        # .net framework 3.5 service pack 1
        # $url = "https://dotnet.microsoft.com/download/thank-you/net35-sp1"
        # $url = "http://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe"

        Write-Host "requested -> .net framework 4.0"
        $url = "http://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe"
        $suffix="3_5_SP1"
    }
    elseif ($requestedVersion -eq 1)
    {
        # .net framework 4.0
        # $url = "https://dotnet.microsoft.com/download/thank-you/net40-offline"
        # $url = "https://download.microsoft.com/download/1/B/E/1BE39E79-7E39-46A3-96FF-047F95396215/dotNetFx40_Full_setup.exe"
        # $url = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"

        Write-Host "requested -> .net framework 4.0"
        $url = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"
        $suffix="4_0"
    }
    elseif ($requestedVersion -eq 2)
    {
        # .net framework 4.5
        # $url = "https://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe"
        # $url = "https://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe"
        # $url = "http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe"
        
        Write-Host "requested -> .net framework 4.5"
        $url = "http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe"
        $suffix="_4_5"
    }
    elseif ($requestedVersion -eq 3)
    {
        # .net framework 4.5.1
        # $url = "https://dotnet.microsoft.com/download/thank-you/net451-offline"
        # $url = "http://download.microsoft.com/download/7/4/0/74078A56-A3A1-492D-BBA9-865684B83C1B/NDP451-KB2859818-Web.exe"
        # $url = "http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe"

        Write-Host "requested -> .net framework 4.5.1"
        $url = "http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe"
        $suffix="_4_5_1"
    }
    elseif ($requestedVersion -eq 4)
    {
        # .net framework 4.5.2
        # $url = "https://dotnet.microsoft.com/download/thank-you/net452-offline"
        # $url = "http://download.microsoft.com/download/9/A/7/9A78F13F-FD62-4F6D-AB6B-1803508A9F56/51209.34209.03/web/NDP452-KB2901954-Web.exe"
        # $url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
        
        Write-Host "requested -> .net framework 4.5.2"
        $url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
        $suffix="_4_5_2"
    }
    elseif ($requestedVersion -eq 5)
    {
        # .net framework 4.6
        # $url = "https://dotnet.microsoft.com/download/thank-you/net46-offline"
        # $url = "http://download.microsoft.com/download/2/8/7/2870C339-3C77-49CF-8DDF-AD6189AB8597/NDP453-KB2969351-x86-x64-AllOS-ENU.exe"
        # $url = "http://download.microsoft.com/download/1/4/A/14A6C422-0D3C-4811-A31F-5EF91A83C368/NDP46-KB3045560-Web.exe"
        # $url = "http://download.microsoft.com/download/6/F/9/6F9673B1-87D1-46C4-BF04-95F24C3EB9DA/enu_netfx/NDP46-KB3045557-x86-x64-AllOS-ENU_exe/NDP46-KB3045557-x86-x64-AllOS-ENU.exe"
        
        Write-Host "requested -> .net framework 4.6"
        $url = "http://download.microsoft.com/download/6/F/9/6F9673B1-87D1-46C4-BF04-95F24C3EB9DA/enu_netfx/NDP46-KB3045557-x86-x64-AllOS-ENU_exe/NDP46-KB3045557-x86-x64-AllOS-ENU.exe"
        $suffix="_4_6"
    }
    elseif ($requestedVersion -eq 6)
    {
        # .net framework 4.6.1
        # $url = "https://dotnet.microsoft.com/download/thank-you/net461-offline"
        # $url = "http://download.microsoft.com/download/3/5/9/35980F81-60F4-4DE3-88FC-8F962B97253B/NDP461-KB3102438-Web.exe"
        # $url = "http://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe"

        Write-Host "requested -> .net framework 4.6.1"
        $url = "http://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe"
        $suffix="_4_6_1"
    }
    elseif ($requestedVersion -eq 7)
    {
        # .net framework 4.6.2
        # $url = "https://dotnet.microsoft.com/download/thank-you/net462-offline"
        # $url = "https://download.microsoft.com/download/D/5/C/D5C98AB0-35CC-45D9-9BA5-B18256BA2AE6/NDP462-KB3151802-Web.exe"
        # $url = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"

        Write-Host "requested -> .net framework 4.6.2"
        $url = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
        $suffix="_4_6_2"
    }
    elseif ($requestedVersion -eq 8)
    {
        # .net framework 4.7
        # $url = "https://dotnet.microsoft.com/download/thank-you/net47-offline"
        # $url = "http://download.microsoft.com/download/A/E/A/AEAE0F3F-96E9-4711-AADA-5E35EF902306/NDP47-KB3186500-Web.exe"
        # $url = "http://download.microsoft.com/download/F/9/E/F9EE2F15-8F40-4319-A300-1734E58B8E0B/NDP47-KB3186497-x86-x64-AllOS-ENU.exe"

        Write-Host "requested -> .net framework 4.7"
        $url = "http://download.microsoft.com/download/F/9/E/F9EE2F15-8F40-4319-A300-1734E58B8E0B/NDP47-KB3186497-x86-x64-AllOS-ENU.exe"
        $suffix="_4_7"
    }
    elseif ($requestedVersion -eq 9)
    {
        # .net framework 4.7.1
        # $url = "https://dotnet.microsoft.com/download/thank-you/net471-offline"
        # $url = "https://download.microsoft.com/download/8/E/2/8E2BDDE7-F06E-44CC-A145-56C6B9BBE5DD/NDP471-KB4033344-Web.exe"
        # $url = "https://download.microsoft.com/download/C/4/C/C4CF757F-7578-4608-B483-7C51E16FB58F/NDP471-KB4033342-x86-x64-AllOS-ENU.exe"
        
        Write-Host "requested -> .net framework 4.7.1"
        $url = "https://download.microsoft.com/download/C/4/C/C4CF757F-7578-4608-B483-7C51E16FB58F/NDP471-KB4033342-x86-x64-AllOS-ENU.exe"
        $suffix="_4_7_1"
    }
    elseif ($requestedVersion -eq 10)
    {
        # .net framework 4.7.2
        # $url = "https://dotnet.microsoft.com/download/thank-you/net472-offline"
        # $url = "http://go.microsoft.com/fwlink/?linkid=863258"
        # $url = "https://download.microsoft.com/download/0/5/C/05C1EC0E-D5EE-463B-BFE3-9311376A6809/NDP472-KB4054531-Web.exe"
        # $url = "https://download.microsoft.com/download/6/E/4/6E48E8AB-DC00-419E-9704-06DD46E5F81D/NDP472-KB4054530-x86-x64-AllOS-ENU.exe"

        Write-Host "requested -> .net framework 4.7.2"
        $url = "https://download.microsoft.com/download/6/E/4/6E48E8AB-DC00-419E-9704-06DD46E5F81D/NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
        $suffix="_4_7_2"
    }
    elseif ($requestedVersion -eq 12)
    {
        # .net framework 4.8
        # $url = "https://dotnet.microsoft.com/download/thank-you/net48-offline"
        # $url = "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/c9b8749dd99fc0d4453b2a3e4c37ba16/ndp48-web.exe"
        # $url = "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe"

        Write-Host "requested -> .net framework 4.8"

        $url = "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe"
        $suffix="_4_8"
    }

    $output = "$PSScriptRoot\netFrameworkInstaller$suffix.exe"
    $start_time = Get-Date
       
    Invoke-WebRequest -Uri $url -OutFile $output  
    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"  
      
    Start-Process $output 
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
Write-Host "`n*****************]=- .net framework -=[*******************`n" 
[console]::ForegroundColor = "yellow" 
Get-Installed-Framework-Versions
[console]::ResetColor()
Write-Host "`n**********************************************************"
# in case .net framework family 4 is present in system, script start application otherwise 
# download and install predefined framework
Get-Framework-Versions-And-Handle-Operation $processCommand $requestVersion

[console]::ForegroundColor = "red" 
Write-Host "*****]=- Copyright © 2015 Peter Malik - (MalikP.) -=[*****"
[console]::ResetColor()
Write-Host "**********************************************************"