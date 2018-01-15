@echo off
:: This script is to automate program installations on computers. It's to not repeat
:: every time I have to prepare a computer the same steps.


:: Firstly, check on OS of the computer.
echo Beginning system preparations.
cd C:\script\System
cmd /c call SOdetector.bat

echo Done.
:: WARNING: REGISTRY MODIFICATIONS HERE
:: The script MUST be run on priviliged terminal.
runas /user:User registry.bat
del registry.bat
echo Registry modificatiosn finished.

:: Creating and providing privileges on administrator account, which is not "User".
echo Creating administrator account.
cmd /c call admin.bat
del admin.bat
cd C:\script

del System /F /Q

echo First thing first. Antivirus.
echo I have to install and activate it.
cd C:\script\Kaspersky10
C:\script\Kaspersky10\setup.exe /pEULA=1 /pKSN=0 /pALLOWREBOOT=0 /s
echo Antivirus installed and activated. Please check manually that activation is correct.
cd C:\script
del Kaspersky10 /F /Q
echo.

:: Acrobat Reader
echo Let's read PDFs, just in case you need a manual.
cmd /c msiexec /i C:\script\Reader\AcroRead.msi transforms=AcroRead.mst /quiet /norestart
del Reader /F /Q
echo Done.

:: LibreOffice
echo Installing LibreOffice, to work and make documentation.
cmd /c msiexec /i C:\script\LibreOffice.msi /quiet /norestart ALLUSERS=1 CREATEDESKTOPLINK=0 REGISTER_ALL_MSO_TYPES=0 REGISTER_NO_MSO_TYPES=1 ISCHECKFORPRODUCTUPDATES=1 QUICKSTART=0 ADDLOCAL=ALL UI_LANGS=es_ES
del LibreOffice.msi

:: Compressors
echo We need a compressor to see some files. 7z will do the job.
C:\script\7z-x64.exe /S

:: Web surfers.
echo Installing Firefox, 64-bit version.
start /wait C:\script\Firefox64.exe /silent /install
echo Installing Chrome now.
start /wait C:\script\Chrome_Setup.exe /silent /install
echo Done. They'll take configuration from registry.
echo.

:: Java.
echo Web-surfing may require multimedia content. Let's install Java.
start /wait C:\script\jre-win-x64.exe install_silent=1 auto_update=1 nostartmenu=1 removeoutofdatejres=1

:: Citrix
echo We are about to finish. It may not be needed, but here is Citrix Receiver.
cmd /c CitrixReceiver.exe /silent /enableprelaunch=false
del CitrixReceiver.exe
echo.

:: TeamViewer
echo It may be useful to connect remotely. Let's use TeamViewer.
mkdir "C:\Users\%username%\Desktop\TeamViewer"
xcopy C:\script\TeamViewer "C:\Users\%username%\Desktop\TeamViewer" /Y /Q /Z
del TeamViewer /F /Q
echo Just remember we are using TeamViewer 10 portable.
echo.

:: Changing privileges: admin account won't be this one.
echo Revocking user privileges.
net localgroup Users "User" /add
net localgroup Administradores "User" /delete

echo Computer ready to deploy.
echo As a prevention measure, it will be rebooted to ensure
echo all programs are installed correctly.
echo Computer will reboot in 30 seconds. Please, save your progress
echo to prevent data lose.
shutdown -r -f -t 30
timeout 30
