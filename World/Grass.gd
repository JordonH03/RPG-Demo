extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://Effects/GrassEffect.tscn") # Save scene as variable
		var grassEffect = GrassEffect.instance()                 # Create instance/copy of scene
		var world = get_tree().current_scene                     # Access world in file tree
		world.add_child(grassEffect)                             # Add scene instance to world
		grassEffect.global_position = global_position            # Set scene position
		queue_free()                                             # Remove grass
		
