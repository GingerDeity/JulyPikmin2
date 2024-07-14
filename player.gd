class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FOLLOW_OFFSET = 60

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	var direction = velocity.normalized()
	
	if (abs(direction) > Vector2()): 
		$Follow.position = -direction *  FOLLOW_OFFSET
		$Follow.rotation = direction.angle()
	
	move_and_slide()
