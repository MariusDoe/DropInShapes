extends Control

var main: Node2D
var camera: MainViewportCamera
var draw: Draw

func _ready():
	main = get_node("VBoxContainer/MainViewportContainer/Viewport/Main")
	draw = get_node("VBoxContainer/HBoxContainer/Draw")
	camera = get_node("VBoxContainer/MainViewportContainer/Viewport/Camera2D")
	camera.show_size(Vector2(850, 700))

func _on_Draw_done_drawing():
	add_drawn_static(Vector2(500, 500))

func add_drawn_static(position):
	var poly = draw.get_collision_polygon()
	var node = Node2D.new()
	var body = StaticBody2D.new()
	body.add_child(poly)
	node.add_child(body)
	main.add_child(node)
	body.position = position
