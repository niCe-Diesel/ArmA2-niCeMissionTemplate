nonJIP = [] execVM "briefing.sqf";

CIVILIAN setFriend [EAST, 1];
EAST setFriend [CIVILIAN, 1];

// Disable Saving and Auto Saving
enableSaving [false, false];

//Misc. Radio/Weapon
player setVariable ["BIS_noCoreConversations", true]; //disable greeting menu
0 fadeRadio 0; //mute in-game radio commands

ace_sys_tracking_markers_enabled = false;
ace_sys_eject_fnc_weaponcheck = {};
ace_sys_wounds_enabled = true;
ace_sys_repair_default_tyres = true;
ace_settings_enable_vd_change = true; // viewdistance
ace_settings_enable_tg_change = true; // grass density
ace_viewdistance_limit = 10000;
ace_wounds_prevtime = 1200;
ace_sys_wounds_withSpect = false;
ace_sys_wounds_leftdam = 0;
ace_sys_wounds_noai = true; //disable wounds for AI for performance
ace_sys_wounds_player_movement_bloodloss = true;
ace_sys_wounds_ai_movement_bloodloss = true;
ace_sys_wounds_no_medical_vehicles = true;

// default terrain grid (25), if performance too bad, disable grass (50)
setTerrainGrid 25;
setViewDistance 3500;

// because of the wait, probably everything after here will be executed after leaving briefing screen
// shouldn't harm to wait for bis function init
waituntil {!isnil "bis_fnc_init"};

// ONLY PLAYER INIT FROM HERE
if (isDedicated) exitWith {};
if (isNull player) then //JIP player
{
	waitUntil {!isNull player}; // JIP block here
	JIP = [] execVM "briefing.sqf";
};
waitUntil {player==player};

[] execVM "scripts\aiHearTalking.sqf";
[] execVM "initPlayer.sqf";

// For debugging
//while {true} do {
//  hintsilent format ["%1\n%2\n%3", getPosASL player select 0, getPosASL player select 1, getPosASL player select 2];
//  sleep 0.2;
//};
//hintsilent format ["offset: %1", nimitz_offset];
//diag_log "test";
//diag_log format ["offset: %1", nimitz_offset];
//["debug here", "init", [true, true, true]] call CBA_fnc_debug;
//onEachFrame {hint str diag_fps};
//onEachFrame {hint str diag_tickTime};