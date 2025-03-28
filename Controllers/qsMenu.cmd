@echo off
setlocal EnableDelayedExpansion

:: If no parameter provided, show the menu
if "%~1"=="" goto ShowMenu
if /i "%~1"=="git" goto ShowGitAliases
if /i "%~1"=="nav" goto ShowNavAliases
if /i "%~1"=="proj" goto ShowProjAliases
if /i "%~1"=="web" goto ShowWebAliases
if /i "%~1"=="util" goto ShowUtilAliases
goto InvalidOption

:ShowMenu
cls
echo.
echo ===========================================
echo             AVAILABLE ALIASES             
echo ===========================================
echo.
echo  1. [git]  - Git Version Control            
echo  2. [nav]  - Navigation Commands            
echo  3. [cust] - View Custom Aliases               
echo  4. [vca] - Add Custom Aliases               
echo.
echo  0. Exit                                    
echo.
echo ===========================================
echo.
echo Enter a number or category name (e.g. "git" or "1"):
set /p choice="> "

:: Process the choice
if "%choice%"=="0" goto Exit
if "%choice%"=="1" call :DisplayAliases git GIT
if "%choice%"=="2" call :DisplayAliases navigation NAVIGATION
if "%choice%"=="3" call :DisplayAliases qstack CUSTOM
if "%choice%"=="4" call :ManageAliases qstack CUSTOM
goto InvalidOption


:ManageAliases
:: Parameters: %1 = category to pass, %2 = display name
cls
echo ===========================================
echo               ADD ALIASES                   
echo ===========================================
echo.
powershell -Command "& 'c:\Program Files\cmder\config\QStackPlugin\Controllers\addCustomAlias.ps1' -Category '%1'"
exit
pause > nul
goto ShowMenu

:DisplayAliases
:: Parameters: %1 = category to pass, %2 = display name
cls
echo ===========================================
echo               %2 ALIASES                   
echo ===========================================
echo.
powershell -Command "& 'c:\Program Files\cmder\config\QStackPlugin\Controllers\showDescriptions.ps1' -Category '%1'"
echo.
echo Press any key to return to the menu...
pause > nul
goto ShowMenu

:InvalidOption
cls
echo.
echo Invalid option selected!
echo.
echo Press any key to return to the menu...
pause > nul
goto ShowMenu

:Exit
endlocal
exit /b