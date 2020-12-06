extends TextureRect
class_name Draw

func _ready():
	texture = ImageTexture.new()
	clear()

var image: Image
var points: Array

func get_size():
	return image.get_size()

func clear():
	image = Image.new()
	image.create(rect_size.x, rect_size.y, false, Image.FORMAT_LA8)
	image.fill(Color(0, 0, 0, 0))
	set_image_on_texture()
	points = []

func set_image_on_texture():
	(texture as ImageTexture).create_from_image(image)

var last: Vector2
var last_valid = false
var drawing = false
var locked = false

signal done_drawing

func _on_Draw_gui_input(event: InputEvent):
	if not locked:
		if event is InputEventMouseMotion:
			if event.button_mask & BUTTON_LEFT:
				var pos = event.position
				if pos.x >= 0 and pos.y >= 0 and \
					pos.x < image.get_size().x and pos.y < image.get_size().y:
					if last_valid:
						draw_line_image(last, pos)
					last = pos
					points.append(pos)
					last_valid = true
				else:
					end()
		if event is InputEventMouseButton:
			if event.pressed:
				start()
			else:
				end()

func lock():
	locked = true

func unlock():
	locked = false

func start():
	last_valid = false
	clear()
	drawing = true

func end():
	if drawing:
		emit_signal("done_drawing")
		drawing = false

var color = Color.black

func draw_line_image(from: Vector2, to: Vector2):
	var delta = to - from
	var m = (delta * 1.0).normalized()
	if m.length() == 0:
		return
	var current = from
	var rounded = current.round()
	
	image.lock()
	var size = image.get_size()
	while (rounded.x <= to.x if delta.x > 0 else rounded.x >= to.x) and \
		  (rounded.y <= to.y if delta.y > 0 else rounded.y >= to.y):
			if rounded.x >= 0 and rounded.x <= size.x and \
			   rounded.y >= 0 and rounded.y <= size.y:
				image.set_pixelv(rounded, color)
			current += m
			rounded = current.round()
	image.unlock()
	set_image_on_texture()

func get_collision_polygon():
	var convex = ConvexPolygonShape2D.new()
	convex.set_point_cloud(PoolVector2Array(points))
	var poly = CollisionPolygon2D.new()
	poly.polygon = convex.points
	return poly

func get_angle(a: Vector2, b: Vector2):
	return (b - a).angle()

func get_poly(a, b):
	var poly = CollisionPolygon2D.new()
	var offset = image.get_size() / 2
	poly.polygon = PoolVector2Array([a - offset, b - offset])
	return poly

func get_collision_polygons(min_angle):
	if len(points) <= 1:
		return []
	var polys = []
	var a = points[0]
	var i = 0
	var break_outer = false
	while not break_outer:
		i += 1
		if i >= len(points):
			break_outer = true
			break
		var b = points[i]
		var orig_angle = get_angle(a, b)
		if b == a:
			continue
		while true:
			i += 1
			if i >= len(points):
				break_outer = true
				break
			var c = points[i]
			if abs(orig_angle - get_angle(c, a)) >= min_angle:
				polys.append(get_poly(a, b))
				a = b
				break
	var last_point = points[len(points) - 1]
	if a != last_point:
		polys.append(get_poly(a, last_point))
	return polys

func get_image():
	return image
