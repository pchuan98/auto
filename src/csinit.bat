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

:: detected the npm enviroment
call npm -v >nul 2>&1
IF ERRORLEVEL 1 (
    call "%~dp0colors.bat" 2 0 "[E] Npm is not installed. Please download and install it first. The download url : https://nodejs.org/en/download/"
    exit /b 1
)

call npm ls -g --silent commitizen > nul || call "%~dp0colors.bat" 4 0 "[I] Installing commitizen ..." ^
    && call npm install --silent -g commitizen
call npm ls -g --silent cz-conventional-changelog > nul || call "%~dp0colors.bat" 4 0 "[I] Installing cz-conventional-changelog ..." ^
    && call npm install --silent -g cz-conventional-changelog

: append .czrc for cz-conventional-changelog
IF NOT EXIST .czrc (
    echo {"path": "cz-conventional-changelog"} > .czrc
    call "%~dp0colors.bat" 3 0 "[I] Append .czrc file"
) ELSE (
    call "%~dp0colors.bat" 4 0 "[W] The .czrc file already exists"
)

: append .czrc to .gitignore
IF NOT EXIST .gitignore (
    echo .czrc> .gitignore
    type "%~dp0..\templates\ignore\vs" >> .gitignore
    call "%~dp0colors.bat" 3 0 "[I] .gitignore file created"
) ELSE (
    setlocal Enabledelayedexpansion
        set /p firstLine=<.gitignore
        if "!firstLine!" neq ".czrc" (
            call "%~dp0colors.bat" 4 0 "[W] Append .czrc to .gitignore"
            echo .czrc> temp
            type .gitignore >> temp
            move /y temp .gitignore > nul
        ) ELSE (
            call "%~dp0colors.bat" 4 0 "[W] The .gitignore file already exists"
        )
    endlocal
)

: append LICENSE
IF NOT EXIST LICENSE (
    type "%~dp0..\templates\license\mit" >> LICENSE
    call "%~dp0colors.bat" 3 0 "[I] LICENSE file created"
) ELSE (
    call "%~dp0colors.bat" 4 0 "[W] The LICENSE file already exists"
)

: append nuget.config
IF NOT EXIST nuget.config (
    type "%~dp0..\templates\cs\nuget" >> nuget.config
    call "%~dp0colors.bat" 3 0 "[I] nuget.config file created"
) ELSE (
    call "%~dp0colors.bat" 4 0 "[W] The nuget.config file already exists"
)

: append Directory.Build.props
IF NOT EXIST Directory.Build.props (
    type "%~dp0..\templates\cs\directory" >> Directory.Build.props
    call "%~dp0colors.bat" 3 0 "[I] Directory.Build.props file created"
) ELSE (
    call "%~dp0colors.bat" 4 0 "[W] The Directory.Build.props file already exists"
)

: valid and append
IF NOT EXIST src ( mkdir src && call "%~dp0colors.bat" 3 0 "[I] The src folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The src folder already exists"

IF NOT EXIST docs ( mkdir docs && call "%~dp0colors.bat" 3 0 "[I] The docs folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The docs folder already exists"

IF NOT EXIST test ( mkdir test && call "%~dp0colors.bat" 3 0 "[I] The test folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The test folder already exists"

IF NOT EXIST build ( mkdir build && call "%~dp0colors.bat" 3 0 "[I] The build folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The build folder already exists"

IF NOT EXIST benchmark ( mkdir benchmark && call "%~dp0colors.bat" 3 0 "[I] The benchmark folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The benchmark folder already exists"

IF NOT EXIST imgs ( mkdir imgs && call "%~dp0colors.bat" 3 0 "[I] The imgs folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The imgs folder already exists"

IF NOT EXIST .github ( mkdir .github && call "%~dp0colors.bat" 3 0 "[I] The .github folder created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The .github folder already exists"

IF NOT EXIST README.md ( type nul > README.md && call "%~dp0colors.bat" 3 0 "[I] The README.md file created" ) ^
    ELSE call "%~dp0colors.bat" 4 0 "[W] The README.md file already exists"

IF EXIST .git ( call "%~dp0colors.bat" 4 0 "[W] This folder is already a git repository." ) ELSE (
    call git init >nul 2>&1

    IF ERRORLEVEL 1 (
        echo.
        call "%~dp0colors.bat" 2 0 "[E] Failed to initialize git repository."
        exit /b 1
    )
    call "%~dp0colors.bat" 3 0 "[I] Initialized git repository."
)

call "%~dp0colors.bat" 3 0 "[I] Git repository created successfully."