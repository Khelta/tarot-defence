extends AnimationPlayer

func _ready() -> void:
	_idle()
	
func _idle() -> void:
	play("Rig_Medium_General/Idle_B")
	
func _attack() -> void:
	play("Rig_Medium_CombatRanged/Ranged_1H_Shoot")
