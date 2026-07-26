extends Button
class_name SellTowerButton

signal sell_requested


func _on_pressed() -> void:
	sell_requested.emit()
