@echo off
setLocal EnableDelayedExpansion


rem This script should receive:
rem  1. Command Name to run
rem  2. Computer List text file
set commandNameToRun=%~1
set computerListFile=%~2


rem Change below only if credentials changed, Or application is installed on a different computer:
set userNameToUse=#_USERNAME_TO_USE_#
set passwordToUse=#_PASSWORD_TO_USE_#
set commandsHostingComputerName=#_HOSTING_COMPUTER_#


rem Change below only when files are not in their defined locations:
rem  (if any files are missing an error will be shown)
set workingDir=\\%commandsHostingComputerName%\RemoteScripts
set helpersDir=%workingDir%\Helpers
set runRemoteCommandScript=%helpersDir%\RunRemoteCommand\RunRemoteCommand.bat


set commandToRun=%helpersDir%\DefinedActions\%commandNameToRun%.bat


goto :START


::Main Function::
:START

call :CHECK_PARAMS

call :CHOOSE_COMPUTERS_TO_RUN_ON

call :READ_COMPUTER_LIST_AND_ISSUE_REMOTE_COMMANDS


goto :END




:CHECK_PARAMS
echo.
echo Checking parameters:

echo workingDir=!workingDir!
echo helpersDir=!helpersDir!
echo computerListFile=!computerListFile!
echo commandNameToRun=!commandNameToRun!
echo commandToRun=!commandToRun!
echo.

if not exist "!workingDir!" set /a errorNum=1 && goto :Error
if not exist "!helpersDir!" set /a errorNum=2 && goto :Error
if not exist "!computerListFile!" set /a errorNum=3 && goto :Error
if not exist "!runRemoteCommandScript!" set /a errorNum=4 && goto :Error
if not exist "!commandToRun!" set /a errorNum=5 && goto :Error

echo.
echo Params are ok, Continuing...
echo.
echo.

EXIT /B


:CHOOSE_COMPUTERS_TO_RUN_ON

echo You are about to run remote command:
echo commandToRun=!commandToRun!
echo.
echo on the following computers:
call :PRINT_COMPUTERS

CHOICE /C YN0 /M "Are you sure? (Choose 0 to edit computers list)"

rem chose NO
if !errorlevel! equ 2 (
	goto :END
)

rem chose 0
if !errorlevel! equ 3 (
	cls
	notepad.exe !computerListFile!
	goto :CHOOSE_COMPUTERS_TO_RUN_ON
)


EXIT /B



:PRINT_COMPUTERS
echo.
set /a count=1
for /f "tokens=* delims=" %%p in (!computerListFile!) do (
	set computerNameFromFile=%%p
	echo !count!. !computerNameFromFile!
	set /a count+=1
)
echo.


EXIT /B



:READ_COMPUTER_LIST_AND_ISSUE_REMOTE_COMMANDS
echo Reading computers from: !computerListFile!
echo.

for /f "tokens=* delims=" %%p in (!computerListFile!) do (
	set computerNameFromFile=%%p
	echo !computerNameFromFile!
	start cmd /c !runRemoteCommandScript! "!computerNameFromFile!" "!userNameToUse!" "!passwordToUse!" "!commandToRun!"
)

EXIT /B



:Error
rem %errorNum% should be defined by now
echo.
echo Error
echo.

if !errorNum! equ 1 echo workingDir=!workingDir!  does not exist.
if !errorNum! equ 2 echo helpersDir=!helpersDir!  does not exist
if !errorNum! equ 3 echo computerListFile=!computerListFile!  does not exist
if !errorNum! equ 4 echo runRemoteCommandScript=!runRemoteCommandScript!  does not exist
if !errorNum! equ 5 echo commandToRun=!commandToRun! does not exist

echo.
echo Aborting
echo.
pause





:END

exit
