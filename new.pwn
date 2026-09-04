#include <a_samp>
#include <Pawn.CMD>
#include <textdraw-streamer>

#define MAX_TEXTDRAW_MINIGAME 135

enum E_MINIGAME
{
    bool:MiniGameIsAShow,
    PlayerText:MiniGameTD[MAX_TEXTDRAW_MINIGAME],
    MiniGameBarLoadingCount,
    MiniGameLoadingBarTimer,
    MiniGameNumberTarget[MAX_TEXTDRAW_MINIGAME],
    MiniGameNumberSelect[MAX_TEXTDRAW_MINIGAME],
    MiniGameNumberTargetHidden[3],
    MiniGameNumberHiddenIndex[3],
    MiniGameNumberSelectRandTimer,
    MiniGameScore
}

new MiniGameData[MAX_PLAYERS][E_MINIGAME];

main()
{
    print("Minigame Project By Billy Simonee");
}

public OnPlayerDisconnect(playerid, reason)
{
    MiniGameData[playerid][MiniGameIsAShow] = false;

    if(MiniGameData[playerid][MiniGameLoadingBarTimer] != -1)
    {
        KillTimer(MiniGameData[playerid][MiniGameLoadingBarTimer]);
        MiniGameData[playerid][MiniGameLoadingBarTimer] = -1;
    }

    MiniGameData[playerid][MiniGameBarLoadingCount] = 0;

    MiniGameData[playerid][MiniGameIsAShow] = false;

    if(MiniGameData[playerid][MiniGameNumberSelectRandTimer] != -1)
    {
        KillTimer(MiniGameData[playerid][MiniGameNumberSelectRandTimer]);
        MiniGameData[playerid][MiniGameNumberSelectRandTimer] = -1;
    }

    for(new i = 0; i < 3; i++)
    {
        MiniGameData[playerid][MiniGameNumberTargetHidden][i] = 0;
        MiniGameData[playerid][MiniGameNumberHiddenIndex][i] = 0;
    }

    for(new i = 0; i < MAX_TEXTDRAW_MINIGAME; i++)
    {
        MiniGameData[playerid][MiniGameNumberTarget][i] = 0;
        MiniGameData[playerid][MiniGameNumberSelect][i] = 0;

        PlayerTextDrawDestroy(playerid, MiniGameData[playerid][MiniGameTD][i]);
    }
    MiniGameData[playerid][MiniGameScore] = 0;
    return 1;
}

public OnClickDynamicPlayerTextDraw(playerid, PlayerText:textid)
{
    for(new i = 1; i < 61; i++)
    {
        if(textid == MiniGameData[playerid][MiniGameTD][i])
        {
            new string[500];
            new stringTDIndex = i + 72;
            new clickedNumber = MiniGameData[playerid][MiniGameNumberSelect][stringTDIndex];
            new bool:isCorrect = false;
            new matchedTargetTDIndex = -1;

            for(new h = 0; h < 3; h++)
            {
                if(clickedNumber == MiniGameData[playerid][MiniGameNumberTargetHidden][h])
                {
                    isCorrect = true;
                    matchedTargetTDIndex = MiniGameData[playerid][MiniGameNumberHiddenIndex][h];
                    break;
                }
            }

            if(isCorrect)
            {
                if(MiniGameData[playerid][MiniGameScore] < 3)
                {
                    MiniGameData[playerid][MiniGameScore]++;
                    new matchedBoxIndex = matchedTargetTDIndex - 6;

                    format(string, sizeof(string), "%d", clickedNumber);
                    PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][matchedTargetTDIndex], string);
                    PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][matchedTargetTDIndex]);

                    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][matchedBoxIndex], 0x00FF00FF);
                    PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][matchedBoxIndex]);
                }
                else
                {
                    MiniGameData[playerid][MiniGameScore] = 0;
                    MiniGameData[playerid][MiniGameBarLoadingCount] = 100;

                    if(MiniGameData[playerid][MiniGameLoadingBarTimer] != -1)
                    {
                        KillTimer(MiniGameData[playerid][MiniGameLoadingBarTimer]);
                        MiniGameData[playerid][MiniGameLoadingBarTimer] = -1;
                    }

                    MiniGameData[playerid][MiniGameIsAShow] = false;

                    if(MiniGameData[playerid][MiniGameNumberSelectRandTimer] != -1)
                    {
                        KillTimer(MiniGameData[playerid][MiniGameNumberSelectRandTimer]);
                        MiniGameData[playerid][MiniGameNumberSelectRandTimer] = -1;
                    }

                    for(new i = 0; i < 3; i++)
                    {
                        MiniGameData[playerid][MiniGameNumberTargetHidden][i] = 0;
                        MiniGameData[playerid][MiniGameNumberHiddenIndex][i] = 0;
                    }

                    for(new i = 0; i < MAX_TEXTDRAW_MINIGAME; i++)
                    {
                        MiniGameData[playerid][MiniGameNumberTarget][i] = 0;
                        MiniGameData[playerid][MiniGameNumberSelect][i] = 0;

                        PlayerTextDrawHide(playerid, MiniGameData[playerid][MiniGameTD][i]);
                    }
                }
            }
            else
            {
                PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);

                MiniGameData[playerid][MiniGameBarLoadingCount] += 5;
                PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][134], 0xFF0000FF);
                PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][134]);

                SetTimerEx("RefreshColorBar", 1250, false, "i", playerid);
            }

            return 1;
        }
    }
    return 1;
}

