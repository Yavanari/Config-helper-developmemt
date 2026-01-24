#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ConfigHelper.ahk
UpdateColors()
; Data for popular configs
PopularConfigGuiShow(*)
{
global PopularConfigGui := Gui("-Caption")
global ConfigData := [
    { name: "Anni act 9(Cheez) 2:00 CT", image: "\Assets\CheezAct9.png", gamemode: "Event Anni" , y_start: 80,  x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1vejTGJpCf70PB5AgC3bEBwVQxGo_ueu8", discordLink: "https://discord.com/channels/1309512479386243072/1436697408582189128" },
    { name: "Escanor All Rifts(Hiccup) NO ONE PIECE RIFT", image: "\Assets\EscanorAllRifts.png", gamemode: "Rift" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1Li-uKHP29GjytDeZJHbl8KRA9_A_Jc4q", discordLink: "https://discord.com/channels/1309512479386243072/1438337915645333604" },
    { name: "Anni act 9(Anself) 1:50 CT", image: "\Assets\AnsAct9.png",  gamemode: "Event Anni" ,y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1Q1A6I5fKXz0SEb-eakEKLgGanjbzqlrk", discordLink: "https://discord.com/channels/1309512479386243072/1449132950762422445" },
    { name: "Escanor Solo Cid Act 2(Hiccup) 5:00 CT", image: "\Assets\EscanorAllRifts.png",  gamemode: "Raid" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1kxHoylw0ZaH6aFKF2YNIiFivPo8EWYtg", discordLink: "https://discord.com/channels/1309512479386243072/1435817560011706442" },
    { name: "Jeju_Island(Hiccup) 20:00 CT",    image: "\Assets\JejuIslandHiccup.png",  gamemode: "Dungeon" ,  y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1n1Z8Nbsc8jEyr3JLK_F2M-kINBRHIcmx", discordLink: "https://discord.com/channels/1309512479386243072/1445200628602245294" }, 
    { name: "Dio OH Cid Act 2 (Hiccup) 8:00 CT", image: "\Assets\DIoCidAct2.png",  gamemode: "Raid" ,y_start: 220,  x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1apsf_8bUn2yehHc3eY6SzqNfHoUVykEp", discordLink: "https://discord.com/channels/1309512479386243072/1445911411279794297" },
    { name: "Sasuke Cid Act 2 (Gnoemy) ~2:45 CT",   image: "\Assets\CidSasuke.png",  gamemode: "Raid" ,y_start: 360, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1ftWyLr4bNA6RNx6Ft37MAwcI7VgVh8d9", discordLink: "https://discord.com/channels/1309512479386243072/1444442525359276192" },
    { name: "Frozen Volcano Freeza",   image: "\Assets\FreezaFrozenVolcano.png",   gamemode: "Dungeon" ,y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1reMrrVfvRWgFFxmi7tV9YF8dw_rbc9rv", discordLink: "https://discord.com/channels/1309512479386243072/1374915274855284798" },
    { name: "Merikatori P2W config", image:"\Assets\MeriConfig.png", gamemode: "All" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1-f7dQKIrmerFGAK8LQQYqGhTwTyfmrk0", discordLink: "https://discord.com/channels/1309512479386243072/1435701109980266668"},
    { name: "Merikatori F2P config", image:"\Assets\MeriConfig.png", gamemode: "All", y_start: 80, x_col: 2, downloadLink: "https://drive.google.com/uc?export=download&id=1z7nfHRuxSQJ0lUfdptlKKv-3bQDTHZ0C", discordLink: "https://discord.com/channels/1309512479386243072/1435701109980266668"},
    { name: "Fall Infinite (Kxizen)", image:"\Assets\FallInfKxizen.png",  gamemode: "Infinite" , y_start: 220, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1OJlvUCkE-Xjm4MCeNmY1edkG7zDCqzoZ", discordLink: "https://discord.com/channels/1309512479386243072/1448913041638035576"},
    { name: "Fall Regular 3 Monarchs (Hiccup) 9:00 CT", image:"\Assets\FallRegular3Mon.png", gamemode: "Event Ainz" ,y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1CjwD8hzDjRg3XnlXsaO92sheEwCl53Uw", discordLink: "https://discord.com/channels/1309512479386243072/1449833858324369409"},
    { name: "Fall Infinite (FunnyValentine)", image:"\Assets\FallInfValentine.png",  gamemode: "Infinite" , y_start: 80, x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=1PcG5k6KUCLcWH2gobI1uR1FJ2rLWvBPg", discordLink:"https://discord.com/channels/1309512479386243072/1458687130623541248"},
    { name: "Solo Escanor HAPPY Factory(Zad) ~5:30 CT" , image: "\Assets\EscanorAllRifts.png" , gamemode: "Raid" , y_start: 80, x_col: 2, downloadLink: "https://drive.google.com/uc?export=download&id=1RpUG_mC0zlDv1Jy0-o1N06p34NDUt6RX", discordLink:""},
    { name: "Frozen Port wave 20 reset(Alligator) ~12:00 CT" , image:"\Assets\MeriConfig.png", gamemode: "Frozen Port" , y_start: 80 , x_col: 1, downloadLink: "https://drive.google.com/uc?export=download&id=179TM6I9KyNxt_WT9V7W7whdbavnI4BPI", discordLink: "https://discord.com/channels/1309512479386243072/1460623551789924535" },
    { name: "Shank's rift(Mericatori) READ INFO IN CONFIG LINK" , image: "\Assets\ShanksRiftMeri.png", gamemode: "Rift",  y_start: 220, x_col: 1, downloadlink: " https://drive.google.com/uc?export=download&id=1vSf7U661bKJLWMlMSNsf4HxN6OfieTwq" , discordlink: "https://discord.com/channels/1309512479386243072/1460690201029644394"},
    { name: "One piece rift Uma(Mericatori)" , image: "\Assets\RiftUmaMeri.png" , gamemode: "Rift" , y_start: 360 , x_col: 1 , downloadLink: "https://drive.google.com/uc?export=download&id=1WrQoBeo812BZRmLaZt6mS4fRdd3Pa7N6" , discordLink: "https://discord.com/channels/1309512479386243072/1461428543220088968"},
    { name: "Anni act 9(Nika) 1:40 CT" , image: "\Assets\NikaAct9.png" , gamemode: "Event Anni" , y_start: 360 , x_col: 1 , downloadLink: "https://drive.google.com/uc?export=download&id=1_QHrobJqD9Wn8iMyxiAc2L5VFY09GQof" , discordLink: "https://discord.com/channels/1309512479386243072/1461442177635975198"}

]
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
TabCtrl := PopularConfigGui.Add("Tab3", "w1170 h530 +Border +Multi", ["Rift", "Raid" ,"Dungeon","Frozen port" , "Event Anni","Event Ainz","Portals","Infinite","Merikatori aio configs"])
TabCtrl.SetFont("bold " . "c" TextColor . " s15", "Arial")
PopularConfigGui.SetFont("bold " . "c" TextColor . " s11", "Arial")
TabCtrl.UseTab(1)
global AutoImportCheckBox:=PopularConfigGui.AddCheckbox("x930 y500 vAutoImport" , "Auto import downloaded configs")
AutoImportCheckBox.Value := 1
global AutoImport:=AutoImportCheckBox.Value
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
DownloadConfigHandler(url, *)
{
    global DownloadLinkAuto := url 
    DownloadConfig()
    if (AutoImportCheckBox.Value = 1 ) && (DownloadLinkAuto != "https://drive.google.com/uc?export=download&id=1-f7dQKIrmerFGAK8LQQYqGhTwTyfmrk0") && (DownloadLinkAuto !="https://drive.google.com/uc?export=download&id=1z7nfHRuxSQJ0lUfdptlKKv-3bQDTHZ0C")
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
PopularConfigGui.Show()
}
