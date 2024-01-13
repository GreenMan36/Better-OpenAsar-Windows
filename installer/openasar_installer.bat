@echo off
rem This changes variables from %variable% to !variable! to allow for delayed expansion
rem This is required for the for loops to work properly
setlocal enabledelayedexpansion

rem lil animation, can be skipped by pressing any key 3 times
cls
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo.
echo ####  ###  #### #   #      ##  ####  ##  ###  
echo #  #  #  # #    ##  #     #  # #    #  # #  # 
echo #  #  ###  #### # # #     #### #### #### ###  
echo #  #  #    #    #  ##     #  #    # #  # #  # 
echo ####  #    #### #   #  #  #  # #### #  # #  # 
echo.
C:\Windows\System32\TIMEOUT.exe /t 1 > nul 2> nul
cls
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo.
echo ====  ===  ==== =   =      ==  ====  ==  ===  
echo =  =  =  = =    ==  =     =  = =    =  = =  = 
echo =  =  ===  ==== = = =     ==== ==== ==== ===  
echo =  =  =    =    =  ==     =  =    = =  = =  = 
echo ====  =    ==== =   =  =  =  = ==== =  = =  = 
echo.
C:\Windows\System32\TIMEOUT.exe /t 1 > nul 2> nul
cls
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo.
echo ....  ...  .... .   .      ..  ....  ..  ...  
echo .  .  .  . .    ..  .     .  . .    .  . .  . 
echo .  .  ...  .... . . .     .... .... .... ...  
echo .  .  .    .    .  ..     .  .    . .  . .  . 
echo ....  .    .... .   .  .  .  . .... .  . .  . 
echo.
C:\Windows\System32\TIMEOUT.exe /t 1 > nul 2> nul
cls

rem Discord flavor selection menu
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo.
echo Select Discord version:
echo 1. Discord Stable (Default Client)
echo 2. Discord PTB
echo 3. Discord Canary
echo.
set /p "selection=Enter the number corresponding to your selection: "
echo.

if "%selection%"=="1" (
    set "discordApp=Discord"
) else if "%selection%"=="2" (
    set "discordApp=DiscordPTB"
) else if "%selection%"=="3" (
    set "discordApp=DiscordCanary"
) else if "%selection%"=="" (
    echo No input detected. Defaulting to Discord Stable.
    set "discordApp=Discord"
) else (
	color 04
    echo Invalid selection. Please try again.
    color
    pause
    exit /b
)


rem Finds the latest major, minor, and patch version numbers for the selected Discord flavor
set "latestMajor=0"
set "latestMinor=0"
set "latestPatch=0"

for /f "delims=" %%d in ('dir /b /ad /on "%localappdata%\%discordApp%\app-*"') do (
    set "folderName=%%~nxd"
    rem Split the version number into major, minor, and patch
    for /f "tokens=1-3 delims=.-" %%a in ("!folderName:~4!") do (
        set /a "major=%%a"
        set /a "minor=%%b"
        set /a "patch=%%c"
        rem Compare numerically
        if !major! gtr !latestMajor! (
            set "latestMajor=!major!"
            set "latestMinor=!minor!"
            set "latestPatch=!patch!"
        ) else if !major! equ !latestMajor! (
            if !minor! gtr !latestMinor! (
                set "latestMinor=!minor!"
                set "latestPatch=!patch!"
            ) else if !minor! equ !latestMinor! (
                if !patch! gtr !latestPatch! (
                    set "latestPatch=!patch!"
                )
            )
        )
    )
)

rem Construct the latest version string
set "latestVersion=!latestMajor!.!latestMinor!.!latestPatch!"

rem If no version folders are found, exit. We can't continue
if "!latestVersion!"=="0.0.0" (
    color 04
    echo No version folders found.
    color
    pause
    exit /b
)

echo Closing Discord... (wait around 3 seconds)
echo.

rem Kills Discord multiple times to make sure it's closed
for /l %%i in (1,1,3) do (
    C:\Windows\System32\TASKKILL.exe /f /im %discordApp%.exe > nul 2> nul
)

rem Waits 3 seconds to make sure Discord is fully closed
C:\Windows\System32\TIMEOUT.exe /t 3 /nobreak > nul 2> nul
cls

rem Let the user make sure all info is correct before continuing
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo.
echo Confirm the following information before continuing.
echo.
echo Version: %discordApp%
echo App version: %latestVersion%
echo Full path: %localappdata%\%discordApp%\app-%latestVersion%\resources\
echo.
pause

echo Installing OpenAsar... (ignore any flashes, this is a download progress bar)
echo.
echo 1. Backing up original app.asar to app.asar.backup
rem Popular client mods use these files as the asar to read discord from
if exist "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar" (
    echo Detected Vencord installation, installing to _app.asar instead.
    move /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar" "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar.backup" >nul
) else ( if exist "%localappdata%\%discordApp%\app-%version%\resources\app.orig.asar" (
    echo Detected Replugged installation, installing to app.orig.asar instead.
    move /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.orig.asar" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.orig.asar.backup" >nul
) else (
    rem No mod known
    move /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.backup" >nul
))

rem If the copy command failed, exit
if errorlevel 1 (
    color 04
    echo Error: Failed to copy the file.
    echo Please check the file paths and try again.
    echo.
    color
    pause
    exit
)

rem Download OpenAsar, change the color so the download bar blends in
color 36
echo 2. Downloading OpenAsar
if exist "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar.backup" (
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar"" >nul
) else ( if exist "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.orig.asar.backup" (
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.orig.asar"" >nul
) else (
    rem No mod known
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar"" >nul
))

rem Check if the download command failed
if not %errorlevel%==0 (
    color 04
    echo Error: Failed to download and replace the asar file.
    echo Attempting to restore backup...
    move /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.backup" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar" >nul

    if not %errorlevel%==0 (
        echo Error: Failed to restore the backup. Check %localappdata%\%discordApp%\app-%latestVersion%\resources\ and make sure to restore the .backup file to .asar for Discord to be able to launch again.
        pause
    ) else (
        echo Backup restored successfully. Discord was not modded but should be able to be launched.
    )
    exit
)

rem Change the color to indicate success and start Discord
cls
color 02
echo.
echo Opening Discord...
start "" "%localappdata%\%discordApp%\Update.exe" --processStart %discordApp%.exe > nul 2> nul

C:\Windows\System32\TIMEOUT.exe /t 1 /nobreak > nul 2> nul

echo.
echo.
echo OpenAsar should be installed! You can check by looking for an "OpenAsar" option in your Discord settings.
echo Not installed? Try restarting Discord, running the script again, joining the OpenAsar Discord or contacting @GreenMan36 on Discord.
echo.
echo Installer updated by @aaronliu and maintained by @GreenMan36
echo Also check out some of my other projects at https://GreenMan36.github.io
echo.

echo.
pause
color

exit /b
