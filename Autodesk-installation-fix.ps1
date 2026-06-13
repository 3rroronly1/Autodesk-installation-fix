param(
    [switch]$RunInstaller
)

$ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
$blockedExes = @(
    "DownloadManager.exe", "ProcessManager.exe", "install_manager.exe",
    "install_helper_tool.exe", "LogAnalyzer.exe", "AdskAccessCore.exe",
    "AdskAccessDialogUtility.exe", "AdskAccessService.exe", "AdskAccessServiceHost.exe",
    "AdskIdentityManager.exe", "AdskInstallerUpdateCheck.exe", "AdskUpdateCheck.exe",
    "AdSSO.exe", "Autodesk Access UI Host.exe", "AcEventSync.exe", "AcQMod.exe",
    "ADPClientService.exe", "AdpSDKUtil.exe", "GenuineService.exe"
)

$removed = 0
foreach ($exe in $blockedExes) {
    $keyPath = "$ifeoPath\$exe"
    if (Test-Path $keyPath) {
        try {
            Remove-Item -Path $keyPath -Force -ErrorAction Stop
            Write-Host "Removed block: $exe"
            $removed++
        } catch {
            Write-Warning "Could not remove $exe - run as Administrator"
        }
    }
}

if ($removed -eq 0) {
    Write-Host "No blocks found or already fixed."
}

if ($RunInstaller) {
    $setupPath = Join-Path $PSScriptRoot "Setup.exe"
    if (Test-Path $setupPath) {
        Write-Host "Launching AutoCAD Setup.exe..."
        Start-Process -FilePath $setupPath -Wait
    } else {
        Write-Error "Setup.exe not found in $PSScriptRoot"
    }
}
