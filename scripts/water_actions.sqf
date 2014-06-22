/*
 * Content in this script has been mainly copied and adapted
 * (e.g. translated to english) from http://www.armaholic.com/page.php?id=12937
 * "Revive script for ACE2 Wounding system by columdrum"
 *
 * activate like this for every player, e.g. in init.sqf:
 *  revive_WaterAction = 2;
 *  water_actions = compile preprocessFileLineNumbers 'water_actions.sqf';
 *  ["ace_sys_wounds_rev", {player spawn water_actions}] call CBA_fnc_addEventhandler;
 *
 * use cases:
 * 1. Heli-Pilot (or any other unit w/o live raft) crashes into water, becomes uncon, stays on surface, can be pulled by swimmers to shore / loaded into vehicles (heli/boat)
 * 2. F18 pilot crashes into water, becomes unconsciuous, is moved into live raft. Rescue-Heli/Boat (rescue-vehicle) moves to crashed pilot, pilot is moved into rescue-vehicle (when very near above pilot in live raft), can be pulled out later like with all other ace-uncon units
 *
 * test cases:
 * - T1 (UC1): F18 pilot boards F18, drives overboard, becomes uncon, stays on surface
 * - T2 (UC1): As T1, plus: rescue chopper moves close to unit to rescue, is moved into vehicle
 * - T3 (UC1): As T2, plus: rescue chopper lands on carrier, uncon unit can be pulled out next to chopper and can be treated (gets consciuous)
 * - T4 (UC2): F18 pilot boards F18, drives overboard, becomes uncon, is moved into live raft
 * - T5 (UC2): As T1, plus: rescuer jumps carefully overboard, not uncon, swims to live raft, can pull unit out
 * - T6 (UC2): As T1, plus: rescue chopper moves close to unit to rescue, is moved into vehicle
 *
 * known issues:
 * - if you ever "drag" a uncon unit in water, don't drop, otherwise rescuee will be under water and can not be rescued. Better: Don't drag people in water!
 *
 * currently only use case 1 is supported
 *
 * This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License: http://creativecommons.org/licenses/by-sa/4.0/
 */

if (!isnil 'revive_Initialized') exitwith{ diag_log['WARNING multiple instances of revive detected!']; };
revive_Initialized = true;

Revive_SeaRescue = {
	private ["_rescueObjects", "_rescuee", "_rescuer", "_tmpobj", "_freePositions"];
	if (((getposASL player) select 2) < -1) then {
		player setpos [getpos player select 0, getpos player select 1, 0]
	};
	_tmpobj = 'Sign_sphere10cm_EP1' createvehicle [getpos player select 0, getpos player select 1, 0]; //TODO: create the vehicle only local? may cause bumping, test
	player attachto [_tmpobj, [0, 0, 0]];
	_rescued = false;
	while {(surfaceIsWater (getPos player)) && alive player && (player call ace_sys_wounds_fnc_isUncon)} do {
		if (!_rescued) then { // if not been rescued search for possible rescuers
			if (((getposASL player) select 2) < -1) then {
				_tmpobj setpos [getpos player select 0, getpos player select 1, 0]
			};
			_rescueObjects = nearestObjects [player, ["Man","Land","Helicopter","Ship"], 7];
			_rescueObjects = _rescueObjects - [player];
			if (count _rescueObjects > 0) then {
				{
					if (alive _x && (side _x == playerside)) then {
						if (_x iskindof "Man") then {
							if (!(_x call ace_sys_wounds_fnc_isUncon)) then {
								_tmpobj attachto [_x, [0, 2, 0]]; // attach the tempobject (and the player with it) to the rescuer
								_rescued = true;
								_rescuer = _x;
							};
						} else {
							_freePositions = (_x) emptyPositions "cargo"; // including driver, gunner, ...
							if (_freePositions > 0) then {
								detach player;
								player assignAsCargo _x;
								player moveincargo _x;
								// does not work, normal vehicleChat is not broadcasted, this call also has no effect. maybe the if is wrong?
								// [-1, {if (player in (crew _x)) then {player vehicleChat _this}}, "One person was rescued from water"] call CBA_fnc_globalExecute;
								// _x vehicleChat "One person was rescued from water";
								waitUntil {vehicle player != player};
								_rescued = true;
								_rescuer = _x;
								_tmpobj setpos [0, 0, -500]; // if enters the vehicle, hide the temp object
							} else {
								player attachto [_tmpobj, [0, 0, 0]]; // no room in the vehicle, back to floating
							};
						};
					};
				} foreach _rescueObjects;
			};
		} else { // if been rescued, check if they are alive
			if (_rescuer iskindof "Man") then { // the rescuer might have died
				if (_rescuer call ace_sys_wounds_fnc_isUncon || !alive _rescuer) then {
					detach _tmpobj;
					_rescued = false;
					player attachto [_tmpobj, [0, 0, 0]];
				};
			} else {
				if (vehicle player == player) then {
					if (!alive _rescuer) then {
						// the player have exit the vehicle, it might have been destroyed or something else unforeseen happened
						_tmpobj setpos getpos player;
						_rescued = false;
						player attachto [_tmpobj, [0, 0, 0]]; // no room in the vehicle, back to floating
					};
					if (((getposASL player) select 2) > 1) then {
						sleep 10;
					};
				};
			};
		};
		sleep 5;
	};
	detach player;
	deletevehicle _tmpobj;
};

