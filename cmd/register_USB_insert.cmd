:: charset="cp866"
:: � ������� �ணࠬ�� USBPlugEvent vsuh.cmdpath.backup������ �ਯ� %vsvsuh.USBflash.id �� ��⠭���� 䫥誨 � id=%vsuh.register.id%
:: ��ਯ� ����蠥� ᢮� ��������� �� �����᪨�
@echo on
if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0.. && call cmd\configure %1
Set cmd.log=log\register.log
tasklist /FI "IMAGENAME eq %vsuh.task.exe%*"|find /I "%vsuh.task.exe%" && ( 
	>>%cmd.log% echo %time% �ணࠬ�� %vsuh.task.exe% 㦥 �믮������. ������� �����.
	>>%cmd.log% taskkill /F /FI "IMAGENAME eq %vsuh.task.exe%*"
	) 
pause
:: # curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe (as admin)
echo cmd\USBPlugEvent.exe -i "%vsuh.USBflash.id%" "%~dp0..\%vsuh.cmdpath.backup%"
start /b cmd\USBPlugEvent.exe -i "%vsuh.USBflash.id%" "%~dp0..\%vsuh.cmdpath.backup%"

exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"
exit /b
