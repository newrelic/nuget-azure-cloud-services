Function InstallNewrelicAgent()
{
	Write-Host "Begin installing the New Relic .net Agent";

	$NR_INSTALLER_NAME = "NewRelicAgent_x64_5.8.28.0.msi";
	$NR_HOME = "$env:ALLUSERSPROFILE\New Relic\.NET Agent\";

	Write-Host "Installing the New Relic .net Agent";
	If ($env:IsWorkerRole -eq "true")
	{
	    $feedback = (Start-Process -file $NR_INSTALLER_NAME -arg "/qn /lv* `"$env:TEMP\nr_install.log`" NR_LICENSE_KEY=$env:LICENSE_KEY INSTALLLEVEL=50" -PassThru -Wait).ExitCode;
	} 
	else
	{
	    $feedback = (Start-Process -file $NR_INSTALLER_NAME -arg "/qn /lv* `"$env:TEMP\nr_install.log`" NR_LICENSE_KEY=$env:LICENSE_KEY" -PassThru -Wait).ExitCode;
	}

	If (($env:IsWorkerRole -eq "false") -and ($env:EMULATED -eq "false"))
	{
		Write-Host "Restarting IIS and W3SVC to pick up the new environment variables";
		iex "IISRESET";
		iex "NET START W3SVC";
	}

	If ($feedback -eq 0)
	{
	  Write-Host "New Relic .net Agent was installed successfully";
	} 
	else 
	{
	  Write-Host "An error occurred installing the New Relic .net Agent 1. Errorlevel = $env:LASTEXITCODE"

	  $LASTEXITCODE=$lastexitcode;
	}
}

Function InstalNewrelicServer()
{
	Write-Host "Begin installing the New Relic Server Monitor"

	# Current version of the installer
	$NR_INSTALLER_NAME = "NewRelicServerMonitor_x64_3.3.3.0.msi"

	Write-Host "Installing the New Relic Server Monitor";
	$feedback = (Start-Process -file $NR_INSTALLER_NAME -arg "/qn /lv* `"$env:TEMP\nr_server_install.log`" NR_LICENSE_KEY=$env:LICENSE_KEY" -Wait -PassThru).ExitCode;

	If ($feedback -eq 0) 
	{
	  #  The New Relic Server Monitor installed ok and does not need to be installed again.
	  Write-Host "New Relic Server Monitor was installed successfully";

	  iex "NET STOP `"New Relic Server Monitor Service`"";
	  iex "NET START `"New Relic Server Monitor Service`"";
	}
	else
	{
	  #   An error occurred. Log the error to a separate log and exit with the error code.
	  Write-Host "An error occurred installing the New Relic Server Monitor 1. Errorlevel = $feedback";

	  $LASTEXITCODE = $feedback;
	}
}

InstallNewrelicAgent;
InstalNewrelicServer;

exit $LASTEXITCODE;