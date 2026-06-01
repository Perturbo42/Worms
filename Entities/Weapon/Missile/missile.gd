class_name Missile extends Explosive

func _on_main_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Worm"):
		return
	explode(body)
