@echo off
:: WARNING: REGISTRY MODIFICATION AHEAD
:: This batch is to modify the registry. All registry modifications should be
:: done here, one mod in each line, to prevent registry key corruption.

:: External registry file, to combine with the existent.

reg import regkey.reg

:: Enabling Windows Update in unattended mode.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_dWORD /d 1 /f
