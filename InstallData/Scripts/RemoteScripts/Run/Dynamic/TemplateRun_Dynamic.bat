@echo off

rem Change below only if credentials changed, Or application is installed on a different computer:
set commandsHostingComputerName=#_HOSTING_COMPUTER_#

set workingDir=\\%commandsHostingComputerName%\RemoteScripts
set dynamicComputerListRunScript=%workingDir%\Helpers\StaticAndDynamicScripts\Dynamic_RunRemoteTaskOnComputerList.bat

rem Variables to be changed by the setup:
set commandToRunName=#_COMMAND_TO_RUN_NAME_#
set computerListToRunOn=%workingDir%\Helpers\ComputerLists\Dynamic\#_COMPUTER_LIST_TO_RUN_ON_PLACE_HOLDER_#

rem Check if running remote command script exists:
if not exist "%dynamicComputerListRunScript%" (
	echo Error && echo.
	echo Dynamic Computer List Run Script doesn't exist at:
	echo %dynamicComputerListRunScript% && echo.
	echo Aborting... && echo.
	pause
	exit 1
)

rem Run remote command:
call "%dynamicComputerListRunScript%" "%commandToRunName%" "%computerListToRunOn%"