extends Area2D

var items_within_range = []

func _process(_delta) -> void:
	if Global.game_paused:
		return
	
	if Input.is_action_just_pressed("pickup"):
		if items_within_range.size() > 0: 
			pickup_item() 
			
	if items_within_range.size() > 0: 
		for index in range(items_within_range.size()): 
			if index == 0: 
				items_within_range[index].show_pickup_line() 
			else:
				items_within_range[index].hide_pickup_line() 

func pickup_item() -> void:
	var item_container = items_within_range[0] as ItemContainer 
	Global.pickup_item.emit(item_container.item)
	item_container.queue_free()

func _on_area_entered(area):
	items_within_range.append(area)

func _on_area_exited(area):
	area.hide_pickup_line() 
	items_within_range.erase(area)




