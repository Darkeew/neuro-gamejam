extends Node2D

func _ready():
	$Num1.text = str(Global.numbers_schizo[0])
	$Num2.text = str(Global.numbers_schizo[1])
	$Num3.text = str(Global.numbers_schizo[2])
	$Num4.text = str(Global.numbers_schizo[3])
