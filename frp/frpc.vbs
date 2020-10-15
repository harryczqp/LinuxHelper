dim objShell 
set objShell=wscript.createObject("WScript.Shell") 
iReturnCode=objShell.Run("D:\ServerFiles\frp\frpc.exe -c D:\ServerFiles\frp\frpc.ini",0,TRUE)