class_name Emini
extends CharacterBody2D

const SPEED = 100
const TUNNEL_VISION = 75
const TOTAL_HEALTH = 5
const MAX_ANGULAR_SPEED = PI/4

enum STATE {IDLE, TARGET, ATTACK}
var state = STATE.IDLE

var _target = null
var _velocity: Vector2
var _health = TOTAL_HEALTH

func set_state(state):
	match state:
		STATE.IDLE:
			set_velocity(Vector2.ZERO)
		STATE.ATTACK:
			set_velocity(Vector2.ZERO)
			if %BiteWindup.is_stopped(): 
				print("hi")
				%BiteWindup.start()
			
	self.state = state

#doing body-overlap detection here means all operations are being done with respect to frames,
#unlike before where some operations weren't and some were, created weird interactions
func _physics_process(delta):
<<<<<<< HEAD
	if _health <= 0:
		queue_free()
	
	var target_direction = Vector2.ZERO
	var target_distance = 0
	if _target != null:
		_velocity = (_target.position - position).limit_length(SPEED)
		sqrt(_velocity.x)
		sqrt(_velocity.y)
		# converts rotation to a vector from the positive x axis
		var direction_vector = Vector2.from_angle(Vector2.DOWN.angle_to(Vector2.from_angle(rotation)))
		var target_vector = _target.position - position
		var angle_difference = direction_vector.angle_to(target_vector)
		var angular_velocity_limit = MAX_ANGLULAR_SPEED * delta
		var angular_velocity = clamp(angle_difference, -angular_velocity_limit, angular_velocity_limit)
		print("angleDifference", angle_difference)
		
		rotate(angular_velocity)
	else:
		_velocity = Vector2.ZERO
	
	if ($FOV_Area.has_overlapping_bodies()):
		state = STATE.TARGET
		evaluate_targeting(_target)
	else:
		state = STATE.IDLE
		set_target(null)
=======
	print(state)
	match (state):
		STATE.TARGET:
			if evaluate_targeting() == false: return
			
			var target_vector = _target.position - position
			_velocity = (target_vector).normalized() * SPEED
			
			# converts rotation to a vector from the positive x axis
			var direction_vector = Vector2.from_angle(Vector2.DOWN.angle_to(Vector2.from_angle(rotation)))
			var angle_difference = direction_vector.angle_to(target_vector)
			var angular_velocity_limit = MAX_ANGULAR_SPEED * delta
			var angular_velocity = clamp(angle_difference, -angular_velocity_limit, angular_velocity_limit)
			
			rotate(angular_velocity)
			
			set_velocity(_velocity)
			move_and_slide()
>>>>>>> ce28a2f708d4f2e4719c01fc1effa8ba6f104ac9

func _on_bite_windup_timeout():
	match state:
		STATE.ATTACK:
			%BiteWindup.start()
	print("[Enemy] Biting!")
	var entities = %BiteArea.get_overlapping_bodies()
	for entity in entities: if entity is Pikmin: entity.set_is_hit(true)

func _on_fov_body_entered(body):
	print(state)
	match state:
		STATE.IDLE:
			set_state(STATE.TARGET)

func _on_fov_body_exited(body):
	match state:
		STATE.TARGET:
			if !%FOV_Area.get_overlapping_bodies().is_empty(): return
			set_state(STATE.IDLE)
	
func _on_bite_body_entered(body):
	match state:
		STATE.IDLE, STATE.TARGET:
			set_state(STATE.ATTACK)

func _on_bite_body_exited(body):
	match state:
		STATE.ATTACK:
			print(!%BiteArea.get_overlapping_bodies().is_empty())
			print(!%FOV_Area.get_overlapping_bodies().is_empty())
			if !%BiteArea.get_overlapping_bodies().is_empty(): return
			elif !%FOV_Area.get_overlapping_bodies().is_empty():
				set_state(STATE.TARGET)
				return
			set_state(STATE.IDLE)
			
#moved code from on_body_exited to here
func evaluate_targeting(target):
	var overlapping_bodies = $FOV_Area.get_overlapping_bodies()
<<<<<<< HEAD
	var closest_entity
	var closest_distance

	if target != null:
		closest_entity = target
	else:
		closest_entity =  overlapping_bodies[0]
	closest_distance = closest_entity.position.distance_to(position)

=======
	if overlapping_bodies.is_empty(): return false
	var closest_entity = overlapping_bodies[0]
	var closest_distance = closest_entity.position.distance_to(position)
>>>>>>> ce28a2f708d4f2e4719c01fc1effa8ba6f104ac9
	for entity in overlapping_bodies.slice(1, overlapping_bodies.size()):
		var curr_distance = entity.position.distance_to(position)
		if curr_distance >= (closest_distance - TUNNEL_VISION): continue
		closest_distance = curr_distance
		closest_entity = entity
	_target = closest_entity
	
func damage(damage):
	_health -= damage
	if _health <= 0:
		queue_free()
			