Revive_NearCoast = {
	//Function By Norrin, used on his revive script, all credits for him
	private ["_downed_x","_downed_y","_center_x","_center_y","_zzzz"];
	if (((getposASL player) select 2) > -0.2) exitwith{}; // only if he is under the water
	while{surfaceIsWater (getPos player)} do
	{
		_downed_x = getPos player select 0;
		_downed_y = getPos player select 1;
		_center_x = getMarkerPos "center" select 0;
		_center_y = getMarkerPos "center" select 1;

		while {surfaceIsWater [_downed_x, _downed_y]} do
		{
			if (_zzzz == 0) then {
				titlecut ["Your body is washing ashore. Please wait", "BLACK FADED", 5];
			};
			sleep 0.01;
			if (_downed_x > _center_x) then {
				_downed_x = _downed_x - 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_y > _center_y) then {
				_downed_y = _downed_y - 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_x < _center_x) then {
				_downed_x = _downed_x + 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
			if (_downed_y < _center_y) then {
				_downed_y = _downed_y + 25;
				sleep 0.01;
				player setPos [_downed_x, _downed_y];
				sleep 0.01;
			};
		_zzzz = _zzzz + 1;
		sleep 0.1;
		};
	};
};

/* parameter 'revive_WaterAction' determines what to do if someone dies in the water. The possible options are:
 * 0 : Do nothing . if deep water, it will be no chance to save him, escept if there is respawn :P, if not, you may be able to drag out of the water
 * 1 : Direct death ( lifes=0 if respawn not enabled, and -1 life if respawn enabled) if the player dies and sinks in deep water
 * 2 : The dead player floats over the water, there is 2 ways to save him. Go with a vehicle really close to him and he will get onboard automatically, also you can swim to him to grab him and carry him to the coast.
 * 3 : The player is moved to the nearest coast, using norrin script.
 * e.g.: revive_WaterAction = 3;
 */
Revive_function_WaterAction = {
	//check if he is really under water, and outside vehicle
	if ((((getposASL player) select 2) < 0) && (revive_WaterAction != 0) && (vehicle player == player)) then {
		if (!isnil 'Revive_executing_WaterRescue') exitwith {player groupChat "l138";}; // exit early if already executing
		Revive_executing_WaterRescue = true;

		switch revive_WaterAction do
		{
		  case 1: {if (((getposASL player) select 2) < -2) then {player setdamage 1}}; // immediate death on drowning unconsciuous
		  case 2: {call Revive_SeaRescue}; // wait for rescue vehicle
		  case 3: {call Revive_NearCoast}; // move to nearest coast
		  default {};
		};

		Revive_executing_WaterRescue = nil;
	};
};

/* Normally called like this:
 * water_actions = compile preprocessFileLineNumbers 'water_actions.sqf';
 * ["ace_sys_wounds_rev", {player spawn water_actions}] call CBA_fnc_addEventhandler;
 */
while { ((player getVariable "ace_w_revive") > 0) && (alive player)} do {
	[] spawn Revive_function_WaterAction;
	sleep 9; // arbitrary number
};