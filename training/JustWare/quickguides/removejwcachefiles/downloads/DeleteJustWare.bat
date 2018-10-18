@echo off
setlocal enabledelayedexpansion
set app=%localappdata%\Apps\2.0
set appdata=%localappdata%\Apps\2.0\Data
set user=%localappdata%\NewDawnTech\JustWare5

::%localappdata%\Apps\2.0
set source=%app%
set sourcemsg=the JustWare Application folder(s) (Apps\2.0)
set next=:userdel
set nextdelete=:deletedirs
goto populateappdirs

:userdel
::%localappdata%\NewDawnTech\JustWare5
set source=%user%
set sourcemsg=the User Settings folder(s) (NewDawnTech)
set next=:doend
set nextdelete=:dodelete
goto dochoice

:dochoice
if exist !source! (
	echo ----------------
	echo Confirm Deletion
	echo ----------------
	CHOICE /M "Do you really want to delete !sourcemsg!" /C YN
	IF ERRORLEVEL 2 (
		echo ...Skipping !source!...
		goto !next!
	)
	IF ERRORLEVEL 1 (
		goto !nextdelete!
	)
) else (
	echo ----------
	echo   Notice
	echo ----------
	echo -- No JustWare settings found in !source!.
	goto !next!
)

:populateappdirs
:: ----------------------------
:: Populate the directory array
:: ----------------------------
:: JustWare directories are 2 nested folders deep into any root app directory
::   Apps/2.0/<blah>/<blah>/<justName>
::   Apps/2.0/Data/<blah>/<blah>/<justName>
:: Notes:
::   ~s Convert names with spaces into short names
::   \NUL is a way to detect if file is a directory
:: ----------------------------
set index=-1

::Apps
for /f %%i in ('dir /b /s "%app%" ^|findstr "just" ') do (
	IF EXIST %%~si\NUL (
		set /a index=!index!+1
 		set directories[!index!]=%%i
 		set lastindex=!index!
	)
)

::AppData
for /f %%i in ('dir /b /s "%appdata%" ^|findstr "just" ') do (
	IF EXIST %%~si\NUL (
		set /a index=!index!+1
 		set directories[!index!]=%%i
 		set lastindex=!index!
	)
)

::If any directories were added, ask for delete
if defined directories[0] (
	goto dochoice
) else (
	echo .
	echo ----------
	echo   Notice
	echo ----------
	echo -- No JustWare installations found in !app!.
  goto !next!
)

:deletedirs
echo .
echo --------------------------------
echo ...Deleting Application Files...
echo --------------------------------
for /L %%f in (0,1,!lastindex!) do (
	IF EXIST !directories[%%f]! (
		echo   ... deleting !directories[%%f]!
  	rmdir !directories[%%f]! /s /q
	)
)
goto !next!

:dodelete
echo .
echo ----------------------------
echo ...Deleting User Settings...
echo ----------------------------
echo   ...deleting !source!...
rmdir !source! /s /q
goto !next!

:doend
echo .
pause