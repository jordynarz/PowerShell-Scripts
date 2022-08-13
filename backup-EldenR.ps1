<#
Elden Ring Backup and Restore Script

TODO: 
	Contain the backup inside a function[COMPLETED]
	Add Input for naming save folder [COMPLETED]
	Input validation
	Create Menu[COMPLETED]
	Create Restore functions [COMPLETED]
		-able to view saved backups and select one

         
#>

using namespace System.Management.Automation.Host # Library for menu

# Preferences
$ErrorActionPreference = "Stop"		# Behavior - error actions to stop instead of continuing

# Global Variables

$Date= ((Get-Date).ToString('MM-dd-yyyy-HH-mm'))						# Auto currentDate save path
$myDocs = [System.Environment]::GetFolderPath("MyDocuments")			# MyDocuments folder
$appData = [System.Environment]::GetFolderPath("ApplicationData")		# AppData folder
$eldenPath = Join-Path -Path $appData -ChildPath "EldenRing"			# path = AppData\Roaming\EldenRing\
$eldenUser = Get-ChildItem  $eldenPath -Directory						# Just the user number inside the path = AppData\Roaming\EldenRing\
$restorePath = Join-Path -Path $eldenPath -ChildPath $eldenUser			# path = AppData\Roaming\EldenRing\1234...\
$docPath = Join-Path -Path $myDocs -ChildPath "EldenRingBackups"		# path = MyDocuments/EldenRingBackups
$sl2Files = Get-ChildItem -Path $eldenPath -Include "*.sl2*" -Recurse	# .sl2 files that are the Elden Ring save data inside the path = AppData\Roaming\EldenRing\1234...\
$restoreSavePath = Join-Path -Path $docPath -ChildPath $Date   			# Auto currentDate save path in MyDocuments


function BackupSL2 {
	if (![System.IO.Directory]::Exists($eldenPath)) {
		"The Path Does Not Exist."}
	else {
		$inputBackup= Read-Host -Prompt "Name your backup"
		#INPUT VALIDATE THE ABOVE ^^^
        Validate $inputBackup # validate the user input for word characters and not null or empty

		$savePath = Join-Path -Path $docPath -ChildPath $inputBackup # path = MyDocuments
		
		$FileExists = Test-Path -Path $savePath".zip" -PathType Leaf
		if ($FileExists -eq $True) {throw "There is a backup with this name"}	# Error catching if the file EXISTS
		

		$sl2Files | Compress-Archive -DestinationPath $savePath".zip" -Force
    #   Compress-Archive -DestinationPath $savePath".zip" -Force
		



		New-Menu # Calls the menu again to keep the program open
	}
	
}


function restoreBackupSL2 {
	if (![System.IO.Directory]::Exists($eldenPath)) {
		"The Path Does Not Exist."}
	else {
		
		$sl2Files | Compress-Archive -DestinationPath $restoreSavePath".zip" -Force
    		
	}
	
}

function restoreSL2 {
    restoreBackupSL2 # Run the backup before restoring
	#Write-Host 'INSERT RESTORE FUNCTIONS HERE'
    Get-ChildItem $docPath | Out-GridView -PassThru | Expand-Archive -DestinationPath $restorePath -Force
    Write-Host "******Restore Completed******" -ForegroundColor Blue
    
	New-Menu #Runs the program menu again to keep the program open
}

function New-Menu {
    #[CmdletBinding()]
	Write-Host 	'------Elden Ring Backup Script------' -ForegroundColor Yellow
	Write-Host "------What would you like to do?------" -ForegroundColor Green
    $backup = [ChoiceDescription]::new('&Backup', 'Backup Elden Ring .sl2 files')
    $restore = [ChoiceDescription]::new('&Restore', 'Restore the selected .sl2 file')
    $quit = [ChoiceDescription]::new('&Quit', 'Quit out')

    $options = [ChoiceDescription[]]($backup, $restore, $quit)

    $result = $host.ui.PromptForChoice($Title, $Question, $options, 2)


    switch ($result) {
        0 { BackupSL2}
        1 { restoreSL2 }
        2 { return }
    }
	
}

Function Validate {
    Param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
	[ValidatePattern("\w")]		# \w is any word character 
    [String[]]$Value
    )
	#Write-Host $Value
	#[System.IO.FileInfo] $Value
	#Test-Path -Path $Value -IsValid



    }
    



# Run the Program Menu
New-Menu

