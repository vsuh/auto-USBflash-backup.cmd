:: charset="cp866"                                                         VSCraft(c)2023 
:: ����ࢭ�� ����஢���� ᮤ�ন���� USB flash drive
:: ��ਯ� ������ �믮������� ⮫쪮 ����� 䫥誠 � 䠩��� seal.seal ��⠭���������� � ����

@echo off
SETLOCAL ENABLEDELAYEDEXPANSION && cd /d %~dp0 && call configure

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
set error_log=%~dp0log\%yy%-%mm%-%dd%_error.log
set SEAL=%vsuh.flash.mountpoint%\seal.seal
set RAR=%vsuh.flash.mountpoint%\bin\rar.exe
if NOT exist %RAR% (@echo RAR executable not found in %vsuh.flash.mountpoint%\bin
	exit
)
exit /b

:do_backup
cd /d %vsuh.flash.mountpoint%
echo CD=%CD% %RAR% a -r -u -p%vsuh.backup.rarpw% -agYYYY-MM-DD ^
		-es ^
		-y -ilog%error_log% ^
		%vsuh.backup.files.path%\IRIS_ *.*

%RAR% a -r -u -p%vsuh.backup.rarpw% -agYYYY-MM-DD ^
		-es ^
		-y -ilog%error_log% ^
		%vsuh.backup.files.path%\IRIS_ *.*

cd /d %~dp0

exit /b

:delete_old_arcs

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