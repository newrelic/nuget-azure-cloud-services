echo on
PowerShell -ExecutionPolicy Unrestricted .\install.ps1 >> "%TEMP%\StartupLog.txt" 2>&1

EXIT /B %errorlevel%