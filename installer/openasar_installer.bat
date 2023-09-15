@echo off
rem This changes variables from %variable% to !variable! to allow for delayed expansion
rem This is required for the for loops to work properly
setlocal enabledelayedexpansion

rem lil animation, can be skipped by pressing any key 3 times
cls
echo.
echo Installer updated by @aaronliu and maintained by @greenman36
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
echo Installer updated by @aaronliu and maintained by @greenman36
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
echo Installer updated by @aaronliu and maintained by @greenman36
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
echo Installer updated by @aaronliu and maintained by @greenman36
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


rem Finds the latest version folder for the selected Discord flavor
set "latestVersion="

for /f "delims=" %%d in ('dir /b /ad /on "%localappdata%\%discordApp%\app-*"') do (
    set "folderName=%%~nxd"
    rem just the version number (without the app- prefix)
    set "version=!folderName:~4!"
    if "!version!" gtr "!latestVersion!" (
        set "latestVersion=!version!"
    )
)

rem If no version folders are found, exit. We can't continue
if not defined latestVersion (
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
echo Installer updated by @aaronliu and maintained by @greenman36
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
rem This is done multiple times because there's multiple client mods that use different file names and we support those
copy /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.backup" > nul 2> nul
if exist "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar" (
    copy /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\_app.asar" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.backup" > nul 2> nul
)
if exist "%localappdata%\%discordApp%\app-%version%\resources\app.asar.orig" (
    copy /y "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.orig" "%localappdata%\%discordApp%\app-%latestVersion%\resources\app.asar.backup" > nul 2> nul
)

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
powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile "%localappdata%\%discordApp%\app-%version%\resources\app.asar"" > nul 2> nul

if exist "%localappdata%\%discordApp%\app-%version%\resources\_app.asar" (
    copy "%localappdata%\%discordApp%\app-%version%\resources\app.asar" "%localappdata%\%discordApp%\app-%version%\resources\_app.asar"
)
if exist "%localappdata%\%discordApp%\app-%version%\resources\app.asar.orig" (
    copy "%localappdata%\%discordApp%\app-%version%\resources\app.asar" "%localappdata%\%discordApp%\app-%version%\resources\app.asar.orig"
)

rem If the download command failed, exit
if errorlevel 1 (
    color 04
    echo Error: Failed to download and replace the asar file.
    echo Please check your internet connection. Also make sure that the Discord client is closed.
    echo.
    color
    pause
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
echo Not installed? Try restarting Discord, running the script again, joining the OpenAsar Discord or contacting @greenman36 on Discord.
echo.
echo Installer updated by @aaronliu and maintained by @greenman36
echo Also check out some of my other projects at [GreenMan36.github.io](https://GreenMan36.github.io)
echo.

echo.
pause
color

exit /b
