:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

:: use this file to run your own startup commands
:: use in front of the command to prevent printing the command

:: uncomment this to have the ssh agent load when cmder starts
:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-agent.cmd" /k exit

:: uncomment the next two lines to use pageant as the ssh authentication agent
:: SET SSH_AUTH_SOCK=/tmp/.ssh-pageant-auth-sock
:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-pageant.cmd"

:: you can add your plugins to the cmder path like so
:: set "PATH=%CMDER_ROOT%\vendor\whatever;%PATH%"

:: arguments in this batch are passed from init.bat, you can quickly parse them like so:
:: more usage can be seen by typing "cexec /?"

:: %ccall% "/customOption" "command/program"

:: ==============================================================================================
::                                     Custom Variables
::                                Used by separated alias cmd files
:: ==============================================================================================

:: ===============================================
::                  URL Variables
:: ===============================================
@echo off

:: ===============================================
::              Load custom aliases
:: ===============================================

:: Call the custom loading screen if it exists
powershell -File "%CMDER_ROOT%\config\QStackPlugin\Controllers\loadAliases.ps1"

:: Define management aliases
doskey vsc-als=code "%CMDER_ROOT%\config\user_aliases.cmd"
doskey vsc-prof=code "%CMDER_ROOT%\config\user_profile.cmd"
doskey edit-git=code "%CMDER_ROOT%\config\QStackPlugin\git_aliases.cmd"
doskey edit-nav=code "%CMDER_ROOT%\config\QStackPlugin\navigation_aliases.cmd"
doskey cd-myals=cd "%CMDER_ROOT%\config\QStackPlugin"
doskey edit-load=code "%CMDER_ROOT%\config\QStackPlugin\qStackLoading.cmd"
doskey show-als="%CMDER_ROOT%\config\QStackPlugin\Controllers\qsMenu.cmd" $*
doskey crawl=powershell -File "%CMDER_ROOT%\config\QStackPlugin\Controllers\crawl.ps1" -RootDirectory $1
doskey fd=powershell -File "%CMDER_ROOT%\config\QStackPlugin\Controllers\findDups.ps1" -DirectoryPath $1
@REM doskey transfer=powershell -File "%CMDER_ROOT%\config\QStackPlugin\Controllers\transferFilesToRepo.ps1"

echo.



:: ===============================================
::              Color Guide
:: ===============================================
::    0 = Black       8 = Gray
::    1 = Blue        9 = Light Blue
::    2 = Green       A = Light Green
::    3 = Aqua        B = Light Aqua
::    4 = Red         C = Light Red
::    5 = Purple      D = Light Purple
::    6 = Yellow      E = Light Yellow
::    7 = White       F = Bright White