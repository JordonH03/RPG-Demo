extends KinematicBody2D

# Movement variables
## exports variables as editable properties in the Inspector
export var MAX_SPEED = 120
export var ACCELERATION = 500
export var ROLL_SPEED = 125
export var FRICTION = 500
## Initializes player velocity variable
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO
var stats = PlayerStats

# Animation Variables

## List of different animations
enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
## Animation nodes
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Collision node variables
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	animationTree.active = true # Turns animation on
	swordHitbox.knockback_vector = roll_vector
	stats.connect("no_health", self, "queue_free")
	

func _physics_process(delta):
	# Checks for current animation state
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)
		ATTACK: attack_state(delta)
		
	# Test rotation
	print($HitboxPivot.rotation_degrees)

# Movement function
func move_state(delta):
	var input_vector = Vector2.ZERO
	# Calculates the direction of movement based on key input
	# Allows for multi-directional movement
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # reduces the velocity to the smallest unit...1
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		# Sets the different animations based on key input
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		print(input_vector)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # moves player to 0,0 by FRICTION val
		
	# Commands player body to stop on collision
	move()
	
	# Checks for ATTACK action and switches animation
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

# Attack function
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
# Roll function
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
# Switches back to move state
func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	print("hit")
