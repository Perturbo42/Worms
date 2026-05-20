extends Node2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var destructible: CollisionPolygon2D = $StaticBody2D/Destructible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destructible.polygon = polygon_2d.polygon
	pass # Replace with function body.

func clip(poly: Polygon2D):
	var offset_poly = Polygon2D.new()
	
	offset_poly.polygon = poly.global_transform * poly.polygon
	var res = Geometry2D.clip_polygons(polygon_2d.polygon, offset_poly.polygon)
	
	if res.is_empty():
		polygon_2d.polygon.clear()
		destructible.set_deferred("polygon", PackedVector2Array())
		return
	
	polygon_2d.polygon = res[0]
	destructible.set_deferred("polygon", res[0])
	
	offset_poly.queue_free()
