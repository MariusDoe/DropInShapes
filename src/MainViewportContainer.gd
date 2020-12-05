extends ViewportContainer

func _ready():
	get_node("Viewport").size = rect_size