stock ShowPlayerMiniGame(playerid, loading_time = 60)
{
    if(MiniGameData[playerid][MiniGameIsAShow])
        return 0;

    MiniGameData[playerid][MiniGameIsAShow] = true;

    MiniGameData[playerid][MiniGameTD][0] = CreatePlayerTextDraw(playerid, 198.000, 161.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][0], 243.000, 210.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][0], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][0], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][0], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][0], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][0], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][0], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][0], 1);

    MiniGameData[playerid][MiniGameTD][1] = CreatePlayerTextDraw(playerid, 200.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][1], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][1], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][1], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][1], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][1], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][1], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][1], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][1], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][1], 1);

    MiniGameData[playerid][MiniGameTD][2] = CreatePlayerTextDraw(playerid, 224.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][2], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][2], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][2], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][2], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][2], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][2], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][2], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][2], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][2], 1);

    MiniGameData[playerid][MiniGameTD][3] = CreatePlayerTextDraw(playerid, 248.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][3], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][3], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][3], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][3], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][3], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][3], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][3], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][3], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][3], 1);

    MiniGameData[playerid][MiniGameTD][4] = CreatePlayerTextDraw(playerid, 272.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][4], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][4], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][4], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][4], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][4], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][4], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][4], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][4], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][4], 1);

    MiniGameData[playerid][MiniGameTD][5] = CreatePlayerTextDraw(playerid, 296.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][5], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][5], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][5], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][5], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][5], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][5], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][5], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][5], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][5], 1);

    MiniGameData[playerid][MiniGameTD][6] = CreatePlayerTextDraw(playerid, 320.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][6], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][6], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][6], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][6], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][6], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][6], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][6], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][6], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][6], 1);

    MiniGameData[playerid][MiniGameTD][7] = CreatePlayerTextDraw(playerid, 344.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][7], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][7], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][7], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][7], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][7], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][7], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][7], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][7], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][7], 1);

    MiniGameData[playerid][MiniGameTD][8] = CreatePlayerTextDraw(playerid, 368.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][8], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][8], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][8], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][8], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][8], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][8], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][8], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][8], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][8], 1);

    MiniGameData[playerid][MiniGameTD][9] = CreatePlayerTextDraw(playerid, 392.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][9], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][9], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][9], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][9], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][9], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][9], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][9], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][9], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][9], 1);

    MiniGameData[playerid][MiniGameTD][10] = CreatePlayerTextDraw(playerid, 416.000, 207.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][10], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][10], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][10], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][10], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][10], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][10], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][10], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][10], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][10], 1);

    MiniGameData[playerid][MiniGameTD][11] = CreatePlayerTextDraw(playerid, 200.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][11], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][11], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][11], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][11], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][11], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][11], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][11], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][11], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][11], 1);

    MiniGameData[playerid][MiniGameTD][12] = CreatePlayerTextDraw(playerid, 224.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][12], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][12], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][12], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][12], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][12], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][12], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][12], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][12], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][12], 1);

    MiniGameData[playerid][MiniGameTD][13] = CreatePlayerTextDraw(playerid, 248.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][13], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][13], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][13], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][13], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][13], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][13], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][13], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][13], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][13], 1);

    MiniGameData[playerid][MiniGameTD][14] = CreatePlayerTextDraw(playerid, 272.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][14], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][14], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][14], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][14], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][14], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][14], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][14], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][14], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][14], 1);

    MiniGameData[playerid][MiniGameTD][15] = CreatePlayerTextDraw(playerid, 296.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][15], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][15], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][15], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][15], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][15], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][15], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][15], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][15], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][15], 1);

    MiniGameData[playerid][MiniGameTD][16] = CreatePlayerTextDraw(playerid, 320.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][16], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][16], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][16], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][16], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][16], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][16], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][16], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][16], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][16], 1);

    MiniGameData[playerid][MiniGameTD][17] = CreatePlayerTextDraw(playerid, 344.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][17], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][17], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][17], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][17], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][17], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][17], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][17], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][17], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][17], 1);

    MiniGameData[playerid][MiniGameTD][18] = CreatePlayerTextDraw(playerid, 368.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][18], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][18], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][18], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][18], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][18], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][18], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][18], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][18], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][18], 1);

    MiniGameData[playerid][MiniGameTD][19] = CreatePlayerTextDraw(playerid, 392.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][19], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][19], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][19], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][19], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][19], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][19], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][19], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][19], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][19], 1);

    MiniGameData[playerid][MiniGameTD][20] = CreatePlayerTextDraw(playerid, 416.000, 234.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][20], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][20], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][20], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][20], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][20], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][20], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][20], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][20], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][20], 1);

    MiniGameData[playerid][MiniGameTD][21] = CreatePlayerTextDraw(playerid, 200.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][21], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][21], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][21], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][21], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][21], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][21], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][21], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][21], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][21], 1);

    MiniGameData[playerid][MiniGameTD][22] = CreatePlayerTextDraw(playerid, 224.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][22], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][22], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][22], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][22], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][22], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][22], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][22], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][22], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][22], 1);

    MiniGameData[playerid][MiniGameTD][23] = CreatePlayerTextDraw(playerid, 248.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][23], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][23], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][23], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][23], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][23], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][23], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][23], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][23], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][23], 1);

    MiniGameData[playerid][MiniGameTD][24] = CreatePlayerTextDraw(playerid, 272.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][24], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][24], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][24], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][24], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][24], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][24], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][24], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][24], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][24], 1);

    MiniGameData[playerid][MiniGameTD][25] = CreatePlayerTextDraw(playerid, 296.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][25], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][25], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][25], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][25], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][25], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][25], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][25], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][25], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][25], 1);

    MiniGameData[playerid][MiniGameTD][26] = CreatePlayerTextDraw(playerid, 320.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][26], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][26], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][26], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][26], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][26], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][26], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][26], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][26], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][26], 1);

    MiniGameData[playerid][MiniGameTD][27] = CreatePlayerTextDraw(playerid, 344.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][27], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][27], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][27], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][27], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][27], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][27], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][27], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][27], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][27], 1);

    MiniGameData[playerid][MiniGameTD][28] = CreatePlayerTextDraw(playerid, 368.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][28], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][28], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][28], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][28], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][28], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][28], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][28], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][28], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][28], 1);

    MiniGameData[playerid][MiniGameTD][29] = CreatePlayerTextDraw(playerid, 392.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][29], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][29], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][29], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][29], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][29], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][29], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][29], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][29], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][29], 1);

    MiniGameData[playerid][MiniGameTD][30] = CreatePlayerTextDraw(playerid, 416.000, 261.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][30], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][30], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][30], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][30], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][30], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][30], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][30], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][30], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][30], 1);

    MiniGameData[playerid][MiniGameTD][31] = CreatePlayerTextDraw(playerid, 200.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][31], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][31], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][31], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][31], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][31], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][31], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][31], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][31], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][31], 1);

    MiniGameData[playerid][MiniGameTD][32] = CreatePlayerTextDraw(playerid, 224.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][32], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][32], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][32], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][32], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][32], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][32], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][32], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][32], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][32], 1);

    MiniGameData[playerid][MiniGameTD][33] = CreatePlayerTextDraw(playerid, 248.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][33], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][33], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][33], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][33], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][33], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][33], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][33], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][33], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][33], 1);

    MiniGameData[playerid][MiniGameTD][34] = CreatePlayerTextDraw(playerid, 272.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][34], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][34], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][34], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][34], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][34], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][34], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][34], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][34], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][34], 1);

    MiniGameData[playerid][MiniGameTD][35] = CreatePlayerTextDraw(playerid, 296.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][35], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][35], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][35], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][35], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][35], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][35], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][35], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][35], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][35], 1);

    MiniGameData[playerid][MiniGameTD][36] = CreatePlayerTextDraw(playerid, 320.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][36], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][36], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][36], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][36], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][36], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][36], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][36], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][36], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][36], 1);

    MiniGameData[playerid][MiniGameTD][37] = CreatePlayerTextDraw(playerid, 344.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][37], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][37], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][37], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][37], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][37], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][37], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][37], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][37], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][37], 1);

    MiniGameData[playerid][MiniGameTD][38] = CreatePlayerTextDraw(playerid, 368.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][38], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][38], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][38], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][38], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][38], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][38], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][38], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][38], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][38], 1);

    MiniGameData[playerid][MiniGameTD][39] = CreatePlayerTextDraw(playerid, 392.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][39], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][39], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][39], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][39], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][39], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][39], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][39], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][39], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][39], 1);

    MiniGameData[playerid][MiniGameTD][40] = CreatePlayerTextDraw(playerid, 416.000, 288.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][40], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][40], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][40], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][40], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][40], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][40], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][40], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][40], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][40], 1);

    MiniGameData[playerid][MiniGameTD][41] = CreatePlayerTextDraw(playerid, 200.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][41], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][41], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][41], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][41], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][41], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][41], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][41], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][41], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][41], 1);

    MiniGameData[playerid][MiniGameTD][42] = CreatePlayerTextDraw(playerid, 224.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][42], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][42], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][42], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][42], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][42], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][42], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][42], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][42], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][42], 1);

    MiniGameData[playerid][MiniGameTD][43] = CreatePlayerTextDraw(playerid, 248.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][43], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][43], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][43], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][43], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][43], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][43], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][43], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][43], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][43], 1);

    MiniGameData[playerid][MiniGameTD][44] = CreatePlayerTextDraw(playerid, 272.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][44], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][44], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][44], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][44], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][44], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][44], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][44], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][44], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][44], 1);

    MiniGameData[playerid][MiniGameTD][45] = CreatePlayerTextDraw(playerid, 296.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][45], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][45], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][45], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][45], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][45], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][45], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][45], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][45], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][45], 1);

    MiniGameData[playerid][MiniGameTD][46] = CreatePlayerTextDraw(playerid, 320.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][46], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][46], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][46], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][46], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][46], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][46], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][46], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][46], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][46], 1);

    MiniGameData[playerid][MiniGameTD][47] = CreatePlayerTextDraw(playerid, 344.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][47], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][47], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][47], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][47], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][47], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][47], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][47], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][47], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][47], 1);

    MiniGameData[playerid][MiniGameTD][48] = CreatePlayerTextDraw(playerid, 368.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][48], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][48], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][48], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][48], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][48], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][48], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][48], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][48], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][48], 1);

    MiniGameData[playerid][MiniGameTD][49] = CreatePlayerTextDraw(playerid, 392.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][49], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][49], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][49], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][49], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][49], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][49], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][49], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][49], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][49], 1);

    MiniGameData[playerid][MiniGameTD][50] = CreatePlayerTextDraw(playerid, 416.000, 315.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][50], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][50], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][50], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][50], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][50], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][50], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][50], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][50], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][50], 1);

    MiniGameData[playerid][MiniGameTD][51] = CreatePlayerTextDraw(playerid, 200.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][51], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][51], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][51], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][51], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][51], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][51], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][51], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][51], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][51], 1);

    MiniGameData[playerid][MiniGameTD][52] = CreatePlayerTextDraw(playerid, 224.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][52], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][52], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][52], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][52], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][52], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][52], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][52], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][52], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][52], 1);

    MiniGameData[playerid][MiniGameTD][53] = CreatePlayerTextDraw(playerid, 248.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][53], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][53], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][53], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][53], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][53], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][53], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][53], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][53], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][53], 1);

    MiniGameData[playerid][MiniGameTD][54] = CreatePlayerTextDraw(playerid, 272.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][54], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][54], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][54], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][54], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][54], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][54], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][54], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][54], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][54], 1);

    MiniGameData[playerid][MiniGameTD][55] = CreatePlayerTextDraw(playerid, 296.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][55], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][55], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][55], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][55], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][55], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][55], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][55], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][55], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][55], 1);

    MiniGameData[playerid][MiniGameTD][56] = CreatePlayerTextDraw(playerid, 320.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][56], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][56], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][56], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][56], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][56], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][56], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][56], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][56], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][56], 1);

    MiniGameData[playerid][MiniGameTD][57] = CreatePlayerTextDraw(playerid, 344.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][57], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][57], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][57], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][57], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][57], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][57], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][57], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][57], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][57], 1);

    MiniGameData[playerid][MiniGameTD][58] = CreatePlayerTextDraw(playerid, 368.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][58], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][58], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][58], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][58], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][58], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][58], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][58], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][58], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][58], 1);

    MiniGameData[playerid][MiniGameTD][59] = CreatePlayerTextDraw(playerid, 392.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][59], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][59], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][59], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][59], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][59], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][59], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][59], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][59], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][59], 1);

    MiniGameData[playerid][MiniGameTD][60] = CreatePlayerTextDraw(playerid, 416.000, 342.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][60], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][60], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][60], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][60], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][60], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][60], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][60], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][60], 1);
    PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][60], 1);

    MiniGameData[playerid][MiniGameTD][61] = CreatePlayerTextDraw(playerid, 248.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][61], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][61], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][61], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][61], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][61], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][61], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][61], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][61], 1);

    MiniGameData[playerid][MiniGameTD][62] = CreatePlayerTextDraw(playerid, 272.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][62], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][62], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][62], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][62], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][62], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][62], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][62], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][62], 1);

    MiniGameData[playerid][MiniGameTD][63] = CreatePlayerTextDraw(playerid, 296.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][63], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][63], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][63], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][63], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][63], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][63], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][63], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][63], 1);

    MiniGameData[playerid][MiniGameTD][64] = CreatePlayerTextDraw(playerid, 320.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][64], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][64], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][64], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][64], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][64], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][64], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][64], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][64], 1);

    MiniGameData[playerid][MiniGameTD][65] = CreatePlayerTextDraw(playerid, 344.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][65], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][65], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][65], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][65], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][65], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][65], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][65], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][65], 1);

    MiniGameData[playerid][MiniGameTD][66] = CreatePlayerTextDraw(playerid, 368.000, 166.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][66], 23.000, 26.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][66], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][66], 0x00FF00FF);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][66], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][66], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][66], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][66], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][66], 1);

    MiniGameData[playerid][MiniGameTD][67] = CreatePlayerTextDraw(playerid, 252.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][67], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][67], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][67], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][67], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][67], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][67], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][67], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][67], 1);

    MiniGameData[playerid][MiniGameTD][68] = CreatePlayerTextDraw(playerid, 276.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][68], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][68], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][68], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][68], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][68], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][68], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][68], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][68], 1);

    MiniGameData[playerid][MiniGameTD][69] = CreatePlayerTextDraw(playerid, 300.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][69], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][69], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][69], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][69], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][69], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][69], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][69], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][69], 1);

    MiniGameData[playerid][MiniGameTD][70] = CreatePlayerTextDraw(playerid, 324.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][70], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][70], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][70], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][70], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][70], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][70], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][70], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][70], 1);

    MiniGameData[playerid][MiniGameTD][71] = CreatePlayerTextDraw(playerid, 348.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][71], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][71], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][71], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][71], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][71], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][71], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][71], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][71], 1);

    MiniGameData[playerid][MiniGameTD][72] = CreatePlayerTextDraw(playerid, 372.000, 171.000, "20");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][72], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][72], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][72], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][72], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][72], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][72], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][72], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][72], 1);

    MiniGameData[playerid][MiniGameTD][73] = CreatePlayerTextDraw(playerid, 204.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][73], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][73], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][73], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][73], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][73], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][73], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][73], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][73], 1);

    MiniGameData[playerid][MiniGameTD][74] = CreatePlayerTextDraw(playerid, 228.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][74], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][74], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][74], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][74], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][74], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][74], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][74], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][74], 1);

    MiniGameData[playerid][MiniGameTD][75] = CreatePlayerTextDraw(playerid, 251.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][75], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][75], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][75], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][75], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][75], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][75], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][75], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][75], 1);

    MiniGameData[playerid][MiniGameTD][76] = CreatePlayerTextDraw(playerid, 275.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][76], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][76], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][76], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][76], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][76], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][76], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][76], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][76], 1);

    MiniGameData[playerid][MiniGameTD][77] = CreatePlayerTextDraw(playerid, 300.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][77], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][77], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][77], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][77], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][77], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][77], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][77], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][77], 1);

    MiniGameData[playerid][MiniGameTD][78] = CreatePlayerTextDraw(playerid, 323.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][78], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][78], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][78], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][78], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][78], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][78], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][78], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][78], 1);

    MiniGameData[playerid][MiniGameTD][79] = CreatePlayerTextDraw(playerid, 348.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][79], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][79], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][79], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][79], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][79], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][79], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][79], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][79], 1);

    MiniGameData[playerid][MiniGameTD][80] = CreatePlayerTextDraw(playerid, 371.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][80], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][80], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][80], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][80], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][80], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][80], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][80], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][80], 1);

    MiniGameData[playerid][MiniGameTD][81] = CreatePlayerTextDraw(playerid, 396.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][81], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][81], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][81], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][81], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][81], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][81], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][81], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][81], 1);

    MiniGameData[playerid][MiniGameTD][82] = CreatePlayerTextDraw(playerid, 420.000, 212.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][82], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][82], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][82], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][82], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][82], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][82], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][82], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][82], 1);

    MiniGameData[playerid][MiniGameTD][83] = CreatePlayerTextDraw(playerid, 204.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][83], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][83], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][83], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][83], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][83], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][83], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][83], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][83], 1);

    MiniGameData[playerid][MiniGameTD][84] = CreatePlayerTextDraw(playerid, 228.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][84], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][84], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][84], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][84], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][84], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][84], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][84], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][84], 1);

    MiniGameData[playerid][MiniGameTD][85] = CreatePlayerTextDraw(playerid, 251.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][85], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][85], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][85], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][85], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][85], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][85], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][85], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][85], 1);

    MiniGameData[playerid][MiniGameTD][86] = CreatePlayerTextDraw(playerid, 275.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][86], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][86], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][86], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][86], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][86], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][86], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][86], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][86], 1);

    MiniGameData[playerid][MiniGameTD][87] = CreatePlayerTextDraw(playerid, 300.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][87], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][87], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][87], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][87], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][87], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][87], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][87], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][87], 1);

    MiniGameData[playerid][MiniGameTD][88] = CreatePlayerTextDraw(playerid, 323.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][88], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][88], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][88], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][88], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][88], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][88], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][88], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][88], 1);

    MiniGameData[playerid][MiniGameTD][89] = CreatePlayerTextDraw(playerid, 348.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][89], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][89], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][89], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][89], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][89], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][89], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][89], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][89], 1);

    MiniGameData[playerid][MiniGameTD][90] = CreatePlayerTextDraw(playerid, 371.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][90], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][90], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][90], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][90], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][90], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][90], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][90], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][90], 1);

    MiniGameData[playerid][MiniGameTD][91] = CreatePlayerTextDraw(playerid, 396.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][91], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][91], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][91], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][91], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][91], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][91], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][91], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][91], 1);

    MiniGameData[playerid][MiniGameTD][92] = CreatePlayerTextDraw(playerid, 420.000, 239.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][92], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][92], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][92], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][92], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][92], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][92], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][92], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][92], 1);

    MiniGameData[playerid][MiniGameTD][93] = CreatePlayerTextDraw(playerid, 204.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][93], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][93], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][93], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][93], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][93], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][93], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][93], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][93], 1);

    MiniGameData[playerid][MiniGameTD][94] = CreatePlayerTextDraw(playerid, 228.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][94], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][94], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][94], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][94], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][94], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][94], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][94], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][94], 1);

    MiniGameData[playerid][MiniGameTD][95] = CreatePlayerTextDraw(playerid, 251.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][95], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][95], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][95], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][95], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][95], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][95], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][95], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][95], 1);

    MiniGameData[playerid][MiniGameTD][96] = CreatePlayerTextDraw(playerid, 275.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][96], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][96], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][96], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][96], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][96], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][96], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][96], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][96], 1);

    MiniGameData[playerid][MiniGameTD][97] = CreatePlayerTextDraw(playerid, 300.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][97], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][97], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][97], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][97], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][97], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][97], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][97], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][97], 1);

    MiniGameData[playerid][MiniGameTD][98] = CreatePlayerTextDraw(playerid, 323.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][98], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][98], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][98], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][98], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][98], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][98], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][98], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][98], 1);

    MiniGameData[playerid][MiniGameTD][99] = CreatePlayerTextDraw(playerid, 348.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][99], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][99], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][99], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][99], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][99], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][99], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][99], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][99], 1);

    MiniGameData[playerid][MiniGameTD][100] = CreatePlayerTextDraw(playerid, 371.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][100], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][100], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][100], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][100], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][100], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][100], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][100], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][100], 1);

    MiniGameData[playerid][MiniGameTD][101] = CreatePlayerTextDraw(playerid, 396.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][101], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][101], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][101], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][101], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][101], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][101], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][101], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][101], 1);

    MiniGameData[playerid][MiniGameTD][102] = CreatePlayerTextDraw(playerid, 420.000, 266.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][102], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][102], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][102], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][102], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][102], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][102], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][102], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][102], 1);

    MiniGameData[playerid][MiniGameTD][103] = CreatePlayerTextDraw(playerid, 204.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][103], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][103], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][103], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][103], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][103], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][103], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][103], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][103], 1);

    MiniGameData[playerid][MiniGameTD][104] = CreatePlayerTextDraw(playerid, 228.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][104], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][104], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][104], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][104], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][104], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][104], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][104], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][104], 1);

    MiniGameData[playerid][MiniGameTD][105] = CreatePlayerTextDraw(playerid, 251.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][105], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][105], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][105], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][105], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][105], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][105], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][105], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][105], 1);

    MiniGameData[playerid][MiniGameTD][106] = CreatePlayerTextDraw(playerid, 275.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][106], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][106], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][106], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][106], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][106], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][106], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][106], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][106], 1);

    MiniGameData[playerid][MiniGameTD][107] = CreatePlayerTextDraw(playerid, 300.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][107], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][107], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][107], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][107], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][107], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][107], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][107], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][107], 1);

    MiniGameData[playerid][MiniGameTD][108] = CreatePlayerTextDraw(playerid, 323.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][108], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][108], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][108], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][108], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][108], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][108], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][108], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][108], 1);

    MiniGameData[playerid][MiniGameTD][109] = CreatePlayerTextDraw(playerid, 348.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][109], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][109], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][109], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][109], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][109], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][109], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][109], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][109], 1);

    MiniGameData[playerid][MiniGameTD][110] = CreatePlayerTextDraw(playerid, 371.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][110], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][110], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][110], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][110], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][110], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][110], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][110], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][110], 1);

    MiniGameData[playerid][MiniGameTD][111] = CreatePlayerTextDraw(playerid, 396.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][111], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][111], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][111], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][111], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][111], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][111], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][111], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][111], 1);

    MiniGameData[playerid][MiniGameTD][112] = CreatePlayerTextDraw(playerid, 420.000, 294.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][112], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][112], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][112], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][112], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][112], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][112], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][112], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][112], 1);

    MiniGameData[playerid][MiniGameTD][113] = CreatePlayerTextDraw(playerid, 204.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][113], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][113], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][113], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][113], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][113], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][113], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][113], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][113], 1);

    MiniGameData[playerid][MiniGameTD][114] = CreatePlayerTextDraw(playerid, 228.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][114], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][114], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][114], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][114], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][114], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][114], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][114], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][114], 1);

    MiniGameData[playerid][MiniGameTD][115] = CreatePlayerTextDraw(playerid, 251.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][115], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][115], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][115], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][115], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][115], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][115], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][115], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][115], 1);

    MiniGameData[playerid][MiniGameTD][116] = CreatePlayerTextDraw(playerid, 275.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][116], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][116], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][116], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][116], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][116], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][116], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][116], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][116], 1);

    MiniGameData[playerid][MiniGameTD][117] = CreatePlayerTextDraw(playerid, 300.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][117], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][117], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][117], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][117], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][117], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][117], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][117], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][117], 1);

    MiniGameData[playerid][MiniGameTD][118] = CreatePlayerTextDraw(playerid, 323.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][118], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][118], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][118], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][118], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][118], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][118], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][118], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][118], 1);

    MiniGameData[playerid][MiniGameTD][119] = CreatePlayerTextDraw(playerid, 348.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][119], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][119], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][119], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][119], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][119], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][119], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][119], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][119], 1);

    MiniGameData[playerid][MiniGameTD][120] = CreatePlayerTextDraw(playerid, 371.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][120], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][120], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][120], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][120], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][120], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][120], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][120], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][120], 1);

    MiniGameData[playerid][MiniGameTD][121] = CreatePlayerTextDraw(playerid, 396.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][121], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][121], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][121], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][121], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][121], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][121], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][121], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][121], 1);

    MiniGameData[playerid][MiniGameTD][122] = CreatePlayerTextDraw(playerid, 420.000, 321.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][122], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][122], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][122], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][122], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][122], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][122], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][122], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][122], 1);

    MiniGameData[playerid][MiniGameTD][123] = CreatePlayerTextDraw(playerid, 204.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][123], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][123], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][123], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][123], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][123], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][123], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][123], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][123], 1);

    MiniGameData[playerid][MiniGameTD][124] = CreatePlayerTextDraw(playerid, 228.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][124], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][124], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][124], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][124], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][124], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][124], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][124], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][124], 1);

    MiniGameData[playerid][MiniGameTD][125] = CreatePlayerTextDraw(playerid, 251.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][125], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][125], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][125], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][125], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][125], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][125], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][125], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][125], 1);

    MiniGameData[playerid][MiniGameTD][126] = CreatePlayerTextDraw(playerid, 275.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][126], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][126], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][126], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][126], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][126], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][126], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][126], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][126], 1);

    MiniGameData[playerid][MiniGameTD][127] = CreatePlayerTextDraw(playerid, 300.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][127], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][127], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][127], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][127], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][127], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][127], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][127], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][127], 1);

    MiniGameData[playerid][MiniGameTD][128] = CreatePlayerTextDraw(playerid, 323.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][128], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][128], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][128], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][128], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][128], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][128], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][128], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][128], 1);

    MiniGameData[playerid][MiniGameTD][129] = CreatePlayerTextDraw(playerid, 348.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][129], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][129], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][129], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][129], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][129], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][129], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][129], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][129], 1);

    MiniGameData[playerid][MiniGameTD][130] = CreatePlayerTextDraw(playerid, 371.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][130], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][130], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][130], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][130], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][130], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][130], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][130], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][130], 1);

    MiniGameData[playerid][MiniGameTD][131] = CreatePlayerTextDraw(playerid, 396.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][131], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][131], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][131], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][131], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][131], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][131], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][131], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][131], 1);

    MiniGameData[playerid][MiniGameTD][132] = CreatePlayerTextDraw(playerid, 420.000, 347.000, "50");
    PlayerTextDrawLetterSize(playerid, MiniGameData[playerid][MiniGameTD][132], 0.300, 1.500);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][132], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][132], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][132], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][132], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][132], 150);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][132], 2);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][132], 1);

    MiniGameData[playerid][MiniGameTD][133] = CreatePlayerTextDraw(playerid, 200.000, 196.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][133], 239.000, 7.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][133], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][133], 150);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][133], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][133], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][133], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][133], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][133], 1);

    MiniGameData[playerid][MiniGameTD][134] = CreatePlayerTextDraw(playerid, 200.000, 196.000, "LD_BUM:blkdot");
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][134], 239.000, 7.000);
    PlayerTextDrawAlignment(playerid, MiniGameData[playerid][MiniGameTD][134], 1);
    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][134], -1);
    PlayerTextDrawSetShadow(playerid, MiniGameData[playerid][MiniGameTD][134], 0);
    PlayerTextDrawSetOutline(playerid, MiniGameData[playerid][MiniGameTD][134], 0);
    PlayerTextDrawBackgroundColor(playerid, MiniGameData[playerid][MiniGameTD][134], 255);
    PlayerTextDrawFont(playerid, MiniGameData[playerid][MiniGameTD][134], 4);
    PlayerTextDrawSetProportional(playerid, MiniGameData[playerid][MiniGameTD][134], 1);

    MiniGameData[playerid][MiniGameBarLoadingCount] = 0;

    new string[500];

    for(new i = 73; i < 133; i++)
    {
        MiniGameData[playerid][MiniGameNumberSelect][i] = random(99 - 20 + 1) + 20;

        format(string, sizeof(string), "%d", MiniGameData[playerid][MiniGameNumberSelect][i]);
        PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][i], string);
    }

    new uniqueNumbers[60];
    new uniqueCount = 0;

    for(new i = 73; i < 133; i++)
    {
        new val = MiniGameData[playerid][MiniGameNumberSelect][i];
        new bool:exists = false;

        for(new j = 0; j < uniqueCount; j++)
        {
            if(uniqueNumbers[j] == val)
            {
                exists = true;
                break;
            }
        }

        if(!exists)
        {
            uniqueNumbers[uniqueCount] = val;
            uniqueCount++;
        }
    }

    for(new i = uniqueCount - 1; i > 0; i--)
    {
        new r = random(i + 1);
        new temp = uniqueNumbers[i];
        uniqueNumbers[i] = uniqueNumbers[r];
        uniqueNumbers[r] = temp;
    }

    new targetIdx = 0;
    for(new i = 67; i < 73; i++)
    {
        MiniGameData[playerid][MiniGameNumberTarget][i] = uniqueNumbers[targetIdx];
        targetIdx++;

        format(string, sizeof(string), "%d", MiniGameData[playerid][MiniGameNumberTarget][i]);
        printf("%d", MiniGameData[playerid][MiniGameNumberTarget][i]);
        PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][i], string);
    }

    new hideIndices[6] = {67, 68, 69, 70, 71, 72};

    for(new i = 5; i > 0; i--)
    {
        new r = random(i + 1);
        new temp = hideIndices[i];
        hideIndices[i] = hideIndices[r];
        hideIndices[r] = temp;
    }

    for(new i = 0; i < 3; i++)
    {
        new targetTDIndex = hideIndices[i];
        printf("Hidden IDX: %d", targetTDIndex);

        MiniGameData[playerid][MiniGameNumberHiddenIndex][i] = hideIndices[i];

        MiniGameData[playerid][MiniGameNumberTargetHidden][i] = MiniGameData[playerid][MiniGameNumberTarget][targetTDIndex];

        format(string, sizeof(string), "%d", MiniGameData[playerid][MiniGameNumberTargetHidden][i]);
        PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][targetTDIndex], string); 
    }

    for(new i = 1; i < 61; i++)
    {
        PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][i], 0);
    }

    for(new i = 0; i < MAX_TEXTDRAW_MINIGAME; i++)
    {
        PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][i]);
    }

    SetTimerEx("DelayHiddenNumberMiniGame", 3000, false, "ii", playerid, loading_time);

    SelectTextDraw(playerid, 0x029BFAFF);
    return 1;
}

