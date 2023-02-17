:: charset="cp866"
:: С помощью программы USBPlugEvent vsuh.cmdpath.backupлнение скрипта %vsvsuh.USBflash.id при установке флешки с id=%vsuh.register.id%
:: Скрипт повышает свои полномочия до админских
@echo off
if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0 && call cmd\configure

:: # curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe (as admin)
USBPlugEvent.exe -i "%vsuh.USBflash.id%" "%vsuh.cmdpath.backup%"
exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
