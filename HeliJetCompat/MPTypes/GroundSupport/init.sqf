// Debug log
bis_fnc_moduleMPTypeGroundSupport_debug = false;

// Wait for player
if (!isDedicated) then {
	waitUntil{!isNull player};
};

//wait for Spawn AI functions are initialized
waitUntil{!(isNil{bis_fnc_moduleSpawnAI_main}) && {!(isNil{bis_fnc_moduleSpawnAISectorTactic_main})}};

private _path = "\A3\Missions_F_Heli\MPTypes\GroundSupport\functions\";

[
	_path,
	"bis_fnc_moduleMPTypeGroundSupport_",
	[
		"requester",
		"onEventHandler",
		"rewardScore",
		"playSentence",
		"intro",
		"getCasScoreReward",
		"logFormat",
		"log"
	],
	false
]
call bis_fnc_loadFunctions;

// Clear vehicle cargos
{
	clearMagazineCargo _x;
	clearWeaponCargo _x;
	clearItemCargo _x;
	clearBackpackCargo _x;
}
forEach ((allMissionObjects "Air") + (allMissionObjects "Car") + (allMissionObjects "Ship"));

if (isServer) then
{
	_this execVM "\HeliJetCompat\MPTypes\GroundSupport\initServer.sqf";
};

if !(isDedicated) then
{
	[] spawn bis_fnc_moduleMPTypeGroundSupport_intro;
	_this execVM "\HeliJetCompat\MPTypes\GroundSupport\initPlayerLocal.sqf";
};

// Initializes dynamic requester system, locality handled within
["Initialize"] call bis_fnc_moduleMPTypeGroundSupport_requester;

// Initializes score system
if (isMultiplayer) then {
	["Initialize"] call bis_fnc_moduleMPTypeGroundSupport_rewardScore;
};