forward DelayHiddenNumberMiniGame(playerid, loading_time);
public DelayHiddenNumberMiniGame(playerid, loading_time)
{
    if(!MiniGameData[playerid][MiniGameIsAShow])
        return 0;

    for(new i = 0; i < 3; i++)
    {
        new targetTDIndex = MiniGameData[playerid][MiniGameNumberHiddenIndex][i];
        printf("Hidden IDX: %d", targetTDIndex);

        new boxIDndex = targetTDIndex - 6;
        PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][boxIDndex], 0xFF0000FF);
        PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][boxIDndex]);

        PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][targetTDIndex], "??");
        PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][targetTDIndex]);
    }

    for(new i = 1; i < 61; i++)
    {
        PlayerTextDrawSetSelectable(playerid, MiniGameData[playerid][MiniGameTD][i], 1);
        PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][i]);
    }

    if(MiniGameData[playerid][MiniGameLoadingBarTimer] != -1)
    {
        KillTimer(MiniGameData[playerid][MiniGameLoadingBarTimer]);
        MiniGameData[playerid][MiniGameLoadingBarTimer] = -1;
    }

    MiniGameData[playerid][MiniGameLoadingBarTimer] = SetTimerEx("LoadingProgressBar", loading_time * 1000 / 100, true, "i", playerid);

    if(MiniGameData[playerid][MiniGameNumberSelectRandTimer] != -1)
    {
        KillTimer(MiniGameData[playerid][MiniGameNumberSelectRandTimer]);
        MiniGameData[playerid][MiniGameNumberSelectRandTimer] = -1;
    }

    MiniGameData[playerid][MiniGameNumberSelectRandTimer] = SetTimerEx("MiniGameRandomSelect", 2000, true, "i", playerid);
    return 1;
}

