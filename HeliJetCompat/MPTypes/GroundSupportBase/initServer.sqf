private["_module","_activated","_initialized"];

_module 	= [_this,0,objNull,[objNull]] call bis_fnc_param;
_activated 	= [_this,2,true,[true]] call bis_fnc_param;

_initialized 	= _module getVariable ["initialized",false];

//make sure the module is initialized only once
if (_initialized) exitWith {_module setVariable ["activated",_activated];};

_module setVariable ["initialized",true];
_module setVariable ["activated",_activated];

//["[i][GroundSupportBase][%1] initialized!",_module] call bis_fnc_logFormat;

/*--------------------------------------------------------------------------------------------------

	INIT RESUPPLY & EVAC & AIRCRAFT-RESPAWN POINTS

--------------------------------------------------------------------------------------------------*/
private["_resupplyPoints","_evacPoints","_respawnPoints"];

_resupplyPoints = [_module,["LocationResupplyPoint_F"],true] call BIS_fnc_synchronizedObjects;
_evacPoints 	= [_module,["LocationEvacPoint_F"],true] call BIS_fnc_synchronizedObjects;
_respawnPoints 	= [_module,["LocationRespawnPoint_F"],true] call BIS_fnc_synchronizedObjects;

/*--------------------------------------------------------------------------------------------------

	INIT EVAC POINTS SINKS

--------------------------------------------------------------------------------------------------*/
private["_evacSinks"];

_evacSinks = [];

{
	_evacSinks = _evacSinks + ([_x,["Car"],false] call BIS_fnc_synchronizedObjects);

	_light = createVehicle ["PortableHelipadLight_01_red_F",getPos _x,[],0,"CAN_COLLIDE"];
	_light setPosASL getPosASL _x;
}
forEach _evacPoints;

{
	_x setAmmoCargo 0;
	_x setRepairCargo 0;
	_x setFuelCargo 0;
	_x lock 2;
	_x allowDamage false;
}
forEach _evacSinks;

/*--------------------------------------------------------------------------------------------------

	INIT RESUPPLY VEHICLES

--------------------------------------------------------------------------------------------------*/
private["_resupplyVehicles","_light"];

_resupplyVehicles = [];

{
	_resupplyVehicles = _resupplyVehicles + ([_x,["Car"],false] call BIS_fnc_synchronizedObjects);

	_light = createVehicle ["PortableHelipadLight_01_blue_F",getPos _x,[],0,"CAN_COLLIDE"];
	_light setPosASL getPosASL _x;
}
forEach _resupplyPoints;

{
	_x setAmmoCargo 0;
	_x setRepairCargo 0;
	_x setFuelCargo 0;
	_x lock 2;
	_x allowDamage false;
}
forEach _resupplyVehicles;

/*--------------------------------------------------------------------------------------------------

	STORE BASE VARIABLES

--------------------------------------------------------------------------------------------------*/
private["_sideID","_side","_size"];

_sideID = _module getVariable ["Side",1];
_side   = _sideID call bis_fnc_sideType;

_size 	= _module getVariable ["size",200];

_module setVariable ["side",_side,true];
_module setVariable ["sideID",_sideID,true];
_module setVariable ["size",_size,true];
_module setVariable ["resupplyPoints",_resupplyPoints,true];
_module setVariable ["evacPoints",_evacPoints,true];
_module setVariable ["evacSinks",_evacSinks,true];
_module setVariable ["respawnPoints",_respawnPoints,true];
_module setVariable ["resupplyVehicles",_resupplyVehicles,true];

missionNamespace setVariable [format["bis_fnc_moduleMPTypeGroundSupportBase_%1",_side],_module];

//set friendship with CIV and vice versa
_side setFriend [civilian, 1];
civilian setFriend [_side, 1];

/*--------------------------------------------------------------------------------------------------

	CREATE GROUP ICON HOLDER

--------------------------------------------------------------------------------------------------*/
private["_hqUnit","_hqGroup","_hqClass","_hqPos","_hqFlag","_hqFlagClass","_hqMarker"];

_hqClass 	= ["O_officer_F","B_officer_F","I_officer_F"] select _sideID;
_hqFlagClass  	= ["Flag_CSAT_F","Flag_NATO_F","Flag_AAF_F"] select _sideID;
_hqFlag 	= nearestObjects [getPos _module, [_hqFlagClass], _size];
_hqMarker	= ["o_hq","b_hq","n_hq"] select _sideID;

if (count _hqFlag > 0) then
{
	_hqFlag = _hqFlag select 0;
	_hqPos = getPos _hqFlag;
}
else
{
	_hqPos = getPos _module;
	_hqFlag = createVehicle [_hqFlagClass,_hqPos,[],0,"CAN_COLLIDE"];
	_hqFlag setPos _hqPos;
};

//create the HQ marker
private _marker = createMarker ["marker_" + _hqMarker,_hqPos];
_marker setMarkerShape "ICON";
_marker setMarkerType _hqMarker;

//offset flag vertical position
_hqPos set [2,3.75];

_hqGroup = createGroup _side;
_hqUnit	 = _hqGroup createUnit [_hqClass, _hqPos, [], 0, "NONE"];

if (isMultiplayer) then
{
	_hqUnit enableSimulationGlobal false;
	_hqUnit hideObjectGlobal true;
}
else
{
	_hqUnit enableSimulation false;
	_hqUnit hideObject true;
};

_hqUnit setPos _hqPos;

_module setVariable ["hqLogicGroup",_hqGroup,true];

/*--------------------------------------------------------------------------------------------------

	INIT AIRCRAFT AND RESPAWN POINTS

--------------------------------------------------------------------------------------------------*/
_syncHelis = [_module,["Helicopter"],false] call BIS_fnc_synchronizedObjects;
_syncPlanes = [_module,["Plane"],false] call BIS_fnc_synchronizedObjects;

{
	[_x,_module] spawn hjc_fnc_moduleMPTypeGroundSupportBase_setupVehicle;
}
forEach (_syncHelis + _syncPlanes);

/*--------------------------------------------------------------------------------------------------

	FLAG MODULE INIT SERVER SCRIPT AS COMPLETED

--------------------------------------------------------------------------------------------------*/
_module setVariable ["initServer_completed",true,true];