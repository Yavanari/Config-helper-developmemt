#Requires AutoHotkey v2.0
#Include ConfigHelper.ahk
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

