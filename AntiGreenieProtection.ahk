#Requires AutoHotkey v2.0
#Include ConfigHelper.ahk
UpdateColors(*)
{
FileContent := FileRead(A_ScriptDir . "\GuiSettings.txt") 
Lines := StrSplit(FileContent, "`n", "`r") 
global BackgroundColor:=Lines[6]
global TextColor:=Lines[7]
}
Antigreenie()
{
AmountOfAssets:=0
loop files, A_ScriptDir . "\Assets\*" , "F"
{
    AmountOfAssets++
}
if (AmountOfAssets<15)
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
UpdateColors()
}
}
CreateAllFolders(*)
{   
AllMapsByGamemode:= Map(
    "Rift", ["Kuinshi_Palace", "Mountain_Shrine", "Underground_Church"],
    "Raid", ["Spider_Forest", "Ruined_City", "Jojo_1", "Jojo_2"],
    "Event", ["Burning_Spirit_Tree", "Crystal_Chapel", "Double_Dungeon", "Golden_Castle", "Kuinshi_Palace", "Old_Lobby", "Old_Namek", "Shining_Castle", "The_Land_of_Gods" , "Lich_Kings_Throne"],
    "Dungeon", ["Jeju_island", "Frozen_Volcano"],
    "Portals", ["Sun_Temple", "Lich_Kings_Throne"],
    "Boss Rush", ["Rumbling_Event", "Dark_Tainted_Tyrant", "Blood_Red_Chamber", "Shibuya_Aftermath"],
    "Legend Stage", ["Crystal_Chapel", "Shining_Castle" , "Imprisoned_Island" , "Burning_Spirit_Tree"],
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
        }
    }
}
AllSubFolders:=[A_ScriptDir . "\Data\Config\Default\All" ,A_ScriptDir . "\Data\Config\Team" , A_ScriptDir . "\Data\Roblox\Mount" , A_ScriptDir . "\Data\Config\Unit_Ability" ]
for SubFolder in AllSubFolders
{
    if !DirExist(SubFolder)
    {
        DirCreate(SubFolder)
    }
}
MsgBox("Created all Gamemode folders and Sub folders")
}
UpdateColors()