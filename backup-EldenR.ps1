<#
Elden Ring Backup and Restore Script

TODO: 
	Contain the backup inside a function[COMPLETED]
	Add Input for naming save folder [remove date?]
	Input validation
	Create Menu[Working but not what I want]
	Create Restore functions
		-able to view saved backups and select one

            -WhatIf ?? Use this and try stuff
#>

using namespace System.Management.Automation.Host # Library for menu

$Date= ((Get-Date).ToString('MM-dd-yyyy-HH-mm'))					# Old Version
$myDocs = [System.Environment]::GetFolderPath("MyDocuments")
$appData = [System.Environment]::GetFolderPath("ApplicationData")
$eldenPath = Join-Path -Path $appData -ChildPath "EldenRing"
$eldenUser = Get-ChildItem  $eldenPath -Directory
$restorePath = Join-Path -Path $eldenPath -ChildPath $eldenUser
$docPath = Join-Path -Path $myDocs -ChildPath "EldenRingBackups"
$sl2Files = Get-ChildItem -Path $eldenPath -Include "*.sl2*" -Recurse
$restoreSavePath = Join-Path -Path $docPath -ChildPath $Date   			#Old Version
#$savePath = Join-Path -Path $docPath -ChildPath $inputBackup

function BackupSL2 {
	if (![System.IO.Directory]::Exists($eldenPath)) {
		"The Path Does Not Exist."}
	else {
		$inputBackup= Read-Host -Prompt "Name your backup: "
		#INPUT VALIDATE THE ABOVE ^^^
        #Validate $inputBackup

		$savePath = Join-Path -Path $docPath -ChildPath $inputBackup # Move to Input Menu

		$sl2Files | Compress-Archive -DestinationPath $savePath".zip" -Confirm -Force
    #   Compress-Archive -DestinationPath $savePath".zip" -Force

		New-Menu # Calls the menu again to keep the program open
	}
	
}


function restoreBackupSL2 {
	if (![System.IO.Directory]::Exists($eldenPath)) {
		"The Path Does Not Exist."}
	else {
		#$savePath = Join-Path -Path $docPath -ChildPath  # Saves folder as current date

		$sl2Files | Compress-Archive -DestinationPath $restoreSavePath".zip" -Force
    #   Compress-Archive -DestinationPath $savePath".zip" -Force

		
	}
	
}

function restoreSL2 {
    restoreBackupSL2 # Run the backup before restoring
	Write-Host 'INSERT RESTORE FUNCTIONS HERE'
    Get-ChildItem $docPath | Out-GridView -PassThru | Expand-Archive -Confirm -DestinationPath $restorePath -Force
    
    
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
    [String[]]$Value
    )
    }
    



# Run the Program Menu
New-Menu

