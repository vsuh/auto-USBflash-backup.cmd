:: charset="cp866"
:: С помощью программы USBPlugEvent регистрирует выполнение скрипта %vsuh.register.cmd% при установке флешки с id=%vsuh.register.id%
:: Скрипт повышает свои полномочия до админских
@echo off
if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
SETLOCAL ENABLEDELAYEDEXPANSION
cd /d %~dp0 && call configure
Set here=%~dp0
Set log=log\%here%%~n0.log
:: # curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe (as admin)
USBPlugEvent.exe -i "%vsuh.register.id%" "%vsuh.register.cmd%"
exit


:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
