#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ConfigHelper.ahk
#Include  DeepLink.ahk
UpdateVariable(*) 
{     
    global AutoImport := AutoImportCheckBox.Value 
}
; Data for popular configs
PopularConfigGuiShow(*)
{
UpdateColors()
global AutoImport:=1
global ConfigData := []
global PopularConfigGui := Gui("-Caption")
IniFile := A_ScriptDir "\configs.ini"
Loop Parse, IniRead(IniFile), "`n", "`r" 
    {
        sec := A_LoopField
        if (sec = "")
            continue
        ConfigData.Push({
            name:         IniRead(IniFile, sec, "name"),
            image:        IniRead(IniFile, sec, "image"),
            gamemode:     IniRead(IniFile, sec, "gamemode"),
            y_start:      Number(IniRead(IniFile, sec, "y_start", 80)),
            x_col:        Number(IniRead(IniFile, sec, "x_col", 1)),
            downloadLink: IniRead(IniFile, sec, "downloadLink"),
            discordLink:  IniRead(IniFile, sec, "discordLink", "")
        })
    }
X_COL1_TEXT := 30
X_COL1_BUTTONS := 450   
X_COL2_TEXT := 600
X_COL3_TEXT:= 1180   
X_COL2_BUTTONS := 1030 
X_COL3_BUTTONS := 1610
BUTTON_WIDTH := 130
PIC_HEIGHT := 90
PopularConfigGui.BackColor := BackgroundColor
PopularConfigGui.SetFont("cffffff s15", "Arial")
TabCtrl := PopularConfigGui.Add("Tab3", "w1170 h530 +Border +Multi", ["Rift", "Raid" ,"Dungeon" , "Frozen port" , "Portals" , "Winter Infinite" , "Merikatori aio configs"])
TabCtrl.SetFont("bold " . "c" TextColor . " s15", "Arial")
PopularConfigGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
TabCtrl.UseTab(1)
global AutoImportCheckBox:=PopularConfigGui.AddCheckbox("x930 y500 vAutoImport" , "Auto import downloaded configs")
AutoImportCheckBox.Value := AutoImport
AutoImportCheckBox.OnEvent("Click", UpdateVariable)
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
OpenDiscordLink(url, *) 
{
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
PopularConfigGui.Show()
}
DownloadConfigHandler(url, *)
{
    global DownloadLinkAuto := url 
    DownloadConfig()
    if (AutoImport = 1 ) && (DownloadLinkAuto != "https://drive.google.com/uc?export=download&id=1-f7dQKIrmerFGAK8LQQYqGhTwTyfmrk0") && (DownloadLinkAuto !="https://drive.google.com/uc?export=download&id=1z7nfHRuxSQJ0lUfdptlKKv-3bQDTHZ0C") 
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
        global AutoDetectRead:=FileRead(ImportConfigs . "\" . SelectedConfigFolder . "\AutoDetect.txt") 
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
        ImportTeamButton:=v.Add("Text", "x45 y80 w70 h25 Center Background" . BackgroundColor . " c" . TextColor " +Border", "Import").OnEvent("Click" , (*) => Pause(0))
        v.Show()
        Pause
        global SelectedTeam:=TeamAuto.Text
        v.Destroy()
        SearchConfigs()
        if DirExist(ImportConfigs . "\" . LatestPath . "\Mount")
        {
            FileMove ImportConfigs . "\" . LatestPath . "\Mount" , A_ScriptDir . "\Data\Roblox\Mount" , 1
        }
        Import()
        try DirDelete(ImportConfigs . "\" . LatestPath , 1)
    }
}