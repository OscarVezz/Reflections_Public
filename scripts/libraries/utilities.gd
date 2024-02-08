class_name Utilities
extends Resource


static func get_raw_action_input() -> int:
	if (Input.is_action_just_pressed("action_left")):
		return 0;
	elif (Input.is_action_just_pressed("action_up")):
		return 1;
	elif (Input.is_action_just_pressed("action_right")):
		return 2;
	else:
		return -1;


static func get_raw_vector_input() -> Vector2:
	var x = Input.get_action_raw_strength("right", false) - Input.get_action_raw_strength("left", false);
	if (x != 0):
		return Vector2(x, 0);
	else:
		var y = Input.get_action_raw_strength("down", false) - Input.get_action_raw_strength("up", false)
		return Vector2(0, y);
#	return Vector2 (
#		Input.get_action_raw_strength("right", false) - Input.get_action_raw_strength("left", false),
#		Input.get_action_raw_strength("down", false) - Input.get_action_raw_strength("up", false)
#	)

static func get_vector_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down");




static func custom_round(number: float) -> float:
	var rounded: float = round(number * 2) / 2;
	if (int(rounded * 2) % 2 != 0):
		return rounded;
	else:
		if (rounded < number):
			return rounded + 0.5;
		else: 
			return rounded - 0.5;

static func custom_round_vector(vector: Vector3) -> Vector3:
	return Vector3(custom_round(vector.x), vector.y, custom_round(vector.z));

static func round_vector(vector: Vector3) -> Vector3:
	return Vector3(round(vector.x), vector.y, round(vector.z));




static func is_action_pressed(action : String) -> bool:
	if (Input.is_action_pressed(action)):
		return true;
	return false;

static func is_action_just_pressed(action : String) -> bool:
	if (Input.is_action_just_pressed(action)):
		return true;
	return false;
