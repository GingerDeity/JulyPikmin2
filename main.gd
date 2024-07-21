class_name Main
extends Node2D
@export var pikminScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) #added
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func add_pikmin(position, state):
	var pikmin = pikminScene.instantiate()
	pikmin.global_position = position
	pikmin.set_state(state)
	add_child(pikmin)

func _input(event):
	if event.is_action_pressed("create_pikmin"):
		var pikmin = pikminScene.instantiate()
		pikmin.set_target($Player)
		var x = randf_range(0, get_viewport().size.x)
		var y = randf_range(0, get_viewport().size.y)
		pikmin.global_position = Vector2(x, y)
		add_child(pikmin)
	elif event.is_action_pressed("exit"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
