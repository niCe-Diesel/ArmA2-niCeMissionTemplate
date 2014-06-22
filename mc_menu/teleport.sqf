hint "teleport";
titleText["Select map position for teleport", "PLAIN"];
onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ''; true;";