::# backup.dest.ssh.1 = cyxasus:G:/IRIS_BACKUPS
::# backup.dest.ssh.2 = helor:BACKUPS/IRIS
::# backup.files.path=d:\backups\USBFLASH
::# backup.keypath=C:\Users\vsuh\.ssh\id_rsa
SETLOCAL ENABLEDELAYEDEXPANSION
@echo on
Set me=%0
Set _cd=%CD%
call :configure
cd %backup.files.path%
for /f "usebackq delims== tokens=1,2" %%I in (`set backup.dest`) DO (
	Set var=%%I
	Set val=%%J
	IF "!var:~12,3!"=="ssh" ( 
	echo ^*^*^*^*^ SSH copy to !val!
		scp -i !backup.keypath! *.rar !val! 
	)
	

)
cd /d %_cd%
EXIT
:configure
@echo off
FOR /F "eol=; tokens=1,2,3,4* delims==# usebackq" %%I in (`findstr /B /C:"::#" %me%`) DO @(
    @set str=%%K
    @set var=%%J
    @SET !var: =!=!str: =!
)
exit /b