extends Area2D

class_name CameraTransitionZone

signal on_transitioned_entered
signal on_transitioned_exited


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body):
	if !(body is Player):
		return
	
	Global.main_camera.transition_to(get_parent())
	on_transitioned_entered.emit()


func on_body_exited(body):
	if !(body is Player):
		return
	
	Global.main_camera.transition_free(get_parent())
	on_transitioned_exited.emit()

