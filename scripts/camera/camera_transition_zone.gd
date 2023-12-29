extends Area2D

class_name CameraTransitionZone


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body):
	if !(body is Player):
		return
	
	Global.main_camera.transition_to(get_parent())


func on_body_exited(body):
	if !(body is Player):
		return
	
	Global.main_camera.transition_free()

