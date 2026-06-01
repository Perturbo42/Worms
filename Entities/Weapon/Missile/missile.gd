class_name Missile extends Explosive
var gravity:float = 0.0
var velocity:Vector2

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()
