:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
l=ls --show-control-chars -CFGNhp --color --ignore={"NTUSER.DAT*","ntuser.dat*"} $*
ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
pwsh=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''%CMDER_ROOT%/vendor/profile.ps1'''"



;= rem ===============================================
;= rem     ADDITIONAL ALIASES
;= rem ===============================================
;= rem Custom aliases are now managed in user_profile.cmd
;= rem See: "%CMDER_ROOT%\config\user_profile.cmd"

;= rem Debug alias to verify this file loaded
test-alias=echo Main aliases file loaded successfully

;= rem Add direct access to profile editor
vsc-prof=code "%CMDER_ROOT%\config\user_profile.cmd"

;= rem Copy directory path and .sln filename
copd=cmd /V:ON /C "<nul set /p=!CD!"|clip & echo Current directory path copied to clipboard
cops=@powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir = Get-Location; $sln = Get-ChildItem -Path $dir -Filter '*.sln' | Select-Object -First 1; if($sln){$path = Join-Path $dir $sln.Name; $path | Set-Clipboard; Write-Host \"Copied to clipboard: $path\" -ForegroundColor Green}else{Write-Host \"No .sln file found in current directory\" -ForegroundColor Red}"
