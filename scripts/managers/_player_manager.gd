class_name  PlayerManager
extends Node


signal has_died
signal has_shoot(action)


@export var _player: RollingCube;
@export var _hurt_particles: GPUParticles3D;
@export var _hp := 3;
@export var _shoot_cooldown := 3.0;
@export var _colors: Array[Color];

var _skin: MeshInstance3D;
var _skin_id: int;

var can_shoot: bool = true;
var last_action: int;

var movementDirection: Vector2;
var action: int;
var directions: Array = [Vector2(2, 0), Vector2(0, -2), Vector2(-2, 0)]

var invulneravility_tween: Tween;
var hit_count := 0;


func _ready():
	_skin = _player.get_child(0).get_child(0);
	_skin.get_active_material(0).albedo_color = _colors[0];
	_skin_id += 1;
	_player.take_damage.connect(_on_hit_taken);



func follow(_value: int):
	_hurt_particles.position = Vector3(_player.global_position.x, 0.5, _player.global_position.z);

func _on_hit_taken(amount: int):
	if (invulneravility_tween):
		if (invulneravility_tween.is_running()):
			return;
	
	invulneravility_tween = create_tween().bind_node(_player).set_loops(6);
	invulneravility_tween.tween_callback(func(): _player.visible = !_player.visible).set_delay(0.08);
	#invulneravility_tween.tween_method(follow, 1, 10, 0.5);
	
	_hp -= amount;
	hit_count += amount;
	_explode();
	
	if (!SignalManager.is_practice_active):
		if (_skin_id < _colors.size()):
			_skin.get_active_material(0).albedo_color = _colors[_skin_id];
			_skin_id += 1;
		if (_hp < 1):
			has_died.emit()

func _explode():
	SignalManager.camera_shake.emit([Vector2(_player.global_position.x * -1, _player.global_position.z).normalized(), 0.46, 6, 1]);
	AudioManager.play_sfx(3, 4);
	_hurt_particles.position = Vector3(_player.global_position.x, 0.5, _player.global_position.z);
	_hurt_particles.restart();



func _process(_delta):
	
	movementDirection = Utilities.get_raw_vector_input();
	if (movementDirection.length() > 0):
		var direction: Vector3 = _player.roll_and_move(Vector3(movementDirection.x, 0, movementDirection.y));
		#if (direction.length() > 0):
			#SignalManager.player_moved.emit(direction);
	SignalManager.player_moved.emit(_player.get_child(1).global_position);
	
	
	if (!can_shoot):
		SignalManager.explosion_prop_update.emit(last_action);
		return;
	
	action = Utilities.get_raw_action_input();
	if (action >= 0):
		SignalManager.player_shoot.emit(action);
		SignalManager.camera_shake.emit([directions[action], 0.46, 6, 1]);
		AudioManager.play_sfx(1, 4);
		last_action = action;
		can_shoot = false;
		create_tween().tween_callback(restart_action.bind(last_action)).set_delay(_shoot_cooldown);


func restart_action(index):
	can_shoot = true;
	SignalManager.explosion_prop_ended.emit(index);


func _physics_process(_delta):
		#_player.set_velocity(Vector3.ZERO)
	#_player.set_up_direction(Vector3.UP)
	#_player.move_and_slide();
	var collision = _player.move_and_collide(Vector3.ZERO)
	if collision:
		print("a")
		_player.velocity = _player.velocity.slide(collision.get_normal());
	#var collision_info = _player.move_and_collide(Vector3.ZERO * _delta)
	#if (collision_info):
		#pass
