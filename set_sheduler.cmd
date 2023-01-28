:: Регистрирует задачу в планировщике заданий по запуску скрипта register_USB_insert.cmd при старте компьютера
cd /d %~dp0
Set cmd.log=Scheduler_Register.LOG

if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
Set task.name=\cyx\USB_EVENT_REGISTER
Set task.exe=USBPlugEvent
Set task.cmd="%~dp0register_USB_insert.cmd admin"
>>%cmd.log% %date% %time% ==============================================
>>%cmd.log%      echo %time% ^> SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%task.name%" /TR %task.cmd% /F
>>%cmd.log% 2>&1 SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%task.name%" /TR %task.cmd% /F

echo err=%ERRORLEVEL%
tasklist /FI "IMAGENAME eq %task.exe%*"|find /I "%task.exe%" && ( 
	echo %time% Программа %task.exe% уже выполняется>>%cmd.log% 
	) || (
	>>%cmd.log%      echo %time% ^> SCHTASKS /Run /I /TN %task.name%
	>>%cmd.log% 2>&1 SCHTASKS /Run /I /TN "%task.name%"
) 
exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
type %cmd.log%

exit /b
