extends Viewport

class_name CustomViewport

func fit_size(target: Vector2):
	var parent_size = (get_parent() as ViewportContainer).rect_size
	size = parent_size
	if target.x / target.y > parent_size.x / parent_size.y:
		size.y = size.x * target.y / target.x
	else:
		size.x = size.y * target.x / target.y
