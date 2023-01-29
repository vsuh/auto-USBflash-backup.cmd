:: charset="cp866"
:: С помощью программы USBPlugEvent регистрирует выполнение скрипта %vsuh.register.cmd% при установке флешки с id=%vsuh.register.id%
:: Скрипт повышает свои полномочия до админских
@echo off

if `%1`==`admin` goto iamadmin
reg.exe query "HKU\S-1-5-19">nul 2>&1
if %errorlevel% equ 1 goto UACPrompt

:iamadmin
cd /d %~dp0 && call :configure
Set here=%~dp0
Set log=%here%%~n0.log
:: # curl https://github.com/initmaster/USBPlugEvent/releases/download/1.0.0/USBPlugEvent.exe -o USBPlugEvent.exe (as admin)
USBPlugEvent.exe -i "%vsuh.register.id%" "%vsuh.register.cmd%"
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

