class_name Explosive extends RigidBody2D
@export var explosion: CollisionPolygon2D
@export var explosion_size: float
@export var explosion_force: float
var gravity:float = 0.0
var velocity:Vector2

var hurt:Array[Worm] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var nb_points = 32
	var points = PackedVector2Array()
	for i in range(nb_points+1):
		var point = deg_to_rad(i * 360.0 / nb_points - 90)
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * explosion_size)
	explosion.polygon = points
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()

func explode(collider: Node2D):
	for x in hurt:
		var direction = (x.global_position - global_position).normalized()
		x.velocity += direction * explosion_force
	if collider.is_in_group("Destructible"):
		collider.owner.clip(explosion)
	call_deferred("queue_free")

func _on_explosion_area_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Worm"):
		return
	hurt.append(body)

func _on_explosion_area_body_exited(body: Node2D) -> void:
	if !body.is_in_group("Worm"):
		return
	hurt.erase(body)
