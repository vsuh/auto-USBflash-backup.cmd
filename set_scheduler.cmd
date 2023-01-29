:: charset="cp866"
:: Регистрирует задачу в планировщике заданий по запуску скрипта register_USB_insert.cmd при старте компьютера
cd /d %~dp0
Set cmd.log=%~n0.log

if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
cd /d %~dp0 && call :configure
::Set task.name=\cyx\USB_EVENT_REGISTER
::Set task.exe=USBPlugEvent
::Set task.cmd="%~dp0register_USB_insert.cmd admin"
>>%cmd.log% echo %date% %time% ==============================================
>>%cmd.log% echo %time% ^> SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%task.name%" /TR %task.cmd% /F
>>%cmd.log% 2>&1           SCHTASKS /Create /RU SYSTEM /SC ONSTART /TN "%task.name%" /TR %task.cmd% /F

echo err=%ERRORLEVEL%
tasklist /FI "IMAGENAME eq %task.exe%*"|find /I "%task.exe%" && ( 
	>>%cmd.log%  echo %time% Программа %task.exe% уже выполняется
	) || (
	>>%cmd.log%  echo %time% ^> SCHTASKS /Run /I /TN "%task.name%"
	>>%cmd.log% 2>&1            SCHTASKS /Run /I /TN "%task.name%" ) 
exit

:UACPrompt
mshta "vbscript:CreateObject("Shell.Application").ShellExecute("%~fs0", "", "", "runas", 1) & Close()"

exit /b


::#----------------------------------------------------------------------------------------------------------------------------#::
:configure
call :check_cfg
    FOR /F "eol=; usebackq delims== tokens=1,2*" %%I in ("settings.ini") DO @(
        @Set var=%%I
        @Set value=%%J
        @Set var=!var: =!
        @Set value=!value:\ ={#__#__#}!
        @Set value=!value: =!
        @Set value=!value:{#__#__#}= !
        Set !var!=!value!
    )
     
exit /b

:check_cfg

SET PRF=__CHECK__
FOR /F "eol=; usebackq delims== tokens=1,2*" %%A in ("settings.ini.dist") DO @(
    @Set var=%%A
    @Set !PRF!.!var: =!=""
)

FOR /F "eol=; usebackq delims== tokens=1,2*" %%A in (`set %PRF%`) DO @(
    @set CheckVar=%%A
    FOR /F "eol=; usebackq delims== tokens=1,2*" %%I in ("settings.ini") DO @(
        @Set var=%%I
        @Set var=!var: =!
        if /I !var!==!CheckVar:%PRF%.=! @Set !CheckVar!=
    )
 )
 echo on
Set %PRF% 2>nul 1>&2

if %ERRORLEVEL% EQU 0 ( echo В файле `settings.ini` не найдены переменные:
    for /F "eol=; usebackq delims== tokens=1,2*" %%A in (`set %PRF%`) DO (
        @Set var=%%A
        @Set var=!var:%PRF%.=!
        @Echo -  "!var!"
    )
    timeout 12>nul
    EXIT
) 
@exit /b

