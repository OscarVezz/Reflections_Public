extends Node3D


@onready var _animation_player: AnimationPlayer = $AnimationPlayer;


func on_play():
	_animation_player.play("explosion", -1, 3.0, false);
	create_tween().tween_callback(reverse).set_delay(1.5);

func reverse():
	_animation_player.play_backwards("explosion");
	AudioManager.play_sfx(2, 4);
