:: charset="cp866"
:: � ������� �ணࠬ�� USBPlugEvent ॣ������� �믮������ �ਯ� %vsuh.register.cmd% �� ��⠭���� 䫥誨 � id=%vsuh.register.id%
:: ��ਯ� ����蠥� ᢮� ��������� �� �����᪨�
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
