#define PLUGIN_VERSION "0.1.0"

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

char g_cMap[128];

public Plugin myinfo = 
{
	name = "Map and Player Status",
	author = "NoAiOne",
	description = "Check the current status and player of the map",
	version = PLUGIN_VERSION,
	url = "https://github.com/noaione/SourcemodPlugins"
};

public void OnPluginStart()
{
    // Map info
    RegConsoleCmd("sm_current", Command_MapCurrent, "Get current map information");

    // Player info
    RegConsoleCmd("sm_status", Command_PlayerStatus, "Get all player active in the lobby");
    RegConsoleCmd("sm_players", Command_PlayerStatus, "Get all player active in the lobby");
}

char[] ActualMapName(char[] map)
{
    char cMapName[256];
    if (map[0] == 'c')
    {
        bool wrapIt = true;
        if (strcmp(map, "c1m1_hotel"))
        {
            cMapName = "Dead Center - The Hotel";
        }
        else if (strcmp(map, "c1m2_streets"))
        {
            cMapName = "Dead Center - The Streets";
        }
        else if (strcmp(map, "c1m3_mall"))
        {
            cMapName = "Dead Center - The Mall";
        }
        else if (strcmp(map, "c1m4_atrium"))
        {
            cMapName = "Dead Center - Atrium Finale";
        }
        else if (strcmp(map, "c2m1_highway"))
        {
            cMapName = "Dead Carnival - The Highway";
        }
        else if (strcmp(map, "c2m2_fairgrounds"))
        {
            cMapName = "Dead Carnival - The Fairgrounds";
        }
        else if (strcmp(map, "c2m3_coaster"))
        {
            cMapName = "Dead Carnival - The Coaster";
        }
        else if (strcmp(map, "c2m4_barns"))
        {
            cMapName = "Dead Carnival - The Barns";
        }
        else if (strcmp(map, "c2m5_concert"))
        {
            cMapName = "Dead Carnival - The Concert";
        }
        else if (strcmp(map, "c3m1_plankcountry"))
        {
            cMapName = "Swamp Fever - Plank Country";
        }
        else if (strcmp(map, "c3m2_swamp"))
        {
            cMapName = "Swamp Fever - The Swamp";
        }
        else if (strcmp(map, "c3m3_shantytown"))
        {
            cMapName = "Swamp Fever - The Shantytown";
        }
        else if (strcmp(map, "c3m4_plantation"))
        {
            cMapName = "Swamp Fever - The Plantation";
        }
        else if (strcmp(map, "c4m1_milltown_a"))
        {
            cMapName = "Hard Rain - The Milltown";
        }
        else if (strcmp(map, "c4m2_sugarmill_a"))
        {
            cMapName = "Hard Rain - The Sugar Mill";
        }
        else if (strcmp(map, "c4m3_sugarmill_b"))
        {
            cMapName = "Hard Rain - Mill Escape";
        }
        else if (strcmp(map, "c4m4_milltown_b"))
        {
            cMapName = "Hard Rainl - Return to Town";
        }
        else if (strcmp(map, "c4m5_milltown_escape"))
        {
            cMapName = "Hard Rain - Town Escape";
        }
        else if (strcmp(map, "c5m1_waterfront"))
        {
            cMapName = "The Parish - The Waterfront";
        }
        else if (strcmp(map, "c5m2_park"))
        {
            cMapName = "The Parish - The Park";
        }
        else if (strcmp(map, "c5m3_cemetery"))
        {
            cMapName = "The Parish - The Cemetery";
        }
        else if (strcmp(map, "c5m4_quarter"))
        {
            cMapName = "The Parish - The Quarter";
        }
        else if (strcmp(map, "c5m5_bridge"))
        {
            cMapName = "The Parish - The Bridge";
        }
        else if (strcmp(map, "c6m1_riverbank"))
        {
            cMapName = "The Passing - The Riverbank";
        }
        else if (strcmp(map, "c6m2_bedlam"))
        {
            cMapName = "The Passing - The Underground";
        }
        else if (strcmp(map, "c6m3_port"))
        {
            cMapName = "The Passing - The Port";
        }
        else if (strcmp(map, "c7m1_docks"))
        {
            cMapName = "The Sacrifice - The Docks";
        }
        else if (strcmp(map, "c7m2_barge"))
        {
            cMapName = "The Sacrifice - The Barge";
        }
        else if (strcmp(map, "c7m3_port"))
        {
            cMapName = "The Sacrifice - The Port";
        }
        else if (strcmp(map, "c8m1_apartment"))
        {
            cMapName = "No Mercy - The Apartment";
        }
        else if (strcmp(map, "c8m2_subway"))
        {
            cMapName = "No Mercy - The Subway";
        }
        else if (strcmp(map, "c8m3_sewers"))
        {
            cMapName = "No Mercy - The Sewer";
        }
        else if (strcmp(map, "c8m4_interior"))
        {
            cMapName = "No Mercy - The Hospital";
        }
        else if (strcmp(map, "c8m5_rooftop"))
        {
            cMapName = "No Mercy - Rooftop Finale";
        }
        else if (strcmp(map, "c9m1_alleys"))
        {
            cMapName = "Crash Course - The Alleys";
        }
        else if (strcmp(map, "c9m2_lots"))
        {
            cMapName = "Crash Course - The Truck Depot Finale";
        }
        else if (strcmp(map, "c10m1_caves"))
        {
            cMapName = "Death Toll - The Turnpike";
        }
        else if (strcmp(map, "c10m2_drainage"))
        {
            cMapName = "Death Toll - The Drains";
        }
        else if (strcmp(map, "c10m3_ranchhouse"))
        {
            cMapName = "Death Toll - The Church";
        }
        else if (strcmp(map, "c10m4_mainstreet"))
        {
            cMapName = "Death Toll - The Town";
        }
        else if (strcmp(map, "c10m5_houseboat"))
        {
            cMapName = "Death Toll - Boathouse Finale";
        }
        else if (strcmp(map, "c11m1_greenhouse"))
        {
            cMapName = "Dead Air - The Turnpike";
        }
        else if (strcmp(map, "c11m2_offices"))
        {
            cMapName = "Dead Air - The Crane";
        }
        else if (strcmp(map, "c11m3_garage"))
        {
            cMapName = "Dead Air - The Construction Site";
        }
        else if (strcmp(map, "c11m4_terminal"))
        {
            cMapName = "Dead Air - The Terminal";
        }
        else if (strcmp(map, "c11m5_runway"))
        {
            cMapName = "Dead Air - Runway Finale";
        }
        else if (strcmp(map, "c12m1_hilltop"))
        {
            cMapName = "Blood Harvest - The Woods";
        }
        else if (strcmp(map, "c12m2_traintunnel"))
        {
            cMapName = "Blood Harvest - The Tunnel";
        }
        else if (strcmp(map, "c12m3_bridge"))
        {
            cMapName = "Blood Harvest - The Bridge";
        }
        else if (strcmp(map, "c12m4_barn"))
        {
            cMapName = "Blood Harvest - The Train Station";
        }
        else if (strcmp(map, "c12m5_cornfield"))
        {
            cMapName = "Blood Harvest - Farmhouse Finale";
        }
        else if (strcmp(map, "c13m1_alpinecreek"))
        {
            cMapName = "Cold Stream - Alpine Creek";
        }
        else if (strcmp(map, "c13m2_southpinestream"))
        {
            cMapName = "Cold Stream - South Pine Stream";
        }
        else if (strcmp(map, "c13m3_memorialbridge"))
        {
            cMapName = "Cold Stream - Memorial Bridge";
        }
        else if (strcmp(map, "c13m4_cutthroatcreek"))
        {
            cMapName = "Cold Stream - Cut-throat Creek";
        }
        else if (strcmp(map, "c14m1_junkyard"))
        {
            cMapName = "The Last Stand - The Junkyard";
        }
        else if (strcmp(map, "c14m2_lighthouse"))
        {
            cMapName = "The Last Stand - Lighthouse Finale";
        }
        else
        {
            strcopy(cMapName, sizeof(cMapName), map);
            wrapIt = false;
        }
        if (wrapIt)
        {
            char[] wrapName = new char[strlen(map) + 5];
            Format(wrapName, strlen(map) + 5, " (%s)", map);
            StrCat(cMapName, sizeof(cMapName), wrapName);
        }
    }
    else
    {
        strcopy(cMapName, sizeof(cMapName), map);
        StrCat(cMapName, sizeof(cMapName), " (Custom)");
    }
    return cMapName;
}

