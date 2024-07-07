class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var h_dir = Input.get_axis("ui_left", "ui_right")
	var v_dir = Input.get_axis("ui_up", "ui_down")
	
	if h_dir:
		velocity.x = h_dir
	else:
		velocity.x = 0

	if v_dir:
		velocity.y = v_dir
	else:
		velocity.y = 0
		
	velocity = velocity.normalized()
	velocity *= SPEED

	move_and_slide()
