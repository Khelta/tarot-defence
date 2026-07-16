extends Control
class_name TowerPanel

func _ready() -> void: 
	set_text_labels(1, 2, 3, 4, 5, 6)


func set_text_labels(damage: int, 
					 range: int,
					 attack_area: int,
					 attack_speed: float,
					 damage_dealt: float,
					 enemies_killed: int) -> void:

	var damage_label         : Label = get_node("VBoxContainer/Damage")
	var range_label          : Label = get_node("VBoxContainer/Range")
	var attack_area_label    : Label = get_node("VBoxContainer/AttackArea")
	var attack_speed_label   : Label = get_node("VBoxContainer/AttackSpeed")
	var damage_dealt_label   : Label = get_node("VBoxContainer/DamageDealt")
	var enemies_killed_label : Label = get_node("VBoxContainer/EnemiesKilled")

	damage_label.text         = str(damage)
	range_label.text          = str(range)
	attack_area_label.text    = str(attack_area)
	attack_speed_label.text   = str(attack_speed)
	damage_dealt_label.text   = str(damage_dealt)
	enemies_killed_label.text = str(enemies_killed)
