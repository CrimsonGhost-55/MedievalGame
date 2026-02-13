extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

var target: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = PlayerManager.player

func process(_delta: float):
	#nav_agent.set_target_position(target.global_position)
	
	if enemy.global_position.distance_to(target.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyWander")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(_delta: float) -> void:
	#if nav_agent.is_navigation_finished():
		#return
	#
	#var next_position: Vector3 = nav_agent.get_next_path_position()
	#enemy.velocity = enemy.global_position.direction_to(next_position) * enemy.RunSpeed
	var target_origin = target.get_global_transform().origin
	
	var enemy_origin = enemy.get_global_transform().origin
	
	var offset = target_origin * 2 - enemy_origin
	
	enemy.velocity = enemy.global_position.direction_to(offset) * enemy.RunSpeed
	
	
