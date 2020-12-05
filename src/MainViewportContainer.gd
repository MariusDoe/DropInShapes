extends ViewportContainer

func _draw():
	get_node("Viewport").size = rect_size
