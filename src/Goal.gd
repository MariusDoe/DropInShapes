extends Node2D
class_name Goal
signal goal_reached

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if (body.is_in_group("Ball")):
		$Timer.start()

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if (body.is_in_group("Ball")):
		$Timer.stop()

func _on_Timer_timeout() -> void:
	print("Goal Reached")
	emit_signal("goal_reached")
