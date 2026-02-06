extends CharacterBody3D

var health = 90
var SPEED = 5.0
const JUMP_VELOCITY = 4.5


var food_amount = 0
var crouch_height = 0.5
var stand_height = 2
var eat_amount = 0

var is_sprinting = false
var is_crouching = false



var throwable_food = load("res://thrown_food.tscn")
var dropped_food = load("res://food_item.tscn")
@onready var pos = $Head/Camera3D/Hand

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if %SeeCast.is_colliding():
		var object = %SeeCast.get_collider()
		if object != null and object.has_method("pick_up"):
			if Input.is_action_just_pressed("pick_up"):
				object.pick_up()
				food_amount += 1
				
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("sprint") and is_on_floor() and $StaminaBar.stamina.value > 0 and is_crouching != true :
		SPEED = 10
		$StaminaBar.stamina.value -= 1
		$StaminaBar.can_regen = false
		$StaminaBar.s_timer = 0
		is_sprinting = true
	
	if Input.is_action_just_released("sprint") or $StaminaBar.stamina.value == 0:
		SPEED = 5
		is_sprinting = false
	
	
	if health <= 0:
		get_tree().reload_current_scene()
	
	
	$FoodAmount/CanvasLayer/Control/FoodText.text = "Food: " + str(food_amount)
	
	crouch()
	drop()
	throw()
	eat()
	
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
 
func drop():
	if Input.is_action_just_pressed("drop") and food_amount > 0:
		food_amount -= 1
		var instance = dropped_food.instantiate()
		instance.position = $Head/Camera3D/Hand.global_position
		get_parent().add_child(instance)
		
		
		var force = -10
		var upDir = 3.5
		
		var player_direction = $Head.global_transform.basis.z.normalized()
		
		instance.apply_central_impulse(player_direction * force * Vector3(0, upDir, 0))

func throw():
	if Input.is_action_just_pressed("throw") and food_amount > 0:
		food_amount -= 1
		var instance = throwable_food.instantiate()
		instance.position = $Head/ThrowMaker.global_position
		get_parent().add_child(instance)
		
		
		var force = -10
		var upDir = 3.5
		
		var player_direction = $Head.global_transform.basis.z.normalized()
		
		instance.apply_central_impulse(player_direction * force + Vector3(0, upDir, 0))

func eat():
	if Input.is_action_just_pressed("eat") and food_amount > 0:
		food_amount -= 1
		eat_amount += 1
		health += 5
		print(eat_amount)
		$Healthbar.health.value += 5
		print($StaminaBar.base_max)
	
	
	
	if eat_amount >= 4:
		
		$StaminaBar.base_max += 20
		$StaminaBar.stamina.value += 20
		$StaminaBar/TextureProgressBar.max_value += 20
		eat_amount = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		print(health)
		$Healthbar.health.value -= 10
		health -= 10



func _on_timer_timeout() -> void:
	pass
