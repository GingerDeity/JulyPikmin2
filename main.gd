class_name Main
extends Node2D
@export var pikminScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) #added
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func add_pikmin(new_position, new_state):
	var pikmin = pikminScene.instantiate()
	pikmin.global_position = new_position
	pikmin.set_state(new_state)
	add_child(pikmin)

func _input(event):
	if event.is_action_pressed("create_pikmin"):
		var x = randf_range(0, get_viewport().size.x)
		var y = randf_range(0, get_viewport().size.y)
		add_pikmin(Vector2(x, y), PIKMIN_STATE.IDLE)
	elif event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("ARMY_OF_MORDOR"):
		for i in range(100):
			var x = randf_range(0, get_viewport().size.x)
			var y = randf_range(0, get_viewport().size.y)
			add_pikmin(Vector2(x, y), PIKMIN_STATE.IDLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
