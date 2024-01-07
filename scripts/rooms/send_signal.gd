extends Area2D

func _on_body_entered(body):
	if body is Player and not Global.hidden_note_shown:
		print("body entered")
		set_deferred("monitoring", false)
		await get_tree().create_timer(3.0).timeout
		Global.show_hidden_note.emit()
		Global.pause_game.emit()

func _process(_delta):
	if Global.hidden_note_shown:
		if Input.is_action_just_pressed("escape"):
			Global.hide_hidden_note.emit()
			Global.neuro = true 
			Global.become_neuro.emit()
			SoundManager.play_sound.emit("key_collect")
			Global.unpause_game.emit()
			queue_free()

