class_name StateMachine
extends Node


@export var initialState: State;

var currentState: State
var states: Dictionary = {}

#onready var _state: State = get_node(initialStatePath);


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			child.connect("transitioned", Callable(self, "on_child_transition"));
	
	if (initialState):
		initialState._enter();
		currentState = initialState;


func _process(delta):
	if (currentState):
		currentState._update(delta);


func _physics_process(delta):
	if (currentState):
		currentState._physics_update(delta);



func on_state_change(new_state_id: int):
	var newState: State = get_child(new_state_id);
	if (!newState):
		return;
	
	if (currentState):
		currentState._exit();
	
	newState._enter();
	currentState = newState;


func on_child_transition(state_emitter: State, new_state_name: String):
	if (state_emitter != currentState):
		return;
	
	var newState: State = states.get(new_state_name.to_lower());
	if (!newState):
		return;
	
	if (currentState):
		currentState._exit();
	
	newState._enter();
	currentState = newState;
