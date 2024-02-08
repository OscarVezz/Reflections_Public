extends Node


signal start_requested
signal pause_ended(elapsed_time)

var in_start := true;
var in_tutorial := false;
var tut_state := 0;

var focus := false;
var start_time_msec := 0;
var elapsed_time_msec := 0;

var _restart_call := false;
var _end_call := false;

@export var tutorial_canvas: Array[Control];
@export var progress_bars: Array[ProgressBar];
@export var disclaimer_label: Label;

@onready var _tempo_manager: TempoManager = $TempoManager as TempoManager;
@onready var _pause_menu: CanvasLayer = $UI/PauseMenu as CanvasLayer;
@onready var _start_menu: CanvasLayer = $UI/StartMenu as CanvasLayer;
@onready var _tutorial_menu: CanvasLayer = $UI/Tutorial as CanvasLayer;
@onready var _disclaimer: CanvasLayer = $UI/Disclaimer as CanvasLayer;
@onready var _fps_layer: CanvasLayer = $UI/FPSCounter as CanvasLayer;
@onready var _flash: ColorRect = $UI/Flash/Flash as ColorRect;

@onready var _player: PlayerManager = $PlayerManager as PlayerManager;
@onready var _music_index: int = AudioServer.get_bus_index("music");
@onready var _sfx_index: int = AudioServer.get_bus_index("sfx");

var progress_tween: Tween


func _ready():
	start_requested.connect(_tempo_manager.restart_tempo);
	pause_ended.connect(_tempo_manager.add_pause_time);
	_player.has_died.connect(func(): _restart_call = true);
	SignalManager.game_end.connect(on_end_call);
	SignalManager.flash.connect(on_flash_call);
	#connect("start_requested", Callable(_tempo_manager, "restart_tempo"));
	#connect("pause_ended", Callable(_tempo_manager, "add_pause_time"))


func on_flash_call(args: Array):
	var flash_tween: Tween = create_tween().bind_node(self).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
	flash_tween.tween_property(_flash, "color", Color.WHITE, 3.84);
	#_flash.color = Color.WHITE;

func on_end_call(args: Array):
	#_tempo_manager.stop();
	_tempo_manager.process_mode = Node.PROCESS_MODE_ALWAYS;
	
	disclaimer_label.text = "Well done! You have been hit {0} times!".format({"0":_player.hit_count});
	_disclaimer.visible = true;
	start_pause();
	
	_end_call = true;


func start_tween(state: int, time: float):
	if (progress_tween):
		if (progress_tween.is_running()):
			return;
	
	progress_tween = create_tween().bind_node(_tutorial_menu);
	progress_tween.tween_property(progress_bars[state], "value", 1, time);
	progress_tween.tween_callback(end_tween.bind(tut_state));

func end_tween(state: int):
	tutorial_canvas[state].visible = false;
	tut_state += 1;
	if (tut_state < tutorial_canvas.size()):
		tutorial_canvas[tut_state].visible = true;


func _process(_delta):
	
	if (_end_call):
		return;
	
	if (_restart_call):
		_on_restart_pressed();
	
	if (in_tutorial):
		if (tut_state == 0):
			var movementDirection = Utilities.get_raw_vector_input();
			if (movementDirection.length() > 0):
				start_tween(tut_state, 2.5);
		elif (tut_state == 1):
			var action = Utilities.get_raw_action_input();
			if (action >= 0):
				start_tween(tut_state, 3.5);
		elif (tut_state == 2):
			start_tween(tut_state, 6.5);
		elif (tut_state == 3):
			start_tween(tut_state, 7.5);
		elif (tut_state == 4):
			in_tutorial = false;
	
	
	if (Input.is_action_just_pressed("pause")):
		
		if (focus):
			_pause_menu.visible = true;
			focus = false;
			return
		
		if (!get_tree().paused):
			start_pause();
		else:
			end_pause();
		
		
	elif (Input.is_action_just_pressed("start")):
		
		if (in_tutorial):
			return;
		
		if (get_tree().paused):
			end_pause();
		
		in_start = false;
		in_tutorial = false;
		_start_menu.visible = false;
		_tutorial_menu.visible = false;
		emit_signal("start_requested");



func start_pause():
	if (in_start):
		_start_menu.visible = false;
	if (in_tutorial):
		_tutorial_menu.visible = false;
	start_time_msec = Time.get_ticks_msec();
	_pause_menu.visible = true;
	get_tree().paused = true;


func end_pause():
	if (in_start):
		_start_menu.visible = true;
	if (in_tutorial):
		_tutorial_menu.visible = true;
	elapsed_time_msec = Time.get_ticks_msec() - start_time_msec;
	emit_signal("pause_ended", elapsed_time_msec);
	_pause_menu.visible = false;
	focus = false;
	get_tree().paused = false;



func _unhandled_input(event):
	if (event.is_action_pressed("restart")):
		if (get_tree()):
			get_tree().paused = false;
			get_tree().reload_current_scene();


func _on_quit_pressed():
	get_tree().quit();

func _on_continue_pressed():
	if (_end_call):
		return;
	end_pause();

func _on_restart_pressed():
	get_tree().paused = false;
	get_tree().reload_current_scene();

func _on_exit_pressed():
	if (_end_call):
		return;
	_pause_menu.visible = false;
	focus = true;


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(_music_index, linear_to_db(value));

func _on_effects_slider_value_changed(value):
	AudioServer.set_bus_volume_db(_sfx_index, linear_to_db(value));


func _on_tutorial_start_pressed():
	in_start = false;
	_start_menu.visible = false;
	
	_tutorial_menu.visible = true;
	in_tutorial = true;


func _on_fps_button_toggled(toggled_on):
	_fps_layer.visible = toggled_on;

func _on_practice_button_toggled(toggled_on):
	SignalManager.is_practice_active = toggled_on;
