class_name Emini
extends CharacterBody2D

@export var max_speed: = 175.0

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

enum STATE {IDLE, TARGET, ATTACK}
var state: STATE
var _target: Node2D
var _velocity: Vector2

func _ready():
	state = STATE.IDLE
	#randomize()
	#_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func set_target(target):
	_target = target

#doing body-overlap detection here means all operations are being done with respect to frames,
#unlike before where some operations weren't and some were, created weird interactions
func _physics_process(_delta):
	var target_direction = Vector2.ZERO
	var target_distance = 0
	if _target != null:
		_velocity = (_target.position - position).limit_length(max_speed)
		sqrt(_velocity.x)
		sqrt(_velocity.y)
		set_rotation(position.angle_to_point(_target.position) + PI/2)
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
		if (curr_distance < closest_distance):
			closest_distance = curr_distance
			closest_entity = entity
	set_target(closest_entity)

func closer_than_target(position: Vector2):
	return global_position.distance_to(position) < global_position.distance_to(_target.position) #had to change to "<" for some reason

#func _on_fov_area_body_entered(body):
	#if state != STATE.TARGET:
		#state = STATE.TARGET
		#set_target(body)
	#elif state == STATE.TARGET && closer_than_target(body.position):
		#set_target(body)
	#print("[Enemy] A " + body.name + " has entered my perception")
	#var overlapping_bodies = $FOV_Area.get_overlapping_bodies()
	#print("[Enemy] I see ", overlapping_bodies.size(), " entities")
#
#func _on_fov_area_body_exited(body):
	#print("[Enemy] A " + body.name + " has exited my perception")
	#var overlapping_bodies = $FOV_Area.get_overlapping_bodies()
	#print("[Enemy] I see ", overlapping_bodies.size(), " entities")
	#if (!overlapping_bodies.size()):
		#state = STATE.IDLE
		#set_target(null)
		#return
	#
	#var closest_entity = overlapping_bodies[0]
	#var closest_distance = closest_entity.position.distance_to(position)
	#for entity in overlapping_bodies.slice(1, overlapping_bodies.size()):
		#var curr_distance = entity.position.distance_to(position)
		#if (curr_distance < closest_distance):
			#closest_distance = curr_distance
			#closest_entity = entity
#
	#print("[Enemy] The closest perceived entity is a ", closest_entity.name, 
		#" that is ", closest_distance, " pixels away")
	#state = STATE.TARGET
	#set_target(closest_entity)
