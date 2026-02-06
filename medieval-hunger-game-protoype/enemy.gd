extends CharacterBody3D

var player = null
var food = null

var speed = 5.0
var see_food = false

@export var player_path : NodePath
@export var food_path : NodePath


@onready var nav_agent = $NavigationAgent3D
@onready var raycast = $RayCast 
@onready var foodraycast = $FoodRayCast

func _ready() -> void:
	player = get_node(player_path)
	food = get_node(player_path)
	

func _physics_process(delta: float) -> void:
	raycast.look_at(player.global_position, Vector3.UP)
	
	velocity = Vector3.ZERO
	
	
	if raycast.is_colliding():
		if raycast.get_collider() == player and see_food == false:
			##Creates a list of points or corwds for the enemy to get to its destination
			nav_agent.set_target_position(player.global_position)
			##Creates a variable to allow the enemy to get from point to point
			var next_player_nav_point = nav_agent.get_next_path_position()
			##Is what makes the enemy move
			velocity = (next_player_nav_point - global_position).normalized() * speed
			##The Model turns to look at the player
			look_at(Vector3(next_player_nav_point.x, global_position.y, next_player_nav_point.z), Vector3.UP)
			
			move_and_slide()
	
	
	


func _on_food_dectector_body_entered(body: Node3D) -> void:
	if body.is_in_group("thrown food"):
		raycast.look_at(food.global_position, Vector3.UP)
		print("Fooood")
		see_food = true
		velocity = Vector3.ZERO
		
		
		var next_food_nav_point = nav_agent.get_next_path_position()
		velocity = (next_food_nav_point - global_position).normalized() * speed
		##look_at(Vector3(next_food_nav_point.x, global_position.y, next_food_nav_point.z), Vector3.UP)
		
		move_and_slide()
	else:
		see_food = false
