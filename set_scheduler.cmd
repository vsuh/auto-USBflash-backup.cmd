:: charset="cp866"
:: Регистрирует задачу в планировщике заданий по запуску скрипта register_USB_insert.cmd при старте компьютера
cd /d %~dp0
Set cmd.log=%~n0.log

if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0 && call configure

>>%cmd.log% echo %date% %time% ==============================================
>>%cmd.log% echo %time% ^> SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%vsuh.task.name%" /TR "%~dp0!vsuh.task.cmd!" /F
>>%cmd.log% 2>&1           SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%vsuh.task.name%" /TR "%~dp0!vsuh.task.cmd!" /F

>>%cmd.log% echo %time% ^> SCHTASKS /Create /RU SYSTEM /SC ONLOGON /TN "%vsuh.task1.name%" /TR "!vsuh.register.cmd!" /F
>>%cmd.log% 2>&1           SCHTASKS /Create /RU SYSTEM /SC ONLOGON /TN "%vsuh.task1.name%" /TR "!vsuh.register.cmd!" /F

echo err=%ERRORLEVEL%
tasklist /FI "IMAGENAME eq %vsuh.task.exe%*"|find /I "%vsuh.task.exe%" && ( 
	>>%cmd.log% echo %time% Программа %vsuh.task.exe% уже выполняется. Завершаю процесс.
	>>%cmd.log% tasklist /FI "IMAGENAME eq %vsuh.task.exe%*"
	) 
>>%cmd.log%  echo %time% ^> SCHTASKS /Run /I /TN "%vsuh.task.name%"
>>%cmd.log% 2>&1            SCHTASKS /Run /I /TN "%vsuh.task.name%" ) 
exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"

exit /b

