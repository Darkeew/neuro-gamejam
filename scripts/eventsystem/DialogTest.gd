extends Area2D


func _ready():
	EventBus.register_listener("test",self)
	EventBus.register_listener("test2",self)
	EventBus.register_condition_solver("test_condition2",conditionsolver)

var used_dialogs = []
var dialogs_used = 0

func show_dialog(text):
	if text.has("dialog"):
		var d = text.dialog.pick_random()
		var i = 0
		while used_dialogs.has(d):
			d = text.dialog.pick_random()
			i+=1
			if i > text.dialog.size():
				break
		Global.test.text = d
		used_dialogs.append(d)
	Global.game_paused = true
	await get_tree().create_timer(1.5).timeout
	Global.test.text = ""
	Global.game_paused = false
	dialogs_used+=1

func _on_body_entered(_body:Node2D):
	EventBus.emit_event("test")

func conditionsolver(_event):
	return dialogs_used > 2
