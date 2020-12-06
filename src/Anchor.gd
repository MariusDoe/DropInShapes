extends Node2D

class_name Anchor

func get_rect():
	var size = $Border.texture.get_size() * $Border.scale * scale
	return Rect2(position - (size / 2), size)
