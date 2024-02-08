class_name EnemyFollow
extends State


@export var enemy: CharacterBody2D
@export var moveSpeed := 10.0

var player: CharacterBody2D


func _enter():
	player = get_tree().get_nodes_in_group("Player").front()

func _exit():
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	if (!enemy):
		return;
	
	var direction = player.global_position - enemy.global_position;
#	if (direction.length() > 25):
	enemy.set_velocity(direction.normalized() * moveSpeed)
	enemy.move_and_slide()
	enemy.velocity;
	
	if (direction.length() > 50):
		emit_signal("transitioned", self, "enemyidle");
