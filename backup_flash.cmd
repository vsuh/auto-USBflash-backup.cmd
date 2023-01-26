@echo off
call :read_settings
call :check_usb_flash
call :do_backup
call :delete_old_arcs
echo Finished(%ERRORLEVEL%)
exit


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
set bk_path=d:\backups\USBFLASH
set sr_path=d:\IRIS
set SEAL=d:\IRIS\seal.seal
set RAR=d:\iris\bin\rar.exe
set curr_path=%CD%
set f2k=5
exit /b

:do_backup
cd /d %sr_path%
%RAR% a -r -agYYYY-MM-DD -xbin -xseal.seal -x"System Volume Information" -y -- %bk_path%\IRIS_ *.*
cd /d %curr_path%

exit /b

:delete_old_arcs
SETLOCAL ENABLEDELAYEDEXPANSION
Set ii=0
echo DELETE all except %f2k% files from "%bk_path%" directory
for /f  %%I in ('dir /o:-d /a:-d /b %bk_path%') DO (
	Set /a ii=ii+1
	if !ii! GTR %f2k% echo !ii!: DELETE %%I && del %bk_path%\%%I
)
