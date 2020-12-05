extends Camera2D

class_name MainViewportCamera

func _ready():
	make_current()

func show_size(show: Vector2):
	var size = (get_parent() as Viewport).size
	var adjustedShow = show
	var showOffset = Vector2(0, 0)
	if show.x / show.y > size.x / size.y:
		adjustedShow.y = show.x * size.y / size.x
		showOffset.y -= (adjustedShow.y - show.y) / 2
	else:
		adjustedShow.x = show.y * size.x / size.y
		showOffset.x -= (adjustedShow.x - show.x) / 2
	var zoom_xy = adjustedShow.x / size.x
	zoom = Vector2(zoom_xy, zoom_xy)
	position = showOffset / 2 + adjustedShow / 2
