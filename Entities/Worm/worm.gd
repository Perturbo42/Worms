class_name Worm extends CharacterBody2D
@onready var timer: Timer = $Timer
@onready var marker: Marker2D = $Marker2D

const MISSILE = preload("uid://siacw3omdria")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 400.0
enum Weapons{
	Missile,
	Grenade
}

var weapon_velocity := 600.0
var is_active: bool = false
var curr_weapon: Weapons = Weapons.Missile

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_velocity += 20
			weapon_velocity = clamp(weapon_velocity, 100, 1500)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_velocity -= 20
			weapon_velocity = clamp(weapon_velocity, 100, 1500)

func _process(delta: float) -> void:
	marker.look_at(get_global_mouse_position())
	if is_active:
		if Input.is_action_just_pressed("shoot"):
			if curr_weapon == Weapons.Missile:
				var missile = MISSILE.instantiate()
				get_parent().add_child(missile)
				missile.transform = marker.global_transform
				missile.velocity = weapon_velocity * missile.transform.x
				missile.gravity = GRAVITY


func _physics_process(delta: float) -> void:
	if !is_active:
		#apply gravity, apply knockback
		return
	

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
