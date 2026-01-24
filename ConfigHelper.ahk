#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
#Include AntiGreenieProtection.ahk
#Include ManualImporting.ahk
#Include PopularConfigs.ahk
#Include GreenieGuide.ahk
global AutoMap:=""
global AutoGamemode:=""
;ADD "AntiGreenie" FUNCTION HERE B4 RELEASING
Antigreenie()
UpdateColors()
TraySetIcon (A_ScriptDir . "\Assets\TrayIcon.png")
global ManualImportingGui := Gui("-Caption 2 ") 
global PopularConfigGui := Gui("-Caption 2")
MyGui := Gui("-Caption 2 ")
MyGui.BackColor := BackgroundColor
TitleBar := MyGui.Add("Text", "w480 h30 Center Background" . BackgroundColor . " c" . TextColor, "Config Helper")
TitleBar.SetFont("s10 Bold", "Arial")
OnMessage(0x201, EnableDrag)
EnableDrag(wParam, lParam, msg, hwnd)
{
    try if (hwnd = MyGui.Hwnd) or (hwnd = ManualImportingGui.Hwnd) or (hwnd = PopularConfigGui.Hwnd) or (hwnd = GuideGui.Hwnd) or (hwnd=ImportGuideGui.Hwnd) or (hwnd=ExportGuideGui.Hwnd)
    {
        try DllCall("SendMessage", "ptr", hwnd, "uint", 0xA1, "ptr", 2, "ptr", 0)
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
Gamemode := MyGui.AddComboBox("vGamemode w130 Background" . BackgroundColor , ["Rift", "Raid", "Dungeon", "Event", "Portals", "BossRush", "LegendStage" , "Infinite"]) ; Drop down menu to choose gamemode
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
MyGui.Add("Text", "x415 y510", "Version 1.9")
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
PopularConfigButton:=MyGui.Add("Text", "x320 y154 w150 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Popular configs" ).OnEvent("Click" , PopularConfigGuiShow)
;Custom GUI button
CustomGuiButton:=MyGui.Add("Text", "x320 y194 w150 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Custom GUI colors" ).OnEvent("Click" , (*) => Run('notepad.exe "' . A_ScriptDir . '\GuiSettings.txt"'))
;Update helper
UpdateHelperButton:=MyGui.Add("Text", "x320 y233 w150 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "UpdateHelper" ).OnEvent("Click" , (*) => Run(A_ScriptDir . "\UpdateHelper.ahk"))
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
            MapsAndActs.Add(["Kuinshi_Palace", "Mountain_Shrine", "Underground_Church" , "Imprisoned_Island"]) ;Drop down list for Rift
        case 2:
            MapsAndActs.Add(["Spider_Forest", "Ruined_City", "Jojo_1", "Jojo_2" , "HAPPY_Factory"]) ;Drop down list for Cid
        case 3:
            MapsAndActs.Add(["Jeju_Island", "Frozen_Volcano"]) ;Drop down list for Dungeons
        case 4:
            MapsAndActs.Add(["Burning_Spirit_Tree", "Crystal_Chapel", "Double_Dungeon", "Golden_Castle", "Kuinshi_Palace", "Old_Lobby", "Old_Namek", "Shining_Castle", "The_Land_of_Gods", "Lich_Kings_Throne" , "Frozen_Port"]) ;Drop down list for Event
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
        MapsAndActs.Text:=ConfigMap
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
    FileCopy PathToDefaultStrategy , A_ScriptDir . "\Data\Config\Default\All" , 1
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
        RunWait('"' . UnrarExePath . '" x -y "' . SourceRar . '" "' . ImportConfigs .  '"')

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
                FileMove ImportConfigs . "\" . SelectedConfigFolder . "\Config.txt" , A_ScriptDir . "\Data\Config\"  . SelectedModeSearch 
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
try FileDelete ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt"
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
        Gamemode.Delete()
        MapsAndActs.Delete()
        Team.Delete()
        }
    } 
}
DownloadConfig(*)
{
    global DownloadLinkManual:=LinkToConfig.Text
    if (DownloadLinkManual = "") && (DownloadLinkAuto = "")
    {
        MsgBox("Link is empty")
    }
    else If (DownloadLinkManual != "")
    {
        Download(DownloadLinkManual , ImportConfigs . "\Downloaded Config.zip")
        UnZip()
        Sleep 400
        MsgBox("Successfully downloaded config")
    }
    else if (DownloadLinkAuto = "https://drive.google.com/uc?export=download&id=1-f7dQKIrmerFGAK8LQQYqGhTwTyfmrk0")
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
            DirDelete ImportConfigs . "\P2W Meri" , 1
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
            DirDelete ImportConfigs . "\F2P Meri" , 1
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
}
UpdateSaveFile()
MyGui.Show()
