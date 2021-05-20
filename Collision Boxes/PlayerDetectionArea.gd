extends Area2D

var player = null


func _physics_process(delta):
	pass

func _on_PlayerDetectionArea_body_entered(body):
	player = body

func _on_PlayerDetectionArea_body_exited(body):
	player = null
	
func can_see_player():
	return player != null
