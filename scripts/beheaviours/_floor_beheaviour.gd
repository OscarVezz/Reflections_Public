extends Marker3D

@export var _is_unique := false;
@export var _mirrors: Array[Node3D] = [];
@export var _floor: Node3D;
@export var _mirror_front: Node3D;
@export var _explosion_prop: Node3D;

var movementTween: Tween;


func _ready():
	SignalManager.floor_expand.connect(on_resize_call);
	SignalManager.player_shoot.connect(on_action_call);
	SignalManager.explosion_prop_update.connect(on_explosion_prop_update_call);
	SignalManager.explosion_prop_ended.connect(restart_mirror);


func on_explosion_prop_update_call(last_action: int):
	_explosion_prop.position = _mirrors[last_action].position;
	_explosion_prop.scale = Vector3(_mirrors[last_action].scale.x, _mirrors[last_action].scale.z, _mirrors[last_action].scale.x);


func on_action_call(action: int):
	if (!_explosion_prop):
		return;
	
	_mirrors[action].visible = false;
	_explosion_prop.visible = true;
	_explosion_prop.position = _mirrors[action].position
	_explosion_prop.rotation = Vector3(0, _mirrors[action].rotation.y, 0)
	_explosion_prop.scale = Vector3(_mirrors[action].scale.x, _mirrors[action].scale.z, _mirrors[action].scale.x)
	_explosion_prop.on_play();
	if (_is_unique):
		SignalManager.directional_free.emit(action, _mirrors[action].position);


func restart_mirror(index: int):
	_explosion_prop.visible = false;
	_mirrors[index].visible = true;



func on_resize_call(args: Array):
	@warning_ignore("unsafe_call_argument")
	resize(args[0], args[1], args[2], args[3], args[4]);



func resize(to:Vector3, time:float, trans_type:int, ease_type:int, mirror_height:float):
	if (movementTween):
		movementTween.kill();
	
	movementTween = create_tween().bind_node(self).set_trans(trans_type).set_ease(ease_type).set_parallel(true);
	movementTween.tween_property(_mirrors[0], "position", Vector3(-to.x/2, mirror_height/2, 0.0), time);
	movementTween.tween_property(_mirrors[1], "position", Vector3(0.0, mirror_height/2, -to.z/2), time);
	movementTween.tween_property(_mirrors[2], "position", Vector3(to.x/2, mirror_height/2, 0.0), time);
	movementTween.tween_property(_mirrors[0], "scale", Vector3(to.z, 1, mirror_height), time);
	movementTween.tween_property(_mirrors[1], "scale", Vector3(to.x, 1, mirror_height), time);
	movementTween.tween_property(_mirrors[2], "scale", Vector3(to.z, 1, mirror_height), time);
	
	if (_floor):
		movementTween.tween_property(_floor, "scale", to, time);
	if (_mirror_front):
		movementTween.tween_property(_mirror_front, "position", Vector3(0.0, mirror_height/2, to.z/2), time);
		movementTween.tween_property(_mirror_front, "scale", Vector3(to.x, 1, mirror_height), time);
