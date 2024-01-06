extends Node2D

func _ready():
	for i in range(1, 4):
		get_node("Num%s" % i).text = Global.numbers_schizo[i - 1]
