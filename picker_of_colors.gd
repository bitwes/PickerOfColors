
var _asdf = null

func _ready():
	_asdf = load('res://picker_of_color.gd').new()
	add_child(_asdf)
	_asdf.set_size(Vector2(315, 1000))
	_init_colors()
	_asdf.update()

func add_range(r, g, b):
	var lr = r
	var lg = g
	var lb = b

	var v = 0
	for i in range(10):
		v = .1 * i
		if(r == -1):
			lr = v
		if(b == -1):
			lb = v
		if(g == -1):
			lg = v
		_asdf.add_unique_color(lr, lg, lb)

func _init_colors():
	#_colors.clear()
	add_range(1, 0, -1)
	add_range(1, 1, -1)

	add_range(1, -1, 0)
	add_range(1, -1, 1)

	add_range(1, -1, -1)


	add_range(1, -1, 1)

	add_range(0, 1, -1)
	add_range(-1, 1, 0)
	add_range(-1, 1, -1)

	add_range(0, -1, 1)
	add_range(-1, 0, 1)
	add_range(-1, -1, 1)

	add_range(-1, -1, -1)

	_asdf.add_unique_color(1,1,1)
	_asdf.add_unique_color(0, 0, 0)
