extends CanvasLayer

@onready var anim_player := $AnimationPlayer

var tweens := {}

func _on_start_button_mouse_entered() -> void:
	if not anim_player.is_playing(): 
		_tween_property(%StartButton, "modulate:a", 0.5)

func _on_start_button_mouse_exited() -> void:
	if not anim_player.is_playing(): 
		_tween_property(%StartButton, "modulate:a", 1)

func _on_start_button_pressed() -> void:
	if not anim_player.is_playing(): 
		$AnimationPlayer.play("hide_menu")
		Global.game_paused = false
		$AnimationPlayer.animation_finished.connect(func(_anim): Global.hide_menu(), CONNECT_ONE_SHOT)

func _tween_property(node: Node, prop: String, value: float, time := 1) -> void:
	var tween_name := "%s_%s" % [node.name, prop]
	if tweens.has(tween_name):
		tweens[tween_name].kill()

	tweens[tween_name] = create_tween()
	tweens[tween_name].tween_property(node, prop, value, time)

