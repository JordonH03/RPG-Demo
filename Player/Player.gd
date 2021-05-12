extends KinematicBody2D

const MAX_SPEED = 120 # used to keep player speed constant
const ACCELERATION = 500
const FRICTION = 500

# Initializes player velocity variable
var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	# Calculates the direciton of movement based on key input
	# Allows for multi-directional movement
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # reduces the velocity to the smallest unit...1
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # moves player to 0,0 by FRICTION val
		
	# Commands player body to stop on collision
	velocity = move_and_slide(velocity)
