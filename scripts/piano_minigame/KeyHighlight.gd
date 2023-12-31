extends Sprite2D

@export var final_color : Color
@export var highlight_color : Color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture.gradient.set_color(1, lerp(texture.gradient.get_color(1), final_color, delta*3))
	texture.gradient.set_color(2, lerp(texture.gradient.get_color(2), final_color, delta*3))
	pass

func set_color():
	texture.gradient.set_color(1,highlight_color)
	texture.gradient.set_color(2,highlight_color)