public void OnMapStart()
{
    GetCurrentMap(g_cMap, sizeof(g_cMap));
    PrintToServer("[N4OMap] Map changing to: %s", g_cMap);
}

public Action Command_MapCurrent(int client, int args)
{
    if (IsNullString(g_cMap))
    {
        return Plugin_Handled;
    }
    if (g_cMap[0] == '\0')
    {
        return Plugin_Handled;
    }
    PrintToChat(client, "Current map: %s", ActualMapName(g_cMap));

    return Plugin_Handled;
}

public Action Command_PlayerStatus(int client, int args)
{
    char cBuffer[266 * (MAXPLAYERS)];
    int pCounter = 1;
    bool anyPlayer = false;
    bool firstTime = true;
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && !IsFakeClient(i))
        {
            char playerName[256];
            GetClientName(i, playerName, sizeof(playerName));
            char playerAndNumber[266];
            if (i == client)
            {
                Format(playerAndNumber, sizeof(playerAndNumber), "%d. %s (You)\n", pCounter, playerName);
            }
            else
            {
                Format(playerAndNumber, sizeof(playerAndNumber), "%d. %s\n", pCounter, playerName);
            }
            if (firstTime)
            {
                firstTime = false;
                strcopy(cBuffer, sizeof(cBuffer), playerAndNumber);
            }
            else
            {
                StrCat(cBuffer, sizeof(cBuffer), playerAndNumber);
            }
            pCounter += 1;
            anyPlayer = true;
        }
    }
    if (!anyPlayer)
    {
        PrintToServer("[N4OMap] No player in the lobby");
    }
    else
    {
        int maxChar = strlen(cBuffer);
        // Remove the last \n
        cBuffer[maxChar - 1] = '\0';
        PrintToChat(client, "Active Players:\n%s", cBuffer);
    }
    return Plugin_Handled;
}
