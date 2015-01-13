// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate
//@file Created: 23/7/2013 16:00
//@file Description: Check if you can pack the Camouflage Netting
//@file Argument: [_netting] the (object that is a) camo net to check if its packable
//@file Argument: [] automatically find the closest camo net to check.

#define ERR_NO_TARGET "No estás cerca de ninguna red de camuflaje"
#define ERR_TOO_FAR_AWAY "Estás demasiado lejos de la red de camuflaje"
#define ERR_ALREADY_HAVE "No puedes llevar más redes de camuflaje"
private ["_netting", "_error"];
_netting = objNull;

if (count _this == 0) then {
	_netting = [] call mf_items_camo_net_nearest;
} else {
	_netting = _this select 0;
};

_error = "";
switch (true) do {
	case (!alive player): {_error = " "}; // Player is dead, no need for a error message
	case (player distance _netting > 5): {_error = ERR_TOO_FAR_AWAY};
	case (MF_ITEMS_CAMO_NET call mf_inventory_is_full): {_error = ERR_ALREADY_HAVE};
};
_error;
