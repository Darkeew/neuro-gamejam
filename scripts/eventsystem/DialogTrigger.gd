extends Area2D

class_name EventTrigger

@export var event_name: String = ""

static var used_triggers = []


func _ready():
	if event_name == "":
		print("EventTrigger: event_name is empty")
		return
	
	if used_triggers.has({"name" :name,"scene": Global.current_scene.name, "event_name" : event_name}):
		print("EventTrigger: event_name is already used")
		queue_free()
		return
	body_entered.connect(on_body_entered)


func on_body_entered(body):
	if body is Player:
		var worked = await EventBus.emit_event(event_name)
		if worked:
			used_triggers.append({"name" :name,"scene": Global.current_scene.name, "event_name" : event_name})
			queue_free()



