class_name BossLaser
extends State


@export var body: Boss
@export var _anim_player: AnimationPlayer;

func _enter():
	#if (body.rotation_tween):
		#body.rotation_tween.kill();
	var player: Node3D = get_tree().get_nodes_in_group("Player").front();
	body.position = player.position;
	_anim_player.play("laser")

func _exit():
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass


func _explode():
	AudioManager.play_sfx(6, 14);

func _shake():
	SignalManager.camera_shake.emit([Vector2(0, 2), 0.46, 6, 1]);
