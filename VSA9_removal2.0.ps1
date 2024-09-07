$FilePath = "C:\Program Files (x86)\Kaseya"

# Check if the Kaseya folder exists
if (Test-Path -Path $FilePath -PathType Container) {
    # Get the name of the Kaseya VSA agent folder
    $VSA9Agent = Get-ChildItem -Path $FilePath -Directory | Select-Object -ExpandProperty Name -First 1
    

    if ($VSA9Agent) {
        # Stop the Kaseya VSA agent process if it is running
        $processName = "NewAgentMon"
        $runningProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue
        
        if ($runningProcess) {
            Stop-Process -Name $processName -Force
            Write-Host "Stopped the '$processName' process."
        }
        
        # Start the uninstallation process
        $uninstallPath = Join-Path -Path $FilePath -ChildPath "$VSA9Agent\KASetup.exe"
        $uninstallArguments = "/r /s /g $VSA9Agent /l"
        
        if (Test-Path -Path $uninstallPath -PathType Leaf) {
            Start-Process -FilePath $uninstallPath -ArgumentList $uninstallArguments -Wait
            Write-Host "Uninstallation process has completed for '$VSA9Agent'."
        } else {
            Write-Host "Uninstallation path '$uninstallPath' does not exist or is not a file."
        }
        
        # Remove the Kaseya folder
        Remove-Item -Path $FilePath -Recurse -Force
        Write-Host "Removed the Kaseya folder."
    } else {
        Write-Host "No Kaseya VSA agent folder found in '$FilePath'."
    }
} else {
    Write-Host "Kaseya folder does not exist in '$FilePath'."
}
