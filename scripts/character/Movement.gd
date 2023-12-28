extends CharacterBody2D

@export var movement_speed :float = 100

func _physics_process(_delta):
	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var updirection :float =Input.get_axis("move_up", "move_down")
	var direction :float = Input.get_axis("move_left", "move_right")
	var wishvelocity :Vector2 = Vector2(direction, updirection)
	wishvelocity = wishvelocity.normalized() * movement_speed


	wishvelocity.y /= 2
	# Move the character.
	velocity = velocity.lerp(wishvelocity, 0.6)

	move_and_slide()