extends Label

var suffix = " Gold"

func _on_gold_changed(gold_value: int):
	text = str(gold_value) + suffix
