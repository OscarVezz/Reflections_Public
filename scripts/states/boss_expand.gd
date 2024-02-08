class_name BossExpand
extends State


@export var body: Boss
@export var _shadow: Sprite3D;
@export var _anim_player: AnimationPlayer;
@export var _cube: MeshInstance3D;
@export var _prop: PackedScene;
@export var _particles: GPUParticles3D;
@export var _material: StandardMaterial3D;
@export var _hitbox: Area3D;

var _cube_start_position: Vector3;
var _cube_start_scale: Vector3;
var _cube_step: float;
var _cumm_scale: float;

var expand_tween: Tween;
var sub_tween: Tween;


func _enter():
	_material.emission_energy_multiplier = 1.2;
	_cube_start_position = Vector3(0, 4, 0);
	_cube_start_scale = Vector3.ONE * 0.1;
	_cube_step = 1.38;
	_cumm_scale = 0.55;
	
	var player: Node3D = get_tree().get_nodes_in_group("Player").front();
	body.position = player.position;
	
	if (body.rotation_tween):
		body.rotation_tween.kill();
	
	_anim_player.play("RESET");
	_anim_player.stop();
	_cube.visible = false;
	_shadow.visible = false;
	
	_cube.position = _cube_start_position;
	_cube.scale = _cube_start_scale;
	
	expand_tween = create_tween().bind_node(self);
	expand_tween.tween_interval(0.24);
	for i in 8:
		expand_tween.tween_callback(_expand).set_delay(0.24);
	expand_tween.tween_callback(_end);



func _end():
	if (sub_tween):
		sub_tween.kill();
	
	AudioManager.play_sfx(4, 9);
	
	sub_tween = create_tween().bind_node(self).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING).set_parallel(true);
	for child in get_children():
		sub_tween.tween_property(child, "scale", Vector3.ONE * 0.1, 0.24);
		
	sub_tween.chain().tween_callback(_finish);
	sub_tween.chain().tween_callback( func(): 
		_hitbox.scale = Vector3.ONE
		_hitbox.position = Vector3(0,6,0)).set_delay(0.1);



func _finish():
	for child in get_children():
		child.queue_free();
	
	SignalManager.camera_shake.emit([Vector2(0, 2), 0.46, 6, 1]);
	
	body.rotation = Vector3.ZERO;
	_cube.rotation = Vector3.ZERO;
	
	_hitbox.position = body.position;
	_hitbox.scale = Vector3.ONE * 17;
	
	_particles.position = _cube_start_position;
	_particles.restart();
	
	_cube.visible = false;
	_shadow.visible = false;
	
	_material.emission_energy_multiplier = 1.2;



func _expand():
	if (sub_tween):
		sub_tween.kill();
	
	_cube.visible = true;
	_cube.scale = _cube_start_scale;
	
	var axis: Vector3 = Vector3(0, randf_range(-1, 1), 0).normalized();
	var to = (Quaternion(axis, PI) * _cube.quaternion).normalized();
	
	var prop: MeshInstance3D = _prop.instantiate() as MeshInstance3D;
	prop.position = _cube_start_position + body.position;
	prop.scale = _cube_start_scale;
	add_child(prop);
	
	sub_tween = create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true);
	sub_tween.tween_property(_cube, "scale", Vector3.ONE * _cumm_scale, 0.24);
	sub_tween.tween_property(prop, "scale", Vector3.ONE * _cumm_scale, 0.24);
	sub_tween.tween_property(_cube, "quaternion", to, 0.96);
	
	var extra_tween = create_tween().bind_node(self).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC);
	extra_tween.tween_property(prop, "quaternion", to, 0.96);
	
	_cumm_scale *= _cube_step;
	#_material.emission_energy_multiplier += 0.015;



func _exit():
	pass

func _update(_delta: float):
	pass

func _physics_update(_delta: float):
	pass
