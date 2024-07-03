:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.14
:: Description: download and config npm
:: Usage: npm.bat
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

set download_url=https://nodejs.org/dist/latest/win-x64/node.exe
set install_path=C:\Users\haeer\Desktop\node

msiexec /i https://nodejs.org/dist/latest/node-v21.2.0-x64.msi /quiet /qn /norestart INSTALLDIR="%install_path%"

pause