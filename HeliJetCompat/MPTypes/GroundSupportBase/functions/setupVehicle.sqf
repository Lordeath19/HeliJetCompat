private["_vehicle","_base","_vehicleClass"];

_vehicle	= [_this,0,objNull,[objNull]] call bis_fnc_param;
_base 		= [_this,1,objNull,[objNull]] call bis_fnc_param;
_vehicleClass	= typeOf _vehicle;

if (isNull _vehicle) exitWith
{
	["[x] Cannot re-setup the vehicle upon respawn!"] call bis_fnc_error;
};

//setup vehicle lock
[_vehicle,"init"] call hjc_fnc_moduleMPTypeGroundSupportBase_lockAircraft;

//gather info about aircraft initial state
_vehicle setVariable ["bis_initDamage",damage _vehicle,true];
_vehicle setVariable ["bis_initFuel",fuel _vehicle,true];
_vehicle setVariable ["bis_initMagazines",_vehicle call bis_fnc_moduleMPTypeGroundSupportBase_getVehicleAmmo,true];

//resupply vehicle
_vehicle call bis_fnc_moduleMPTypeGroundSupportBase_resupplyVehicle;

//clear vehicle cargo
clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;


private["_group"];

_group = group _vehicle;

//add even handler: GetIn & GetOut
_vehicle setVariable ["bis_crewGroup",_group,true];
_vehicle addEventHandler ["GetIn",bis_fnc_moduleMPTypeGroundSupportBase_onVehicleEntered];
_vehicle addEventHandler ["GetOut",bis_fnc_moduleMPTypeGroundSupportBase_onVehicleLeft];
//add even handler: RopeAttach to flag sling loaded cargo with last owner
_vehicle addEventHandler ["RopeAttach", { if ((_this select 2) isKindOf "ReammoBox_F") then { (_this select 2) setVariable ["BIS_lastSlingloadOwner", driver (_this select 0), true]; }; }];

//start vehicle simulation
_vehicle setVelocity [0,0,1];

private["_fsm"];

//start the aircraft fsm
if (_vehicle isKindOf "Plane") then {
	_fsm = [_vehicle,_base] execFSM "\HeliJetCompat\MPTypes\GroundSupportBase\fsms\plane.fsm";
}
else {
	_fsm = [_vehicle,_base] execFSM "\HeliJetCompat\MPTypes\GroundSupportBase\fsms\helicopter.fsm";
};
_vehicle setVariable ["bis_fsm",_fsm,true];

waitUntil{sleep 1; completedFSM _fsm;};

//["[i] Vehicle is going to respawn: _vehicle = %1 | _base = %2 | _vehicleClass = %3",_vehicle,_base,_vehicleClass] call bis_fnc_logFormat;

//respawn helicopter
[_base,_vehicleClass] call hjc_fnc_moduleMPTypeGroundSupportBase_respawnVehicle;