extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn") # Preloads animation scene for later use

var knockback = Vector2.ZERO # Initializes knockback

onready var stats = $Stats # Acesses Stats node properties

# Test code
func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	# Knocks back the enemy on a hit
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()  # Create instance/copy of effect scene
	get_parent().add_child(enemyDeathEffect)            # Add effect to parent (bat)
	enemyDeathEffect.global_position = global_position  # Set position of instance to parent
