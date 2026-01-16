#Requires AutoHotkey v2.0
#SingleInstance Force
global ShowMsgBox:=0
global ImportConfigs := A_ScriptDir . "\ImportConfigs"
global ExportConfig := A_ScriptDir . "\ExportConfig"
global ExtractedConfigs:= A_ScriptDir . "\ExtractedConfigs"
global PathToDefaultStrategy:= ImportConfigs . "\All_Strategy.txt"
Antigreenie(*)
{
;Checking if Import and Export Folder exist

If !DirExist(ImportConfigs) || !DirExist(ExportConfig) || !DirExist(ExtractedConfigs)
    {
    DirCreate ImportConfigs ;Create Import folder if its not exist
    DirCreate ExportConfig ;Create Export folder if its not exist
    DirCreate ExtractedConfigs ;Create ExtractedConfigs folder if its not exist
    MsgBox("Created Export and Import folders")
}
AmountOfAssets:=0
loop files, A_ScriptDir . "\Assets\*" , "F"
{
    AmountOfAssets++
}
if (AmountOfAssets<19)
{
    MsgBox("Missing files in Assets folder `nRun updatehelper.ahk to download them")
    ExitApp()        
}
if !FileExist(A_ScriptDir . "\Salmon_AV.exe")
{
    x:=Gui()
    x.SetFont("c000000 s15", "Arial")
    x.AddText("x10 y10" , "Config Helper filles supposed to be in Macro folder pls look at example below")
    x.AddPicture("x10 y50" , A_ScriptDir . "\Assets\Bruh1.png")
    x.OnEvent("Close" , (*) => ExitApp())
    x.Show()
    Pause
}
if !FileExist(A_ScriptDir . "\WinRar.exe")
{
    MsgBox("Missing Winrar.exe`nRun UpdateHelper.ahk to download")
    ExitApp
}
}

CreateAllFolders(*)
{   
AllMapsByGamemode:= Map(
    "Rift", ["Kuinshi_Palace", "Mountain_Shrine", "Underground_Church" , "Imprisoned_Island"],
    "Raid", ["Spider_Forest", "Ruined_City", "Jojo_1", "Jojo_2" , "HAPPY_Factory"],
    "Event", ["Burning_Spirit_Tree", "Crystal_Chapel", "Double_Dungeon", "Golden_Castle", "Kuinshi_Palace", "Old_Lobby", "Old_Namek", "Shining_Castle", "The_Land_of_Gods" , "Lich_Kings_Throne" , "Frozen_Port"],
    "Dungeon", ["Jeju_island", "Frozen_Volcano"],
    "Portals", ["Sun_Temple", "Lich_Kings_Throne"],
    "BossRush", ["Rumbling_Event", "Dark_Tainted_Tyrant", "Blood_Red_Chamber", "Shibuya_Aftermath"],
    "LegendStage", ["Crystal_Chapel", "Shining_Castle" , "Imprisoned_Island" , "Burning_Spirit_Tree"],
    "Infinite" , ["Lich_Kings_Throne"]
)
For GamemodeFolders, MapsForGamemode in AllMapsByGamemode
{
    for MapFolderName in MapsForGamemode
    {           
        CreatePath:=A_ScriptDir . "\Data\Config\" . GamemodeFolders . "\" . MapFolderName
        if !DirExist(CreatePath)
        {
            DirCreate(CreatePath)
            global ShowMsgBox:=1
        }
    }
}
AllSubFolders:=[A_ScriptDir . "\Data\Config\Default\All" ,A_ScriptDir . "\Data\Config\Team" , A_ScriptDir . "\Data\Roblox\Mount" , A_ScriptDir . "\Data\Config\Unit_Ability" ]
for SubFolder in AllSubFolders
{
    if !DirExist(SubFolder)
    {
        DirCreate(SubFolder)
        global ShowMsgBox:=1
    }
}
if (ShowMsgBox =1)
{
MsgBox("Created all Gamemode folders and Sub folders")
}
}
UpdateColors(*)
{
if !FileExist(A_ScriptDir . "\GuiSettings.txt")
{

SettingsText := 
(
"DO NOT DELETE THIS TEXT
USE HEX COLORS FOR IT(remove # at the start of code)  FIRST IS BACKGROUND COLOR SECOND IS TEXT COLOR
I DO NOT RECOMEND TO USE FULL WHITE BACKGROUND SINCE CLOSE AND MINIMIZE BUTTONS ARE WHITE
SAVE FILE AND REOPEN HELPER TO APPLY SETTINGS
Current color settings are
1E1E1E
009c5b
Default color settings are
1E1E1E
009c5b"
)
FileObj := FileOpen(A_ScriptDir . "\GuiSettings.txt", "w")
FileObj.Write(SettingsText)
FileObj.Close()
}
FileContent := FileRead(A_ScriptDir . "\GuiSettings.txt") 
Lines := StrSplit(FileContent, "`n", "`r") 
global BackgroundColor:=Lines[6]
global TextColor:=Lines[7]
}