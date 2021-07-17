//make sure player cannot get into the mission if the scenario is over
if (missionNamespace getVariable ["BIS_fnc_moduleMPTypeGroundSupport_missionEnded",false]) exitWith {endMission "End1";};

_logic = _this select 0;
_logicName = gettext (configfile >> "cfgvehicles" >> typeof _logic >> "displayname");

_o = "<img image='\a3\Ui_f\data\IGUI\RscIngameUI\RscHint\indent_gr.paa' width='11'/>";

_rules = format ["<img image='%2' height='32' /><font size='32' face='PuristaLight'> %1</font>",_logicName,gettext (configfile >> "cfgmpgametypes" >> "zsc" >> "icon")];
_keyPrefix = "str_a3_mp_groundsupport_rules_";

{
	_rules = _rules + "<br/><br/>" + _o + localize(_keyPrefix + _x);
}
forEach ["sectors","pilots","role","tasks","enemytickets","winning","wincondition"];

_tips = "";
_keyPrefix = "str_a3_mp_groundsupport_tips_";

{
	if (typeName _x == typeName "") then
	{
		_tips = _tips + "<br/><br/>";
	}
	else
	{
		_tips = _tips + "<br/>  ";
		_x = _x select 0;
	};

	_tips = _tips + _o + localize(_keyPrefix + _x);
}
forEach ["capturesectors","manpowercap","completingtasks_main","completingtasks","completingtasks_1","completingtasks_2","completingtasks_3","completingtasks_4","base",["base_helipad"],["base_maintenance"],["base_medevac"],"lockedaircraft","leavingaircraft","maintenance"];

player creatediarysubject ["BIS_fnc_moduleMPTypeGroundSupport",_logicName];
player creatediaryrecord ["BIS_fnc_moduleMPTypeGroundSupport",[localize "str_a3_firingdrills_tips0",_tips]];
player creatediaryrecord ["BIS_fnc_moduleMPTypeGroundSupport",[localize "str_a3_firing_drills_diary_rec2_title",_rules]];

//wait for loading screen to finish
waitUntil {!([] call BIS_fnc_isLoading) && {time >= 1}};

//initial conversation
["SayLocal", [side group player, "01_PlayerBriefing", true]] call BIS_fnc_moduleMPTypeGroundSupport_playSentence;