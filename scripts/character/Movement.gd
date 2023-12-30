extends CharacterBody2D
class_name Player 

@export var BASE_MAX_SPEED := 100.0
@export var ACCELERATION := 500.0 
@export var FRICTION := 500.0 

#region NODES
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
#endregion 

var direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	update_animation() 

func _physics_process(delta):
	if Global.game_paused:
		velocity = Vector2.ZERO
		return
		
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var target_velocity: Vector2 = direction * BASE_MAX_SPEED
	target_velocity.y = target_velocity.y * 0.7
	
	if direction != Vector2.ZERO: 
		velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()

func update_animation() -> void:
	if velocity == Vector2.ZERO: 
		animation_tree["parameters/conditions/idle"] = true 
		animation_tree["parameters/conditions/is_walking"] = false 

	else: 
		animation_tree["parameters/conditions/idle"] = false 
		animation_tree["parameters/conditions/is_walking"] = true
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
	

func random_footsteps_sound():
	SoundManager.play_footstep_sound.emit()
