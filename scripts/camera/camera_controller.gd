extends Camera2D

class_name CameraController

@export var follow_node : Node2D
@export var follow_offset : Vector2

@export var follow_player : bool = true

@export var look_ahead : bool = false
@export var look_ahead_distance : float = 1.0



var old_position : Vector2
var old_zoom : Vector2
var old_rotation : float
var old_duration : float

var transitioned : bool = false


func _ready():
	if Global.main_camera == null:
		Global.main_camera = self
		# Set Camera to be active
		make_current()
	else:
		push_warning("Multiple cameras in scene. Only one camera can be active at a time.")

func _physics_process(_delta):
	if follow_player:
		follow_node = Global.player
	if follow_node != null and !transitioned:
		var target = follow_node.global_position + follow_offset
		if look_ahead:
			target += follow_node.velocity * look_ahead_distance

		position = target

func transition_to(target : CameraMimic):
	var duration = target.transition_time

	old_position = global_position
	old_zoom = zoom
	old_rotation = rotation
	old_duration = duration

	if duration == 0:
		position = target.position
		zoom = target.zoom
		rotation = target.rotation
	else:
		var transition = create_tween()
		transition.tween_property(self,"position",target.position,duration)
		transition.parallel().tween_property(self,"zoom",target.zoom,duration)
		transition.parallel().tween_property(self,"rotation",target.rotation,duration)
		transition.play()
	
	transitioned = true


func transition_free(target : CameraMimic):
	if transitioned:
		var duration = target.transition_time_out
		transitioned = false

		var transition = create_tween()
		transition.tween_property(self,"zoom",old_zoom,duration)
		transition.parallel().tween_property(self,"rotation",old_rotation,duration)
		transition.parallel().tween_property(self,"position_smoothing_speed",50,duration)
		transition.play()

		position_smoothing_enabled = true
		position_smoothing_speed = 1.0
		#await for the transitiont time and turn of camera smoothing
		await transition.finished
		position_smoothing_enabled = false

		
