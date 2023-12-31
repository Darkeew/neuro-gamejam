extends Area2D

var used := false 

func _on_body_entered(body):
	if body is Player and not used:
		await get_tree().create_timer(2.5).timeout 
		Global.show_hidden_note.emit()
		Global.game_paused = true 

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		Global.hide_hidden_note.emit()
		Global.game_paused = false
		Global.neuro = true 
		used = true 
		Global.become_neuro.emit()

