#Include PopularConfigs.ahk
#Include ConfigHelper.ahk
global DownloadLinkManual:=""
DeepLink(*)
{
global AutoImport:=1
Protocol := "cfghelper"
Action := '"' A_ScriptFullPath '" "%1"' 
try {
    CurrentReg := RegRead("HKCR\" Protocol "\shell\open\command")
} catch {
    CurrentReg := ""
}
if (CurrentReg != Action) {
    if !A_IsAdmin 
    {
        MyGui.Hide
        Run('*RunAs "' A_ScriptFullPath '"')
        ExitApp()
    }
    RegWrite("URL:" Protocol, "REG_SZ", "HKCR\" Protocol)
    RegWrite("", "REG_SZ", "HKCR\" Protocol, "URL Protocol")
    RegWrite(Action, "REG_SZ", "HKCR\" Protocol "\shell\open\command")
}
if (A_Args.Length > 0) 
{
    global AutoImportCheckBox
    RawUrl := A_Args[1]
    TargetUrl := StrReplace(RawUrl, Protocol "://download/?url=", "")
    MyGui.Hide()
    DownloadConfigHandler(TargetUrl)
    ExitApp
}
}
