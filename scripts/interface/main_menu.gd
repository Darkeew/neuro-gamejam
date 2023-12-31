extends CanvasLayer

@onready var anim_player := $AnimationPlayer

func _process(_delta) -> void:
	if Input.is_action_just_pressed("escape") and not anim_player.is_playing():
		_game_start()

func _game_start() -> void:
	SoundManager.play_sound.emit("button_press")
	anim_player.play("hide_menu")
	Global.game_unpaused.emit()
	await anim_player.animation_finished
	self.queue_free()
