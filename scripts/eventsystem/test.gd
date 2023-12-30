extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialog.register_dialog(Global)
	Global.dialog_label = self


var last_dialog = ""

func show_dialog(event):
	if event.has("dialog"):
		var d = event.dialog.pick_random()
		print(event)
		while d.text == last_dialog and event.dialog.size() > 1:
			d = event.dialog.pick_random()

		text = d.text
		Global.game_paused = true
		await get_tree().create_timer(d.time).timeout
		text = ""
		Global.game_paused = false