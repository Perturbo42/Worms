class_name Camera extends Camera2D
var speed: float = 3000

func _ready() -> void:
	if Global.active_worm == null:
		await get_tree().process_frame
	self.global_position = Global.active_worm.global_position

func _process(delta: float) -> void:
	if Global.weapon == null:
		global_position = global_position.move_toward(Global.active_worm.global_position, speed * delta)
	else:
		global_position = global_position.move_toward(Global.weapon.global_position, speed * delta)
