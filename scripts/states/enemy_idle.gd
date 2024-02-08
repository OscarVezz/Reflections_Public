class_name EnemyIdle
extends State

@export var enemy: CharacterBody2D;
@export var moveSpeed := 10.0

var player: CharacterBody2D

var move_direction: Vector2
var wander_time: float


func _enter():
	RandomizeWander();
	player = get_tree().get_nodes_in_group("Player").front()

func _update(_delta: float):
	if (wander_time > 0):
		wander_time -= _delta;
	else:
		RandomizeWander();

func _physics_update(_delta: float):
	if (!enemy):
		return;
	
	enemy.set_velocity(move_direction * moveSpeed)
	enemy.move_and_slide()
	enemy.velocity
	
	var direction = player.global_position - enemy.global_position;
	if (direction.length() < 220):
		emit_signal("transitioned", self, "enemyfollow");


func RandomizeWander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1,2);
