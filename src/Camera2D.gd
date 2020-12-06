extends Camera2D

class_name CustomCamera

func set_main():
	make_current()

func show_rect(rect: Rect2, rot: float, parent = get_parent() as Viewport, stretch = false):
	print("should show: ", rect)
	var size = parent.size
	var adjustedRect = rect
	if not stretch:
		if rect.size.x / rect.size.y > size.x / size.y:
			adjustedRect.size.y = rect.size.x * size.y / size.x
			adjustedRect.position.y -= (adjustedRect.size.y - rect.size.y) / 2
		else:
			adjustedRect.size.x = rect.size.y * size.x / size.y
			adjustedRect.position.x -= (adjustedRect.size.x - rect.size.x) / 2
	zoom = adjustedRect.size / size
	position = adjustedRect.position + adjustedRect.size / 2
	rotating = true
	rotation = rot
	print("zoom: ", zoom)
	print("position: ", position)
	print("rotation: ", rotation)
