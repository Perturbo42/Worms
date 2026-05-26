extends Node2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var destructible: CollisionPolygon2D = $StaticBody2D/Destructible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destructible.polygon = polygon_2d.polygon
	pass # Replace with function body.

func clip(poly: CollisionPolygon2D):
	
	var base_poly := PackedVector2Array()
	for p in polygon_2d.polygon:
		base_poly.append(polygon_2d.global_transform * p)

	var clip_poly := PackedVector2Array()
	for p in poly.polygon:
		clip_poly.append(poly.global_transform * p)

	var res = Geometry2D.clip_polygons(base_poly, clip_poly)

	if res.is_empty():
		polygon_2d.polygon.clear()
		destructible.set_deferred("polygon", PackedVector2Array())
		return

	# Convert result back into local space
	var final_poly := PackedVector2Array()
	for p in res[0]:
		final_poly.append(polygon_2d.global_transform.affine_inverse() * p)

	polygon_2d.polygon = final_poly
	destructible.set_deferred("polygon", final_poly)
