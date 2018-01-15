@echo off
:: Este batch sirve para automatizar la instalación de programas en los equipos de
:: GrupoBC. Estoy con esto pensando en no tener que repetir los mismos pasos cada
:: vez que tenga que preparar un equipo.


:: Detectamos primero la arquitectura del equipo.
echo Comenzando puesta a punto del equipo.
cd C:\script\System
cmd /c call SOdetector.bat

echo Hecho.
:: AVISO: AQUÍ SE ESTÁ MODIFICANDO EL REGISTRO
:: Aquí hay que dar privilegios al script para que cargue el registro.
runas /user:Usuario registry.bat
del registry.bat
echo Terminada modificación del registro.

:: Cambio de privilegios: el administrador será otra cuenta.
echo Generando administrador.
cmd /c call admin.bat
del admin.bat
cd C:\script

del System /F /Q

echo Empezamos asegurando el equipo. Antivirus.
echo Tenemos que instalar y activar.
cd C:\script\Kaspersky10
C:\script\Kaspersky10\setup.exe /pEULA=1 /pKSN=0 /pALLOWREBOOT=0 /s
echo Antivirus instalado y activado. Comprueba que la activación es correcta.
cd C:\script
del Kaspersky10 /F /Q
echo.

:: Acrobat Reader
echo Vamos a leer PDFs, por si hace falta algún manual.
cmd /c msiexec /i C:\script\Reader\AcroRead.msi transforms=AcroRead.mst /quiet /norestart
del Reader /F /Q
echo Hecho.

:: LibreOffice
echo Instala LibreOffice, para poder trabajar y hacer documentacion.
cmd /c msiexec /i C:\script\LibreOffice.msi /quiet /norestart ALLUSERS=1 CREATEDESKTOPLINK=0 REGISTER_ALL_MSO_TYPES=0 REGISTER_NO_MSO_TYPES=1 ISCHECKFORPRODUCTUPDATES=1 QUICKSTART=0 ADDLOCAL=ALL UI_LANGS=es_ES
del LibreOffice.msi

:: Compresores
cd Compresores
echo Intentamos descomprimir, pero nos falta 7z.
C:\script\7z-x64.exe /S

:: Navegadores web.
echo Instalando Firefox, versión de 64 bit.
start /wait C:\script\Firefox64.exe /silent /install
echo Ahora, Chrome.
start /wait C:\script\Chrome_Setup.exe /silent /install
echo Listo. Cogerán la configuración que hemos metido en registro.
echo.

:: Pasamos a Java.
echo Navegar en internet puede pedir contenido multimedia. Vamos con Java.
start /wait C:\script\jre-win-x64.exe install_silent=1 auto_update=1 nostartmenu=1 removeoutofdatejres=1


echo Estamos acabando de instalar. Puede no ser necesario, pero ahí va Citrix.
cmd /c CitrixReceiver.exe /silent /enableprelaunch=false
del CitrixReceiver.exe
echo Tenemos para conexión segura.
echo.

echo Puede que sea necesario hacer alguna cosa en remoto. Arreglemos eso.
mkdir "C:\Users\%username%\Desktop\TeamViewer"
xcopy C:\script\TeamViewer "C:\Users\%username%\Desktop\TeamViewer" /Y /Q /Z
del TeamViewer /F /Q
echo Recuerda que el programa es TeamViewer 10 portable.
echo.

:: Cambio de privilegios: el administrador será otra cuenta.
echo Revocando privilegios al usuario.
net localgroup Usuarios "Usuario" /add
net localgroup Administradores "Usuario" /delete

echo El equipo está preparado para despliegue.
echo Como medida de prevención, se reiniciará para asegurar
echo que todos los programas se han instalado correctamente.
echo El ordenador se reiniciará en 30 segundos.
echo Por favor, cierra cualquier programa que haya podido quedar abierto.
timeout 30
shutdown -r -f -t 00