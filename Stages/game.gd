class_name Game extends Node2D
@onready var worms: Node2D = $Worms

var worm_list:Array[Worm] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game = self
	for worm in worms.get_children():
		if worm is Worm:
			worm_list.append(worm)
			worm.weapon_shot.connect(weapon_shot)
	give_turn(Global.worm_num)
	Global.weapon = null
	pass # Replace with function body.

func give_turn(worm_num: int):
	var worm: Worm = worm_list[worm_num]
	Global.active_worm = worm
	# wait until explosive is finished
	worm.is_active = true

func weapon_shot(_worm: Worm):
	Global.worm_num = (Global.worm_num + 1) % worm_list.size()
	give_turn(Global.worm_num)
	
