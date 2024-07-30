class_name Pikmin
extends CharacterBody2D

@export var max_speed: = 125.0
@export var mouse_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 30.0

var _neighbors: Array = []
var _target: Node2D
var _velocity: Vector2
var state = PIKMIN_STATE.IDLE

const DAMAGE = 1

func set_state(state):
	match state:
		PIKMIN_STATE.IDLE:
			set_target(null)
			set_velocity(Vector2.ZERO)
		PIKMIN_STATE.IN_PARTY:
			set_velocity(Vector2.ZERO)
		PIKMIN_STATE.ATTACK:
			if self.state == PIKMIN_STATE.ATTACK: return
			self.state = state
			var entities = %Notify.get_overlapping_bodies()
			for entity in entities:
				if entity != self && entity is Pikmin:
					entity.set_target(_target)
					entity.set_state(PIKMIN_STATE.ATTACK)
					break
	self.state = state
	
func _physics_process(_delta):
	match state:
		PIKMIN_STATE.FOLLOW:
			apply_movement()
		PIKMIN_STATE.ATTACK:
			apply_movement()
		PIKMIN_STATE.CARRY:
			apply_movement()
	set_velocity(_velocity)
	move_and_slide()
	_velocity = velocity

func _on_attack_windup_timeout():
	match state:
		PIKMIN_STATE.ATTACK:
			%AttackWindup.start()
	var entities = %FlockView.get_overlapping_bodies()
	for entity in entities:
		if entity is Emini: entity.damage(DAMAGE)

func _on_view_body_entered(body: PhysicsBody2D):
	if self == body: 
		_neighbors.append(body)
		return
	match body.get_name():
		"Pikmin":
			print("AAA")
			_neighbors.append(body)
		"Emini": 
			print("hewwo")
			if state == PIKMIN_STATE.ATTACK: return
			set_target(body)
			set_state(PIKMIN_STATE.ATTACK)
			if %AttackWindup.is_stopped(): %AttackWindup.start()
		"QuenchingEmblem":
			if state == PIKMIN_STATE.CARRY: return
			set_state(PIKMIN_STATE.CARRY)
			var toFollow = body.get_path2follow2d()
			randomize()
			toFollow.progress_ratio = randf()
			var point = Node2D.new()
			point.position = toFollow.position
			toFollow.add_child(point)
			set_target(point)

func _on_view_body_exited(body: PhysicsBody2D):
	if body is Pikmin: _neighbors.remove_at(_neighbors.find(body))
	
func kill(): queue_free()

func set_target(target): _target = target

func apply_movement():
	if _target == null: return
	var target_vector = global_position.direction_to(_target.global_position) * max_speed * mouse_follow_force

	# get cohesion, alignment, and separation vectors
	print(_neighbors)
	var vectors = get_neighbors_status(_neighbors)

	# steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force
	var align_vector = vectors[1] * align_force
	var separation_vector = vectors[2] * separation_force

	var acceleration = target_vector + separation_vector #+ cohesion_vector + align_vector
	_velocity = (_velocity + acceleration).limit_length(max_speed)

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
		if d <= 0 or d >= avoid_distance: continue
		avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
	
	var flock_size = flock.size()
	if !flock_size: return
	align_vector /= flock_size
	flock_center /= flock_size
	
	var center_dir = global_position.direction_to(flock_center)
	var center_speed = max_speed * (global_position.distance_to(flock_center) / $FlockView/CollisionShape2D.shape.radius)
	center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]

func _on_flock_view_area_entered(area):
	print(area)
