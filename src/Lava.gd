extends Node2D
class_name Lava
signal ball_died

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if (body.is_in_group("Ball")):
		print("Ball Died")
		emit_signal("ball_died")
