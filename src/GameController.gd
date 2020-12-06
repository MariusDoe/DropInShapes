extends Control

var levels = [
	preload("res://Level1.tscn"),
	preload("res://Level2.tscn"),
	preload("res://Level3.tscn"),
]

var win_screen = preload("res://WinScreen.tscn")

var level: Level = null
var level_index = 0
var camera: CustomCamera
var richtextlabel: RichTextLabel
var draw: Draw
var timer: Timer
var deathtimer: Timer
var main_viewport: CustomViewport

var ballScn = preload("res://Ball.tscn")
var ball: Ball
var ball_anchor: BallAnchor
var anchors: Array

var audioplayer: AudioStreamPlayer = null

func _ready():
	draw = get_node("HBoxContainer/VBoxContainer/DrawPanel/Draw")
	camera = get_node("HBoxContainer/MainViewportContainer/Viewport/Camera2D")
	richtextlabel = get_node("HBoxContainer/VBoxContainer/Panel/RichTextLabel")
	timer = get_node("Timer")
	deathtimer = get_node("Deathtimer")
	main_viewport = get_node("HBoxContainer/MainViewportContainer/Viewport")
	camera.set_main()
	load_level()

func load_level():
	unload_level()
	level = levels[level_index].instance()
	anchors = []
	for child in level.get_children():
		if child is Anchor:
			anchors.append(child)
		if child is BallAnchor:
			ball_anchor = child
		if child is Goal:
			child.connect("goal_reached", self, "_on_Goal_goal_reached")
		if child is Lava:
			child.connect("ball_died", self, "_on_Lava_ball_died")
		if child is AudioStreamPlayer:
			audioplayer = child
	level.remove_child(audioplayer)

	main_viewport.add_child(level)
	ui_update_main_viewport()
	
	richtextlabel.bbcode_enabled = true
	richtextlabel.bbcode_text = level.desc
	
	add_cameras()

	draw.unlock()
	set_timer()
	
	add_child(audioplayer)


func unload_level():
	if level:
		draw.clear()
		clear_added()
		audioplayer.get_parent().remove_child(audioplayer)
		audioplayer.queue_free()
		audioplayer = null
		level.get_parent().remove_child(level)
		level.queue_free()
		level = null

func next_level():
	level_index += 1
	if level_index < len(levels):
		load_level()
	else:
		won()

func won():
	unload_level()
	get_tree().change_scene_to(win_screen)

func reset():
	load_level()

func set_timer():
	timer.start(level.countdown)

func stop_all_timers():
	timer.stop()
	deathtimer.stop()

func _on_Timer_timeout():
	timer.stop()
	drop()
	deathtimer.start(level.deathcountdown)

func _on_Deathtimer_timeout():
	deathtimer.stop()
	reset()

func _on_Draw_done_drawing():
	clear_added()
	add_drawn_to_anchors()

func _on_Goal_goal_reached():
	stop_all_timers()
	next_level()

func _on_Lava_ball_died():
	stop_all_timers()
	reset()

func drop():
	draw.lock()
	var ball = ballScn.instance()
	level.add_child(ball)
	ball.set_position(ball_anchor.position)
	ball_anchor.hide()

var added_drawn_statics = []

func clear_added():
	for added in added_drawn_statics:
		added.queue_free()
	added_drawn_statics = []

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
	level.add_child(node)
	body.position = anchor.position
	body.rotation = anchor.rotation
	body.scale = anchor.get_rect().size / draw.get_size()
	print(body.scale)
	added_drawn_statics.append(node)

func add_cameras():
	var opacity = 1.0
	for anchor in anchors:
		add_camera(anchor, opacity)
		opacity /= 2.0

var cameras = []

func add_camera(anchor: Anchor, opacity):
	var size = draw.get_size()
	var drawPanel = draw.get_parent()
	var viewport_container = ViewportContainer.new()
	var viewport = main_viewport.duplicate(DUPLICATE_SCRIPTS)
	print(viewport.audio_listener_enable_2d)
	viewport_container.add_child(viewport)
	viewport_container.modulate = Color(1, 1, 1, opacity)
	drawPanel.add_child(viewport_container)
	drawPanel.move_child(viewport_container, drawPanel.get_child_count() - 2)
	viewport.world_2d = main_viewport.world_2d
	viewport.size = size
	var cam = camera.duplicate(DUPLICATE_SCRIPTS)
	main_viewport.add_child(cam)
	cam.show_rect(anchor.get_rect(), anchor.rotation, viewport, true)
	cam.custom_viewport = viewport

func ui_update_main_viewport():
	main_viewport.fit_size(level.view_rect.size)
	camera.show_rect(level.view_rect, 0)
