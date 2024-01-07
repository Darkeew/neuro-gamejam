extends Node2D

var ignore := false 

func _ready() -> void:
	_toggle_vase(Global.current_iteration >= 5) 

func _on_area_2d_body_entered(body):
	if not body is Player:
		return 
	
	if Global.current_iteration == 4 and not ignore:
		ignore = true  
		_toggle_vase(true)
		
		$KeyContainer.set_deferred("visible", true)

		SoundManager.play_sound.emit("vase_break")

func _toggle_vase(is_broken := true) -> void:
	$Broken.visible = is_broken
	$BrokenShadow.visible = is_broken

	$Base.visible = not is_broken
	$BaseShadow.visible = not is_broken