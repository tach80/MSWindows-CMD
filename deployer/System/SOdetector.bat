@echo off
:: WARNING: POTENTIALLY BROKEN, but unharmful.
:: This tiny script is used to detect machine SO, and its compilation.
:: The idea is to run it in the beginning, to know which versions the 
:: main has to install.

:: Part one: SO version.
echo Checking operative system.
for /F "tokens=4*" %%a in ('ver') do set "version=%%a"
set kernel=%version:~0,1%
set SO=%version:~0,8%
if %kernel%==1 (
set kernel=%version:~0,2%
set SO=%version:~0,9%
)
if %SO%==6.0.6000	(set SO2=Windows Vista RTM& set SO=VistaSP0)
if %SO%==6.0.6001	(set SO2=Windows Vista Service Pack 1& set SO=VistaSP1)
if %SO%==6.0.6002	(set SO2=Windows Vista Service Pack 2& set SO=VistaSP2)
if %SO%==6.1.7600	(set SO2=Windows 7 RTM& set SO=W7SP0)
if %SO%==6.1.7601	(set SO2=Windows 7 Service Pack 1& set SO=W7SP1)
if %SO%==6.2.9200	(set SO2=Windows 8 RTM& set SO=W8SP0)
if %SO%==6.3.9600	(set SO2=Windows 8.1 RTM& set SO=W81SP0)
if %SO%==10.0.10240	(set SO2=Windows 10 TH1& set SO=W10TH1)
if %SO%==10.0.1058	(set SO2=Windows 10 TH2& set SO=W10TH2)
:: Part two: systems architecture.
for /f %%a in ('wmic os get osarchitecture^|find /i "bit"') do set "bits=%%a"

:: Part three: display all in screen.
echo Your operative system flavour is %SO2%, and its version is %bits% bits.
echo Programs will be installed accordingly to your flavour and version.

timeout 15
