Clear-Host

Write-Host -ForegroundColor Yellow @"






    	 8888888b.                           888        88888888888              d8b                           
    	 888   Y88b                          888            888                  Y8P                           
     	 888    888                          888            888                                                
   	 888   d88P 888d888 .d88b.  .d8888b  888888 .d88b.  888  888d888 8888b.  888 88888b.   .d88b.  888d888 
    	 8888888P"  888P"  d88""88b 88K      888   d88""88b 888  888P"      "88b 888 888 "88b d8P  Y8b 888P"   
     	 888        888    888  888 "Y8888b. 888   888  888 888  888    .d888888 888 888  888 88888888 888     
    	 888        888    Y88..88P      X88 Y88b. Y88..88P 888  888    888  888 888 888  888 Y8b.     888     
    	 888        888     "Y88P"   88888P'  "Y888 "Y88P"  888  888    "Y888888 888 888  888  "Y8888  888     
                                                                                                       

"@

$zalupa = "Created by Vladislav Dissapirov"
$zalupa1 = " - Senior to ScreenSharing hakiraindex"
$Width = $Host.UI.RawUI.WindowSize.Width
$hueta = " " * [math]::Max(0, ($Width - $zalupa.Length) / 3.5)

Write-Host "`n$hueta" -NoNewline
Write-Host $zalupa -ForegroundColor DarkCyan -NoNewline
Write-Host $zalupa1 -ForegroundColor Magenta
Write-Host "`n"


Start-sleep -seconds 5


function Get-ServiceDetailed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [array]$Services
    )

    foreach($Service in $Services) {
        $NewService = [Service]::new()
        $NewService.Name = $Service.Name
        $NewService.DisplayName = $Service.DisplayName
        $NewService.State = $Service.State
        $NewService.PathName = $Service.PathName
        $global:ReturnData += $NewService
    }
}

$ErrorActionPreference = "SilentlyContinue"
$global:ReturnData = @()

class Service {
    [string]$Name = ""
    [string]$DisplayName = ""
    [string]$State = ""
    [string]$PathName = ""
}

$AllServices = Get-WmiObject win32_service | select Name, DisplayName, State, PathName
Get-ServiceDetailed -Services $AllServices

Return $global:ReturnData | Out-GriedView
