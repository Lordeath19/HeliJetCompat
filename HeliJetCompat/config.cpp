class CfgPatches
{
	class HeliJetCompat
	{
		author="Lordeath19";
		name="Arma 3 Heli DLC Jet Support";
		url="https://www.arma3.com";
		requiredAddons[]=
		{
			"A3_Data_F_Heli",
            "A3_Missions_F_Heli",

		};
		requiredVersion=0.1;
		units[]=
		{
			"ModuleMPTypeGroundSupport_F",
			"ModuleMPTypeGroundSupportBase_F"
		};
		weapons[]={};
	};
};
class CfgFunctions
{
	class HeliJetCompat
	{
		tag="HJC";
		class MissionTypes
		{
			class ModuleMPTypeGroundSupport
			{
				file="\HeliJetCompat\MPTypes\GroundSupport\init.sqf";
			};
			class ModuleMPTypeGroundSupportBase
			{
				file="\HeliJetCompat\MPTypes\GroundSupportBase\init.sqf";
			};
		};
	};
};

class CfgVehicles
{
	class Module_F;
	class ModuleMPType_F: Module_F
	{
		class ModuleDescription;
	};
	class ModuleMPTypeGroundSupport_F: ModuleMPType_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleMPTypeGroundSupport_F";
		scope=2;
		isGlobal=2;
		isTriggerActivated=0;
		displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupport_title";
		icon="\a3\Missions_F_Curator\data\img\iconMPTypeSectorControl_ca.paa";
		function="HJC_fnc_ModuleMPTypeGroundSupport";
		functionPriority=20;
		class Arguments
		{
			class bis_groundSupport_needTransport
			{
				displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupport_transporttasks";
				class Values
				{
					class Enabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_enabled";
						value=1;
						default=1;
					};
					class Disabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_disabled";
						value=0;
					};
				};
				typeName="NUMBER";
			};
			class bis_groundSupport_needEvac
			{
				displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupport_medevactasks";
				class Values
				{
					class Enabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_enabled";
						value=1;
						default=1;
					};
					class Disabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_disabled";
						value=0;
					};
				};
				typeName="NUMBER";
			};
			class bis_groundSupport_needAmmo
			{
				displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupport_ressuplytasks";
				class Values
				{
					class Enabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_enabled";
						value=1;
						default=1;
					};
					class Disabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_disabled";
						value=0;
					};
				};
				typeName="NUMBER";
			};
			class bis_groundSupport_needSupport
			{
				displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupport_castasks";
				class Values
				{
					class Enabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_enabled";
						value=1;
						default=1;
					};
					class Disabled
					{
						name="$STR_A3_mp_groundsupport_modulemptypegroundsupport_disabled";
						value=0;
					};
				};
				typeName="NUMBER";
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="$STR_A3_mp_groundsupport_modulemptypegroundsupport_initialize";
			sync[]=
			{
				"SideBLUFOR_F",
				"SideOPFOR_F",
				"SideResistance_F"
			};
			class SideBLUFOR_F
			{
				optional=1;
			};
			class SideOPFOR_F
			{
				optional=1;
			};
			class SideResistance_F
			{
				optional=1;
			};
		};
	};
	class ModuleMPTypeGroundSupportBase_F: ModuleMPType_F
	{
		author="$STR_A3_Bohemia_Interactive";
		_generalMacro="ModuleMPTypeGroundSupportBase_F";
		scope=2;
		isGlobal=2;
		isTriggerActivated=1;
		displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupportbase_base";
		icon="\a3\Missions_F_Curator\data\img\iconMPTypeSectorControl_ca.paa";
		function="HJC_fnc_ModuleMPTypeGroundSupportBase";
		functionPriority=19;
		class Arguments
		{
			class Side
			{
				displayName="$STR_A3_CfgVehicles_ModuleSpawnAI_F_Arguments_Side0";
				class Values
				{
					class West
					{
						name="$STR_A3_CfgGroups_West0";
						value=1;
						default=1;
					};
					class East
					{
						name="$STR_A3_CfgGroups_East0";
						value=0;
					};
					class Guer
					{
						name="$STR_A3_CfgGroups_Indep0";
						value=2;
					};
				};
				typeName="NUMBER";
			};
			class Size
			{
				displayName="$STR_A3_mp_groundsupport_modulemptypegroundsupportbase_size";
				description="$STR_A3_mp_groundsupport_modulemptypegroundsupportbase_sizeofbase";
				typeName="NUMBER";
				defaultValue=200;
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="";
			sync[]={};
		};
	};
};
class CfgGroundSupportRequestTypes
{
	class Transport
	{
		parentTitle="$STR_A3_MP_GroundSupport_Task_Transport_Parent_Title";
		parentDescription="$STR_A3_MP_GroundSupport_Task_Transport_Parent_Description";
		title="$STR_A3_MP_GroundSupport_Task_Transport_Title";
		description="$STR_A3_MP_GroundSupport_Task_Transport_Description";
		marker="$STR_A3_MP_GroundSupport_Task_Transport_Marker";
		fsmPath="a3\Missions_F_Heli\MPTypes\GroundSupport\fsms\Transport.fsm";
	};
	class Medevac
	{
		parentTitle="$STR_A3_MP_GroundSupport_Task_Medevac_Parent_Title";
		parentDescription="$STR_A3_MP_GroundSupport_Task_Medevac_Parent_Description";
		title="$STR_A3_MP_GroundSupport_Task_Medevac_Title";
		description="$STR_A3_MP_GroundSupport_Task_Medevac_Description";
		marker="$STR_A3_MP_GroundSupport_Task_Medevac_Marker";
		fsmPath="a3\Missions_F_Heli\MPTypes\GroundSupport\fsms\Medevac.fsm";
	};
	class CloseAirSupport
	{
		parentTitle="$STR_A3_MP_GroundSupport_Task_CloseAirSupport_Parent_Title";
		parentDescription="$STR_A3_MP_GroundSupport_Task_CloseAirSupport_Parent_Description";
		title="$STR_A3_MP_GroundSupport_Task_CloseAirSupport_Title";
		description="$STR_A3_MP_GroundSupport_Task_CloseAirSupport_Description";
		marker="$STR_A3_MP_GroundSupport_Task_CloseAirSupport_Marker";
		fsmPath="a3\Missions_F_Heli\MPTypes\GroundSupport\fsms\CloseAirSupport.fsm";
	};
	class Slingload
	{
		parentTitle="$STR_A3_MP_GroundSupport_Task_Slingload_Parent_Title";
		parentDescription="$STR_A3_MP_GroundSupport_Task_Slingload_Parent_Description";
		title="$STR_A3_MP_GroundSupport_Task_Slingload_Title";
		description="$STR_A3_MP_GroundSupport_Task_Slingload_Description";
		marker="$STR_A3_MP_GroundSupport_Task_Slingload_Marker";
		fsmPath="a3\Missions_F_Heli\MPTypes\GroundSupport\fsms\Slingload.fsm";
	};
};