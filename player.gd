class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CURSOR_LIMIT = 250

var pikmin_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_view_body_entered(body: PhysicsBody2D):
	print(pikmin_count)
	pikmin_count += 1
	body.queue_free()

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		var cursor_position = (event.position - position).limit_length(CURSOR_LIMIT)
		$Cursor.position = (event.position - position).limit_length(CURSOR_LIMIT)
		Input.warp_mouse(position + cursor_position)
