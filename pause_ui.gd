extends CanvasLayer

signal restart
signal resume


func _on_restart_button_pressed() -> void:
	restart.emit()


func _on_resume_button_pressed() -> void:
	resume.emit()
