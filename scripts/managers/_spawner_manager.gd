extends Node


@export var enemy_scenes: Array[PackedScene];


func _ready():
	SignalManager.connect("spawn_enemies", Callable(self, "on_spawn_call"));
	SignalManager.connect("free_all", Callable(self, "on_free_call"));
	SignalManager.directional_free.connect(on_directional_free_call);
	SignalManager.bost_all.connect(on_bost_call);


func _process(_delta):
	for child in get_children():
		if (child is RollingArea):
			child.roll_and_move(child._desire_direction);



func on_bost_call(args: Array):
	for child: RollingArea in get_children():
		child.rotation_speed *= args[0];


func on_free_call(args: Array):
	for child in get_children():
		child.queue_free();

func on_directional_free_call(indication: int, pos: Vector3):
	for child: Node3D in get_children():
		if (indication == 0):
			if (child.position.x < pos.x):
				child.queue_free();
		elif (indication == 1):
			if (child.position.z < pos.z):
				child.queue_free();
		elif (indication == 2):
			if (child.position.x > pos.x):
				child.queue_free();


func on_spawn_call(args: Array):
	spawn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);


func spawn(type: int, position: Vector3, direction: Vector3, amount: int, separation: Vector3, speed: float, mirror_x: bool, mirror_y: bool):
	
	for i in amount:
		spawn_enemy(type, position + (i * separation), direction, speed);
		if (mirror_x):
			spawn_enemy(type, (position + (i * separation)) * Vector3(-1,1,1), direction * Vector3(-1,1,1), speed);
		if (mirror_y):
			spawn_enemy(type, (position + (i * separation)) * Vector3(1,1,-1), direction * Vector3(1,1,-1), speed);
		if (mirror_x && mirror_y):
			spawn_enemy(type, (position + (i * separation)) * Vector3(-1,1,-1), direction * Vector3(-1,1,-1), speed);


func spawn_enemy(type: int, position: Vector3, direction: Vector3, speed: float):
	var enemy: RollingArea = enemy_scenes[type].instantiate();
	enemy.initialize(position, direction, speed);
	add_child(enemy);
