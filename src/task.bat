:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.20
:: Description: add task schedule
:: Usage: task.bat
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: /tn TaskName 指定任务的名称。
:: /tr TaskRun 指定任务运行的程序或命令。键入可执行文件、脚本文件或批处理文件的完全合格的路径和文件名。如果忽略该路径，SchTasks.exe 将假定文件在Systemroot\System32 目录下。
:: /sc schedule 指定计划类型。有效值为 MINUTE、HOURLY、DAILY、WEEKLY、MONTHLY、ONCE、ONSTART、ONLOGON、ONIDLE。

:: Value                        Description
:: -----------------------------------------------------------------------------------------------
:: MINUTE                       Schedules the task to run every specified number of minutes.
:: HOURLY                       Schedules the task to run every specified number of hours.
:: DAILY                        Schedules the task to run every specified number of days.
:: WEEKLY                       Schedules the task to run every specified number of weeks.
:: MONTHLY                      Schedules the task to run every specified number of months.
:: ONCE                         Schedules the task to run one time only.
:: ONSTART                      Schedules the task to run when the computer starts.
:: ONLOGON                      Schedules the task to run when the user logs on.
:: ONIDLE                       Schedules the task to run when the computer is idle.

:: /mo modifier 指定任务在其计划类型内的运行频率。这个参数对于 MONTHLY 计划是必需的。对于 MINUTE、HOURLY、DAILY 或 WEEKLY 计划，这个参数有效，但也可选。默认值为 1。
:: /d days 指定任务的有效日期。有效值为 MON、TUE、WED、THU、FRI、SAT、SUN 和 *。

:: /i InitialPageFileSize 指定任务启动之前计算机空闲多少分钟。键入一个1 ～ 999之间的整数。这个参数只对于 ONIDLE 计划有效，而且是必需的。
:: /st StartTime 以HH:MM:SS24 小时格式指定时间。默认值是命令完成时的当前本地时间。/st参数只对于 MINUTE、HOURLY、DAILY、WEEKLY、MONTHLY 和 ONCE 计划有效。它只对于 ONCE 计划是必需的。
:: /sd StartDate 以MM/DD/YYYY格式指定任务启动的日期。默认值是当前日期。/sd参数对于所有的计划有效，但只对于 ONCE 计划是必需的。
:: /ed EndDate 指定任务计划运行的最后日期。此参数是可选的。它对于 ONCE、ONSTART、ONLOGON 或 ONIDLE 计划无效。默认情况下，计划没有结束日期。
:: /s Computer 指定远程计算机的名称或 IP 地址（带有或者没有反斜杠）。默认值是本地计算机。
:: /u [domain]user 使用特定用户帐户的权限运行命令。默认情况下，使用已登录到运行 SchTasks 的计算机上的用户的权限运行命令。
:: /p password 指定在/u参数中指定的用户帐户的密码。如果使用/u参数，则需要该参数。
:: /ru {[Domain]User|“System”} 使用指定用户帐户的权限运行任务。默认情况下，使用用户登录到运行 SchTasks 的计算机上的权限运行任务。

:: 这个命令是创建一个计算器的任务，在晚上8:00的时候运行一次calc.exe程序。
:: schtasks /create /tn "计算器"/tr calc.exe /sc once /st 20:00

:: schtasks \create \sc hourly \st 00:05:00 \tn "我的任务" \tr c:\apps\myapp.exe
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::