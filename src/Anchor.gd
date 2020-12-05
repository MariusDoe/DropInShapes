extends Node2D

class_name Anchor

func set_size(size):
	$Border.scale = size / $Border.texture.get_size()
