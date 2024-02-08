class_name RollingArea
extends Area3D


@export var rotation_speed := 0.2;
@export var cube_size := 1.0;
@export var offset := Vector3(0.0, 0.5, 0.0);

@onready var _pivot:  Node3D = $Pivot;
@onready var _mesh:   MeshInstance3D = $Pivot/Boy;
@onready var _hitbox: CollisionShape3D = $Hitbox;

var movementTween: Tween
var _desire_direction: Vector3;
var _start_position: Vector2;



func initialize(start_position: Vector3, movement_direction: Vector3, speed: float):
	position = start_position;
	_start_position = Vector2(start_position.x, start_position.z).normalized();
	_desire_direction = movement_direction;
	rotation_speed = speed;



func _ready():
	
	scale = 0.1 * Vector3.ONE
	
	movementTween = create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(true);
	movementTween.tween_property(self, "scale", cube_size * Vector3.ONE, 0.1);



func roll_and_move(direction: Vector3) -> bool:
	
	if (movementTween):
		if (movementTween.is_running()):
			return false;
	
	
	
	var rounded: Vector3;
	if (int(cube_size) % 2 == 0):
		rounded = Utilities.round_vector(global_position);
	else:
		rounded = Utilities.custom_round_vector(global_position);
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
	
	return true;





func rotate_transform(value) -> void:
	_pivot.transform.basis = Basis(value)
#	_pivot.transform = _pivot.transform.orthonormalized()


func move_transform(pos) -> void:
	_hitbox.position = pos;


func restart_children_positions(pos) -> void:
	global_position = pos
	_pivot.position = Vector3.ZERO
	_mesh.global_position = pos + offset
	_hitbox.position = offset



func _on_RollingArea_body_entered(_body):
	if (_body is RollingCube):
		_body.damage(1);
	queue_free()


func _on_VisibilityNotifier_screen_exited():
	var a = _start_position.dot(Vector2(position.x, position.z).normalized())
	if (a < 0):
		queue_free()
