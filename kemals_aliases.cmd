:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

@echo off
:: ===============================================
:: Navigation aliases for quick directory access
:: ===============================================

:: Template Client Configurations
doskey cd-platqat=cd "%%platqat_dir%%"
doskey cd-wh=cd "%%wh_dir%%"
doskey cd-gsk=cd "%%gsk_dir%%"
doskey cd-bmo=cd "%%bmo_dir%%"
doskey cd-btw=cd "%%btw_dir%%"
doskey cd-dfs=cd "%%dfs_dir%%"
doskey cd-dlg=cd "%%dlg_dir%%"
doskey cd-hal=cd "%%hal_dir%%"
doskey cd-svb=cd "%%svb_dir%%"

:: Hosted Client Configurations
doskey cd-swb=cd "%%schwab_dir%%"
doskey cd-rabo=cd "%%rabo_dir%%"
doskey cd-rabosb=cd "%%rabosb_dir%%"
doskey cd-platqa=cd "%%platqa_dir%%"

:: FIWeb
doskey cd-fiw=cd "C:\SBSDEV\fiweb\SBS.Platform.fi-web"
doskey cd-fiwt=cd "C:\SBSDEV\fiweb\template"

:: Other Projects
doskey cd-vb=cd "%%other_dir%%\vipbackend"
doskey cd-bc=cd "%%other_dir%%\blockconnect\SBS.Platform.blockconnect"
doskey cd-fit=cd "%%other_dir%%\fi-tooling"
doskey cd-sps=cd "%%other_dir%%\spweb"
doskey cd-magic=cd "%%other_dir%%\magicSpells\MagicSpells"
doskey cd-qa=cd "C:\SBSDEV\QA\UITestFramework\SBS.Platform.UITestFramework"

:: Personal Workspaces
doskey cd-als=cd "C:\Program Files\cmder\config\QStackPlugin"
doskey cd-scraps=cd "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main"
doskey cd-ajla=cd "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Ajla"
doskey cd-jr=cd "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Journals"


:: List all navigation aliases
doskey list_cd=for /f "tokens=1 delims==" %%i in ('doskey /macros ^| findstr "^cd-" ^| sort') do @echo %%i

:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

@echo off
:: ===============================================
:: Project aliases for opening solutions
:: ===============================================

:: Hosted Client Configurations
doskey st-swb=start "" "%%schwab_dir%%\SchwabClientConfiguration.sln"
doskey st-rabo=start "" "%%rabo_dir%%\RaboClientConfiguration.sln"
doskey st-rabosb=start "" "%%rabosb_dir%%\Rabo_SBClientConfiguration.sln"
doskey st-platqa=start "" "%%platqa_dir%%\SBS.Platform.platqa-client-configuration.sln"

:: Template Client Configurations
doskey st-platqat=start "" "%%platqat_dir%%\PlatQATemplateClientConfiguration.sln"
doskey st-wh=start "" "%%wh_dir%%\WhClientConfiguration.sln"
doskey st-gsk=start "" "%%gsk_dir%%\GskClientConfiguration.sln"
doskey st-bmo=start "" "%%bmo_dir%%\BmoClientConfiguration.sln"
doskey st-btw=start "" "%%btw_dir%%\BTWClientConfiguration.sln"
doskey st-dfs=start "" "%%dfs_dir%%\DfsClientConfiguration.sln"
doskey st-dlg=start "" "%%dlg_dir%%\DlgClientConfiguration.sln"
doskey st-hal=start "" "%%hal_dir%%\HALClientConfiguration.sln"
doskey st-svb=start "" "%%svb_dir%%\SvbClientConfiguration.sln"

:: FIWeb
doskey st-fiw=start "" "C:\SBSDEV\fiweb\SBS.Platform.fi-web\FiWeb.sln"
doskey st-fiwt=start "" "C:\SBSDEV\fiweb\template\SAFEWorkflow.sln"

:: Other Projects
doskey st-vb=start "" "%%other_dir%%\vipbackend\VipBackend.sln"
doskey st-bc=start "" "%%other_dir%%\blockconnect\SBS.Platform.blockconnect\BlockConnect.sln"
doskey st-fit=start "" "%%other_dir%%\fi-tooling\fi-tooling.sln"
doskey st-sps=start "" "%%other_dir%%\spweb\Source\SafeProcess.sln" 
doskey st-cisco=start "" "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe"

