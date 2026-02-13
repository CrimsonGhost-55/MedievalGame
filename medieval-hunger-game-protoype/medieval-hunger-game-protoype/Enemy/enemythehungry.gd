extends CharacterBody3D

const update_time = 0.2
const SPEED = 150
const smoothing_factor = 0.2
const view_angle: float = 190.0

enum State {IDLE, PATROL, INVESTIGATE, CHASE, ATTACK, RETURN}
var state: State = State.IDLE

var target: Node3D
var patrol_index := 0
var patrol_timer := 0.0
var investigate_timer := 0.0
var update_timer := 0.0
var investigate_position: Vector3
var return_position: Vector3
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


@export var patrol_points: Array[Node3D] = []
@export var speed_walk: float = 3.0
@export var speed_run: float = 5.0
@export var attack_range: float = 2.0
@export var investigate_wait_time: float = 4.0
@export var patrol_wait_time: float = 3.0
@export var update_interval: float = 0.2


@onready var nav_agent = $NavigationAgent3D
@onready var raycast = $RayCast 


func _ready() -> void:
	##Add the player to this var
	target = PlayerManager.player
	_enter_state(State.IDLE if patrol_points.is_empty() else State.PATROL)
	

func _physics_process(delta: float) -> void:
	_update_path(delta)
	
	match state:
		State.IDLE: _state_idle()
		State.PATROL: _state_patrol(delta)
		State.INVESTIGATE: _state_investigate(delta)
		State.CHASE: _state_chase(delta)
		State.ATTACK: _state_attack()
		State.RETURN: _state_return(delta)
	
	_looking()
	_apply_gravity(delta)
	move_and_slide()

##Do not comment out
func _go_to_next_patrol_point() -> void:
	patrol_index = (patrol_index + 1) % patrol_points.size()
	nav_agent.set_target_position(patrol_points[patrol_index].global_transform.origin)

##Do not comment out
func _move_towards(next_pos: Vector3, speed: float) -> void:
	var dir = (next_pos - global_transform.origin)
	dir.y = 0.0
	if is_zero_approx(dir.length()):
		velocity.x = lerp(velocity.x, 0.0, smoothing_factor)
		velocity.z = lerp(velocity.z, 0.0, smoothing_factor)
		return
	
	dir = dir.normalized()
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(dir, smoothing_factor).normalized()
	look_at(global_transform.origin + new_dir, Vector3.UP)
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

##Do not comment out
func _stop_and_idle() -> void:
	velocity = Vector3.ZERO

##Do not comment out
func _walk_to(next_pos: Vector3, speed: float) -> void:
	_move_towards(next_pos, speed)

##Do not comment out
func _update_agent_target() -> void:
	##Add the player to this var
	target = PlayerManager.player
	match state:
		State.PATROL:
			if patrol_points.size() > 0:
				nav_agent.set_target_position(patrol_points[patrol_index].global_position)
		State.INVESTIGATE:
			nav_agent.set_target_position(investigate_position)
		State.CHASE:
			if target:
				nav_agent.set_target_position(target.global_transform.origin)
		State.RETURN:
			nav_agent.set_target_position(return_position)

##Do not comment out
func _update_path(delta):
	update_timer -= delta
	if update_timer <= 0.0:
		_update_agent_target()
		update_timer = update_interval

##Do not comment out
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

func _can_see_player() -> bool:
	return target and raycast.is_colliding() and raycast.get_collider() == target

func _looking() -> void:
	if not target:
		return
	var to_player = (target.global_transform.origin - global_transform.origin).normalized()
	var forward = -global_transform.basis.z
	var angle_deg = rad_to_deg(acos(clamp(forward.dot(to_player), -1.0, 1.0)))
	if angle_deg > view_angle * 0.5:
		return
	
	var ray_forward = -raycast.global_transform.basis.z
	var new_dir = ray_forward.slerp(to_player, smoothing_factor).normalized()
	raycast.look_at(raycast.global_transform.origin + new_dir, Vector3.UP)


func _enter_state(new_state: State) -> void:
	state = new_state
	print(new_state)
	match state:
		State.PATROL:
			patrol_timer = 0 
			_go_to_next_patrol_point()
		State.INVESTIGATE:
			investigate_timer = 0.0
			nav_agent.set_target_position(investigate_position)
		State.CHASE, State.INVESTIGATE:
			return_position = global_transform.origin

func _state_idle() -> void:
	if _can_see_player():
		_enter_state(State.CHASE)

func _state_patrol(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		if patrol_timer <= 0.0:
			patrol_timer = patrol_wait_time
			_stop_and_idle()
		else:
			patrol_timer -= delta
			if patrol_timer <= 0.0:
				_go_to_next_patrol_point()
	else:
		_walk_to(nav_agent.get_next_path_position(), speed_walk)
	
	if _can_see_player():
		_enter_state(State.CHASE)

@warning_ignore("unused_parameter")
func _state_chase(delta: float) -> void:
	if not target:
		_enter_state(State.RETURN)
		return
	
	_walk_to(nav_agent.get_next_path_position(), speed_run)
	
	if global_transform.origin.distance_to(target.global_transform.origin) < attack_range:
		_enter_state(State.ATTACK)
	elif not _can_see_player():
		investigate_position = target.global_transform.origin
		_enter_state(State.INVESTIGATE)

func _state_attack() -> void:
	velocity = Vector3.ZERO
	_enter_state(State.CHASE)

func _state_investigate(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		if investigate_timer <= 0.0:
			investigate_timer = investigate_wait_time
			_stop_and_idle()
		else:
			investigate_timer -= delta
			if investigate_timer <= 0.0:
				_enter_state(State.RETURN)
	else:
		_walk_to(nav_agent.get_next_path_position(), speed_walk)
	
	if _can_see_player():
		_enter_state(State.CHASE)

@warning_ignore("unused_parameter")
func _state_return(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		_enter_state(State.PATROL)
	else:
		_walk_to(nav_agent.get_next_path_position(), speed_walk)
	
	if _can_see_player():
		_enter_state(State.CHASE)

func hear_noise(pos: Vector3) -> void:
	if state not in [State.CHASE, State.ATTACK]:
		investigate_position = pos
		_enter_state(State.INVESTIGATE)
