:: charset="utf-8"
:: Регистрирует задачу в планировщике заданий по запуску скрипта register_USB_insert.cmd при старте компьютера
cd /d %~dp0
Set cmd.log=log\%~n0.log
call :check_all
if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
@SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0 && call cmd\configure
>>%cmd.log% echo %date% %time% ==============================================

call :create_xml %vsuh.task.tmpl% register
>>%cmd.log% echo %time% ^> SCHTASKS /Create /RU SYSTEM /xml %vsuh.task.xml% /TN "%vsuh.task.name%" /F 
>>%cmd.log% 2>&1           SCHTASKS /Delete /TN "%vsuh.task.name%" /F 
>>%cmd.log% 2>&1           SCHTASKS /Create /TN "%vsuh.task.name%"  /RU SYSTEM /xml %vsuh.task.xml% /F
if NOT defined vsuh.dev del %vsuh.task.xml%
         
call :create_xml %vsuh.task.tmpl% backup
>>%cmd.log% echo %time% ^> SCHTASKS /Create /RU SYSTEM /xml "%vsuh.task.xml%" /TN "%vsuh.task1.name%" /F (%CD%) xml %vsuh.task.xml%
>>%cmd.log% 2>&1           SCHTASKS /Delete /TN "%vsuh.task1.name%" /F
>>%cmd.log% 2>&1           SCHTASKS /Create /TN "%vsuh.task1.name%" /RU SYSTEM /xml %vsuh.task.xml% /F 
if NOT defined vsuh.dev del %vsuh.task.xml%

echo err=%ERRORLEVEL%
tasklist /FI "IMAGENAME eq %vsuh.task.exe%*"|find /I "%vsuh.task.exe%" && ( 
	>>%cmd.log% echo %time% Программа %vsuh.task.exe% уже выполняется. Завершаю процесс.
	>>%cmd.log% taskkill /F /FI "IMAGENAME eq %vsuh.task.exe%*"
	) 
>>%cmd.log%  echo %time% ^> SCHTASKS /Run /I /TN "%vsuh.task.name%"
>>%cmd.log% 2>&1            SCHTASKS /Run /I /TN "%vsuh.task.name%"  

exit

:UACPrompt
@mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"

exit /b


:create_xml
>nul chcp 65001
>%vsuh.task.xml% type nul

Set vsuh.val.3=!vsuh.val.3.%2!

for /F "tokens=1,2,3* delims=•" %%A in ('type %1') do (
    Set _str=%%A%%B%%C
    for /L %%T in (1,1,16) do (
        Set _var=!vsuh.var.%%T!
        Set _val=!vsuh.val.%%T!
        if `%%B`==`!_var!` (
	    Set _str=%%A!_val!%%C 
	)
    )
  echo !_str!
)>>%vsuh.task.xml% 
>nul chcp 866
exit /b

:check_all
>nul chcp 65001
if not exist cmd\rar.exe 		( echo Файл "%~dp0cmd\rar.exe" НЕ найден && exit )
if not exist cmd\USBPlugEvent.exe 	( echo Файл "%~dp0cmd\USBPlugEvent.exe" НЕ найден && exit )
if not exist settings.ini 		( echo Файл "%~dp0settings.ini" НЕ найден && exit )
exit /b
