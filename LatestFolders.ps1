Clear-Host

Write-Host -ForegroundColor Yellow @"






    	8888888b.                           888        88888888888              d8b                           
    	888   Y88b                          888            888                  Y8P                           
     	888    888                          888            888                                                
   	888   d88P 888d888 .d88b.  .d8888b  888888 .d88b.  888  888d888 8888b.  888 88888b.   .d88b.  888d888 
    	8888888P"  888P"  d88""88b 88K      888   d88""88b 888  888P"      "88b 888 888 "88b d8P  Y8b 	      888P"   
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

Start-Sleep -seconds 3

Clear-Host

$ErrorActionPreference = "SilentlyContinue"
$global:ReturnData = [System.Collections.Generic.List[object]]::new()

class RecentDoc {
    [string]$SID       = ""
    [string]$UserName  = ""
    [string]$DocName   = ""
}

function Get-RecentDocs { 
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory=$true)][string]$SID,
        [Parameter(Mandatory=$true)][string]$Username
    )

    $regPath = "Registry::HKEY_USERS\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
    
    if (Test-Path -LiteralPath $regPath) {
        $regKey = Get-Item -LiteralPath $regPath
        $properties = $regKey | Select-Object -ExpandProperty property
        
        foreach ($property in $properties) {
            try {
                $data = (Get-ItemProperty -LiteralPath $regPath -Name $property).$property
                $decoded = [System.Text.Encoding]::Unicode.GetString($data)
                $cleanName = ($decoded -replace '[^a-zA-Z0-9 \.\-_\\/()~ ]', '\^').split('\^')[0]
                
                if (-not [string]::IsNullOrEmpty($cleanName)) {
                    $global:ReturnData.Add([RecentDoc]@{
                        SID      = $SID
                        UserName = $Username
                        DocName  = $cleanName
                    })
                }
            }
            catch {
                Write-Verbose "???"
            }
        }
    }
}

$Users = Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.SID -notlike 'S-1-5-18' -and $_.SID -notlike 'S-1-5-19' }

foreach ($User in $Users) {
    Write-Host "`nScanning activity user: $($User.Name)" -ForegroundColor Cyan
    Get-RecentDocs -SID $User.SID -Username $User.Name
}

Start-Sleep -second 3

Clear-Host


Write-Host "`nRegedit path parsed..." -ForegroundColor Green
Start-Sleep -Seconds 3

Clear-Host

if ($global:ReturnData.Count -gt 0) {
    $global:ReturnData | Out-GridView -Title "Recent Documents (Total: $($global:ReturnData.Count))"
}
else {
    Write-Host "Recent path is empty" -ForegroundColor Yellow
}

return $global:ReturnData