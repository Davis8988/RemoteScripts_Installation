@echo off

rem Change below only if credentials changed, Or application is installed on a different computer:
set commandsHostingComputerName=#_HOSTING_COMPUTER_#

set workingDir=\\%commandsHostingComputerName%\RemoteScripts
set staticComputerListRunScript=%workingDir%\Helpers\StaticAndDynamicScripts\Static_RunRemoteTaskOnComputerList.bat

rem Variables to be changed by the setup:
set commandToRunName=#_COMMAND_TO_RUN_NAME_#
set computerListToRunOn=%workingDir%\Helpers\ComputerLists\Static\#_COMPUTER_LIST_TO_RUN_ON_PLACE_HOLDER_#

rem Check if running remote command script exists:
if not exist "%staticComputerListRunScript%" (
	echo Error && echo.
	echo Static Computer List Run Script doesn't exist at:
	echo %staticComputerListRunScript% && echo.
	echo Aborting... && echo.
	pause
	exit 1
)

rem Run remote command:
call "%staticComputerListRunScript%" "%commandToRunName%" "%computerListToRunOn%"