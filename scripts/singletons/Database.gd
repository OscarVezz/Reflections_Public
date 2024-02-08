extends Node


var data_path_file := "res://json/test.json"
var signalData: Dictionary


func _ready():
	signalData = load_json_file(data_path_file);
	process_json_data(signalData);


func process_json_data(string_bars_data_dictionary: Dictionary):
	for i_key in string_bars_data_dictionary:
		var beats_dictionary: Dictionary = string_bars_data_dictionary[i_key];
		
		for j_key in beats_dictionary:
			var signals_dictionary: Dictionary = beats_dictionary[j_key];
			
			for k_key in signals_dictionary:
				var args: Array = signals_dictionary[k_key];
				
				for i in args.size():
					if (typeof(args[i]) == 4):
						args[i] = str_to_var(args[i]);


func load_json_file(file_path: String):
	#var file = File.new();
	#file.open(filePath, File.READ);
	#
	#var content = file.get_as_text();
	#file.close();
	
	var json_text: String = FileAccess.get_file_as_string(file_path);
	var json_dict: Dictionary = JSON.parse_string(json_text);
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(content);
	#return test_json_conv.get_data()
	return json_dict;


func get_value(bar: String, beat: String):
	if (!signalData.has(bar)):
		return;
	if (!signalData[bar].has(beat)):
		return;
	
	return signalData[bar][beat];
