:: charset="cp866"                                                         VSCraft(c)2023 
:: Резервное копирование содержимого USB flash drive
:: Скрипт должен выполняться только когда флешка с файлом seal.seal устанавливается в порт

@echo off
@( SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0 && call cmd\configure %1 )

call :set_dateParts
call :read_settings
call :check_usb_flash
call :do_backup
call :delete_old_arcs

exit

:check_usb_flash
if NOT exist %SEAL% (@echo SEAL file %SEAL% not found
	exit
)
set /p _seal=<%SEAL%
if NOT `%_seal%`==`%vsuh.flash.pin%` (@echo SEAL "%_seal%" not correct
	exit 
)
exit /b

:read_settings
set error_log=log\%yy%-%mm%-%dd%_error.log
set SEAL=%vsuh.flash.mountpoint%\seal.seal
set RAR=%~dp0cmd\rar.exe
if NOT exist %RAR% ( echo RAR executable not found in %RAR% && exit )
exit /b

:do_backup
call :create_exceptions
cd /d %vsuh.flash.mountpoint%
echo CD=%CD% %RAR% a -r -u -p%vsuh.backup.rarpw% -agYYYY-MM-DD -idq -es -x@%vsuh.rar_ext_exept.file% -y -ilog%error_log% %vsuh.backup.files.path%\IRIS_ *.*

%RAR% a -r -u -p%vsuh.backup.rarpw% -agYYYY-MM-DD^
              -idq -es ^
              -x@%vsuh.rar_ext_exept.file%^
              -y -ilog%error_log% ^
              %vsuh.backup.files.path%\IRIS_ *.*
call :rar_rc_descr %ERRORLEVEL%

Set vsuh.result=%vsuh.flash.mountpoint%\BACKED.UP!
attrib -r -s -h %vsuh.result% 
echo %date% %time% Backup done RC:%vsuh.rar.err%>%vsuh.result%
attrib +r +s +h %vsuh.result%
cd /d %~dp0

exit /b

:delete_old_arcs
del %vsuh.rar_ext_exept.file%
Set ii=0
echo DELETE all except %vsuh.backup.keepfiles% files from "%vsuh.backup.files.path%" directory
for /f  %%I in ('dir /o:-d /a:-d /b %vsuh.backup.files.path%') DO (
	Set /a ii=ii+1
	if !ii! GTR %vsuh.backup.keepfiles% echo !ii!: DELETE %%I && del %vsuh.backup.files.path%\%%I
)
exit /b

:set_dateParts
Set yy=%date:~6,4%
Set mm=%date:~3,2%
Set dd=%date:~0,2%
exit /b

:create_exceptions

FOR /L %%I in (1,1,100) DO (
	Set nn=%%I
	IF NOT `!vsuh.ext.%%I!`==`` >>%vsuh.rar_ext_exept.file% echo !vsuh.ext.%%I!
)

exit /b

:rar_rc_descr
Set err=%1

if %err% equ 0   Set vsuh.rar.err=0   Successful operation.
if %err% equ 1   Set vsuh.rar.err=1   Warning. Non fatal error(s) occurred.
if %err% equ 2   Set vsuh.rar.err=2   A fatal error occurred.
if %err% equ 3   Set vsuh.rar.err=3   Invalid checksum. Data is damaged.
if %err% equ 4   Set vsuh.rar.err=4   Attempt to modify a locked archive.
if %err% equ 5   Set vsuh.rar.err=5   Write error.
if %err% equ 6   Set vsuh.rar.err=6   File open error.
if %err% equ 7   Set vsuh.rar.err=7   Wrong command line option.
if %err% equ 8   Set vsuh.rar.err=8   Not enough memory.
if %err% equ 9   Set vsuh.rar.err=9   File create error.
if %err% equ 10  Set vsuh.rar.err=10  No files matching the specified mask and options were found.
if %err% equ 11  Set vsuh.rar.err=11  Wrong password.
if %err% equ 255 Set vsuh.rar.err=255 User break.
exit /b
