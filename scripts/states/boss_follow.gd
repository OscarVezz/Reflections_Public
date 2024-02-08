class_name BossFollow
extends State


@export var body: Boss
@export var moveSpeed := 1.5

var player: Node3D


func _enter():
	player = get_tree().get_nodes_in_group("Player").front();

func _exit():
	pass


func _update(_delta: float):
	if (!player):
		return;
	
	var direction = (player.global_position - body.global_position).normalized();
	body.position += (Vector3(direction.x, 0, direction.z) * moveSpeed * _delta);

func _physics_update(_delta: float):
	pass
