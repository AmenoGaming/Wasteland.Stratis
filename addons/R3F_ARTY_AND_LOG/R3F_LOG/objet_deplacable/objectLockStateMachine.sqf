//	@file Author: [404] Costlyy
//	@file Version: 1.0
//  @file Date:	21/11/2012
//	@file Description: Locks an object until the player disconnects.
//	@file Args: [object,player,int,lockState(lock = 0 / unlock = 1)]

// Check if mutex lock is active.
if(R3F_LOG_mutex_local_verrou) exitWith {
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
};

private["_locking", "_object", "_lockState", "_lockDuration", "_stringEscapePercent", "_iteration", "_unlockDuration", "_totalDuration", "_checks", "_success"];

_object = _this select 0;
_lockState = _this select 3;

_totalDuration = 0;
_stringEscapePercent = "%";

switch (_lockState) do
{
	case 0: // LOCK
	{
		R3F_LOG_mutex_local_verrou = true;
		_totalDuration = 5;
		//_lockDuration = _totalDuration;
		//_iteration = 0;

		_checks =
		{
			private ["_progress", "_object", "_failed", "_text"];
			_progress = _this select 0;
			_object = _this select 1;
			_failed = true;

			switch (true) do
			{
				case (!alive player): { _text = "" };
				case (doCancelAction): { doCancelAction = false; _text = "Cerrar cancelado" };
				case (vehicle player != player): { _text = "Fallo! No puedes hacerlo desde un vehiculo" };
				case (!isNull (_object getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Fallo! Alguien ha movido el objeto" };
				case (_object getVariable ["objectLocked", false]): { _text = "Fallo! Alguien se te ha adelantado" };
				default
				{
					_failed = false;
					_text = format ["Cerrar %1%2 completado", floor (_progress * 100), "%"];
				};
			};

			[_failed, _text];
		};

		_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [_object]] call a3w_actions_start;

		if (_success) then
		{
			_object setVariable ["objectLocked", true, true];
			_object setVariable ["ownerUID", getPlayerUID player, true];

			["Object locked!", 5] call mf_notify_client;
		};

		R3F_LOG_mutex_local_verrou = false;

		/*player switchMove "AinvPknlMstpSlayWrflDnon_medic";

		for "_iteration" from 1 to _lockDuration do
		{
			// If the player is too far or dies, revert state.
			if (player distance _object > 14 || !alive player) exitWith
			{
		        2 cutText ["Cerrar objeto interrumpido...", "PLAIN DOWN", 1];
				R3F_LOG_mutex_local_verrou = false;
			};

			// Keep the player locked in medic animation for the full duration of the unlock.
			if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then {
				player switchMove "AinvPknlMstpSlayWrflDnon_medic";
			};

			_lockDuration = _lockDuration - 1;
		    _iterationPercentage = floor (_iteration / _totalDuration * 100);

			2 cutText [format["Cerrar objeto %1%2 completado", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
		    sleep 1;

			// Sleep a little extra to show that lock has completed.
			if (_iteration >= _totalDuration) exitWith
			{
		        sleep 1;
				_object setVariable ["objectLocked", true, true];
				_object setVariable ["ownerUID", getPlayerUID player, true];
				2 cutText ["", "PLAIN DOWN", 1];
				R3F_LOG_mutex_local_verrou = false;
		    };
		};

		player switchMove ""; */ // Redundant reset of animation state to avoid getting locked in animation.
	};
	case 1: // UNLOCK
	{
		R3F_LOG_mutex_local_verrou = true;
		_totalDuration = if (_object getVariable ["ownerUID", ""] == getPlayerUID player) then { 10 } else { 45 }; // Allow owner to unlock quickly
		//_unlockDuration = _totalDuration;
		//_iteration = 0;

		_checks =
		{
			private ["_progress", "_object", "_failed", "_text"];
			_progress = _this select 0;
			_object = _this select 1;
			_failed = true;

			switch (true) do
			{
				case (!alive player): {};
				case (doCancelAction): { doCancelAction = false; _text = "Desbloquear cancelado" };
				case (vehicle player != player): { _text = "Fallo! No puedes hacerlo desde un vehiculo"};
				case (!isNull (_object getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Action failed! Alguien ha movido el objeto" };
				case !(_object getVariable ["objectLocked", false]): { _text = "Fallo! Alguien se te ha adelantado" };
				default
				{
					_failed = false;
					_text = format ["Desbloquear %1%2 completado", floor (_progress * 100), "%"];
				};
			};

			[_failed, _text];
		};

		_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [_object]] call a3w_actions_start;

		if (_success) then
		{
			_object setVariable ["objectLocked", false, true];
			_object setVariable ["ownerUID", nil, true];
			_object setVariable ["baseSaving_hoursAlive", nil, true];
			_object setVariable ["baseSaving_spawningTime", nil, true];

			["Object unlocked!", 5] call mf_notify_client;
		};

		R3F_LOG_mutex_local_verrou = false;

		/*for "_iteration" from 1 to _unlockDuration do
		{
			// If the player is too far or dies, revert state.
			if (player distance _object > 5 || !alive player) exitWith
			{
		        2 cutText ["Desbloquear objeto interrumpido...", "PLAIN DOWN", 1];
				R3F_LOG_mutex_local_verrou = false;
			};

			// Keep the player locked in medic animation for the full duration of the unlock.
			if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then {
				player switchMove "AinvPknlMstpSlayWrflDnon_medic";
			};

			_unlockDuration = _unlockDuration - 1;
		    _iterationPercentage = floor (_iteration / _totalDuration * 100);

			2 cutText [format["Desbloquear objeto %1%2 completado", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
		    sleep 1;

			// Sleep a little extra to show that lock has completed
			if (_iteration >= _totalDuration) exitWith
			{
		        sleep 1;
				_object setVariable ["objectLocked", false, true];
				_object setVariable ["ownerUID", nil, true];
				_object setVariable ["baseSaving_hoursAlive", nil, true];
				_object setVariable ["baseSaving_spawningTime", nil, true];
				2 cutText ["", "PLAIN DOWN", 1];
				R3F_LOG_mutex_local_verrou = false;
		    };
		};

		player switchMove ""; */ // Redundant reset of animation state to avoid getting locked in animation.
	};
	default // This should not happen...
	{
		diag_log format["WASTELAND DEBUG: An error has occured in LockStateMachine.sqf. _lockState was unknown. _lockState actual: %1", _lockState];
	};
};

if (R3F_LOG_mutex_local_verrou) then {
	R3F_LOG_mutex_local_verrou = false;
	diag_log format["WASTELAND DEBUG: An error has occured in LockStateMachine.sqf. Mutex lock was not reset. Mutex lock state actual: %1", R3F_LOG_mutex_local_verrou];
};
