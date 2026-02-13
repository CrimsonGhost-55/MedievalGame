extends CharacterBody3D
class_name BaseEnemy

var player = null
var food = null


var speed = 5.0
var see_food = false
var damage = 1

const attack_range = 2.0

@export var player_path : NodePath
@export var food_path : NodePath
@export var knockback_force: float


@onready var nav_agent = $NavigationAgent3D
@onready var raycast = $RayCast 
@onready var foodraycast = $FoodRayCast
@onready var timer = $Timer


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
		elif foodraycast.get_collider() == food:
			see_food = true
			nav_agent.set_target_position(food.global_position)
			var next_food_nav_point = nav_agent.get_next_path_position()
			velocity = (next_food_nav_point - global_position).normalized() * speed
			look_at(Vector3(next_food_nav_point.x, global_position.y, next_food_nav_point.z), Vector3.UP)
			move_and_slide()
	
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction, 5.0, 0.12)
