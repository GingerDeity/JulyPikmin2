extends Node2D
@export var pikmin: Pikmin

# Called when the node enters the scene tree for the first time.
func _ready():
	pikmin.instantiate()
	add_child(pikmin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pikmin.set_target($Player.position)
