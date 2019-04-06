@echo off
setLocal EnableDelayedExpansion
		 

set computerToRunOn=%~1
set userNameToUse=%~2
set passwordToUse=%~3
set commandToRun=%~4

set scheduleTaskName=DavidRemoteTasksScr

goto :START

:START

call :CHECK_PARAMS
call :CHECK_PING
call :CREATE_SCHEDULED_TASK
call :RUN_SCHEDULED_TASK

goto :END




:CHECK_PARAMS
echo.
echo Checking parameters:
echo computerToRunOn=!computerToRunOn!
echo userNameToUse=!userNameToUse!
echo passwordToUse=!passwordToUse!
echo domainToUse=!domainToUse!
echo commandToRun=!commandToRun!
echo.

if "!computerToRunOn!" equ "" set /a errorNum=1 && goto :Error
if "!userNameToUse!" equ "" set /a errorNum=2 && goto :Error
if "!passwordToUse!" equ "" set /a errorNum=3 && goto :Error
if "!commandToRun!" equ "" set /a errorNum=4 && goto :Error

EXIT /B


:CHECK_PING
echo.
echo Checking ping to !computerToRunOn!

ping !computerToRunOn! -n 2 | find /i "time"
if !errorlevel! neq 0 set /a errorNum=5 && goto :Error

EXIT /B



:CREATE_SCHEDULED_TASK
echo Creating remote schedule task on !computerToRunOn!

set createOk=FALSE
if /i "!computerToRunOn!" neq "!computername!" (
	schtasks /create /s !computerToRunOn! /u !userNameToUse! /p !passwordToUse! /sc once /st 00:00 /tn !scheduleTaskName! /tr !commandToRun! /f | find /i "SUCCESS" && set createOk=TRUE
	if "!createOk!" equ "FALSE" set /a errorNum=6 && goto :Error
)


EXIT /B


:RUN_SCHEDULED_TASK
echo Running remote schedule task on !computerToRunOn!

set runOk=FALSE
if /i "!computerToRunOn!" neq "!computername!" (
	schtasks /run /s !computerToRunOn! /u !userNameToUse! /p !passwordToUse! /tn !scheduleTaskName! /i | find /i "SUCCESS" && set runOk=TRUE
	if "!runOk!" equ "FALSE" set /a errorNum=7 && goto :Error
) else (
	start cmd /c !commandToRun!
)


EXIT /B



:Error
rem %errorNum% should be defined by now
echo.
echo Error
echo.

if !errorNum! equ 1 echo Param 1=computerToRunOn is empty
if !errorNum! equ 2 echo Param 2=userNameToUse is empty
if !errorNum! equ 3 echo Param 3=passwordToUse is empty
if !errorNum! equ 4 echo Param 4=commandToRun is empty
if !errorNum! equ 5 echo No ping to computer !computerToRunOn!. Check that computer name is correct.
if !errorNum! equ 6 echo Could not create scheduled task on computer !computerToRunOn!. Check your params and that you have permissions. You can also try to run the script again without domain in the userName.
if !errorNum! equ 7 echo Could not run scheduled task on computer !computerToRunOn!. Check your params and that you have permissions. You can also try to run the script again without domain in the userName.

echo.
echo Aborting
echo.
pause
exit


:END







