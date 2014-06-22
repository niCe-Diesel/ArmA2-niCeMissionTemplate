ace_sys_spectator_can_exit_spectator = true;
player setVariable ["ace_sys_spectator_exclude", true];
mc setVariable ["ace_sys_spectator_exclude", true];
[] spawn ace_fnc_startSpectator;