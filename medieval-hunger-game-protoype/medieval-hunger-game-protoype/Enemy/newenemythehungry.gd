extends CharacterBody3D

@export var WalkSpeed: float = 1.0
@export var RunSpeed: float = 5.0
@export var AttackRange: float = 1.5
@export var ChaseDistance: float = 10.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target: Node3D

func _ready() -> void:
	target = PlayerManager.player


func _physics_process(delta: float) -> void:
	move_and_slide()
