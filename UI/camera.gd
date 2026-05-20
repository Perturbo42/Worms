class_name Camera extends Camera2D

func _ready() -> void:
	if Global.active_worm == null:
		await get_tree().process_frame
	self.global_position = Global.active_worm.global_position

func _process(delta: float) -> void:
	global_position = Global.active_worm.global_position
