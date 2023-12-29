extends CharacterBody2D
class_name Player 

@export var BASE_MAX_SPEED := 100.0
@export var ACCELERATION := 500.0 
@export var FRICTION := 500.0 

#region NODES
@onready var animation_tree = $AnimationTree
#endregion 

func _process(delta: float) -> void:
	update_animation() 

func _physics_process(delta):
	if not Global.game_paused:
		return
		
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var target_velocity: Vector2 = input_vector * BASE_MAX_SPEED
	target_velocity.y /= 2 
	
	if input_vector != Vector2.ZERO: 
		velocity = velocity.move_toward(input_vector * BASE_MAX_SPEED, ACCELERATION * delta)
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
	 
