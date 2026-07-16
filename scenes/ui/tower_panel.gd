extends Control
class_name TowerPanel

var current_tower : BaseTower = null


func connect_tower(tower: BaseTower):
	current_tower = tower
	tower.stats_updated.connect(func(): set_text_labels_from_tower(tower))
	set_text_labels_from_tower(tower)


func set_text_labels_from_tower(tower: BaseTower) -> void:
	set_text_labels(int(tower.base_damage),
					int(tower.tower_range),
					int(tower.attack_area),
					tower.attacks_per_second,
					tower.damage_dealt,
					tower.enemies_killed)


func set_text_labels(damage: int, 
					 tower_range: int,
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
	range_label.text          = str(tower_range)
	attack_area_label.text    = str(attack_area)
	attack_speed_label.text   = str(attack_speed)
	damage_dealt_label.text   = str(damage_dealt)
	enemies_killed_label.text = str(enemies_killed)
