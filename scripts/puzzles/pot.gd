extends Node2D

var ignore := false 

func _on_area_2d_body_entered(body):
	if not body is Player:
		return 
	
	if Global.current_iteration == 4 and not ignore:
		ignore = true  
		$Broken.visible = true 
		$Sprite2D.visible = false 
		
		$ItemContainer.set_deferred("visible", true)

		SoundManager.play_sound.emit("vasebreak")
		
