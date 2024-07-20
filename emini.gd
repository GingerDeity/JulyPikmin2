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
	
func _physics_process(_delta):
	var target_direction = Vector2.ZERO
	var target_distance = 0
	if _target != null:
		_velocity = (_target.position - position).limit_length(max_speed)
		sqrt(_velocity.x)
		sqrt(_velocity.y)
		set_rotation(position.angle_to_point(_target.position) + PI/2)
		#rotate((rotation - PI/2) - position.angle_to_point(_target.position))
		
		#print("rotation ", rotation)
		#print("angle ", position.angle_to_point(_target.global_position))
	else:
		_velocity = Vector2.ZERO
	set_velocity(_velocity)
	move_and_slide()
	#match state:
		#STATE.TARGET:
			#pass
		#STATE.ATTACK:
			#pass 

func closer_than_target(position: Vector2):
	return global_position.distance_to(position) > global_position.distance_to(_target.position)

func _on_fov_area_body_entered(body):
	if (body is Player || body is Pikmin) && state != STATE.TARGET:
		state = STATE.TARGET
		set_target(body)
		print(body.name + " entered")

func _on_fov_area_body_exited(body):
	var overlapping_bodies = $FOV_Area.get_overlapping_bodies()
	if (!overlapping_bodies.size()):
		state = STATE.IDLE
		set_target(null)
		return
		
	var closest_entity = overlapping_bodies[0]
	var closest_distance = closest_entity.position.distance_to(position)
	for entity in overlapping_bodies.slice(1, overlapping_bodies.size()):
		var curr_distance = entity.position.distance_to(position)
		if (curr_distance < closest_distance):
			closest_distance = curr_distance
			closest_entity = entity
		print(closest_distance)

	state = STATE.TARGET
	set_target(closest_entity)
	print(body.name + " exited")
