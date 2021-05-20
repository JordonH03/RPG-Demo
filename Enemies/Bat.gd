extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn") # Preloads animation scene for later use

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

# Bat actions
enum {
	IDLE,
	WANDER,
	CHASE	
}

var state = IDLE

# Movement variables
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO # Initializes knockback

onready var stats = $Stats # Acesses Stats node properties
onready var playerDetectionArea = $PlayerDetectionArea
onready var sprite = $BodySprite
onready var hurtbox = $Hurtbox

# Print health variables
func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	# Knocks back the enemy on a hit
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	# Check current state
	match state:
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER: pass
		CHASE:
			var player = playerDetectionArea.player
			if player != null:
				var direction =  (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	velocity = move_and_slide(velocity)
		
func seek_player():
	if playerDetectionArea.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()  # Create instance/copy of effect scene
	get_parent().add_child(enemyDeathEffect)            # Add effect to parent (bat)
	enemyDeathEffect.global_position = global_position  # Set position of instance to parent
