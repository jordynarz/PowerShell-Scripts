$Date= ((Get-Date).ToString('MM-dd-yyyy-HH-mm'))
$myDocs = [System.Environment]::GetFolderPath("MyDocuments")
$appData = [System.Environment]::GetFolderPath("ApplicationData")
$eldenPath = Join-Path -Path $appData -ChildPath "EldenRing"
$docPath = Join-Path -Path $myDocs -ChildPath "EldenRingBackups"
$savePath = Join-Path -Path $docPath -ChildPath $Date

if (![System.IO.Directory]::Exists($eldenPath)) {
	"The Path Does Not Exist."}
else {
	Get-ChildItem -Path $eldenPath -Include "*.sl2*" -Recurse | Compress-Archive -DestinationPath $savePath".zip" -Force
}