:: Open in VS Code
doskey scraps=code "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main"
doskey ajla=code "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Ajla"
doskey journal=code "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Journals"
doskey jrnl=start "" "C:\Users\sekick\AppData\Local\Programs\Obsidian\Obsidian.exe"
doskey magic=code "%%other_dir%%\magicSpells\MagicSpells"
doskey vsc-vars=code "C:\Program Files\cmder\config\user_profile.cmd"

:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

@echo off
:: ===============================================
:: Utility aliases for common tasks
:: ===============================================

:: PowerShell utilities
doskey pwsh=%%SystemRoot%%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''%%CMDER_ROOT%%/vendor/profile.ps1''"
doskey checkdb=powershell -ExecutionPolicy Bypass -File "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Scraps\QStack\PowerShell\checkDB.ps1"
doskey copylicense=powershell -ExecutionPolicy Bypass -File "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\Scraps\QStack\PowerShell\FIW_License\fiwLicenseTransfer.ps1"
doskey qg=@powershell -NoProfile -ExecutionPolicy Bypass -NoLogo -File "C:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\CMDERFiles\quickGrab\quickGrab.ps1" $*

:: Build Commands
doskey br=build runtests
doskey bb=build build

:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

@echo off
:: ===============================================
:: Web-related aliases (GitHub, Jira, etc.)
:: ===============================================

:: GitHub - Template Client Configurations
doskey gh-pqat=start "" "%%ghBaseUrl%%/SBS.Platform.platqa-client-configuration"
doskey gh-gsk=start "" "%%ghBaseUrl%%/SBS.Implementation.gsk-client-configuration"
doskey gh-bmo=start "" "%%ghBaseUrl%%/SBS.Platform.bmo-client-configuration"
doskey gh-btw=start "" "%%ghBaseUrl%%/SBS.Platform.btw-client-configuration"
doskey gh-dfs=start "" "%%ghBaseUrl%%/SBS.Platform.dfs-client-configuration"
doskey gh-dlg=start "" "%%ghBaseUrl%%/SBS.Platform.dlg-client-configuration"
doskey gh-hal=start "" "%%ghBaseUrl%%/SBS.Platform.hal-client-configuration"
doskey gh-svb=start "" "%%ghBaseUrl%%/SBS.Platform.svb-client-configuration"
doskey gh-wh=start "" "%%ghBaseUrl%%/SBS.Platform.wh-client-configuration"

:: GitHub - Hosted Client Configurations
doskey gh-swb=start "" "%%ghBaseUrl%%/SBS.Implementation.schwab-client-configuration"
doskey gh-rabo=start "" "%%ghBaseUrl%%/SBS.Platform.rabo-client-configuration"
doskey gh-rabosb=start "" "%%ghBaseUrl%%/SBS.Platform.rabo_sb-client-configuration"
doskey gh-platqa=start "" "%%ghBaseUrl%%/SBS.Platform.platqa-client-configuration"

:: Project GitHub Links
doskey gh-vb=start "" "%%ghBaseUrl%%/SBS.Platform.vipbackend"
doskey gh-vbt=start "" "%%ghBaseUrl%%/SBS.Platform.vipbackend/tree/fi-template-develop"
doskey gh-bc=start "" "%%ghBaseUrl%%/SBS.Platform.blockconnect"
doskey gh-fit=start "" "%%ghBaseUrl%%/SBS.Platform.fi-tooling"

:: Atlassian Jira and Confluence
doskey jira=start "" "%%jiraBaseUrl%%=11011&selectedIssue=FCCFI-2222&quickFilter=54651"
doskey prs=start "" "%%jiraBaseUrl%%=11011&quickFilter=60497#"
doskey templateRelease=start "" "%%confluenceBaseUrl%%/Template+Q4+2024+-+Official+Release"
doskey nGRelease=start "" "%%confluenceBaseUrl%%/NextGen+Official"
doskey aws=start "" "%%confluenceBaseUrl%%/FPK+Testing+Environment+Silos"