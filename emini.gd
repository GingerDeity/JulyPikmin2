class_name Emini
extends CharacterBody2D

@export var max_speed: = 175.0

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

const TUNNEL_VISION = 75

enum STATE {IDLE, TARGET, ATTACK}
var state: STATE
var _target: Node2D
var _velocity: Vector2
const _max_angular_velocity = PI/4

#var health (is an int)
#var power (is an int)

func _ready():
	state = STATE.IDLE
	#randomize()
	#_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func set_target(target):
	_target = target

#doing body-overlap detection here means all operations are being done with respect to frames,
#unlike before where some operations weren't and some were, created weird interactions
func _physics_process(delta):
	var target_direction = Vector2.ZERO
	var target_distance = 0
	if _target != null:
		#rotation = -PI/2
		#_velocity = (_target.position - position).limit_length(max_speed)
		sqrt(_velocity.x)
		sqrt(_velocity.y)
		# converts rotation to a vector from the positive x axis
		var direction_vector = Vector2.from_angle(Vector2.DOWN.angle_to(Vector2.from_angle(rotation)))
		var target_vector = _target.position - position
		var angle_difference = direction_vector.angle_to(target_vector)
		var angular_velocity_limit = _max_angular_velocity * delta
		var angular_velocity = clamp(angle_difference, -angular_velocity_limit, angular_velocity_limit)
		print("angleDifference", angle_difference)
		
		rotate(angular_velocity)
	else:
		_velocity = Vector2.ZERO
	
	if ($FOV_Area.has_overlapping_bodies()):
		state = STATE.TARGET
		evaluate_targeting()
	else:
		state = STATE.IDLE
		set_target(null)
	
	set_velocity(_velocity)
	move_and_slide()

#moved code from on_body_exited to here
func evaluate_targeting():
	var overlapping_bodies = $FOV_Area.get_overlapping_bodies()
	var closest_entity = overlapping_bodies[0]
	var closest_distance = closest_entity.position.distance_to(position)
	for entity in overlapping_bodies.slice(1, overlapping_bodies.size()):
		var curr_distance = entity.position.distance_to(position)
		if curr_distance < (closest_distance - TUNNEL_VISION):
			closest_distance = curr_distance
			closest_entity = entity
	set_target(closest_entity)

func closer_than_target(position: Vector2):
	return global_position.distance_to(position) < global_position.distance_to(_target.position) #had to change to "<" for some reason
