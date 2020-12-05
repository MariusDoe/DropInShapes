extends Camera2D

func _ready():
	make_current()

func _process(delta):
	zoom = Vector2(2, 2)
