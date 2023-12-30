extends ColorRect

func _on_line_edit_text_submitted(new_text):
	Global.send_password.emit(int(new_text))
