class_name Game extends Node2D
@onready var worms: Node2D = $Worms

var worm_list:Array[Worm] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for worm in worms.get_children():
		if worm is Worm:
			worm_list.append(worm)
	give_turn(worm_list[Global.worm_num])
	pass # Replace with function body.

func give_turn(worm: Worm):
	Global.active_worm = worm
	worm.is_active = true
