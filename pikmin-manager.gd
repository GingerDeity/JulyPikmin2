class_name PikminManager
extends Node

var num_pikmin: int
var all_pikmin: Array
var distance_map: Dictionary

# Example grid parameters
var grid_size: float = 15.0
var grid: Dictionary
@export var pikminScene = load("res://pikmin.tscn")
@export var cohesion_force: = 0.1
@export var align_force: = .3
@export var separation_force: = 0.3
@export var view_distance := 15.0
@export var separation_distance := 10.0

var loop = 0

func _ready():
	num_pikmin = 500  # Example number of allPikmin
	all_pikmin = []
	distance_map = {}

	# Initialize allPikmin
	for i in range(num_pikmin):
		var pikmin = pikminScene.instantiate()
		pikmin.set_target(Vector2(500, 300))
		all_pikmin.append(pikmin)
		add_child(pikmin)

func _process(delta):
	loop = 0
	update_grid()
	update_distances()
	update_flocking_forces()
	print(loop)
	
func set_target(target):
	for pikmin in all_pikmin:
		pikmin.set_target(target)

func get_grid_cell(position: Vector2) -> Vector2:
	return Vector2(floor(position.x / grid_size), floor(position.y / grid_size))

func update_grid():
	grid.clear()
	for pikmin in all_pikmin:
		loop += 1
		var cell = get_grid_cell(pikmin.global_position)
		if !grid.has(cell):
			grid[cell] = []
		grid[cell].append(pikmin)


func get_neighbors(pikmin) -> Array:
	var neighbors = []
	var center_cell = get_grid_cell(pikmin.global_position)
	var pikmin_in_3x3 = get_pikmin_in_3x3(center_cell)
	for possible_neighbor in pikmin_in_3x3:
		loop += 1
		if possible_neighbor == pikmin: continue
		var key = get_pair_key(pikmin.get_instance_id(), possible_neighbor.get_instance_id())
		if distance_map[key] > view_distance: continue
		neighbors.append(possible_neighbor)
		#if neighbors.size() == 10: break
	return neighbors

func get_pikmin_in_3x3(center_cell: Vector2) -> Array:
	var pikmin_in_3x3 = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			loop += 1
			var cell = Vector2(center_cell.x + x, center_cell.y + y)
			if !grid.has(cell): continue
			pikmin_in_3x3 += grid[cell]
	return pikmin_in_3x3

func get_pair_key(id_a: int, id_b: int) -> Array:
	return [min(id_a, id_b), max(id_a, id_b)]

func update_distances():
	var loop_number = 0
	distance_map.clear()
	for pikmin in all_pikmin:
		var pikmin_in_3x3 = get_pikmin_in_3x3(get_grid_cell(pikmin.global_position))
		for possible_neighbor in pikmin_in_3x3:
			loop += 1
			if possible_neighbor == pikmin: continue
			var key = get_pair_key(pikmin.get_instance_id(), possible_neighbor.get_instance_id())
			if distance_map.has(key): continue
			var dist = pikmin.global_position.distance_to(possible_neighbor.global_position)
			distance_map[key] = dist
	#print(loop_number)

func update_flocking_forces():
	var loop_number = 0
	for pikmin in all_pikmin:
		var cohesion_vector: = Vector2()
		var flock_center: = Vector2()
		var align_vector: = Vector2()
		var separation_vector: = Vector2()
		
		var neighbors = get_neighbors(pikmin)
		if neighbors.is_empty(): continue
		for neighbor in neighbors:
			loop += 1
			if pikmin == neighbor: continue
			
			var neighbor_pos = neighbor.global_position
			#print("pikmin", pikmin.global_position, "neighbor", neighbor_pos)
			
			align_vector += neighbor._velocity
			flock_center += neighbor_pos
			
			var key = get_pair_key(pikmin.get_instance_id(), neighbor.get_instance_id())
			var distance = distance_map[key]
			if distance > separation_distance: continue
			separation_vector -= (neighbor_pos - pikmin.global_position).normalized() * (separation_distance / distance)
			
		align_vector = align_vector.normalized()
		flock_center /= neighbors.size()

		var center_dir = pikmin.global_position.direction_to(flock_center)
		#print(pikmin.global_position.distance_to(flock_center))
		var center_speed = (pikmin.global_position.distance_to(flock_center) / view_distance)
		cohesion_vector = center_dir * center_speed
		
		var flocking_force: = Vector2()
		#print("separation_vector: ", separation_vector)
		#print("cohesion_vector: ", cohesion_vector)
		#print("align_vector: ", align_vector)
		flocking_force += separation_vector * pikmin.max_speed * separation_force
		flocking_force += cohesion_vector * pikmin.max_speed * cohesion_force
		flocking_force += align_vector * pikmin.max_speed * align_force
		
		pikmin.set_flocking_force(flocking_force)
	#print(loop_number)
