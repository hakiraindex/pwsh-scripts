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

Function Get-Folder($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.rootfolder = "MyComputer"
	$foldername.Description = "Please select a directory"
	$foldername.ShowNewFolderButton = $false
	
    if($foldername.ShowDialog() -eq "OK")
		{
        $folder += $foldername.SelectedPath
		 } 
	        else  
   {

     Clear-Host

     Write-Host "(Scanning Disk):" -f DarkMagenta -nonewline; 
     Write-Host " Cancelled by the system user" -f Cyan -nonewline
     
	
			exit
   }

    return $Folder

   }

	$Folder = Get-Folder

       Clear-Host

	$topMargin = 5
	$lineGap = 2 

	Write-Host "(Scanning Disk):" -f DarkMagenta -nonewline
	Write-Host " Selected directory:" -f Cyan -nonewline
	Write-Host " ($Folder)" -f Yellow

$Files = Get-ChildItem -Path $Folder -recurse -ErrorAction Ignore
$1=1

			  
$results = ForEach ($File in $Files) {$i++

	# Check that Alternate Data Streams exist, and if so split the output up to 5 variables
	try{$Stream = (Get-Item -literalpath $File.FullName -Stream *).stream|out-string|ConvertFrom-String -PropertyNames St1, St2, St3, Stl4, Stl5}
		Catch{$Stream = ""}
	
	try{$Zone = Get-Content -Stream Zone.Identifier -literalpath $File.FullName -ErrorAction Ignore|out-string|ConvertFrom-String -PropertyNames Z1, Z2, Z3, Z4, Z5}
		Catch{$Zone = ""}

	try{$hashMD5 = (Get-FileHash -literalpath $File.FullName -Algorithm MD5 -ErrorAction Ignore).Hash}catch{$hash=""}
	
	Write-Progress -Activity "Collecting information for File: $file" -Status "File $i of $($Files.Count))" -PercentComplete (($i / $Files.Count) * 100)  

	[PSCustomObject]@{ 
	Path = Split-Path -literalpath $File.FullName 
	'File/Directory Name' = $File 
	'Owner (name/sid)' = (Get-Acl -literalpath $file.FullName).owner
	Length = (Get-ChildItem -literalpath $File.FullName -force).length
	LastAccessTime = (Get-ItemProperty -literalpath $File.FullName).lastaccesstime
	LastWriteTime = (Get-ItemProperty -literalpath $File.FullName).lastwritetime
	Created = (Get-ItemProperty -Literalpath $File.FullName).Created
	}
	
 }

$results | Out-GridView
