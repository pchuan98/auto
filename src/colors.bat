:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.14
:: Description: ANSI color codes
:: Usage: colors.bat
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences?redirectedfrom=MSDN
::
:: Color                Foreground           Background         Usage
:: --------------------------------------------------------------------
:: Black                --                 40                   1
:: Red                  31                 41                   2
:: Green                32                 42                   3
:: Yellow               33                 43                   4
:: Blue                 34                 44                   5
:: Magenta              35                 45                   6
:: Cyan                 36                 46                   7
:: White                37                 47                   8
:: Bright Black         90                 100                  9
:: Bright Red           91                 101                  10
:: Bright Green         92                 102                  11
:: Bright Yellow        93                 103                  12
:: Bright Blue          94                 104                  13
:: Bright Magenta       95                 105                  14
:: Bright Cyan          96                 106                  15
:: Bright White         97                 107                  16
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Note
:: call colors.bat
:: :colors x(fore) y(back) z(msg)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal enabledelayedexpansion

set header=[

set i=0
set j=0

set fores=0m 30m 31m 32m 33m 34m 35m 36m 37m 90m 91m 92m 93m 94m 95m 96m 97m

for %%a in (%fores%) do (
    set "fores[!i!]=%%a"
    set /a i+=1
)

set backs=0m 40m 41m 42m 43m 44m 45m 46m 47m 100m 101m 102m 103m 104m 105m 106m 107m
for %%a in (%backs%) do (
    set "backs[!j!]=%%a"
    set /a j+=1
)

set reset=0m

set count=0
for %%x in (%*) do (
    set /a count+=1
)

if %count%==3 (
   call :f %1 %2 %3
) else (
    call :notice
)
goto :elo

:f
if %1==0 (
    call echo %header%!backs[%2]!%~3%header%%reset%
) else if %2==0 (
    call echo %header%!fores[%1]!%~3%header%%reset%
) else (
    call echo %header%!fores[%1]!%header%!backs[%2]!%~3%header%%reset%
)

goto :elo

:notice
echo colors [fore] [back] msg
goto :elo

:elo
exit /b 0