#Requires AutoHotkey v2.0
#SingleInstance Force
; Start checking if something wrong 
MsgBox("123")
MsgBox("12333")
try UpdateColors()
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
global ManualImportingGui := Gui("-Caption 2 ") 
MyGui := Gui("-Caption 2 ") 
MyGui.BackColor := BackgroundColor
TitleBar := MyGui.Add("Text", "w480 h30 Center Background" . BackgroundColor . " c" . TextColor, "Config Helper")
TitleBar.SetFont("s10 Bold", "Arial")
OnMessage(0x201, EnableDrag)
EnableDrag(wParam, lParam, msg, hwnd)
{
    if (hwnd = MyGui.Hwnd) or (hwnd = ManualImportingGui.Hwnd) or (hwnd = PopularConfigGui.Hwnd)
    {
        DllCall("SendMessage", "ptr", hwnd, "uint", 0xA1, "ptr", 2, "ptr", 0)
    }
}
CloseButton := MyGui.Add("Picture", "x460 y10 w15 h15", A_ScriptDir . "\Assets\Close.png")  
CloseButton.OnEvent("Click", (*) => ExitApp())
MinimizeButton:=MyGui.Add("Picture", "x430 y10 w15 h15", A_ScriptDir . "\Assets\Minimize.png")
MinimizeButton.OnEvent("Click", (*) => MyGui.Minimize())
MyGui.SetFont("bold " . "c" TextColor . " s9", "Arial")
ListOfMountsImport:=[]
global ImportingTeam :=""
MyGui.Add("Text", "x20 y84", "Gamemode:",)
DllCall("uxtheme\SetWindowTheme", "ptr", MyGui.Hwnd, "str", "DarkMode_Explorer", "ptr", 0)
Gamemode := MyGui.AddComboBox("vGamemode w130 Background" . BackgroundColor , ["Rift", "Raid", "Dungeon", "Event", "Portals", "Boss Rush", "Legend Stage" , "Infinite"]) ; Drop down menu to choose gamemode
DllCall("uxtheme\SetWindowTheme", "Ptr", Gamemode.Hwnd, "Str", "DarkMode_Explorer", "Ptr", 0)
MyGui.Add("Text", "x20 y184", "Team: ")
Team:=MyGui.AddDropDownList("vTeam w130 Background" . BackgroundColor . " c" . TextColor,["Team1", "Team2", "Team3", "Team4", "Team5", "Team6", "Team7", "Team8",]) ; Drop down menu to choose team
MyGui.Add("Text", "x20 y134", "Map: ")
MapsAndActs := MyGui.AddDropDownList("x20 y154 w130 vMaps Background" . BackgroundColor . " c" . TextColor, [""])
MyGui.Add("Text", "x20 y34" ,"Config Folder: ")
ConfigFolder:=MyGui.AddDropDownList(" vSelectedConfigFolder w120 x20 y54 w130 Background" . BackgroundColor . " c" . TextColor, [""])  ; Drop down menu to choose Config folder
MyGui.Add("Text","x20 y310", "List of found configs: ")
MyGui.Add("Text","x250 y310", "List of extracted configs: ")
ListOfFoundedConfigs := MyGui.Add("ListBox", " x20 y330 w200 h150 Background" . BackgroundColor . " c" . TextColor)
ListOfExtractedConfigs := MyGui.Add("ListBox", " x250 y330 w200 h150 Background" . BackgroundColor . " c" . TextColor)
MyGui.Add("Text", "x10 y470", " `n Made by: FunnyValentine `n Original idea: Salmon `n Tested By: Hiccup , Zad , Gnoemy, Royam") ;Credits
MyGui.Add("Text", "x300 y34", "Controls")
MyGui.Add("Text", "x415 y510", "Version 1.8a")
;Checking if Import and Export Folder exist
global ImportConfigs := A_ScriptDir . "\ImportConfigs"
global ExportConfig := A_ScriptDir . "\ExportConfig"
global ExtractedConfigs:= A_ScriptDir . "\ExtractedConfigs"
global PathToDefaultStrategy:= ImportConfigs . "\All_Strategy.txt"
If !DirExist(ImportConfigs) || !DirExist(ExportConfig) || !DirExist(ExtractedConfigs)
    {
    DirCreate ImportConfigs ;Create Import folder if its not exist
    DirCreate ExportConfig ;Create Export folder if its not exist
    DirCreate ExtractedConfigs ;Create ExtractedConfigs folder if its not exist
    MsgBox("Created Export and Import folders")
}

