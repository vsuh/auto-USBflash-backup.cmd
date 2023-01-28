:: charset="cp866"
:: Скрипт повышает своиполномочия до админских
@echo off
if %1==admin goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
cd /d %~dp0
:: ID устройства можно получить USBPlugEvent.exe -l
Set id=USB\VID_346D&PID_5678\4390441110687449097
:: 2>nul curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe
USBPlugEvent.exe -i "%id%" "D:\IRIS\bin\backup_flash.cmd"
exit


:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
