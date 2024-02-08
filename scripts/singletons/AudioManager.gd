extends Node


@export var sfx: Array[AudioStreamRandomizer];


func play_sfx(id: int, additive: float):
	play_sound(sfx[id], additive);


func play_sound(stream: AudioStreamRandomizer, additive: float):
	var instance = AudioStreamPlayer.new();
	instance.stream = stream;
	instance.bus = "sfx";
	instance.volume_db += additive;
	instance.finished.connect(remove_node.bind(instance));
	add_child(instance);
	instance.play();


func remove_node(instance: AudioStreamPlayer):
	instance.queue_free();