forward MiniGameRandomSelect(playerid);
public MiniGameRandomSelect(playerid)
{
    if(!MiniGameData[playerid][MiniGameIsAShow])
        return 0;

    for(new i = 73; i < 133; i++)
    {
        MiniGameData[playerid][MiniGameNumberSelect][i] = random(99 - 20 + 1) + 20;
    }

    for(new i = 0; i < 3; i++)
    {
        new hiddenVal = MiniGameData[playerid][MiniGameNumberTargetHidden][i];
        
        new randomGridPos = random(133 - 73) + 73; 
        MiniGameData[playerid][MiniGameNumberSelect][randomGridPos] = hiddenVal;
    }

    new string[16];
    for(new i = 73; i < 133; i++)
    {
        format(string, sizeof(string), "%d", MiniGameData[playerid][MiniGameNumberSelect][i]);
        PlayerTextDrawSetString(playerid, MiniGameData[playerid][MiniGameTD][i], string);
        PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][i]);
    }
    return 1;
}

forward RefreshColorBar(playerid);
public RefreshColorBar(playerid)
{
    if(!MiniGameData[playerid][MiniGameIsAShow])
        return 0;

    PlayerTextDrawColor(playerid, MiniGameData[playerid][MiniGameTD][134], 0xFFFFFFFF);
    PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][134]);
    return 1;
}

