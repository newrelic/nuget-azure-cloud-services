REM Update this variable to the current installer name.
SET NR_INSTALLER_NAME=NewRelicAgent_x64_2.1.0.5.msi

REM Update with your license key
SET LICENSE_KEY=REPLACE_WITH_LICENSE_KEY

SETLOCAL EnableExtensions

if defined NEWRELIC_HOME GOTO NR_ALREADY_INSTALLED
if defined COR_ENABLE_PROFILING GOTO PROFILER_ALREADY_ENABLED
if NOT exist %NR_INSTALLER_NAME% GOTO MISSING_INSTALLER
    
REM Run the agent installer
%NR_INSTALLER_NAME% /quiet NR_LICENSE_KEY=%LICENSE_KEY% >> d:\nr.log

REM Get the NEWRELIC_HOME environment variable value and set it in NR_HOME
FOR /F "skip=2 tokens=3*" %%A IN ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NEWRELIC_HOME 2^>nul') DO SET NR_HOME="%%A %%B"

REM Uncomment the line below if you want to copy a custom newrelic.xml file into your instance
REM copy /Y newrelic.xml %NR_HOME% >> d:\nr.log

REM Uncomment the line below to copy custom instrumentation into the agent directory.
REM copy /y CustomInstrumentation.xml %NR_HOME%\extensions >> d:\nr.log

REM Uncomment the line below to get instrumentation for worker roles and / or not IIS based .net applications
REM SETX COR_ENABLE_PROFILING 1 /M

REM Restart the instance.  The worker process will be instrumented the next time it starts. if emulated then this step will not run
if "%EMULATED%"=="true" goto :EOF
SHUTDOWN /r /c "Reboot after installing the New Relic .NET Agent" /t 0

GOTO END

:MISSING_INSTALLER
ECHO Unable to find %NR_INSTALLER_NAME% >> d:\nr.log
GOTO END

:PROFILER_ALREADY_ENABLED
ECHO A profiler is already enabled.  Skipping the New Relic Agent installation. >> d:\nr.log
GOTO END

:NR_ALREADY_INSTALLED
ECHO NEWRELIC_HOME is already defined.  Skipping the New Relic Agent installation. >> d:\nr.log
GOTO END

:END