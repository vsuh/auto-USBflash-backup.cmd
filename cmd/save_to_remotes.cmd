:: charset="cp866"
::# backup.dest.ssh.1 = cyxasus:G:/IRIS_BACKUPS
::# backup.dest.ssh.2 = helor:BACKUPS/IRIS
::# backup.files.path = d:\backups\USBFLASH
::# backup.keypath = C:\Users\vsuh\.ssh\id_rsa
::
SETLOCAL ENABLEDELAYEDEXPANSION
@echo off
Set me=%0
Set log=%~dpn0.log
Set _cd=%CD%
call :configure
cd %backup.files.path%
for /f "usebackq delims== tokens=1,2" %%I in (`set backup.dest`) DO (
	Set var=%%I
	Set val=%%J
	IF "!var:~12,3!"=="ssh" ( 
	echo ^*^*^*^*^ SSH copy to !val!
		scp -i !backup.keypath! *.rar !val! 
		if `!ERRORLEVEL!`==`0` ( 
			echo !date! !time! !val! SUCCESS >>!log!
				) ELSE ( 
			echo !date! !time! !val! ERROR {!ERRORLEVEL!} >>!log! 
		)
	)
	

)
cd /d %_cd%
EXIT
:configure

FOR /F "eol=; tokens=1,2,3,4* delims==# usebackq" %%I in (`findstr /B /C:"::#" %me%`) DO @(
    @set str=%%K
    @set var=%%J
    @SET !var: =!=!str: =!
)

exit /b