;Download with discord Button
LinkToConfig:=MyGui.AddEdit("x20 y280 w300 Background" . BackgroundColor . " c" . TextColor)
MyGui.AddText("x20 y260", "Download config with direct link")
MyGui.SetFont("s10 bold")
DownloadButton := MyGui.Add("Text", "x350 y280 w110 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Download").OnEvent("Click" , DownloadConfig)
;Default Strategy Button
DefaultButton := MyGui.Add("Text" , "x200 y214 w100 h40 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Default Strategy").OnEvent("Click" , DefultStrategyFunction)
;Export button
ExportButton := MyGui.Add("Text" ,  "x200 y174 w100 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border" , "Export").OnEvent("Click" , Export)
;Import button
ImportButton := MyGui.Add("Text", "x200 y94 w100 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Import").OnEvent("Click", Import)
;Import Mount button
ImportMountButton := MyGui.Add("Text", "x200 y134 w100 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Import Mount").OnEvent("Click" , ImportMountForCid)
;Extract button
Extractbutton := MyGui.Add("Text", "x320 y54 w150 h40 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Extract All Configs `n (Only ZIP and RAR)").OnEvent("Click", UnZip)
;Refresh Button
RefreshButton := MyGui.Add("Text", "x200 y54 w100 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Refresh").OnEvent("Click", UpdateSaveFile)
;Create folders
CreateFoldersButton:= MyGui.Add("Text", "x320 y104 w150 h35 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Manual select config txts").OnEvent("Click", ManualImportingGuiShow)
;Popular config button
PopularConfigButton:=MyGui.Add("Text", "x320 y154 w150 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Popular configs" ).OnEvent("Click" , (*) => PopularConfigGui.Show())
;Custom GUI button
CustomGuiButton:=MyGui.Add("Text", "x320 y194 w150 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Custom GUI colors" ).OnEvent("Click" , (*) => Run('notepad.exe "' . A_ScriptDir . '\GuiSettings.txt"'))
; Gamemode and maps drop down list
MapsAndActs.OnEvent("Change", UpdateSaveFile)
Gamemode.OnEvent("Change", MapList)
ConfigFolder.OnEvent("Change", UpdateSaveFile)
Team.OnEvent("Change", UpdateSaveFile)
MapList(Maps*)
{   
    MapsAndActs.Delete()
    SelectedMode := Gamemode.Value
    SelectedMap := MapsAndActs.Value
    switch SelectedMode
    {
        case 1:
            MapsAndActs.Add(["Kuinshi_Palace", "Mountain_Shrine", "Underground_Church"]) ;Drop down list for Rift
        case 2:
            MapsAndActs.Add(["Spider_Forest", "Ruined_City", "Jojo_1", "Jojo_2"]) ;Drop down list for Cid
        case 3:
            MapsAndActs.Add(["Jeju_Island", "Frozen_Volcano"]) ;Drop down list for Dungeons
        case 4:
            MapsAndActs.Add(["Burning_Spirit_Tree", "Crystal_Chapel", "Double_Dungeon", "Golden_Castle", "Kuinshi_Palace", "Old_Lobby", "Old_Namek", "Shining_Castle", "The_Land_of_Gods", "Lich_Kings_Throne"]) ;Drop down list for Event
        case 5:
            MapsAndActs.Add(["Sun_Temple"]) ;Drop down list for Portals
        case 6:
            MapsAndActs.Add(["Rumbling_Event", "Dark_Tainted_Tyrant", "Blood_Red_Chamber", "Shibuya_Aftermath"]) ;Drop down list for Boss Rush
        case 7:
            MapsAndActs.Add(["Crystal_Chapel", "Shining_Castle"]) ;Drop down list for Legend stages
        case 8:
            MapsAndActs.Add(["Lich_Kings_Throne"]) 
    }
}

UpdateSaveFile(*)
{   
    ;Gettings all nessesary varriables
    global ListOfMountsImport:=[]
    global SelectedMode := Gamemode.Value
    global SelectedMap := MapsAndActs.Value
    global SelectedMapSearch:=MapsAndActs.Text
    global SelectedModeSearch:=Gamemode.Text
    global SelectedTeam:=Team.Text
    global SelectedConfigFolder:=ConfigFolder.Text
    global PathToDeleteFodler:= ImportConfigs  . "\" .  SelectedConfigFolder
    ConfigFolder.Delete()
    ConfigFolder.Add(["Default"])
    loop files, ImportConfigs "\*", "D"
    {   
        ConfigFolder.Add([A_LoopFileName])
    }
    try ConfigFolder.Choose(SelectedConfigFolder) 
        SearchConfigs()
}

