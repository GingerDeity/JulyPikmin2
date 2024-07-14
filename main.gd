extends Node2D
@export var pikminScene: PackedScene

var allPikmin: Array[Pikmin]
var startingPikmin = 100
var pikmin_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	pikmin_manager = PikminManager.new()
	add_child(pikmin_manager)
	
func _input(event):
	if event.is_action_pressed("create_pikmin"):
		var pikmin = pikminScene.instantiate()
		allPikmin.append(pikmin)
		add_child(pikmin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pikmin_manager.set_target($Player.position)
