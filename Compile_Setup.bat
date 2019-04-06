@echo off
setLocal EnableDelayedExpansion
cls

set innoSetupCompile=C:\Program Files (x86)\Inno Setup 5\ISCC.exe
set remoteScriptsInnoSetupScript=%~dp0MainScript\RemoteScripts.iss
set workingDir=%~dp0
set installerOutputDir=%workingDir%Output

if not exist "%innoSetupCompile%" (
	echo Error
	echo InnoSetup compiler does not exist at: 
	echo "%innoSetupCompile%"
	echo.
	echo Aborting...
	pause
	exit 1
)


if not exist "%remoteScriptsInnoSetupScript%" (
	echo Error
	echo Remote Script Inno-Setup script does not exist at: 
	echo "%remoteScriptsInnoSetupScript%"
	echo.
	echo Aborting...
	pause
	exit 1
)

echo.
echo Going to compile RemoteScriptsDavid installer.
echo When compiling is done, output installer file will be available at:
echo.
echo  %installerOutputDir%
echo.
CHOICE /C YN /M "Do you want to continue?"

rem 1 = Y
rem 2 = N
if %errorlevel% equ 2 exit 0


echo Compiling RemoteScriptsDavid installer
echo.

ping 127.0.0.1 -n 1 > nul

"%innoSetupCompile%" "%remoteScriptsInnoSetupScript%" /DCMD_PARAM_SRC_COMPILE_DIR="%workingDir%" /DCMD_PARAM_COMPILED_INSTALLATION_FILE_OUTPUT_DIR="%installerOutputDir%"

echo.

if %errorlevel% gtr 0 (
	echo Error
	echo InnoSetup compilation error. See output.
	echo.
	pause
	exit 1
)

echo Compilation is successful
echo.

if exist "%installerOutputDir%\RemoteScriptsDavid_Install.exe" (
	CHOICE /C YN /M "Do you want to run the compiled setup file now?"
	rem 1 = Y
	rem 2 = N
	if !errorlevel! equ 1 (
		start /D "%installerOutputDir%" RemoteScriptsDavid_Install.exe
	)

) else (
	pause
)

exit 0




