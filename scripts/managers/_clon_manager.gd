extends Node



@export var _player_manager: Node;

@export var _focus: Node3D;
@export var _mirror_left: 	Node3D;
@export var _mirror_center: Node3D;
@export var _mirror_right: 	Node3D;
@export var _clone_left: 	Node3D;
@export var _clone_center: 	Node3D;
@export var _clone_right: 	Node3D;

@onready var _focus_position: Vector3 = Vector3.ZERO;
@onready var _mirror_left_position: Vector3 = Vector3.ZERO;
@onready var _mirror_center_position: Vector3 = Vector3.ZERO;
@onready var _mirror_right_position: Vector3 = Vector3.ZERO;


func _ready():
	_player_manager.connect("has_moved", Callable(self, "move_clones"));


func _process(_delta):
	_focus_position = _focus.global_position;
	
	_mirror_left_position = _mirror_left.global_position;
	_mirror_center_position = _mirror_center.global_position;
	_mirror_right_position = _mirror_right.global_position;
	
	_clone_left.global_position = separation_vector(_focus_position, _mirror_left_position, Vector3(1.0, 0.0, -1.0));
	_clone_center.global_position = separation_vector(_focus_position, _mirror_center_position, Vector3(-1.0, 0.0, 1.0))
	_clone_right.global_position = separation_vector(_focus_position, _mirror_right_position, Vector3(1.0, 0.0, -1.0));


func separation_vector(from: Vector3, to: Vector3, mask: Vector3) -> Vector3:
	var distance: Vector3 = (to - from) * mask
	return Vector3(distance.x + to.x, distance.y, distance.z + to.z);


func move_clones(direction: Vector3):
	_clone_left.roll_and_move(direction * Vector3(-1.0, 0.0, 1.0));
	_clone_center.roll_and_move(direction * Vector3(1.0, 0.0, -1.0));
	_clone_right.roll_and_move(direction * Vector3(-1.0, 0.0, 1.0));
