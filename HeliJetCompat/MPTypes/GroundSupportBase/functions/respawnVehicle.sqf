private["_base","_class","_respawnPoints","_point","_objects","_emptyPoint","_vehicle"];

_base = _this select 0;
_class = _this select 1;

//["[i] Vehicle respawn called: _base = %1 | _vehicleClass = %2",_base,_vehicleClass] call bis_fnc_logFormat;

_respawnPoints = _base getVariable ["respawnPoints",[]];

if (count _respawnPoints == 0) exitWith
{
	format["[x] Base |%1| doesn't have respawn points defined!",_base] call bis_fnc_error;
};

_respawnPoints = _respawnPoints call BIS_fnc_arrayShuffle;
_emptyPoint = objNull;

waitUntil
{
	sleep 1;

	{
		sleep 0.1;

		_point = _x;
		_objects = nearestObjects [_point, ["Car","Air"], 15];
		_objects append ((nearestObjects [_point, ["CAManBase"], 15]) select {alive _x});

		if (count _objects == 0) exitWith
		{
			_emptyPoint = _point;
		};
	}
	forEach _respawnPoints;

	if (isNull _emptyPoint) then {["[x] There is no empty respawn point for side %1!",_base getVariable ["side",[]]] call bis_fnc_logFormat;};

	!(isNull _emptyPoint)
};

_vehicle = createVehicle [_class,getPos _emptyPoint,[],0,"NONE"];
_vehicle setPos (getPos _emptyPoint);
_vehicle setDir (getDir _emptyPoint);

//_gVar = format["bis_heli%1",round random 1000];
//missionNamespace setVariable [_gVar,_vehicle,true];
//["[i] Vehicle |%4| respawned at base: _base = %1 | _vehicle = %2 | _class = %3",_base,_vehicle,_class,_gVar] call bis_fnc_logFormat;

[_vehicle,_base] spawn hjc_fnc_moduleMPTypeGroundSupportBase_setupVehicle;

//play notification to the side about new aircraft being deployed
["PlaySentenceGlobal", [_base getVariable "side", "10_NewChopper", false]] call BIS_fnc_moduleMPTypeGroundSupport_playSentence;