forward LoadingProgressBar(playerid);
public LoadingProgressBar(playerid)
{
    if(!MiniGameData[playerid][MiniGameIsAShow])
        return 0;

    MiniGameData[playerid][MiniGameBarLoadingCount]++;

    new Float:value = 239.0 - (float(MiniGameData[playerid][MiniGameBarLoadingCount]) * 239.0 / 100.0);
    PlayerTextDrawTextSize(playerid, MiniGameData[playerid][MiniGameTD][134], value, 7.0);
    PlayerTextDrawShow(playerid, MiniGameData[playerid][MiniGameTD][134]);

    if(MiniGameData[playerid][MiniGameBarLoadingCount] > 100)
    {
        if(MiniGameData[playerid][MiniGameLoadingBarTimer] != -1)
        {
            KillTimer(MiniGameData[playerid][MiniGameLoadingBarTimer]);
            MiniGameData[playerid][MiniGameLoadingBarTimer] = -1;
        }

        MiniGameData[playerid][MiniGameBarLoadingCount] = 0;

        MiniGameData[playerid][MiniGameIsAShow] = false;

        if(MiniGameData[playerid][MiniGameNumberSelectRandTimer] != -1)
        {
            KillTimer(MiniGameData[playerid][MiniGameNumberSelectRandTimer]);
            MiniGameData[playerid][MiniGameNumberSelectRandTimer] = -1;
        }

        for(new i = 0; i < 3; i++)
        {
            MiniGameData[playerid][MiniGameNumberTargetHidden][i] = 0;
            MiniGameData[playerid][MiniGameNumberHiddenIndex][i] = 0;
        }

        for(new i = 0; i < MAX_TEXTDRAW_MINIGAME; i++)
        {
            MiniGameData[playerid][MiniGameNumberTarget][i] = 0;
            MiniGameData[playerid][MiniGameNumberSelect][i] = 0;

            PlayerTextDrawHide(playerid, MiniGameData[playerid][MiniGameTD][i]);
        }

        MiniGameData[playerid][MiniGameScore] = 0;
    }
    return 1;
}

CMD:minigame(playerid, params[])
{
    ShowPlayerMiniGame(playerid);
    return 1;
}
