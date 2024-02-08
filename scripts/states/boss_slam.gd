class_name BossSlam
extends State


@export var body: Boss
@export var _anim_player: AnimationPlayer;

func _enter():
	#if (body.rotation_tween):
		#body.rotation_tween.kill();
	_anim_player.play("slam")

func _exit():
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass

func _explode():
	AudioManager.play_sfx(4, 4);

func _shake():
	SignalManager.camera_shake.emit([Vector2(0, 2), 0.46, 6, 1]);
