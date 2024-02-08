class_name BossTeleport
extends State


@export var body: Boss
@export var _anim_player: AnimationPlayer;

func _enter():
	var player: Node3D = get_tree().get_nodes_in_group("Player").front();
	body.position = player.position;
	_anim_player.play("teleport");
	_anim_player.queue("slam");

func _exit():
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass
