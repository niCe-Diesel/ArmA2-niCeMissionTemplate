private ["_target","_params","_menuName","_menuRsc","_menuDef","_menus"];

_target = _this select 0;
_params = _this select 1;

_menuName = "";
_menuRsc = "popup";

if (typeName _params == typeName []) then {
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__]};
	_menuName = _params select 0;
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
	_menuName = _params;
};

_menus = [];

if (_menuName == "sub_menu") then {
	_menus set [count _menus,
		[
			["sub_menu","Mission creator menu", _menuRsc],
			[
				["RTE", {[] spawn ION_RTE_pStartRTE;}],
				["Teleport",	{[] exec "mc_menu\teleport.sqf"}],
				["Spectator", {[] exec "mc_menu\spectator.sqf"}],
				["Finish mission (success)", {[] exec "mc_menu\mission_success.sqf"}],
				["Fail mission", {[] exec "mc_menu\mission_cancel.sqf"}]
			]
		]
	];
};

_menuDef = [];
{
	if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
	diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _params, __FILE__];
};

_menuDef