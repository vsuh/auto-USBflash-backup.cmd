@echo off

cd %~dp0

if `%1`==`` call :check_cfg

FOR /F "eol=; usebackq delims== tokens=1,2*" %%I in ("settings.ini") DO @(
    @Set var=%%I
    @Set value=%%J
    @Set var=!var: =!
    @Set value=!value:\ ={#__#__#}!
    @Set value=!value: =!
    @Set value=!value:{#__#__#}= !
    Set !var!=!value!
)
2>nul md log
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
 
Set %PRF% 2>nul >nul

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

