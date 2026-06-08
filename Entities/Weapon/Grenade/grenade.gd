class_name Grenade extends Explosive
@onready var grenade_area: Area2D = $ExplosionArea
var grenade_timer: float = 1.5
var exploding: bool = false

func _process(delta: float) -> void:
	grenade_timer -= delta
	if grenade_timer <= 0 and !exploding:
		exploding = true
		for body in grenade_area.get_overlapping_bodies():
			if !body.is_in_group("Worm"):
				explode(body)
		queue_free()
		
