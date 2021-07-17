["BIS_fnc_moduleMPTypeGroundSupport"] call bis_fnc_startLoadingScreen;

_logic = [_this,0,objnull,[objnull]] call bis_fnc_param;
_units = [_this,1,[],[[]]] call bis_fnc_param;

bis_fnc_moduleMPTypeGroundSupport_module = _logic;

enableSaving [false,false];
enableTeamSwitch false;

true call bis_fnc_drawRespawnPositions;

//--- Global variable declaration
_path = "\A3\Missions_F_Heli\MPTypes\GroundSupport\";
[
	_path,
	"BIS_fnc_moduleMPTypeGroundSupport_",
	[
		"initPlayerServer"
	],
	false
] call bis_fnc_loadFunctions;

//--- Server-side FSM declaration
BIS_fnc_moduleMPTypeGroundSupport_missionFlowFSM = _path + "missionFlow.fsm";

//--- Detect synchronized
_sides = [[],[],[]];
{
	_xType = typeof _x;
	switch _xType do {

		case "SideBLUFOR_F";
		case "SideOPFOR_F";
		case "SideResistance_F": {
			_sideID = ["SideOPFOR_F","SideBLUFOR_F","SideResistance_F"] find _xType;
			if (_sideID >= 0) then {
				_side = _sideID call bis_fnc_sideType;
				_x setvariable ["side",_side,true];

				_xSynced = synchronizedobjects _x;
				_x setvariable ["BIS_moduleMPTypeGroundSupport_mission",_logic];

				_curators = [];
				{
					if (_x call bis_fnc_isCurator) then {_curators set [count _curators,_x];};
				} foreach _xSynced;

				_sides set [_sideID,[_side,_x,+_curators]];
			};
		};
	};
} foreach (_logic call bis_fnc_allsynchronizedobjects);

//--- Remove empty sides
{
	if (count _x == 0) then {_sides set [_foreachindex,-1];};
} foreach _sides;
_sides = _sides - [-1];

_logic setvariable ["sides",_sides,true];

//--- onPlayerConnected
["BIS_fnc_moduleMPTypeGroundSupport_initPlayerServer",_logic] call bis_fnc_onPlayerConnected;

//--- Wait for modules to initialize
waituntil {!isnil {bis_fnc_init}};

//--- Initialize HQ speakers
{
	_var = "BIS_HQ_" + str _x;
	missionnamespace setvariable [_var,_x call bis_fnc_modulehq];
	publicvariable _var;
} foreach [west,east,resistance];

//--- Main mission flow
BIS_fnc_moduleMPTypeGroundSupport_missionFlow = [_logic] execfsm BIS_fnc_moduleMPTypeGroundSupport_missionFlowFSM;

["BIS_fnc_moduleMPTypeGroundSupport"] call bis_fnc_endLoadingScreen;

//--- Add scripted event handlers
{
	[missionNamespace,_x,BIS_fnc_moduleMPTypeGroundSupport_onEventHandler] call bis_fnc_addScriptedEventHandler;
}
forEach
[
	"bis_groundSupport_needTransport",
	"bis_groundSupport_needEvac",
	"bis_groundSupport_needAmmo",
	"bis_groundSupport_needSupport",
	"bis_groundSupport_destinationReached",
	"bis_groundSupport_inEnemySector",
	"bis_groundSupport_closeToDestination",
	"bis_groundSupport_farFromDestination",
	"bis_groundSupport_joined",
	"bis_groundSupport_wiped",
	"bis_groundSupport_decimated",
	"bis_groundSupport_transportStarted",
	"bis_groundSupport_transportEnded",
	"bis_groundSupport_transportAborted",
	"bis_groundSupport_groupSpawned",
	"bis_groundSupport_groupTypeChanged",
	"bis_groundSupport_boarded",
	"bis_groundSupport_disembarked"
];


true
