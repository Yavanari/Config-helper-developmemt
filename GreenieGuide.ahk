#Requires AutoHotkey v2.0
#Include AntiGreenieProtection.ahk
#Include ConfigHelper.ahk
#Include Language.ahk
global GuideGui:=Gui("-Caption 2")
SelectLangGui:=Gui("-Caption 2")
SelectLangGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
SelectLangGui.BackColor := BackgroundColor
SelectLangGui.AddText("x70 y10 Background" . BackgroundColor . " c" . TextColor , "Select Guide Language")
SelectLangGui.AddText("x20 y50 w120 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "English").OnEvent("Click" , (*)=>SetLang("en"))
;SelectLangGui.AddText("x20 y90 w120 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Vietnamese").OnEvent("Click" , (*)=>SetLang("vn"))
SelectLangGui.AddText("x170 y50 w120 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Spanish").OnEvent("Click" , (*)=>SetLang("sp"))
SelectLangGui.AddText("x170 y90 w120 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Portuguese").OnEvent("Click" , (*)=>SetLang("por"))
SetLang(language) {
    global CurrentLang := language
    SelectLangGui.Destroy()
    GuideGuiShow 
}
GuideGuiShow(*)
{
global confirmImprot:=0
GuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
GuideGui.BackColor := BackgroundColor
TitleBar := GuideGui.Add("Text", "w420 h30 Center Background" . BackgroundColor . " c" . TextColor, "Config Helper guide")
CloseButton := GuideGui.Add("Picture", "x430 y10 w15 h15", A_ScriptDir . "\Assets\Close.png").OnEvent("Click", (*) => ExitApp()) 
MinimizeButton:=GuideGui.Add("Picture", "x400 y10 w15 h15", A_ScriptDir . "\Assets\Minimize.png").OnEvent("Click", (*) => GuideGui.Minimize())
GuideGui.AddText("x30 y60 Background" . BackgroundColor . " c" . TextColor , Lang[CurrentLang]["GuideTitle"])
ImportGuide:=GuideGui.AddText("x60 y150 w150 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", Lang[CurrentLang]["ImportBtn"]).OnEvent("Click" , ImportGuideGuiShow)
ExportGuide:=GuideGui.AddText("x260 y150 w150 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", Lang[CurrentLang]["ExportBtn"]).OnEvent("Click" , ExportGuideGuiShow)
ReadButton:=GuideGui.AddText("x160 y200 w150 h60 Center Background" . BackgroundColor . " c" . TextColor " +Border", Lang[CurrentLang]["ReadBtn"]).OnEvent("Click" , ImNotDumb)
GuideGui.Show()
}
ImportGuideGuiShow(*)
{
    global confirmImprot:=1
    GuideGui.Hide()
    global ImportGuideGui:=Gui("-Caption 2")
    ImportGuideGui.BackColor := BackgroundColor
    ImportGuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
    TabCtrl := ImportGuideGui.Add("Tab3", "w1170 h530 +Border +Multi" , [Lang[CurrentLang]["Tab1"], Lang[CurrentLang]["Tab2"], Lang[CurrentLang]["Tab3"]])
    TabCtrl.UseTab(1)
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor , Lang[CurrentLang]["FirstWay"])
    ImportGuideGui.AddText("x610 y90 Background" . BackgroundColor . " c" . TextColor , Lang[CurrentLang]["Import1"])
    ImportGuideGui.AddPicture("x20 y90 h450" , A_ScriptDir . "\Assets\ImportGuide1.png")
    TabCtrl.UseTab(2)
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor ,Lang[CurrentLang]["Import2"])
    ImportGuideGui.AddPicture("x20 y240" , A_ScriptDir . "\Assets\ImportGuide3.png")
    TabCtrl.UseTab(3)
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor , Lang[CurrentLang]["Import3"])
    ImportGuideGui.AddPicture("x500 y40 h450" , A_ScriptDir . "\Assets\GuieAdvanced.png")
    ImportGuideGui.Show()
}
ExportGuideGuiShow(*)
{
    GuideGui.Hide()
    global ExportGuideGui:=Gui("-Caption 2")
    ExportGuideGui.BackColor := BackgroundColor
    ExportGuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
    ExportGuideGui.AddText("x20 y20 Background" . BackgroundColor . " c" . TextColor , Lang[CurrentLang]["Export1"])
    ExportGuideGui.AddPicture("x20 y140" , A_ScriptDir . "\Assets\ExportGuide1.png")
    CloseButton:=ExportGuideGui.AddText("x350 y350 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click", Close)
    ExportGuideGui.Show()
}
ImNotDumb(*)
{
    
    if (confirmImprot = 1)
    {
    FileAppend("Confirm that you have read both guide for impoting and exporting and you wont ask dumb questions" ,A_ScriptDir . "\ImNotDumb.txt" )
    GuideGui.Destroy()
    Pause(0)
    }
    else
    {
        MsgBox(Lang[CurrentLang]["GoRead"])
    }
}
Close(*)
{
    try ExportGuideGui.Hide()
    try ImportGuideGui.Hide()
    GuideGui.Show()
}
ReadGuideAgain(*)
{
    FileDelete(A_ScriptDir . "\ImNotDumb.txt")
    Reload
}