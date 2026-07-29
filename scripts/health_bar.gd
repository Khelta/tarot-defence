extends Control
class_name HealthBar

func _update_hp(current_hp: float, max_hp: float) -> void:
	var progress_bar : ProgressBar = get_child(0)
	progress_bar.max_value = max_hp
	progress_bar.value = current_hp
