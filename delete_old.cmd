@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
if .%1.==.. (echo parameter need - path to delete old files from
exit) ELSE (
Set pt=%1
)
if .%2.==.. (
Set nm=5
) ELSE (
Set nm=%2
)

Set nn=0
echo DELETE all except %nm% files from "%pt%" directory
for /f  %%I in ('dir /o:-d /a:-d /b %pt%') DO (
	Set /a nn=nn+1
	if !nn! GTR %nm% echo !nn!: DELETE %%I && del %pt%\%%I
)
