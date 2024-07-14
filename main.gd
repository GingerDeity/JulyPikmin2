extends Node2D
@export var pikminScene: PackedScene

var allPikmin: Array[Pikmin]

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _input(event):
	if event.is_action_pressed("create_pikmin"):
		var pikmin = pikminScene.instantiate()
		pikmin.set_target($Player)
		allPikmin.append(pikmin)
		add_child(pikmin)
	elif event.is_action_pressed("exit"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
