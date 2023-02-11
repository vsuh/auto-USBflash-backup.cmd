Set t="\cyx\USB_BACKUP_ONIDLE"

SCHTASKS /delete /TN "%t%" /F 
SCHTASKS /create /TN "%t%" /xml Backup_Task.xml
