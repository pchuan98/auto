:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.14
:: Description: some demo code
:: Usage: gitinit.bat
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: error        "%~dp0\colors.bat" 2 0
:: info         "%~dp0\colors.bat" 4 0
:: success      "%~dp0\colors.bat" 3 0

@echo off

IF EXIST .git (
    echo.
    call "%~dp0colors.bat" 2 0 "This folder is already a git repository."
    exit /b 1
)

:: detected the npm enviroment
call npm -v >nul 2>&1
IF ERRORLEVEL 1 (
    echo.
    call "%~dp0colors.bat" 2 0 " npm is not installed. Please download and install it first."
    echo.
    call echo  - https://nodejs.org/en/download
    exit /b 1
)

call npm ls -g --silent commitizen > nul || call "%~dp0colors.bat" 4 0 "Installing commitizen ..." && call npm install --silent -g commitizen
call npm ls -g --silent cz-conventional-changelog > nul || call "%~dp0colors.bat" 4 0 "Installing cz-conventional-changelog ..." && call npm install --silent -g cz-conventional-changelog

echo {"path": "cz-conventional-changelog"} > .czrc
echo .czrc > .gitignore
type "%~dp0templates\ignore\vs" >> .gitignore
type "%~dp0templates\license\mit" >> LICENSE

mkdir src
mkdir docs
mkdir test
mkdir build
mkdir benchmark
mkdir imgs
mkdir .github

type nul > README.md

call git init >nul 2>&1

IF ERRORLEVEL 1 (
    echo.
    call "%~dp0colors.bat" 2 0 "Failed to initialize git repository."
    exit /b 1
)
call "%~dp0colors.bat" 3 0 "Initialized git repository."
