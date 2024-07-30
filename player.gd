class_name Player
extends CharacterBody2D
@export var pikminScene: PackedScene
@export var whistleArea: Node2D

const SPEED = 300.0
const WHISTLE_TIMER = 5.5
var pikmin_count = 20

var WHISTLE_RADIUS
var CURSOR_LIMIT

func _ready():
	WHISTLE_RADIUS = whistleArea.shape.radius
	CURSOR_LIMIT = WHISTLE_RADIUS
	whistleArea.position = %Cursor.position
	whistleArea.disabled = true

func _on_pikmin_follow_body_exited(body):
	#To be added once pikmin stay present in world
	#if body.get_state() == PIKMIN_STATE.IN_PARTY:
	#	body.set_state(PIKMIN_STATE.FOLLOW)
	pass

func _on_pikmin_follow_body_entered(body):
	pikmin_count += 1
	body.queue_free() #don't comment this line if you want pikmin to immediately despawn upon contact
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
		%Cursor.position = (%Cursor.position + event.relative).limit_length(CURSOR_LIMIT)
	elif event.is_action_pressed("throw"):
		if (pikmin_count > 0):
			get_parent().add_pikmin(%Cursor.global_position)
			pikmin_count -= 1
	elif event.is_action_pressed("whistle"):
		%WhistleTimer.start(WHISTLE_TIMER)
		whistleArea.disabled = false
	elif event.is_action_released("whistle"):
		%WhistleTimer.stop()
		whistleArea.disabled = true

func _on_whistle_timer_timeout():
	whistleArea.disabled = true

func _on_whistle_body_entered(body):
	if body is Pikmin:
		body.alert(%PikminPikup)
