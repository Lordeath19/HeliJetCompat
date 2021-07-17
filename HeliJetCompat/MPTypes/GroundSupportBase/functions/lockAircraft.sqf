/*--------------------------------------------------------------------------------------------------

	FUNCTION IS MEANT TO RUN ON CLIENT

	[_aircraft,_mode] call hjc_fnc_moduleMPTypeGroundSupportBase_lockAircraft;

--------------------------------------------------------------------------------------------------*/
private["_aircraft","_mode"];

_aircraft  = [_this,0,objNull,[objNull]] call bis_fnc_param;
_mode  = [_this,1,"default",[""]] call bis_fnc_param;

if (!local _aircraft) exitWith
{
	//["[x] Function was called on REMOTE vehicle '%1'!",_aircraft] call bis_fnc_logFormat;

	[_this,"hjc_fnc_moduleMPTypeGroundSupportBase_lockAircraft",_aircraft] call bis_fnc_MP;
};

switch (_mode) do
{
	case "init":
	{
		_aircraft lockCargo true;

		//lock non-personal turrets
		{
			_aircraft lockTurret [_x, true];
		}
		forEach (allTurrets _aircraft);

		_aircraft lock false;
	};
	case "resupply":
	{
		//unlock vehicle
		_aircraft lock false;
	};
	//default state when player entered driver's seat
	default
	{
		/*
		["[ ][%1] local _aircraft: %2",_aircraft,local _aircraft] call bis_fnc_logFormat;
		["[ ][%1] local driver: %2",_aircraft,local driver _aircraft] call bis_fnc_logFormat;

		{
			["[ ][%1] local turret %2: %3",_aircraft,_x,_aircraft turretLocal _x] call bis_fnc_logFormat;
		}
		forEach allTurrets[_aircraft,true];
		*/

		//lock vehicle
		_aircraft lock true;

		private _lockScript = _aircraft getVariable ["bis_lockScript",scriptNull];

		if !(scriptDone _lockScript) then {terminate _lockScript};

		_lockScript = _aircraft spawn
		{
			private _aircraft = _this;
			private _t = time + 20;
			private _personalTurrets = allTurrets[_aircraft,true] - allTurrets[_aircraft,false];

			waitUntil
			{
				{!(_aircraft turretLocal _x) && {isNull(_aircraft turretUnit _x)}} count _personalTurrets == 0 || {time > _t}
			};

			//unlock cargo positions in general
			_aircraft lockCargo false;

			//lock the 2 seats in little bird
			if (typeOf _aircraft == "B_aircraft_Light_01_F") then
			{
				_aircraft lockCargo [0, true];
				_aircraft lockCargo [1, true];
			};

			//unlock personal turrets
			{
				_aircraft lockTurret [_x, false];
			}
			forEach (allTurrets[_aircraft,true] - allTurrets[_aircraft,false]);

			/*
			{
				["[ ][%1] local turret %2: %3",_aircraft,_x,_aircraft turretLocal _x] call bis_fnc_logFormat;
			}
			forEach allTurrets[_aircraft,true];
			*/
		};

		_aircraft setVariable ["bis_lockScript",_lockScript];
	};
};