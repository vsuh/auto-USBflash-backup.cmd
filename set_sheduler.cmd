:: Регистрирует задачу в планировщике заданий по запуску скрипта register_USB_insert.cmd при старте компьютера
cd /d %~dp0
if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
Set task.name="\cyx\USB_EVENT_REGISTER"
Set task.cmd="%~dp0\register_USB_insert.cmd admin"


SCHTASKS /Create /RU "NT AUTHORITY\LOCALSERVICE" /SC ONSTART ^
 /TN %task.name% /TR %task.cmd% /F /Z

echo err=%ERRORLEVEL%

exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
