extends Camera2D

class_name CustomCamera

func set_main():
	make_current()

func show_rect(rect: Rect2):
	print("should show: ", rect)
	var size = (get_parent() as Viewport).size
	var adjustedRect = rect
	if rect.size.x / rect.size.y > size.x / size.y:
		adjustedRect.size.y = rect.size.x * size.y / size.x
		adjustedRect.position.y -= (adjustedRect.size.y - rect.size.y) / 2
	else:
		adjustedRect.size.x = rect.size.y * size.x / size.y
		adjustedRect.position.x -= (adjustedRect.size.x - rect.size.x) / 2
	var zoom_xy = adjustedRect.size.x / size.x
	zoom = Vector2(zoom_xy, zoom_xy)
	position = adjustedRect.position + adjustedRect.size / 2
	print("zoom: ", zoom)
	print("position: ", position)
