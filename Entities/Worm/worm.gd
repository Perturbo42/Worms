class_name Worm extends CharacterBody2D
@onready var sprite: Sprite2D = $WormSprite
@onready var timer: Timer = $Timer
@onready var marker: Marker2D = $Marker2D

const MISSILE = preload("uid://siacw3omdria")
const GRENADE = preload("res://Entities/Weapon/Grenade/grenade.tscn")
const GROUND_SPEED = 300.0
const GROUND_ACCEL = 1200
const GROUND_DECEL = 1400
const AIR_SPEED = 150.0
const AIR_ACCEL = 500
const AIR_DECEL = 0
const JUMP_VELOCITY = -500.0
const GRAVITY = 400.0

enum Weapons{
	Missile,
	Grenade
}
var weapon_list: Array[String] = ["Missile", "Grenade"]
var weapon_sprite_dict = {}

var dir: float = -1
var weapon_velocity := 1500.0
var is_active: bool = false
var curr_weapon: Weapons = Weapons.Missile

func _ready() -> void:
	for weapon_sprite in marker.get_children():
		if weapon_sprite is Sprite2D:
			weapon_sprite_dict.get_or_add(weapon_sprite.name, weapon_sprite)
			if weapon_sprite.name != weapon_list[curr_weapon]:
				weapon_sprite.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_velocity += 20
			weapon_velocity = clamp(weapon_velocity, 100, 2000)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_velocity -= 20
			weapon_velocity = clamp(weapon_velocity, 100, 2000)
	
	elif event is InputEvent:
		if !event.is_pressed(): return
		if event.keycode == KEY_1:
			change_weapon(Weapons.Missile)
		elif event.keycode == KEY_2:
			change_weapon(Weapons.Grenade)

func _process(_delta: float) -> void:
	marker.look_at(get_global_mouse_position())
	if is_active:
		if Input.is_action_just_pressed("shoot"):
			if curr_weapon == Weapons.Missile:
				var missile = MISSILE.instantiate()
				get_parent().add_child(missile)
				missile.transform = marker.global_transform
				missile.velocity = weapon_velocity * missile.transform.x
				missile.gravity = GRAVITY
			if curr_weapon == Weapons.Grenade:
				var grenade = GRENADE.instantiate()
				get_parent().add_child(grenade)
				grenade.transform = marker.global_transform
				grenade.velocity = weapon_velocity * grenade.transform.x * 0.5
				grenade.gravity = GRAVITY



func _physics_process(delta: float) -> void:
	if !is_active:
		#apply gravity, apply knockback
		return
	
	#Read Input
	dir = Input.get_axis("left","right")
	var jump_pressed = Input.is_action_just_pressed("jump")

	#handle direction
	if dir < -0.05:
		sprite.flip_h = false
		marker.position.x = -80
	elif dir > 0.05:
		sprite.flip_h = true
		marker.position.x = 80
	
	#handle horizontal movement
	var target_speed = GROUND_SPEED if is_on_floor() else AIR_SPEED
	var accel = GROUND_ACCEL if is_on_floor() else AIR_ACCEL
	var decel = GROUND_DECEL if is_on_floor() else AIR_DECEL
	if dir != 0.0:
		velocity.x = move_toward(velocity.x, dir * target_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if jump_pressed and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func change_weapon(weapon: Weapons):
	weapon_sprite_dict.get(weapon_list[curr_weapon]).visible = false
	weapon_sprite_dict.get(weapon_list[weapon]).visible = true
	curr_weapon = weapon
	
