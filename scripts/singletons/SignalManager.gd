extends Node

# Utilities
signal player_moved(new_position)
signal player_shoot(shoot)
signal explosion_prop_update(index)
signal explosion_prop_ended(index)
signal directional_free(indication, position)

# JSON specifics
signal floor_expand(args)	# to:Vector3, time:float, trans_type:int, ease_type:int, mirror_height:float
signal spawn_enemies(args)	# type: int position: Vector3, direction: Vector3, amount: int, separation: Vector3, speed: float, mirror_x: bool, mirror_y: bool
signal free_all(args)
signal bost_all(args)

signal boss_enabled(args)
signal boss_moved(args)
signal boss_rotated(args)
signal boss_changed(args)

signal camera_zoom(args)	# fov:float, time:float, trans_type:int, ease_type:int
signal camera_shake(args)	# to:Vector2, time:float, trans_type:int, ease_type:int

signal flash(args)
signal game_end(args)

var is_practice_active := false;

func emit_signals(dict: Dictionary):
	
	for key in dict:
		var args: Array = dict[key];
		emit_signal(key, args);
