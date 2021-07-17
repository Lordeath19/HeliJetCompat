if (!isDedicated) then {
	waitUntil{!isNull player};
};

//wait for Spawn AI functions are initialized
waitUntil{!(isNil{bis_fnc_moduleSpawnAI_main}) && {!(isNil{bis_fnc_moduleSpawnAISectorTactic_main})}};

private _path = "\A3\Missions_F_Heli\MPTypes\GroundSupportBase";
private _compatPath = "\HeliJetCompat\MPTypes\GroundSupportBase";

/*--------------------------------------------------------------------------------------------------

	LOAD FUNCTIONS

--------------------------------------------------------------------------------------------------*/
[
	format["%1\functions\",_path],
	"bis_fnc_moduleMPTypeGroundSupportBase_",
	[
		"setupPlayer",
		"createVehicleCrew",
		"resupplyVehicle",
		"onVehicleEntered",
		"onVehicleLeft",
		"respawnPlayer",
		"evacGroup",
		"hidePlayer",
		"createCamera",
		"destroyCamera",
		"getVehicleAmmo",
		"setFuel",
		"setAmmo",
		"retreatGroup"
	],
	false
]
call bis_fnc_loadFunctions;

[
	format["%1\functions\",_compatPath],
	"hjc_fnc_moduleMPTypeGroundSupportBase_",
	[
		"setupVehicle",
		"respawnVehicle",
		"lockAircraft"
	],
	false
]
call bis_fnc_loadFunctions;



/*--------------------------------------------------------------------------------------------------

	EXECUTE MODULE FUNCTIONS

--------------------------------------------------------------------------------------------------*/
if (isServer) then
{
	_this call compile preprocessFileLineNumbers format["%1\%2",_compatPath,"initServer.sqf"];
};

//if (missionNamespace getVariable ["BIS_fnc_moduleMPTypeGroundSupportBase_executed",false]) exitWith {};
//BIS_fnc_moduleMPTypeGroundSupportBase_executed = true;

if !(isDedicated) then
{
	_this call compile preprocessFileLineNumbers format["%1\%2",_path,"initPlayerLocal.sqf"];
};
