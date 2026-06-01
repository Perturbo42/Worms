class_name Grenade extends Explosive
var grenade_timer: float = 3.0

func _process(delta: float) -> void:
	grenade_timer -= delta

func _on_main_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Worm"):
		return
	
