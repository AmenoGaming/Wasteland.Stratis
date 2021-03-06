// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerEventServer.sqf
//	@file Author: AgentRev

private ["_type", "_money"];

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_type) do
{
	case "pickupMoney":
	{
		_money = [_this, 1, 0, [0]] call BIS_fnc_param;

		if (_money > 0) then
		{
			[format ["Has cogido $%1", [_money] call fn_numbersText], 5] call mf_notify_client;
			[] spawn fn_savePlayerData;
		}
		else
		{
			["El dinero era falso!", 5] call mf_notify_client;
		};
	};
};
