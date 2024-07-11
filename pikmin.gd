class_name Pikmin
extends CharacterBody2D

@export var max_speed: = 200.0
@export var mouse_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var align_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 30.0

var _width = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height = ProjectSettings.get_setting("display/window/size/viewport_height")

var _neighbors: Array = []
var _target: Vector2
var _velocity: Vector2

func _ready():
	randomize()
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func set_target(target):
	_target = target

func _on_view_body_entered(body: PhysicsBody2D):
	print("hewwo")
	if self != body && body is Pikmin:
		_neighbors.append(body)

func _on_view_body_exited(body: PhysicsBody2D):
	_neighbors.remove_at(_neighbors.find(body))

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.get_button_index() == MOUSE_BUTTON_LEFT:
			#_mouse_target = event.position
		#elif event.get_button_index() == MOUSE_BUTTON_RIGHT:
			#_mouse_target = get_random_target()

func _physics_process(_delta):
	var target_vector = Vector2.ZERO
	if _target != Vector2.INF:
		target_vector = global_position.direction_to(_target) * max_speed * mouse_follow_force
	
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
			print("hi")
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_position.direction_to(flock_center)
		var center_speed = max_speed * (global_position.distance_to(flock_center) / $FlockView/CollisionShape2D.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]