SearchConfigs(*)
{
    if FileExist(ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt") and (SelectedConfigFolder != "Default") and (SelectedConfigFolder != "")
    { 
        FileContent := FileRead(ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt")
        Lines := StrSplit(FileContent, "`n", "`r") 
        global ConfigGamemode:=Lines[1]
        global ConfigMap:=Lines[2]
        Gamemode.Text:=ConfigGamemode
        MapList()
        try MapsAndActs.Text:=ConfigMap
    } 
    SelectedMapSearch := MapsAndActs.Text
    global ListOfConfigs := []
    ListOfFoundedConfigs.Delete()
    targetfolder := ""
    if (SelectedConfigFolder = "Default")
    {
        if (SelectedMapSearch != "")
        {
        ; Search for map config files
        loop files, ImportConfigs . "\" . SelectedMapSearch . "*.txt", "F"
        {
            if (A_LoopFileName = "All_Strategy.txt")
            {
                continue
            }
            else
            {
                ListOfConfigs.push(A_LoopFileFullPath)
                ListOfFoundedConfigs.Add([A_LoopFileName])
            }
        }
        ; Search for team files
        loop files, ImportConfigs . "\Team" . "*.txt", "F"
            {
            global ImportingTeam := A_LoopFileFullPath
            ListOfFoundedConfigs.Add([A_LoopFileName])
            }
        }
    }   
    else
    {
        Loop Files, ImportConfigs "\" . SelectedConfigFolder . "\" . SelectedMapSearch . "*", "RD" 
        {
            if (A_LoopFileName = SelectedMapSearch)
            {
                targetfolder := A_LoopFileFullPath
                loop files, targetfolder . "\*.txt", "F"
                {
                    if (A_LoopFileName = "All_Strategy.txt")
                    {
                        continue
                    }
                    else
                    {   
                            ListOfConfigs.push(A_LoopFileFullPath)
                            ListOfFoundedConfigs.Add([A_LoopFileName])
                    }
                }
            }
        }
        loop files , ImportConfigs "\" . SelectedConfigFolder . "\Team" . "\*.txt" , "F"
        {
            global ImportingTeam := A_LoopFileFullPath
            ListOfFoundedConfigs.Add([A_LoopFileName])
        }
    }
    
}
DefultStrategyFunction(*)
{
    if !FileExist(PathToDefaultStrategy)
    {
    MsgBox("No default strategy found in Import Folder")
    }
    else
    {
    try FileCopy PathToDefaultStrategy , A_ScriptDir . "\Data\Config\Default\All" , 1
    MsgBox("Successfully imported default strategy")
    }
}
UnZip(*)
{  
    UpdateSaveFile()
    ListOfRarAndZipFiles:=[]
    ListOfExtractedConfigs.Delete()
    Loop Files, ImportConfigs . "\*.zip", "RF" 
    {
        if !InStr(A_LoopFileAttrib, "D")
        {
            ListOfExtractedConfigs.Add([A_LoopFileName])
            ListOfRarAndZipFiles.Push(A_LoopFileFullPath)
        }
    
    }
    Loop Files, ImportConfigs . "\*.rar", "RF"
    {
        ListOfExtractedConfigs.Add([A_LoopFileName])
        ListOfRarAndZipFiles.Push(A_LoopFileFullPath)
    }
    for SourceRar in ListOfRarAndZipFiles
    {    
        UnrarExePath:=A_ScriptDir . "\WinRar.exe"
        try RunWait('"' . UnrarExePath . '" x -y "' . SourceRar . '" "' . ImportConfigs .  '"')
    }
    for PathToCopyZip in ListOfRarAndZipFiles
    {
        FileCopy PathToCopyZip, ExtractedConfigs , 1
        FileDelete PathToCopyZip
    }
    If (ListOfRarAndZipFiles.Length=0)
    {
        MsgBox("No Zip and Rar files found")
    }
    else
    {
        MsgBox("Extracted all Zip and Rar files")
    }
UpdateSaveFile()
}

Import(*)
{
    if (AutoImportCheckBox.Value != 1)
    {
    UpdateSaveFile()
    }
    if (AutoGamemode = "RiftAll") and (AutoMap = "RiftAll")
    {
        DirMove ImportConfigs . "\Escanor_All_Rifts\Rift" , A_ScriptDir . "\Data\Config" , 1
        FileMove ImportConfigs . "\Escanor_All_Rifts\Team\Team6.txt", A_ScriptDir . "\Data\Config\Team\" . SelectedTeam . ".txt" , 1
        MsgBox("Successfully imported")
        MapsAndActs.Delete()
        Gamemode.Delete()
        return    
    }
    if (SelectedMode = 0) && (SelectedMap = 0) || (ListOfConfigs.Length = 0)
    {
        MsgBox "You didnt choose Gamemode and Map `nOr no configs found for this map `nMake sure you selected right Config Folder"
        return
    }
    else
    {
        for PathToCopyConfig in ListOfConfigs
        {
            try FileMove PathToCopyConfig , A_ScriptDir . "\Data\Config\" . SelectedModeSearch . "\" . SelectedMapSearch , 1
            try FileMove ImportingTeam , A_ScriptDir . "\Data\Config\Team\" . SelectedTeam . ".txt" , 1 
        }
  
        if FileExist(ImportConfigs . "\" . SelectedConfigFolder . "\Config.txt")
        {
            if MsgBox("Do you want to import Config.txt (modifiers)?",, "YesNo") = "Yes"
            {
            try FileMove ImportConfigs . "\" . SelectedConfigFolder . "\Config.txt" , A_ScriptDir . "\Data\Config\"  . SelectedModeSearch 
            }
            else
            {
                FileDelete(ImportConfigs . "\" . SelectedConfigFolder . "\Config.txt")
            }
        }
        if DirExist(ImportConfigs . "\" . SelectedConfigFolder . "\Unit_Ability")
        {
            loop files , ImportConfigs . "\" . SelectedConfigFolder . "\Unit_Ability\*.txt"
            {
                FileMove A_LoopFileFullPath , A_ScriptDir . "\Data\Config\Unit_Ability" , 1
            } 
        }
        MsgBox("Successfully imported")
    }
    if (SelectedMode = 2) && (SelectedMap = 2)
    {
    ImportMountForCid()
    }
    if (SelectedConfigFolder="Default")
    {
        for FileConfigDelete in ListOfConfigs
        {   
            try FileDelete FileConfigDelete
        }
    }
global ListOfConfigs:=[]
FileDelete ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt"
DeleteFolderIfNoTxt()
UpdateSaveFile()
}
Export(*)
{
    UpdateSaveFile()
    if (SelectedMode = 0) && (SelectedMap = 0)
    {
        MsgBox "You didnt choose Gamemode and Map"
        return
    }
    else
    {
        global TempDir := A_ScriptDir . "\TempExport\" . SelectedModeSearch . "_" . SelectedMapSearch
        global TempMapDir:= TempDir . "\" . SelectedMapSearch
        global TempTeamDir:=TempDir . "\Team"
        AutoDetect:=SelectedModeSearch . "`n" . SelectedMapSearch
        try DirDelete TempDir, 1
        DirCreate TempMapDir 
        DirCreate TempTeamDir
        ModifiersConfigPath:=A_ScriptDir . "\Data\Config\"  . SelectedModeSearch . "\*.txt"
        UnitAbilityPath:=A_ScriptDir . "\Data\Config\Unit_Ability"
        ExportingConfigFromData := A_ScriptDir . "\Data\Config\"  . SelectedModeSearch . "\" . SelectedMapSearch
        if FileExist(A_ScriptDir . "\Data\Config\Team\" . SelectedTeam . ".txt")
        {
        try FileCopy A_ScriptDir . "\Data\Config\Team\" . SelectedTeam . ".txt" , TempTeamDir
        }
        loop files , ExportingConfigFromData  "\*.txt"
        {   
            ConfigFileName:=A_LoopFileFullPath
            FileCopy ConfigFileName, TempMapDir
        }
        if FileExist(ModifiersConfigPath)
        {
            if MsgBox("Do you want to export Config.txt (modifiers)?",, "YesNo") = "Yes"
            {
            try FileCopy ModifiersConfigPath , TempDir
            }
        }
        if DirExist(UnitAbilityPath)
        {
            if MsgBox("Do you want to export Unit Abilities",, "YesNo") = "Yes"
            {
            TempAbilityDir:=TempDir . "\Unit_Ability"
            DirCreate TempAbilityDir
            SelectUnitAbilitiesExplorer:=FileSelect("M3", UnitAbilityPath , "Select unit abilities to export", "All Files (*.*)")
            for AbilityToExport in SelectUnitAbilitiesExplorer
            {
                try FileCopy AbilityToExport , TempAbilityDir             
            }
            }
        }
        if (ExportingConfigFromData=A_ScriptDir . "\Data\Config\Raid\Ruined_City")
        {
            global TempMountDir:=TempDir . "\Mount"
            DirCreate TempMountDir
            MountsSelected:=FileSelect("M3", A_ScriptDir "\Data\Roblox\Mount", "Select Mount Configs", "All Files (*.*)")
            for MountToExport in MountsSelected
            {
            FileCopy MountToExport  , TempMountDir
            }
            
        }
        if (SelectedMode != 0) && (SelectedMap != 0)
        {
        MyGui.Hide
        global g:=Gui("-Caption 2 +AlwaysOnTop")
        g.SetFont("bold c1E1E1E s9", "Arial")
        g.BackColor:= BackgroundColor
        g.AddText("X30 y10 Center c" . TextColor , "Enter Config name")
        ConfigNameEdit:=g.AddEdit("x10 y40")
        Export:=g.Add("Text", "x45 y70 w70 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Export").OnEvent("Click" , (*) => Pause(0))
        g.Show()
        Pause
        ConfigName:=ConfigNameEdit.Value
        AutoDetectTxt:=FileOpen(TempDir . "\AutoDetect.txt", "w")
        AutoDetectTxt.Write(AutoDetect)
        AutoDetectTxt.Close()
        DirMove TempDir , A_ScriptDir . "\TempExport\" . ConfigName , 1
        global ExportingPath:=ExportConfig . "\" . ConfigName . ".zip"
        g.Destroy()
        RunWait "PowerShell.exe -Command Compress-Archive -Path '"  A_ScriptDir . "\TempExport\" . ConfigName "' -DestinationPath '" ExportingPath "' -Force"
        MsgBox("Successfully exported" )
        MyGui.Show
        DirDelete A_ScriptDir . "\TempExport\" , 1
        }
    }
UpdateSaveFile()
}
ManualImportingGuiShow(*)
{ 
    global CoordinatesPath, TeamPath, StrategyPath
    ManualImportingGui := Gui("-Caption" , "Manual Selecting") 
    ManualImportingGui.BackColor := BackgroundColor
    TitleBar := ManualImportingGui.Add("Text", "w680 h30 Center Background" . BackgroundColor . " c" . TextColor, "Manual Selecting")
    TitleBar.SetFont("s10 Bold", "Arial")
    ManualImportingGui.SetFont("bold " . "c" TextColor . " s9", "Arial")
    ManualImportingGui.AddText("x10 y310", "Select Gamemode:")
    global ManualGamemode := ManualImportingGui.AddComboBox("vManGamemode x10 y330 w130 Background" . BackgroundColor . " c" . TextColor, ["Rift", "Raid", "Dungeon", "Event", "Portals", "Boss Rush", "Legend Stage" , "Infinite"])
    ManualImportingGui.AddText("x150 y310", "Select Map:")
    global ManualMaps := ManualImportingGui.AddDropDownList("vManMaps x150 y330 w130 Background" . BackgroundColor . " c" . TextColor, [""])
    ManualImportingGui.AddText("x90 y360", "Team:")
    global ManualTeam := ManualImportingGui.AddDropDownList("vManTeam x90 y380 w130 Background" . BackgroundColor . " c" . TextColor, ["Team1", "Team2", "Team3", "Team4", "Team5", "Team6", "Team7", "Team8"])
    ManualGamemode.OnEvent("Change", (ctrl, *) => ManualUpdateMapList(ctrl, ManualMaps))
    ManualImportingGui.Add("Picture", "x660 y10 w15 h15", A_ScriptDir "\Assets\Close.png").OnEvent("Click", (*) => ManualImportingGui.Hide())
    ManualImportingGui.Add("Picture", "x630 y10 w15 h15", A_ScriptDir "\Assets\Minimize.png").OnEvent("Click", (*) => ManualImportingGui.Minimize())
    AddFileSection(ManualImportingGui, "Strategy", 30, 50, 80, &StrategyPath, UpdateStrategyDisplay)
    AddFileSection(ManualImportingGui, "Coordinates", 120, 140, 170, &CoordinatesPath)
    AddFileSection(ManualImportingGui, "Team", 210, 230, 260, &TeamPath)
    ManualImportingGui.AddText("x350 y30", "Current Strategy")
    global DisplayStrategy := ManualImportingGui.AddListBox("x350 y50 w300 h420 Background" . BackgroundColor . " c" . TextColor " +Border")
    ImportButton:=ManualImportingGui.AddText("x120 y420 w80 h30 Center + Border" , "Import").OnEvent("Click" , ManualImportingAction) 
    OnMessage(0x201, (*) => PostMessage(0xA1, 2,,, "A")) 
    ManualImportingGui.Show()
}
ManualUpdateMapList(SourceCtrl, TargetMapCtrl) {
    TargetMapCtrl.Delete()
    switch SourceCtrl.Value {
        case 1: TargetMapCtrl.Add(["Kuinshi_Palace", "Mountain_Shrine", "Underground_Church"])
        case 2: TargetMapCtrl.Add(["Spider_Forest", "Ruined_City", "Jojo_1", "Jojo_2"])
        case 3: TargetMapCtrl.Add(["Jeju_Island", "Frozen_Volcano"])
        case 4: TargetMapCtrl.Add(["Burning_Spirit_Tree", "Crystal_Chapel", "Double_Dungeon", "Golden_Castle", "Kuinshi_Palace", "Old_Lobby", "Old_Namek", "Shining_Castle", "The_Land_of_Gods", "  "])
        case 5: TargetMapCtrl.Add(["Sun_Temple"])
        case 6: TargetMapCtrl.Add(["Rumbling_Event", "Dark_Tainted_Tyrant", "Blood_Red_Chamber", "Shibuya_Aftermath"])
        case 7: TargetMapCtrl.Add(["Crystal_Chapel", "Shining_Castle"])
        case 8: TargetMapCtrl.Add(["Lich_Kings_Throne"])
    }
}
ManualImportingAction(*)
{
    SelectedModeSearch := ManualGamemode.Text
    SelectedMapSearch := ManualMaps.Text
    SelectedTeam := ManualTeam.Text
    StrategyPathCopy:=StrategyPath.text
    CoordinatesPathCopy:=CoordinatesPath.text
    TeamPathCopy:=TeamPath.text
    try FileMove StrategyPathCopy , A_ScriptDir . "\Data\Config\" . SelectedModeSearch . "\" . SelectedMapSearch , 1
    try FileMove TeamPathCopy, A_ScriptDir . "\Data\Config\Team\" . SelectedTeam . ".txt" , 1
    try FileMove CoordinatesPathCopy, A_ScriptDir . "\Data\Config\" . SelectedModeSearch . "\" . SelectedMapSearch , 1
    MsgBox("Imported Successfully")
}   

AddFileSection(GuiObj, Label, Ty, Ey, By, &EditObj, ExtraAction?) {
    GuiObj.AddText("x10 y" Ty, Label)
    EditObj := GuiObj.AddEdit("x10 y" Ey " w300 Background" . BackgroundColor . " c" . TextColor " ReadOnly") 
    GuiObj.AddText("x10 y" By " w80 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Browse").OnEvent("Click", (*) => CustomFileSelect(EditObj, ExtraAction ?? ""))
}
CustomFileSelect(TargetEdit, ExtraAction := "") {
    Selected := FileSelect(3, A_ScriptDir "\ImportConfigs", "Select file", "All Files (*.*)")
    if (Selected != "") {
        TargetEdit.Value := Selected
    if HasMethod(ExtraAction)
        ExtraAction(Selected)
    }
}
UpdateStrategyDisplay(FilePath) 
{
    try {
        FileContent := FileRead(FilePath)
        DisplayStrategy.Delete()
        FilteredLines := []
        Loop Parse, FileContent, "`n", "`r" 
        {
            if (A_LoopField != "" && !InStr(A_LoopField, "None|None|0|None|None|0"))
                FilteredLines.Push(A_LoopField)
        }
    }
    if (FilteredLines.Length > 0)
    {
            DisplayStrategy.Add(FilteredLines) 
    }
} 

ImportMountForCid(*)
{
    UpdateSaveFile()
    loop files, ImportConfigs "\" SelectedConfigFolder "\Mount\*.txt" , "F"
    {
        ListOfMountsImport.Push(A_LoopFileName)
    }
    if (ListOfMountsImport.Length=0)
    {
        MsgBox("No mounts found in " SelectedConfigFolder "folder")
    }
    else if (SelectedConfigFolder="Mounts")
    {
        FileCopy ImportConfigs . "\" . SelectedConfigFolder . "\Mount\"  , A_ScriptDir . "\Data\Roblox\Mount" , 1
        MsgBox("Successfully imported all mounts")  
    }
    else
    {
        try FileMove ImportConfigs . "\" . SelectedConfigFolder . "\Mount\"  , A_ScriptDir . "\Data\Roblox\Mount" , 1
        MsgBox("Successfully imported all mounts")
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
DeleteFolderIfNoTxt(*)
{
    UpdateSaveFile()
    IsConfigFolderEmpty:=""
    loop files, PathToDeleteFodler . "\*.txt" , "RF"
    {
        IsConfigFolderEmpty:=A_LoopFileName
        break
    }
    if (IsConfigFolderEmpty = "")
    {
        if (PathToDeleteFodler != A_ScriptDir . "\ImportConfigs\")
        {
        try DirDelete(PathToDeleteFodler , 1)
        }
    } 
}
DownloadConfig(*)
{
    global DownloadLinkManual:=LinkToConfig.Text
    If (DownloadLinkManual != "")
    {
        Download(DownloadLinkManual , ImportConfigs . "\Downloaded Config.zip")
        UnZip()
        Sleep 400
        MsgBox("Successfully downloaded config")
    }
    else if (DownloadLinkAuto = "https://drive.google.com/uc?export=download&id=1xY14y9xfrTQJbZPx5C-g3Jh-qJ3f2NnP")
    {
        if MsgBox("This will automatically apply config. `nYOUR DATA/CONFIGS WILL BE REPLACED. `nPls make backup if you dont want to loose it`n`nDo you want to continue?",, "YesNo") = "Yes"
        {
            Download(DownloadLinkAuto , ImportConfigs . "\Downloaded Config.zip")
            Sleep 200
            UnZip()
            Sleep 400
            loop files ImportConfigs . "\P2W Meri\*" , "D"
            {
                DirMove A_LoopFileFullPath , A_ScriptDir . "\Data\Config" , 1
            }
            MsgBox("Successfully imported config")
            DirDelete ImportConfigs . "\P2W Meri" , true
        }
    }
    else if (DownloadLinkAuto = "https://drive.google.com/uc?export=download&id=1z7nfHRuxSQJ0lUfdptlKKv-3bQDTHZ0C")
    {
        if MsgBox("This will automatically apply config. `nYOUR DATA/CONFIGS WILL BE REPLACED. `nPls make backup if you dont want to loose it`n`nDo you want to continue?",, "YesNo") = "Yes"
        {
            Download(DownloadLinkAuto , ImportConfigs . "\Downloaded Config.zip")
            Sleep 200
            UnZip()
            Sleep 400
            loop files ImportConfigs . "\F2P Meri\*" , "D"
            {
                DirMove A_LoopFileFullPath , A_ScriptDir . "\Data\Config" , 1
            }
            MsgBox("Successfully imported config")
            DirDelete ImportConfigs . "\F2P Meri" , true
        }      
    }   
    else If (DownloadLinkAuto !="")
    {

            Download(DownloadLinkAuto , ImportConfigs . "\Downloaded Config.zip")
            Sleep 200
            UnZip()
            Sleep 400
            MsgBox("Successfully downloaded config")
    }
    else
    {
        MsgBox("Link is empty")
    }
}

FilterConfig:=[]
; Data for popular configs
global ConfigData := [
    { name: "Anni act 9(Cheez) 2:00 CT", image: "\Assets\CheezAct9.png", gamemode: "Event Anni" , y_start: 80,  x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1vejTGJpCf70PB5AgC3bEBwVQxGo_ueu8", discordLink: "https://discord.com/channels/1309512479386243072/1436697408582189128" },
    { name: "Escanor All Rifts(Hiccup)", image: "\Assets\EscanorAllRifts.png", gamemode: "Rift" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1Li-uKHP29GjytDeZJHbl8KRA9_A_Jc4q", discordLink: "https://discord.com/channels/1309512479386243072/1438337915645333604" },
    { name: "Anni act 9(Anself) 1:50 CT", image: "\Assets\AnsAct9.png",  gamemode: "Event Anni" ,y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1Q1A6I5fKXz0SEb-eakEKLgGanjbzqlrk", discordLink: "https://discord.com/channels/1309512479386243072/1449132950762422445" },
    { name: "Escanor Solo Cid Act 2(Hiccup) 5:00 CT", image: "\Assets\EscanorAllRifts.png",  gamemode: "Raid" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1kxHoylw0ZaH6aFKF2YNIiFivPo8EWYtg", discordLink: "https://discord.com/channels/1309512479386243072/1435817560011706442" },
    { name: "Jeju_Island(Hiccup) 20:00 CT",    image: "\Assets\JejuIslandHiccup.png",  gamemode: "Dungeon" ,  y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1n1Z8Nbsc8jEyr3JLK_F2M-kINBRHIcmx", discordLink: "https://discord.com/channels/1309512479386243072/1445200628602245294" }, 
    { name: "Dio OH Cid Act 2 (Hiccup) 8:00 CT", image: "\Assets\DIoCidAct2.png",  gamemode: "Raid" ,y_start: 220,  x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1apsf_8bUn2yehHc3eY6SzqNfHoUVykEp", discordLink: "https://discord.com/channels/1309512479386243072/1445911411279794297" },
    { name: "Broly Cid Act 2 (Royam) 7:00 CT",   image: "\Assets\BrolyCidAct2.png",  gamemode: "Raid" ,y_start: 360, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1kOcbQmr4A3EfL25SS9mrcgx3YRpOQQTO", discordLink: "https://discord.com/channels/1309512479386243072/1442204386020298923" },
    { name: "Frozen Volcano Freeza",   image: "\Assets\FreezaFrozenVolcano.png",   gamemode: "Dungeon" ,y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1reMrrVfvRWgFFxmi7tV9YF8dw_rbc9rv", discordLink: "https://discord.com/channels/1309512479386243072/1374915274855284798" },
    { name: "Merikatori P2W config", image:"\Assets\MeriConfig.png", gamemode: "All" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1xY14y9xfrTQJbZPx5C-g3Jh-qJ3f2NnP", discordLink: "https://discord.com/channels/1309512479386243072/1435701109980266668"},
    { name: "Merikatori F2P config", image:"\Assets\MeriConfig.png", gamemode: "All", y_start: 80, x_col: 2, downloadLink: "https://drive.google.com/uc?export=download&id=1z7nfHRuxSQJ0lUfdptlKKv-3bQDTHZ0C", discordLink: "https://discord.com/channels/1309512479386243072/1435701109980266668"},
    { name: "Fall Infinite (Kxizen)", image:"\Assets\FallInfKxizen.png",  gamemode: "Infinite" , y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1OJlvUCkE-Xjm4MCeNmY1edkG7zDCqzoZ", discordLink: "https://discord.com/channels/1309512479386243072/1448913041638035576"},
    { name: "Fall Regular 3 Monarchs (Hiccup) 9:00 CT", image:"\Assets\FallRegular3Mon.png", gamemode: "Event Ainz" ,y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1CjwD8hzDjRg3XnlXsaO92sheEwCl53Uw", discordLink: "https://discord.com/channels/1309512479386243072/1449833858324369409"},
    { name: "Fall Infinite (FunnyValentine)", image:"\Assets\FallInfValentine.png",  gamemode: "Infinite" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1NY0VkL62fLoUyXk7Vs8Tq0SGm4NcI2FN", discordLink:"https://discord.com/channels/1309512479386243072/1458687130623541248"}
]
X_COL1_TEXT := 30
X_COL1_BUTTONS := 450
X_COL2_TEXT := 600
X_COL3_TEXT:= 1180   
X_COL2_BUTTONS := 1030 
X_COL3_BUTTONS := 1610
BUTTON_WIDTH := 130
PIC_HEIGHT := 90
PopularConfigGui := Gui("-Caption")
PopularConfigGui.BackColor := BackgroundColor
PopularConfigGui.SetFont("cffffff s15", "Arial")
TabCtrl := PopularConfigGui.Add("Tab3", "w1170 h530 +Border", ["Rift", "Raid" ,"Dungeon","Event Anni","Event Ainz","Portals","Boss Rush","Legend Stage","Infinite","Merikatori aio configs"])
TabCtrl.SetFont("bold " . "c" TextColor . " s15", "Arial")
PopularConfigGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
TabCtrl.UseTab(1)
AutoImportCheckBox:=PopularConfigGui.AddCheckbox("x930 y500 vAutoImport" , "Auto import downloaded configs")
AutoImportCheckBox.Value := 1
AutoImport:=AutoImportCheckBox.Value
for index, config in ConfigData 
{
    if config.HasOwnProp("gamemode") and (config.gamemode != "All")
    {
        TabCtrl.UseTab(config.gamemode)
    }
    else if (config.gamemode = "All")
    {
        TabCtrl.UseTab("Merikatori AIO configs")
    }
 switch config.x_col
 {
 case 1:
    x_text := X_COL1_TEXT
    x_buttons := X_COL1_BUTTONS
 case 2:
    x_text := X_COL2_TEXT
    x_buttons := X_COL2_BUTTONS
 case 3:
    x_text := X_COL3_TEXT
    x_buttons := X_COL3_BUTTONS
 }
y_text := config.y_start
y_image := y_text + 30
y_download := y_image
y_link := y_image + 60 
link_btn := PopularConfigGui.AddText("x" . x_buttons . " y" . y_link . " w" . BUTTON_WIDTH . " h35 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Link to config")
OpenDiscordLink(url, *) {
    Run(url)
}
link_btn.OnEvent("Click", OpenDiscordLink.Bind(config.discordLink))
CloseButton2:=PopularConfigGui.AddText("x500 y500 w200 h30 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Close")
CloseButton2.OnEvent("Click",(*) => PopularConfigGui.Hide())
PopularConfigGui.AddText("x" . x_text . " y" . y_text, config.name)
PopularConfigGui.AddPicture("x" . x_text . " y" . y_image . " w400 h" . PIC_HEIGHT, A_ScriptDir . config.image)
download_btn := PopularConfigGui.AddText("x" . x_buttons . " y" . y_download . " w" . BUTTON_WIDTH . " h35 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Download Config")
download_btn.OnEvent("Click", DownloadConfigHandler.Bind(config.downloadLink))
OnMessage(0x201, EnableDrag)
}
DownloadConfigHandler(url, *)
{
    global DownloadLinkAuto := url 
    DownloadConfig()
    if (AutoImportCheckBox.Value = 1)
    {
        LatestPath := ""
        LatestTime := 0
        Loop Files, ImportConfigs . "\*", "D" 
        {
        if (A_LoopFileTimeCreated > LatestTime) 
        {
            LatestTime := A_LoopFileTimeCreated
            LatestPath := A_LoopFileName
        }
        }
        global SelectedConfigFolder:=LatestPath
        AutoDetectRead:=FileRead(ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt") 
        Lines := StrSplit(AutoDetectRead, "`n", "`r") 
        global AutoGamemode:=Lines[1]
        global AutoMap:=Lines[2]
        global SelectedModeSearch:=AutoGamemode
        global SelectedMapSearch:=AutoMap
        global SelectedMode:=1
        global SelectedMap:=1
        v:=Gui("-Caption 2 +AlwaysOnTop")
        v.SetFont("bold c1E1E1E s9", "Arial")
        v.BackColor:= BackgroundColor
        v.AddText("X10 y10 Center c" . TextColor , "Select Team")
        TeamAuto:=v.AddDropDownList("vTeamAuto w130 Background" . BackgroundColor . " c" . TextColor,["Team1", "Team2", "Team3", "Team4", "Team5", "Team6", "Team7", "Team8",])
        ImportTeamButton:=v.Add("Text", "x45 y70 w70 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Import").OnEvent("Click" , (*) => Pause(0))
        v.Show()
        Pause
        global SelectedTeam:=TeamAuto.Text
        v.Destroy()
        SearchConfigs()
        Import()
        DirDelete(ImportConfigs . "\" . LatestPath , 1)
    }
}
UpdateColors(*)
{
FileContent := FileRead(A_ScriptDir . "\GuiSettings.txt") 
Lines := StrSplit(FileContent, "`n", "`r") 
global BackgroundColor:=Lines[6]
global TextColor:=Lines[7]
}
CreateAllFolders()
UpdateColors()
UpdateSaveFile()
MyGui.Show()

