class_name Pikmin
extends CharacterBody2D

@export var max_speed: = 20.0
@export var mouse_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 30.0

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

var _neighbors: Array = []
var _target: Node2D
var _velocity: Vector2
var state

var _is_hit = false
const DAMAGE = 1

func _ready():
	state = PIKMIN_STATE.IDLE

func get_state():
	return state

func set_state(new_state):
	state = new_state
	if new_state == PIKMIN_STATE.IDLE:
		set_target(null)
		_velocity = Vector2.ZERO
	elif new_state == PIKMIN_STATE.IN_PARTY:
		_velocity = Vector2.ZERO
	elif new_state == PIKMIN_STATE.ATTACK:
		var entities = %Notify.get_overlapping_bodies()
		for entity in entities:
			if entity != self && entity is Pikmin && entity.get_state() != PIKMIN_STATE.ATTACK:
				entity.set_target(_target)
				entity.set_state(PIKMIN_STATE.ATTACK)
				break

func set_is_hit(new_hit):
	_is_hit = new_hit

func set_target(target):
	_target = target

func get_target():
	return _target

func _on_attack_windup_timeout():
	print("[Pikmin] Attacking!")
	var entities = %FlockView.get_overlapping_bodies()
	for entity in entities:
		if entity is Emini:
			print("[Enemy] ", entity.get_health())
			entity.set_health(entity.get_health() - DAMAGE)

func _on_view_body_entered(body: PhysicsBody2D):
	if self != body:
		if body is Pikmin:
			_neighbors.append(body)
		if body is Emini && state != PIKMIN_STATE.ATTACK:
			set_target(body)
			set_state(PIKMIN_STATE.ATTACK)
			print("[Pikmin] Winding up attack!")
			if %AttackWindup.time_left <= 0:
				%AttackWindup.start()
		if body is QuenchingEmblem && state != PIKMIN_STATE.CARRY:
			print("HI")
			set_state(PIKMIN_STATE.CARRY)
			var toFollow = body.get_path2follow2d()
			randomize()
			toFollow.progress_ratio = randf()
			print(toFollow.position)
			var point = Node2D.new()
			point.position = toFollow.position
			print(point.position)
			toFollow.add_child(point)
			set_target(point)

func _on_view_body_exited(body: PhysicsBody2D):
	if body is Pikmin:
		_neighbors.remove_at(_neighbors.find(body))

func _physics_process(_delta):
	if _is_hit:
		queue_free()
		
	if _target != null:
		print(_target.position)
		
	if _target != null && _target is Emini && _target.get_health() <= 0:
		set_state(PIKMIN_STATE.IDLE)
	
	if state == PIKMIN_STATE.FOLLOW || state == PIKMIN_STATE.ATTACK || state == PIKMIN_STATE.CARRY && _target != null:
		var target_vector = global_position.direction_to(_target.global_position) * max_speed * mouse_follow_force
		
		# get cohesion, alignment, and separation vectors
		var vectors = get_neighbors_status(_neighbors)
		
		# steer towards vectors
		var cohesion_vector = vectors[0] * cohesion_force
		var align_vector = vectors[1] * align_force
		var separation_vector = vectors[2] * separation_force

		var acceleration = target_vector + separation_vector #+ cohesion_vector + align_vector
		_velocity = (_velocity + acceleration).limit_length(max_speed)
	
	set_velocity(_velocity)
	move_and_slide()
	_velocity = velocity


func get_neighbors_status(flock: Array):
	var center_vector: = Vector2()
	var flock_center: = Vector2()
	var align_vector: = Vector2()
	var avoid_vector: = Vector2()
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position

		align_vector += f._velocity
		flock_center += neighbor_pos

		var d = global_position.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_position.direction_to(flock_center)
		var center_speed = max_speed * (global_position.distance_to(flock_center) / $FlockView/CollisionShape2D.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]
