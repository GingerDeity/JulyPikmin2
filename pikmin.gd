class_name Pikmin
extends Node2D

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

var _neighbors: Array = []
var _target: Vector2
var _velocity: Vector2
var _flocking_force: Vector2



@export var max_speed: = 100.0
@export var base_speed: = 100.0
@export var mouse_follow_force: = 0.2

func _ready():
	print("ready!")
	randomize()
	position = Vector2(randf_range(0, _width), randf_range(0, _height))
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func set_target(target):
	_target = target
	
func set_flocking_force(force):
	_flocking_force = force
	

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.get_button_index() == MOUSE_BUTTON_LEFT:
			#_mouse_target = event.position
		#elif event.get_button_index() == MOUSE_BUTTON_RIGHT:
			#_mouse_target = get_random_target()

func _process(delta):
	var target_vector = Vector2.ZERO
	if _target != Vector2.INF:
		target_vector = global_position.direction_to(_target) * max_speed * mouse_follow_force

	var acceleration = _flocking_force + target_vector
	
	_velocity = (_velocity + acceleration).limit_length(max_speed)
	
	position.x = wrapf(position.x, 0, _width)
	position.y = wrapf(position.y, 0, _height)
	
	position += _velocity * delta
