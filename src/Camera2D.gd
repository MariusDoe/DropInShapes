extends Camera2D

func _ready():
	make_current()

func _process(delta):
	offset.y = 50
	offset.x += 50 * delta
	print(offset)
