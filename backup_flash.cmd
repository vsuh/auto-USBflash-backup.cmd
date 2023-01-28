:: charset="cp866"
@echo off
call :set_dateParts
call :read_settings
call :check_usb_flash
call :do_backup
call :delete_old_arcs

exit
:: VSCraft(c)2023 
:: Резервное копирование содержимого USB flash drive
:: Скрипт должен выполняться, когда флешка с файлом seal.seal устанавливается в порт
::###############################[ SUBROUTINES ]##################################::
:check_usb_flash
if NOT exist %SEAL% (@echo SEAL file %SEAL% not found
	exit
)
set /p _seal=<%SEAL%
if NOT .%_seal%.==.36917041. (@echo SEAL "%_seal%" not correct
	exit 
)
if NOT exist %RAR% (@echo RAR executable not found
	exit
)
exit /b

:read_settings
set BACKUP_PATH=d:\backups\USBFLASH
set error_log=d:\backups\log\%yy%-%mm%-%dd%_error.log
set ФЛЕШ=d:\IRIS
set SEAL=d:\IRIS\seal.seal
set RAR=d:\iris\bin\rar.exe
set curr_path=%CD%
set СохранитьФайлов=5
set pw=qwerf
exit /b

:do_backup
cd /d %ФЛЕШ%
%RAR% a -r -u -p%pw% -agYYYY-MM-DD ^
		-es ^
		-y -ilog%error_log% ^
		%BACKUP_PATH%\IRIS_ *.*

cd /d %curr_path%

exit /b

:delete_old_arcs
SETLOCAL ENABLEDELAYEDEXPANSION
Set ii=0
echo DELETE all except %СохранитьФайлов% files from "%BACKUP_PATH%" directory
for /f  %%I in ('dir /o:-d /a:-d /b %BACKUP_PATH%') DO (
	Set /a ii=ii+1
	if !ii! GTR %СохранитьФайлов% echo !ii!: DELETE %%I && del %BACKUP_PATH%\%%I
)

:set_dateParts

Set yy=%date:~6,4%
Set mm=%date:~3,2%
Set dd=%date:~0,2%
