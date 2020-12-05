extends Control

var main: Node2D
var camera: MainViewportCamera
var draw: Draw
var ballScn = preload("res://Ball.tscn")
var ball: Ball
var ball_anchor: BallAnchor
var anchors: Array

func _ready():
	main = get_node("HBoxContainer/MainViewportContainer/Viewport/Main")
	draw = get_node("HBoxContainer/VBoxContainer/Draw")
	camera = get_node("HBoxContainer/MainViewportContainer/Viewport/Camera2D")
	anchors = []
	var anchor_size = draw.get_size()
	for child in main.get_children():
		if child is Anchor:
			anchors.append(child)
			child.set_size(anchor_size)
		if child is BallAnchor:
			ball_anchor = child
	camera.show_size(Vector2(850, 700))

func _on_Draw_done_drawing():
	add_drawn_to_anchors()
	drop()

func drop():
	var ball = ballScn.instance()
	main.add_child(ball)
	ball.set_position(ball_anchor.position)
	ball_anchor.hide()

func add_drawn_to_anchors():
	for anchor in anchors:
		add_drawn_static(anchor)

func add_drawn_static(anchor):
	var polys = draw.get_collision_polygons(deg2rad(2))
	var img = draw.get_image()
	var node = Node2D.new()
	var body = StaticBody2D.new()
	var sprite = Sprite.new()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	sprite.texture = tex
	for poly in polys:
		body.add_child(poly)
	body.add_child(sprite)
	node.add_child(body)
	main.add_child(node)
	body.position = anchor.position
	body.rotation = anchor.rotation
	body.scale = anchor.scale
