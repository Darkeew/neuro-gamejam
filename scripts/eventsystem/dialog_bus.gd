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
	#load the json file
	var json = load("res://assets/dialog/dialog.json")
	var dialog = json.data
	for i in dialog:
		#register the event
		EventBus.register_event(i.trigger, self, "show_dialog", {"dialog":i.dialog,"next": i.next,"condition": i.condition})
	
	EventBus.print_all()
