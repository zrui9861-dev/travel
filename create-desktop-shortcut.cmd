@echo off
REM ===========================================================================
REM  Put a "TerraPortal" shortcut on your Desktop.
REM
REM  Double-click this once. After that, the shortcut on the Desktop starts the
REM  app with a single click - it runs start.cmd, which serves this folder on
REM  127.0.0.1 and opens your browser.
REM
REM  The shortcut points at this folder, so keep the folder where it is (or re-run
REM  this file after moving it).
REM ===========================================================================
setlocal
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$here = '%~dp0';" ^
  "$desk = [Environment]::GetFolderPath('Desktop');" ^
  "$lnk = Join-Path $desk 'TerraPortal.lnk';" ^
  "$s = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk);" ^
  "$s.TargetPath = (Join-Path $here 'start.cmd');" ^
  "$s.WorkingDirectory = $here;" ^
  "$s.Description = 'TerraPortal - travel atlas and footprint globe';" ^
  "$s.IconLocation = '%~dp0favicon.ico,0';" ^
  "$s.Save();" ^
  "Write-Host ('  created ' + $lnk)"

if %errorlevel% neq 0 (
    echo   Could not create the shortcut.
    echo   You can also just double-click start.cmd in this folder.
)

echo.
echo   Done. Look for "TerraPortal" on your Desktop.
ping -n 6 127.0.0.1 >nul
