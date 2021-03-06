/*
execVM "functions\fn_bridgeBuild.sqf";
*/

#include "\z\ace\addons\main\script_component.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_bridgeDummy", "_mouseClickEH", "_mouseWheelEH"];

private _position = getPosATLVisual _bridgeDummy;
_position params ["_posX", "_posY", "_posZ"];
private _dir = getDir player;

/*
private _offset = _bridgeDummy getVariable ["gradTnT_bridgeAttachPosition", [0, 16, 1.5]];
_offset params ["_offsetX", "_offsetY", "_offsetZ"];
_position set [2,(_posZ + _offsetZ)];
*/

deleteVehicle _bridgeDummy;
addCamShake [10, 1, 3];

(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", _mouseClickEH];
(findDisplay 46) displayRemoveEventHandler ["MouseZChanged", _mouseWheelEH];

[] call EFUNC(interaction,hideMouseHint);

inGameUISetEventHandler ["PrevAction", "false"];
inGameUISetEventHandler ["NextAction", "false"];

player forceWalk false;
player setVariable ["gradTnT_carryBridge", -1];

private _bridgesBuilt = player getVariable ["SB_bridgesBuilt", 0];
// exitwith
if (_bridgesBuilt >= SB_MAX_BRIDGES) exitWith {
    private _string = format ["Bridge Limit of %1 reached. Destroy one of the placed bridges via ACE Interact to be able to build new ones.", SB_MAX_BRIDGES];
    hintSilent _string;
};


private _bridge = createSimpleObject ["\a3\structures_f_exp\infrastructure\bridges\bridgewooden_01_f.p3d", _position];
_bridge setPosATL _position;
_bridge setDir _dir;

_bridge enableSimulationGlobal false;

private _bridgeHelper = "rhs_ec400" createVehicle [0,0,0];
_bridgeHelper attachTo [_bridge,[3,0,1.1]];

_bridgeHelper setVariable ["gradTnT_bridgeHelperBridge", _bridge, true];
_bridge setVariable ["gradTnT_bridgeHelper", _bridgeHelper, true];

private _bridgesBuilt = player getVariable ["SB_bridgesBuilt", 0];
_bridgesBuilt = _bridgesBuilt + 1;
player setVariable ["SB_bridgesBuilt", _bridgesBuilt, true];

private _bridgesLeft = format ["You can build %1 more bridges.", (2 - _bridgesBuilt)];
hintSilent _bridgesLeft;


[_bridge, "", ""] spawn gradTnT_fnc_bftAdd;


[_bridge] remoteExec ["gradTnT_fnc_bridgeActionDestroy", 0, true];
[_bridge, side player] remoteExec ["gradTnT_fnc_bridgeMarker", 0, true];
