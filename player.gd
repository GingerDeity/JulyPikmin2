class_name Player
extends CharacterBody2D
@export var pikminScene: PackedScene
@export var whistleArea: Node2D

const SPEED = 300.0
const WHISTLE_TIMER = 5.5
var WHISTLE_RADIUS
var CURSOR_LIMIT

var pikmin_count = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	WHISTLE_RADIUS = whistleArea.shape.radius
	CURSOR_LIMIT = WHISTLE_RADIUS
	whistleArea.position = $Cursor.position
	whistleArea.disabled = true

func _on_pikmin_follow_body_exited(body):
	if body.get_state() == PIKMIN_STATE.IN_PARTY:
		body.set_state(PIKMIN_STATE.FOLLOW)

func _on_pikmin_follow_body_entered(body):
	pikmin_count += 1
	body.set_state(PIKMIN_STATE.IN_PARTY)
	body.queue_free() #don't comment this line if you want pikmin to immediately despawn upon contact
	get_parent().remove_child(body)
	print("[Player] Curr Inventory: ", pikmin_count)

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	#if direction != Vector2.ZERO:
		#$PikminFollow.set_rotation($PikminFollow.position.angle_to_point(direction))

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		$Cursor.position = ($Cursor.position + event.relative).limit_length(CURSOR_LIMIT)
	elif event.is_action_pressed("throw"):
		if (pikmin_count > 0):
			get_parent().add_pikmin($Cursor.global_position, PIKMIN_STATE.IDLE)
			pikmin_count -= 1
			print("[Player] Curr Inventory: ", pikmin_count)
	elif event.is_action_pressed("whistle"):
		$WhistleTimer.start(WHISTLE_TIMER)
		whistleArea.disabled = false
		print("whistle area enabled")
	elif event.is_action_released("whistle"):
		$WhistleTimer.stop()
		whistleArea.disabled = true
		print("whistle area disabled")

func _on_whistle_timer_timeout():
	whistleArea.disabled = true
	print("whistle area disabled")

func _on_whistle_body_entered(body):
	if body is Pikmin:
		body.set_target($PikminFollow/PikminPikup)
		body.set_state(PIKMIN_STATE.FOLLOW)
