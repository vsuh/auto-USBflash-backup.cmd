:: Скрипт повышает своиполномочия до админских
@echo off
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

cd /d %~dp0

2>nul curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe
USBPlugEvent.exe -i "USB\VID_346D&PID_5678\4390441110687449097" "D:\IRIS\bin\backup_flash.cmd"



:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
