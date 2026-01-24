#Requires AutoHotkey v2.0
#Include AntiGreenieProtection.ahk
#Include ConfigHelper.ahk
global GuideGui:=Gui("-Caption 2")
GuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
GuideGui.BackColor := BackgroundColor
TitleBar := GuideGui.Add("Text", "w420 h30 Center Background" . BackgroundColor . " c" . TextColor, "Config Helper guide")
CloseButton := GuideGui.Add("Picture", "x430 y10 w15 h15", A_ScriptDir . "\Assets\Close.png").OnEvent("Click", (*) => ExitApp()) 
MinimizeButton:=GuideGui.Add("Picture", "x400 y10 w15 h15", A_ScriptDir . "\Assets\Minimize.png").OnEvent("Click", (*) => GuideGui.Minimize())
GuideGui.AddText("x30 y60 Background" . BackgroundColor . " c" . TextColor , "Welcome greenie this is your first Helper launch `nSo i will try to explain you how to import,export configs`nClick buttons below for guides")
ImportGuide:=GuideGui.AddText("x60 y150 w150 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "How to Import").OnEvent("Click" , ImportGuideGuiShow)
ExportGuide:=GuideGui.AddText("x260 y150 w150 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "How to Export").OnEvent("Click" , ExportGuideGuiShow)
ReadButton:=GuideGui.AddText("x160 y200 w150 h60 Center Background" . BackgroundColor . " c" . TextColor " +Border", "I've read guides`nAnd wont ask dumb questions").OnEvent("Click" , ImNotDumb)
ImportGuideGuiShow(*)
{
    GuideGui.Hide()
    global ImportGuideGui:=Gui("-Caption 2")
    ImportGuideGui.BackColor := BackgroundColor
    ImportGuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
    TabCtrl := ImportGuideGui.Add("Tab3", "w1170 h530 +Border +Multi" , ["First way" , "Second way", "Advanced way"])
    TabCtrl.UseTab(1)
    text1:=
    (
        "In config helper Click `"Popular Config`" button
        After choose gamemode and choose config you want to import`nThen click `"Download Config`"
        Click ok every time it shows white window`nThen choose team that you will use for macro
        Note: Old configs for this team,gamemode,map will be replaced
        Then click import button and thats it
        Reopen your macro after that"
    )
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor , "Using popular configs tab(Recomended)")
    ImportGuideGui.AddText("x610 y90 Background" . BackgroundColor . " c" . TextColor , text1)
    ImportGuideGui.AddPicture("x20 y90 h450" , A_ScriptDir . "\Assets\ImportGuide1.png")
    TabCtrl.UseTab(2)
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    Text2:=
    (
        "Other ways
Go to custom-configs in salmon server and download a custom config (only v2.0 configs work and if they were made with helper)
Copy the (.rar or .zip) file into the newly made ImportConfigs folder
Click Extract All Configs button(All Zip, Rar will be moved to ExtractedZIP folder)
Select Extracted config folder in config folder menu to search configs only in this folder`nYOU MUST SELECT NEW CONFIG FOLDER AND NOT DEFAULT
Select Gamemode , Map , Team (Select Team only if original config had Team.txt in it)
Click Import Button
After importing Config folder will be deleted"
    )
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor , Text2)
    ImportGuideGui.AddPicture("x20 y240" , A_ScriptDir . "\Assets\ImportGuide3.png")
    TabCtrl.UseTab(3)
    CloseButton:=ImportGuideGui.AddText("x975 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click",Close)
    text3:=
    (
        "If config have wrong format for helper you can click `"Manual select`"
        Then browse strategy,team,coordinate files 
        Select map,gamemode,team slot
        Note: Old configs for this team,gamemode,map will be replaced
        And press import button"
    )
    ImportGuideGui.AddText("x20 y60 Background" . BackgroundColor . " c" . TextColor , Text3)
    ImportGuideGui.AddPicture("x500 y40 h450" , A_ScriptDir . "\Assets\GuieAdvanced.png")
    ImportGuideGui.Show()
}
ExportGuideGuiShow(*)
{
    GuideGui.Hide()
    global ExportGuideGui:=Gui("-Caption 2")
    ExportGuideGui.BackColor := BackgroundColor
    ExportGuideGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
    Text:=
    (
        "Select Gamemode , Map , Team you want to export
Click Export button
Will also ask if you want to export unit ability,mount,modifiers
You can also can change Config name when exporting
Exported config will be saved in ExportConfig folder"
    )
    ExportGuideGui.AddText("x20 y20 Background" . BackgroundColor . " c" . TextColor , Text)
    ExportGuideGui.AddPicture("x20 y140" , A_ScriptDir . "\Assets\ExportGuide1.png")
    CloseButton:=ExportGuideGui.AddText("x350 y350 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close").OnEvent("Click", Close)
    ExportGuideGui.Show()
}
ImNotDumb(*)
{
    Pause(0)
    FileCords := FileOpen(A_ScriptDir . "\ImNotDumb.txt", "w")
    FileCords.Write("Confirm that you have read both guide for impoting and exporting and you wont ask dumb questions")
    FileCords.Close()
}
Close(*)
{
    try ExportGuideGui.Hide()
    try ImportGuideGui.Hide()
    GuideGui.Show()
}