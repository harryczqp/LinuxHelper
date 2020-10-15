dim objShell 
set objShell=wscript.createObject("WScript.Shell") 
iReturnCode=objShell.Run(".\frps.exe -c .\frps.ini",0,TRUE)