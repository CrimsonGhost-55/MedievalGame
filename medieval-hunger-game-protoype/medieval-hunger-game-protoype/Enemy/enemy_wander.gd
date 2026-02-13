extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0
var target: Node3D

@onready var enemy: CharacterBody3D = get_parent().get_parent()
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

func _ready() -> void:
	target = PlayerManager.player

func randomize_variables():
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	wander_time = randf_range(1.5, 4)
	
func enter():
	randomize_variables()

func process(_delta: float):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= _delta
	
	if enemy.global_position.distance_to(target.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyChase")

func physics_process(_delta: float):
	enemy.velocity = wander_direction * enemy.WalkSpeed
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity()
