extends Node

class_name Iteration_Condition

enum show_condition {
	EXACT,
	LESS_EQUAL,
	GREATER_EQUAL,
	LESS,
	GREATER
}

@export var iter : int
@export var condition : show_condition = show_condition.GREATER_EQUAL

@export var delete_node : bool = true


func _ready():
	var iteration = Global.current_iteration
	#delete if not in range
	get_parent().visible = false
	var passed = false
	match condition:
		show_condition.EXACT:
			if iteration == iter:
				passed = true
		show_condition.LESS_EQUAL:
			if iteration <= iter:
				passed = true
		show_condition.GREATER_EQUAL:
			if iteration >= iter:
				passed = true
		show_condition.LESS:
			if iteration < iter:
				passed = true
		show_condition.GREATER:
			if iteration > iter:
				passed = true
	
	if passed:
		get_parent().visible = true
		for child in get_parent().get_children():
			if child is StaticBody2D:
				for collision_body in child.get_children():
					collision_body.set_deferred("disabled", false)  
		
		return

	if delete_node:
		get_parent().queue_free()
	get_parent().visible = false
	
