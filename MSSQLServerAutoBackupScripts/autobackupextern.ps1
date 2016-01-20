#Powershell 2.0 or above
Register-WmiEvent -Class win32_VolumeChangeEvent -SourceIdentifier volumeChange
write-host (get-date -format s) " Beginning script..."
do{
$newEvent = Wait-Event -SourceIdentifier volumeChange
$eventType = $newEvent.SourceEventArgs.NewEvent.EventType
$eventTypeName = switch($eventType)
{
1 {"Configuration changed"}
2 {"Device arrival"}
3 {"Device removal"}
4 {"docking"}
}
write-host (get-date -format s) " Event detected = " $eventTypeName
if ($eventType -eq 2)
{
$driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
$driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
write-host (get-date -format s) " Drive name = " $driveLetter
write-host (get-date -format s) " Drive label = " $driveLabel
# Executa apenas se a drive cumprir a condição neste caso a label ser "BackupsExterno"
if ($driveLetter -eq 'E:' -and $driveLabel -eq 'BackupsExterno')
{
write-host (get-date -format s) " Iniciando dentro de 3 segundos..."
write-host (get-date -format s) " Segure-se bem!!!! (Dino joke)"
start-sleep -seconds 3
start-process "E:\sync.bat"
#backup das bds
if(-not(Get-Module SQLPS)) {Import-Module SQLPS -DisableNameChecking}
invoke-sqlcmd -inputfile "c:\bck\BackupDasBDSExterno" -serverinstance "MSSQLSERVER\SQLEXPRESS" –Username "sa" –Password "sapwd"
 #fim do backup das bds
}
}
Remove-Event -SourceIdentifier volumeChange
} while (1-eq1) #Loop até ao proximo evento
Unregister-Event -SourceIdentifier volumeChange
write-host (get-date -format s) " Obrigado! Até a uma proxima!"
write-host (get-date -format s) " Votos de um excelente dia."