extends CharacterBody3D


@onready var _hitbox: CollisionShape3D = $CollisionShape3D


func _ready():
	SignalManager.player_moved.connect(move_shadow);


func move_shadow(new_position: Vector3):
	_hitbox.global_position = new_position;
