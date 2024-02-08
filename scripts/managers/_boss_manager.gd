class_name Boss
extends Node3D


@onready var _floating_cube: MeshInstance3D = get_node("Cube");
@onready var _shadow: Sprite3D = get_node("Shadow");
@onready var _animation_player: AnimationPlayer = get_node("AnimationPlayer");
@onready var _state_machine: StateMachine = $StateMachine as StateMachine;

var movement_tween: Tween
var rotation_tween: Tween


func _ready():
	SignalManager.boss_enabled.connect(on_show_call);
	SignalManager.boss_moved.connect(on_move_call);
	SignalManager.boss_changed.connect(on_change_call);
	SignalManager.boss_rotated.connect(on_rotate_call);



func on_change_call(args: Array):
	_state_machine.on_state_change(args[0]);


func on_rotate_call(args: Array):
	rotate_boss(args[0], args[1], args[2], args[3]);

func rotate_boss(axis: Vector3, time: float, trans_type: int, ease_type: int):
	var to = (Quaternion(axis, PI) * quaternion).normalized();
	rotation_tween = create_tween().bind_node(self).set_loops().set_ease(ease_type).set_trans(trans_type);
	rotation_tween.tween_property(self, "quaternion", to, 0.96);


func on_move_call(args: Array):
	move_boss(args[0], args[1], args[2], args[3])

func move_boss(to: Vector3, time: float, trans_type: int, ease_type: int):
	if (movement_tween):
		movement_tween.kill();
	
	movement_tween = create_tween().bind_node(self).set_trans(trans_type).set_ease(ease_type).set_parallel(true);
	movement_tween.tween_property(self, "position", to, time);


func on_show_call(args: Array):
	set_visibility(args[0]);

func set_visibility(visibility: bool):
	_shadow.visible = visibility;
