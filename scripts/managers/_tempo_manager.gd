class_name TempoManager
extends Node


@export var use_debug := false;
@export var debug_bar := 0;
@export var debug_beat := 0;

@export var beats_per_bar := 4;
@export var beats_per_minute := 100.0;
@export var main: AudioStream;
@export var main_offset: float;

var is_ticking := false;
var start_time_msec := 0;
var pause_time_msec := 0;

var beat_count := 0;
var bar_count := 0;
var beat_step_msec := 0;


# Change later
var _test_dict;
@onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer



func _ready():
	_test_dict = Database.signalData;
	_audio_player.stream = main;



func _process(_delta):
	
	if (!is_ticking):
		return
	
	var elapsed_time_msec =  ((beats_per_bar * (bar_count - 1)) * beat_step_msec) + (beat_count * beat_step_msec)
	if (Time.get_ticks_msec() > start_time_msec + elapsed_time_msec + pause_time_msec):
		beat_count += 1;
		
		if (beat_count > beats_per_bar):
			beat_count = 1;
			bar_count += 1;
		
		var i_key = str(bar_count);
		var j_key = str(beat_count);
		
		if (i_key in _test_dict):
			if (j_key in _test_dict[i_key]):
				SignalManager.emit_signals(_test_dict[i_key][j_key]);
#				print(_test_dict[i_key][j_key]);
		
#		print("Bar: {0}, Beat: {1}".format({"0":bar_count, "1":beat_count}));




func restart_tempo() -> void:
	
	if (is_ticking):
		return;
	
	
	start_time_msec = Time.get_ticks_msec();
	pause_time_msec = 0;
	beat_step_msec = (60.0 / beats_per_minute) * 1000.0;
	
	if (use_debug):
		beat_count = debug_beat - 1
		bar_count = debug_bar
		var offset_msec = ((bar_count - 1) * beats_per_bar * beat_step_msec) + (beat_count * beat_step_msec)
		start_time_msec -= offset_msec;
		_audio_player.play(main_offset + (offset_msec / 1000.0));
#		bar_count += 1
	else:
		beat_count = 0;
		bar_count = 1;
		_audio_player.play(main_offset);
	
	is_ticking = true;


func add_pause_time(elapsed_time_msec: int):
	pause_time_msec += elapsed_time_msec;


func stop():
	_audio_player.stop(); 
