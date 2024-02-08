extends Camera3D


@export var extra: TextureRect;
var zoom_tween: Tween
var shake_tween: Tween
var _start_offset


func _ready():
	SignalManager.camera_zoom.connect(on_zoom_call);
	SignalManager.camera_shake.connect(on_shake_call);
	_start_offset = Vector2(h_offset, v_offset);



func on_shake_call(args: Array):
	shake(args[0], args[1], args[2], args[3]);

func shake(to:Vector2, time:float, trans_type:int, ease_type:int):
	if (shake_tween):
		shake_tween.kill();
	
	h_offset += to.x
	v_offset += to.y;
	shake_tween = create_tween().bind_node(self).set_trans(trans_type).set_ease(ease_type).set_parallel(true);
	shake_tween.tween_property(self, "h_offset", _start_offset.x, time);
	shake_tween.tween_property(self, "v_offset", _start_offset.y, time);



func on_zoom_call(args: Array):
	zoom(args[0], args[1], args[2], args[3]);

func zoom(to:float, time:float, trans_type:int, ease_type:int):
	if (zoom_tween):
		zoom_tween.kill();
	
	zoom_tween = create_tween().bind_node(self).set_trans(trans_type).set_ease(ease_type).set_parallel(true);
	zoom_tween.tween_property(self, "fov", to, time);
	if (extra):
		var scaling = ((tan(deg_to_rad(fov * 0.5))) / (tan(deg_to_rad(to * 0.5)))) * extra.scale.x;
		zoom_tween.tween_property(extra, "scale", Vector2(scaling, scaling), time);
