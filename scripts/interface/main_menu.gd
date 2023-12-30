extends CanvasLayer

@onready var anim_player := $AnimationPlayer

func _on_start_button_mouse_entered() -> void:
	if not anim_player.is_playing(): 
		Global.tween_property(name, %StartButton, "modulate:a", 0.5)

func _on_start_button_mouse_exited() -> void:
	if not anim_player.is_playing(): 
		Global.tween_property(name, %StartButton, "modulate:a", 1)

func _on_start_button_pressed() -> void:
	if not anim_player.is_playing(): 
		SoundManager.play_sound.emit("button_press")
		$AnimationPlayer.play("hide_menu")
		Global.game_paused = false
		$AnimationPlayer.animation_finished.connect(func(_anim): Global.hide_menu(), CONNECT_ONE_SHOT)

