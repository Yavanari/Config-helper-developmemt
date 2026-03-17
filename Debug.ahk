#Requires AutoHotkey v2.0
#Include ConfigHelper.ahk
DebugGui:=Gui()
DebugGui.SetFont("s12 bold" )
UnpauseBtn:=DebugGui.AddButton(,"Bypass AntiGreenieProtection(most of it)").OnEvent("Click" , Bypass)
Btn1:=DebugGui.AddButton(, "Check folders").OnEvent("Click" , CheckFolders)
Btn2:=DebugGui.AddButton(, "Delete all folders(even data)").OnEvent("Click" , DeleteFolders)
Btn3:=DebugGui.AddButton(, "Reload").OnEvent("Click" ,Reload1)
Bypass(*)
{
    Pause(0)
    FileAppend "1" , A_ScriptDir . "\WinRar.exe"
    assetsarray:=["Bruh1.png" , "CidSasuke.png" , "Close.png" ,
    "DIoCidAct2.png" , "EscanorAllRifts.png" , "ExportGuide1.png" ,
    "FreezaFrozenVolcano.png" , "GuieAdvanced.png" , "ImportGuide1.png" , 
    "ImportGuide2.png" , "ImportGuide3.png", "JejuIslandHiccup.png" , 
    "MeriConfig.png" , "Minimize.png" , "RiftUmaMeri.png" , "ShanksRiftMeri.png"]
    DirCreate A_ScriptDir . "\Assets"
    For createasset in assetsarray
    {
        if FileExist(A_ScriptDir . "\Assets\" . createasset)
        {
            continue
        }
        else
        {
        FileAppend "1" , A_ScriptDir . "\Assets\" . createasset
        }
    }
}
CheckFolders(*)
{
    UpdateSaveFile
    SearchConfigs
    AmountOfFoldersInImport:=0
    AmountOfCorrectFoldersInImport:=0
    Loop Files, ImportConfigs . "\*", "D"
    {
       AmountOfFoldersInImport++
    }
    Loop Files, ImportConfigs . "\AutoDetect.txt", "RF"
    {
        if A_LoopFileFullPath == ImportConfigs . "\AutoDetect.txt"{
            continue
        }
       AmountOfCorrectFoldersInImport++
    }
    MsgBox("Total config folders: " AmountOfFoldersInImport "`nTotal correct format folder: "  AmountOfCorrectFoldersInImport "`n(if autodetect.txt exist means that config was made with helper `nthat mean it fully supported)")  

}
DeleteFolders(*)    
{
    DirDelete A_ScriptDir . "\Data" , 1
    DirDelete ImportConfigs , 1
    DirDelete ExportConfig , 1
    DirDelete ExtractedConfigs , 1
}
CheckAllVarriables(*)
{
    UpdateSaveFile
    PopularConfigGuiShow
    q:=Gui()
    q.AddText(,)
}
Reload1(*)
{
    Reload
}

F1::
{
    DebugGui.Show
}
