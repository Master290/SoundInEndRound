#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <clientprefs>

#pragma newdecls required
#pragma semicolon 1

Handle mvp_SongPlayer;

public Plugin myinfo =
{
	name = "SoundInEndRound",
	author = "Cahid Armatura",
	description = "Played sound in end round",
	version = "1.0.0",
	url = "https://github.com/zloybik"
}

public void OnPluginStart() {
    RegConsoleCmd("sm_music", ChooseMusic, "Player equiping any music in the list");
    mvp_SongPlayer = RegClientCookie("mvp_song", "Song choosed and saved player", CookieAccess_Private);
    HookEvent("round_mvp", RoundMusicStart);
}

public void OnMapStart() {
    AddFileToDownloadsTable("sound/mvps/kali.mp3");
    AddFileToDownloadsTable("sound/mvps/signalizaciya.mp3");
    AddFileToDownloadsTable("sound/mvps/OMG.mp3");
    FakePrecacheSound("*/mvps/kali.mp3");
    FakePrecacheSound("*/mvps/signalizaciya.mp3");
    FakePrecacheSound("*/mvps/OMG.mp3");
}

public Action RoundMusicStart(Event event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(event.GetInt("userid"));
    char MusicChoosed[64];
    GetClientCookie(client, mvp_SongPlayer, MusicChoosed, sizeof(MusicChoosed));
    char nickname[32];
    GetClientName(client, nickname, sizeof(nickname));

    if(StrEqual(MusicChoosed, "0")) {
        //... nothing
    }
    else if(StrEqual(MusicChoosed, "1")) {
        ClientCommand(client, "playgamesound Music.StopAllMusic");
        EmitSoundToAll("*/mvps/kali.mp3");
        PrintCenterTextAll("Playing: kali - bubad. Music choosed by %s", nickname);
    }
    else if(StrEqual(MusicChoosed, "2")) {
        ClientCommand(client, "playgamesound Music.StopAllMusic");
        EmitSoundToAll("*/mvps/OMG.mp3");
        PrintCenterTextAll("Playing: OMG - bubad. Music choosed by %s", nickname);
    }
    else if(StrEqual(MusicChoosed, "3")) {
        ClientCommand(client, "playgamesound Music.StopAllMusic");
        EmitSoundToAll("*/mvps/signalizaciya.mp3");
        PrintCenterTextAll("Playing: Signalizaciya - bubad. Music choosed by %s", nickname);
    }

    return Plugin_Handled;
}

void FakePrecacheSound(const char[] szPath)
{
	AddToStringTable(FindStringTable("soundprecache"), szPath);
}

public Action ChooseMusic(int client, int args) {
    Menu menu = CreateMenu(Menu_Callback);
    menu.SetTitle("Choose music");
    menu.AddItem("Nothing", "Nothing");
    menu.AddItem("Music1", "kali - bubad");
    menu.AddItem("Music2", "OMG - bubad");
    menu.AddItem("Music3", "Signalizaciya - bubad");
    menu.Display(client, 60);
    return Plugin_Handled;
}

public int Menu_Callback(Menu menu, MenuAction action, int param1, int param2) {
    switch(action) {
        case MenuAction_Select: 
        {
            char id[32];
            char music[64];
            char item[32];
            menu.GetItem(param2, item, sizeof(item));

            if(StrEqual("Nothing", item)) {
                id = "0";
                SetClientCookie(param1, mvp_SongPlayer, id);
                PrintToChat(param1, "\x01[\x02MVP by Cahid\x01]: You set on MVP Music named: \x04 Nothing");
            }
            else if(StrEqual("Music1", item)) {
                id = "1";
                SetClientCookie(param1, mvp_SongPlayer, id);
                PrintToChat(param1, "\x01[\x02MVP by Cahid\x01]: You set on MVP Music named: \x04 kali - bubad");
            }
            else if(StrEqual("Music2", item)) {
                id = "2";
                SetClientCookie(param1, mvp_SongPlayer, id);
                PrintToChat(param1, "\x01[\x02MVP by Cahid\x01]: You set on MVP Music named: \x04 OMG - bubad");
            }
            else if(StrEqual("Music3", item)) {
                id = "3";
                SetClientCookie(param1, mvp_SongPlayer, id);
                PrintToChat(param1, "\x01[\x02MVP by Cahid\x01]: You set on MVP Music named: \x04 Signalizaciya - bubad");
            }
        }
        case MenuAction_End:
        {
            delete menu;
        }
    }
}