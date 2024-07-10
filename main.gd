extends Node2D
@export var pikminScene: PackedScene

var allPikmin: Array[Pikmin]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("create_pikmin"):
		var pikmin = pikminScene.instantiate()
		allPikmin.append(pikmin)
		add_child(pikmin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for pikmin in allPikmin:
		pikmin.set_target($Player.position)
