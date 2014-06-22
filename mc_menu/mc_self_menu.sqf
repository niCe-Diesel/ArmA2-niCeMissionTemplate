/*
 * reference:
 * - http://dev.withsix.com/projects/cca/wiki/FlexiMenu
 * - http://forums.unitedoperations.net/index.php/topic/13882-cbaace-interaction-menu-syntax-for-scripters/
 * - http://forums.unitedoperations.net/index.php/topic/22731-tutorial-adding-ace-interact-options-to-missions/
 *
 * Some ideas inspired by Makato[Miela]
 */

private ["_params", "_menuName", "_menuRsc", "_menuDef", "_menus"];

_params = _this select 1;

_menuName = "main";
_menuRsc = "popup";

// The following if statement is used for error checking and prepping menu variables. If not present there is a possibility bad info could be processed messing up the menus. I've commented it as best I can.
if (typeName _params == typeName []) then { // If the arguments received by this code are an array...
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this, __FILE__];}; // And if that array has no info in it, log the error and ignore arguments
	_menuName = _params select 0;  // _menuName is the first argument
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc}; // If there are more than one argument, _menuRsc is defined as the second argument, else it is _menuRsc as defined above
} else { // If the arguments received by this code are not an array...
	_menuName = _params;  // _menuName is the argument received by this code
};	

_menus = [
  [
    ["main", "menu", _menuRsc], // The name of this menu set, the title of this menu(you'll only really see it on submenus), and the _menuRsc
    [
      ["<t color='#FFAE00'>mission creator menu ></t>",
        {}, // Code to execute, if this is a link to a sub menu, leave blank
        "", // Location of icon (if any, in .paa format)
        "", // Hover text for this option
		["mc_menu\submenu.sqf", "sub_menu", 1] // Location of submenu source (in this example it's all in one file, so it's this file), name of submenu, and if the main menu should stay open when opening submenu. If this is 0 or not present, main menu will disappear and submenu will take it's place.
		]
    ]
  ]
];

_menuDef = [];
{
  if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;
_menuDef