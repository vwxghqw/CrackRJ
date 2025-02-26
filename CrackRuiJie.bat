@echo off

::不带参数的提权操作
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0","","runas",1)(window.close)&&exit

::映像劫持
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RouterKit.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RouterChk.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RCC-Client.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\rccdaemon.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LocalAppServer.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RJRemoteserver.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\halo_module_daemon.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RCC_ClassManager_Stu_Box.exe" /f /v debugger /d "/" 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RCC_ClassManager_Stu_Box_r.exe" /f /v debugger /d "/" 

echo 以下操作可能会有提示不存在进程，不影响

::杀进程
taskkill /im RouterKit.exe /f
taskkill /im RouterChk.exe /f
taskkill /im RCC-Client.exe /f
taskkill /im rccdaemon.exe /f
taskkill /im LocalAppServer.exe /f
taskkill /im RJRemoteserver.exe /f
taskkill /im halo_module_daemon.exe /f
taskkill /im RCC_ClassManager_Stu_Box.exe /f
taskkill /im RCC_ClassManager_Stu_Box_r.exe /f

::关驱动
sc stop rccdaemon

::禁用隐藏盘符
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /f
taskkill /im explorer.exe /f & explorer

::恢复taskmgr3的问题，提权，改名
takeown /f %windir%\system32\taskmgr3.exe > nul
icacls %windir%\system32\taskmgr3.exe /grant administrators:F > nul
ren %windir%\system32\taskmgr3.exe taskmgr.exe

::开启网络
::netsh interface set interface "以太网" enable

::等五秒
timeout 5 > nul

::检测网络是否联通
for /l %i in (1, 1, 10) do (
	ping baidu.com > nul && echo 已联通baidu.com，正在打开...  && start baidu.com && exit
	timeout /t 3 /nobreak
)

::版本：1.5 添加恢复taskmgr
::版本：1.4 添加开启网络与网络检测
