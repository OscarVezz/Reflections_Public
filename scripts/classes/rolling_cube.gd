class_name RollingCube
extends CharacterBody3D


signal take_damage(amount);

@export var rotation_speed := 0.2;
@export var cube_size := 1.0;
@export var offset := Vector3(0.0, 0.5, 0.0);
@export var limit_movement := false;

@onready var _pivot: Node3D = $Pivot;
@onready var _mesh: 	MeshInstance3D = $Pivot/Boy;
@onready var _hitbox: CollisionShape3D = $Hitbox;
@onready var _sphere_cast: ShapeCast3D = $ShapeCast3D;


var movementTween: Tween



func roll_and_move(direction: Vector3) -> Vector3:
	
	if (movementTween):
		if (movementTween.is_running()):
			return Vector3.ZERO;
	
	
	# Here is the clip out of bounds problem 
	if (limit_movement):
		_sphere_cast.position = direction;
		_sphere_cast.force_shapecast_update();
		if (_sphere_cast.is_colliding()):
			return Vector3.ZERO;
		#if (test_move(transform, direction)):
			#return false;
	
	
	var rounded: Vector3 = Utilities.custom_round_vector(global_position);
	var destination: Vector3 = rounded + ((cube_size * Vector3.ONE) * direction)
	
	
	# Setting up the children for rotation
	_pivot.global_position += ((cube_size / 2) * direction);
	_mesh.global_position += (-(cube_size / 2) * direction);
	
	
	var axis: Vector3 = direction.cross(Vector3.DOWN)
	# Transform base Rotation (VERY BAD) (please use quaternions bro)
#	var from = _pivot.transform.basis;
#	var to = _pivot.transform.basis.rotated(axis, PI/2);
	var from = Quaternion(_pivot.transform.basis).normalized();
	var to = (Quaternion(axis, PI/2) * from).normalized();
	
	
	movementTween = create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true);
	movementTween.tween_property(self, "position", rounded, rotation_speed)
	movementTween.tween_method(Callable(self, "rotate_transform"), from, to, rotation_speed);
	movementTween.tween_method(Callable(self, "move_transform"), Vector3.ZERO, direction + offset, rotation_speed);
	movementTween.chain().tween_callback(Callable(self, "restart_children_positions").bind(destination));
	
	return destination;



func rotate_transform(value) -> void:
	_pivot.transform.basis = Basis(value)
#	_pivot.transform = _pivot.transform.orthonormalized()


func move_transform(pos) -> void:
	_hitbox.position = pos;


func restart_children_positions(pos) -> void:
	var true_pos = Utilities.custom_round_vector(_hitbox.global_position)
	
	global_position = Vector3(true_pos.x , 0.0, true_pos.z)
	_pivot.position = Vector3.ZERO
	_mesh.global_position = pos + offset
	_hitbox.position = offset
	
	AudioManager.play_sfx(0, -2);


func damage(amount: int):
	take_damage.emit(amount);
