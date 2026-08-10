extends Node3D
class_name EnemyWavePreview

@export var node_position : Node
@export var position_offset : Vector3
@export var tile_spacing : float = 2.0

func _ready() -> void:
	self.position = node_position.position + position_offset

func set_wave_preview_from_wave_string(wave_string: String) -> void:
	var wave_data = WaveDataUtils.get_wave_data_from_wave_string(wave_string)
	set_wave_preview_from_wave_data(wave_data)


func set_wave_preview_from_wave_data(wave_data : Array[WaveData]) -> void:
	delete_wave_preview()

	var enemy_counts = WaveDataUtils.get_enemy_counts(wave_data)
	var count = enemy_counts.size()

	for i in range(count):
		var offset = i - (count - 1) / 2.0
		var x = offset * tile_spacing

		var enemy_type = enemy_counts.keys()[i]
		var preview_tile_scene = EnemyUtils.enemy_data_dict[enemy_type].enemy_preview_tile
		var preview_tile = preview_tile_scene.instantiate()
		$Marker3D.add_child(preview_tile)
		preview_tile.position.x += x


func delete_wave_preview() -> void:
	var preview_tiles = $Marker3D.get_children()

	for preview_tile in preview_tiles:
		preview_tile.queue_free()
