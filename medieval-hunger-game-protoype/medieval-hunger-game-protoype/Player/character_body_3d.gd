extends CharacterBody3D

var health = 90
var SPEED = 5.0
const JUMP_VELOCITY = 4.5


var sensitivity = 0.2
var min_angle = -80
var max_angle = 90
var crouch_height = 0.5
var stand_height = 2
var eat_amount = 0
var sprint_amount = 0
var push_back = 100
var currentvel := Vector3.ZERO
var look_rot: Vector2


var is_sprinting = false
var is_crouching = false
var moving = true



var knockback: Vector3 = Vector3.ZERO
var knockback_timer: float = 0.0
var knockback_resistance = 10
var y_speed := 0

@onready var game_over_ui = $CanvasLayer/GameOverScreen

var throwable_food = load("res://Interactables/thrown_food.tscn")
@onready var pos = $Head/Hand
@onready var head = $Head

func _ready() -> void:
	PlayerManager.player = self
	$UI/Healthbar.health.value = GameState.get_value("health")
	$UI/HungerBar.hunger.value = GameState.get_value("hunger")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if moving:
		crouch()
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and moving:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("sprint") and is_on_floor() and $UI/StaminaBar.stamina.value > 0 and is_crouching != true :
		SPEED = 10
		$UI/StaminaBar.stamina.value -= 1
		$UI/StaminaBar.can_regen = false
		$UI/StaminaBar.s_timer = 0
		is_sprinting = true
		sprint_amount += 1
	
	
	if Input.is_action_just_released("sprint") or $UI/StaminaBar.stamina.value == 0:
		SPEED = 5
		is_sprinting = false
	
	if sprint_amount == 400:
		$UI/HungerBar.hunger.value -= 5
		sprint_amount = 0
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector3.ZERO
	
	if health <= 0 or $UI/HungerBar.hunger.value == 0:
		die()
	
	
	$UI/FoodAmount/CanvasLayer/Control/FoodText.text = "Food: " + str(GameState.state["food"])
	
	
	throw()
	eat()
	
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	move_and_slide()

func crouch():
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching
		if is_crouching:
			$CollisionShape3D.shape.height = crouch_height
			SPEED = 3
			is_sprinting = false
		else:
			$CollisionShape3D.shape.height = stand_height
			SPEED = 5
 


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and moving == true:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func throw():
	if Input.is_action_just_pressed("throw") and GameState.state["food"] > 0:
		GameState.set_value("food", GameState.get_value("food") - 1)
		var instance = throwable_food.instantiate()
		instance.position = $Head/Hand.global_position
		get_parent().add_child(instance)
		
		
		var force = -10
		var upDir = 3.5
		
		var player_direction = $Head.global_transform.basis.z.normalized()
		
		instance.apply_central_impulse(player_direction * force + Vector3(0, upDir, 0))

func eat():
	if Input.is_action_just_pressed("eat") and GameState.state["food"] > 0:
		GameState.set_value("food", GameState.get_value("food") - 1)
		eat_amount += 1
		health += 5
		print(eat_amount)
		$UI/Healthbar.health.value += 5
		$UI/HungerBar.hunger.value += 10
		
	
	
	
	if eat_amount >= 4:
		
		$UI/StaminaBar.base_max += 20
		$UI/StaminaBar.stamina.value += 20
		$UI/StaminaBar/TextureProgressBar.max_value += 20
		eat_amount = 0

func apply_knockback(direction: Vector3, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func die():
	moving = false
	game_over_ui.show_gameover()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		health -= 50
		GameState.set_value("health", $UI/Healthbar.health.value)
		$UI/Healthbar.health.value -= 50

func _add_food_amount(value: Variant) -> void:
	GameState.set_value("food", GameState.get_value("food") + 1)
