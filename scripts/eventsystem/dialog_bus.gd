extends Node

#Loads dialog from a json file and registers to trigger events and then shows the dialog and also can trigger other events based on a condition
# the json is in this format:
# {
#   {
#     "trigger": "event_name",
#     "condition": "condition_name", #optional
#     "dialog": ["dialog_text",],
#     "next": "event_name" #optional
#   }
# }

func _ready():
	#load all dialog files in assets/dialog
	var json_files = []
	var dir : PackedStringArray = DirAccess.get_files_at("res://assets/dialog")
	for i in dir:
		if i.ends_with(".json"):
			json_files.append(i)

	#load all json files
	for json_file in json_files:
		print("loading dialog file: "+json_file)
		var json = load("res://assets/dialog/"+json_file)
		var dialog = json.data
		for i in dialog:
			var dialogs = null
			var next = null
			var condition = null

			if i.has("dialog"):
				dialogs = i.dialog
			if i.has("next"):
				next = i.next
			if i.has("condition"):
				condition = i.condition
			
			#register the event
			EventBus.register_event(i.trigger, self, "show_dialog", {"event_name":i.trigger,"dialog":dialogs,"next": next,"condition": condition})
