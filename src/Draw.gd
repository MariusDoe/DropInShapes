extends TextureRect
class_name Draw

func _ready():
	texture = ImageTexture.new()
	clear()

var image: Image
var points: Array

func clear():
	image = Image.new()
	image.create(rect_size.x, rect_size.y, Image.FORMAT_LA8, Image.INTERPOLATE_NEAREST)
	image.fill(Color.white)
	set_image_on_texture()
	points = []
	
func set_image_on_texture():
	(texture as ImageTexture).create_from_image(image)

var last: Vector2
var last_valid = false

signal done_drawing

func _on_Draw_gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if event.button_mask & BUTTON_LEFT:
			var pos = event.position - rect_position
			pos.x += image.get_size().x
			if last_valid:
				draw_line_image(last, pos)
			last = pos
			points.append(pos)
			last_valid = true
	if event is InputEventMouseButton:
		if event.pressed:
			last_valid = false
			clear()
		else:
			emit_signal("done_drawing")

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
	var poly = CollisionPolygon.new()
	poly.polygon.append_array(points)
	return poly



