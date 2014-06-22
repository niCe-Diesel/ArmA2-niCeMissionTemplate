/* This adds the MP event to the player
 */
//fnc_respawn = {
//	waituntil {(alive player)};
//	// ...
//};
//player addMPEventHandler ["MPRespawn", {_this call fnc_respawn;}];

// Add MC menu
// key definition: ArmA 2\userconfig\acre\acre_keys.hpp
// add to self-interact to all or only with "hidden" key combination
//waitUntil {!isNil "ace_sys_interaction_key_self"};  //wait for start
//["player", [ace_sys_interaction_key_self], -10, ["mc_menu\mc_self_menu.sqf", "main"]] call CBA_ui_fnc_add;

//alt_shift_m = [[50,[true,false,true]]];
//["player", alt_shift_m, -10, ["mc_menu\mc_self_menu.sqf", "main"]] call CBA_ui_fnc_add;
_actionIndex = [["RTE starten (Diesel)", CBA_fnc_actionargument_path,[[], {[] call ION_RTE_pStartRTE}], 0, False, True, "", "name player == ""Diesel"""]] call CBA_fnc_addPlayerAction;

revive_WaterAction = 2;
water_actions = compile preprocessFileLineNumbers 'scripts\water_actions.sqf';
["ace_sys_wounds_rev", {player spawn water_actions}] call CBA_fnc_addEventhandler;

waitUntil {time > 0}; // after briefing
player switchMove "amovpercmstpslowwrfldnon_player_idlesteady03";  //lower players weapon