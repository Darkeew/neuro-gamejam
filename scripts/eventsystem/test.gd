extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialog.register_dialog(Global)
	Global.dialog_label = self


var last_dialog = ""

func show_dialog(event):
	var d = event.dialog[0]
	var flags = event.flags if event.has("flags") else []
	if !flags.has("unpaused"):
		Global.game_paused = true
		
	if event.has("sfx"):
		SoundManager.play_sound.emit(event.sfx)
		
	if event.has("music"):
		SoundManager.change_music.emit(event.music)

	if flags.has("sequence"):
		await sequence_play(event)
		return

	d = event.dialog.pick_random()
	#print(event)
	while d.text == last_dialog and event.dialog.size() > 1:
		d = event.dialog.pick_random()

	text = d.text
	
	await get_tree().create_timer(d.time).timeout
	text = ""
	if event.has("time"):
		await get_tree().create_timer(event.time).timeout
	if flags.has("unpaused"):
		Global.game_paused = false

func sequence_play(event):
	var sequence = event.dialog
	var flags = event.flags if event.has("flags") else []
	var i = 0
	while i < sequence.size():
		var d = sequence[i]
		text = d.text
		await get_tree().create_timer(d.time).timeout
		text = ""
		i += 1
	if event.has("time"):
		await get_tree().create_timer(event.time).timeout
	if flags.has("unpaused"):
		Global.game_paused = false
