function Get-Installed-Framework-Versions()
{
    $installedFrameworks = @()
    if(Is-Key-Present "HKLM:\Software\Microsoft\.NETFramework\Policy\v1.0" "3705") { $installedFrameworks += "1.0" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v1.1.4322" "Install") { $installedFrameworks += "1.1" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727" "Install") { $installedFrameworks += "2.0" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup" "InstallSuccess") { $installedFrameworks += "3.0" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v3.5" "Install") { $installedFrameworks += "3.5" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install") { $installedFrameworks += "4.0c" }
    if(Is-Key-Present "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") { $installedFrameworks += "4.0" }   
     
    return $installedFrameworks
}

function Get-Framework-Versions-And-Hanle-Operation()
{
    if ((Get-Framework40-Family-Version) -ge 1)
    {
         Start-Process notepad.exe 
    }
    else
    {
        Download-And-Install-Framework
    }
}

function Get-Framework40-Family-Version()
{
    $result = -1
    if(Test-Key "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" "Install" -or Test-Key "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Install") 
    {
        # net 4.0 is installed
        $result = 0
        $version = Get-Framework-Value "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" "Release"
        if ($version -ge 393295)
        {
            # net 4.6 or later
            $result = 4
        }
        elseif ($version -ge 379893) 
        {
             # net 4.5.2 or later
             $result = 3
        }
        elseif ($version -ge 378675)
        {
             # net 4.5.1 or later
             $result = 2
        }
        elseif ($version -ge 378389) 
        {
             # net 4.5.0 or later
             $result = 1
        }   
    }
    else
    {
        $result = -1
    }
    
    return $result
}

function Download-And-Install-Framework()
{
      # net 4.0   -> http://download.microsoft.com/download/1/B/E/1BE39E79-7E39-46A3-96FF-047F95396215/dotNetFx40_Full_setup.exe
      # net 4.5   -> http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe
      # net 4.5.2 -> http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe
      # net 4.6   -> http://download.microsoft.com/download/1/4/A/14A6C422-0D3C-4811-A31F-5EF91A83C368/NDP46-KB3045560-Web.exe => except win 10
      $url = "http://download.microsoft.com/download/1/4/A/14A6C422-0D3C-4811-A31F-5EF91A83C368/NDP46-KB3045560-Web.exe"
      $output = "$PSScriptRoot\NDP46-KB3045560-Web.exe"
      $start_time = Get-Date
       
      Invoke-WebRequest -Uri $url -OutFile $output  
      Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"  
      
      Start-Process NDP46-KB3045560-Web.exe 
      # -NoNewWindow -Wait
}
 
function Is-Key-Present([string]$path, [string]$key)
{
    if(!(Test-Path $path)) { return $false }
    if ((Get-ItemProperty $path).$key -eq $null) { return $false }
    return $true
}

function Get-Framework-Value([string]$path, [string]$key)
{
    if(!(Test-Path $path)) { return "-1" }
    
    return (Get-ItemProperty $path).$key  

}

Get-Installed-Framework-Versions
Get-Framework-Versions-And-Hanle-Operation