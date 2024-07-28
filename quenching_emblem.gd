class_name QuenchingEmblem
extends CharacterBody2D

const PIKMIN_WEIGHT = 1
const MIN_WEIGHT = 3
const MAX_WEIGHT = 6

var curr_weight = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%PikUpPathFollow.loop = true
	pass

func get_path2follow2d():
	return %PikUpPathFollow

func _on_push_area_body_entered(body):
	curr_weight += PIKMIN_WEIGHT
	print("[Treasure] weight decreased to ", curr_weight)

func _on_push_area_body_exited(body):
	curr_weight -= PIKMIN_WEIGHT
	print("[Treasure] weight increased to ", curr_weight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curr_weight >= MIN_WEIGHT && curr_weight <= MAX_WEIGHT:
		print("[Treasure] now movable")
		move_and_slide()
