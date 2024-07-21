class_name Player
extends CharacterBody2D
@export var pikminScene: PackedScene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CURSOR_LIMIT = 250

var pikmin_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_view_body_entered(body: PhysicsBody2D):
	pikmin_count += 1
	body.queue_free()
	print("[Player] Curr Inventory: ", pikmin_count)

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		$Cursor.position = ($Cursor.position + event.relative).limit_length(CURSOR_LIMIT)
	elif event.is_action_pressed("throw"):
		if (pikmin_count > 0):
			get_parent().add_pikmin($Cursor.global_position, 2) #new, to-do: change 2 to actual enum name
			pikmin_count -= 1
			print("[Player] Curr Inventory: ", pikmin_count)
