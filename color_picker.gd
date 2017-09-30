class PickerOfColors:
	extends Control

	var _cell_size = Vector2(30, 30)
	var _row_width = 1
	var _colors = []
	var _selected_index = 30
	var _selected_top_left = Vector2(400, 50)

	func _draw():
		draw_rect(Rect2(Vector2(0,0), get_size()), Color(.5, .5, .5))
		_draw_colors(_colors)

	func _draw_color(x, y, color, selected=false):
		var outline_color = Color(1,1,1)
		var outline_extra = 1
		if(selected):
			outline_color = Color(0, 0, 0)
			outline_extra = 10

		# draw outline
		draw_line(Vector2(x - outline_extra / 2, y), Vector2(x + _cell_size.x + outline_extra / 2, y), outline_color, _cell_size.x + outline_extra)
		# draw color
		draw_line(Vector2(x + 1, y), Vector2(x + _cell_size.x -1, y), color, _cell_size.x -2)

	func _draw_colors(colors):
		var row_width = int(int(get_size().x) / _cell_size.x)
		for i in range(colors.size()):
			var l = _get_color_location(i)
			_draw_color(l.x, l.y, colors[i])

		if(_selected_index != -1):
			var l = _get_color_location(_selected_index)
			_draw_color(l.x, l.y, colors[_selected_index], true)

	func _get_color_location(index):
		var to_return = Vector2(0, 0)
		#var row_width = int(int(get_size().x) / _size)
		to_return.x = fmod(index, _row_width) * _cell_size.x #+ int(_size/2)
		to_return.y = int(index/_row_width) * _cell_size.y + int(_cell_size.y/2)
		return to_return

	func _get_color_at_location(loc):
		var to_return = -1
		var x = int(int(loc.x) / int(_cell_size.x))
		var y = int(int(loc.y) / int(_cell_size.y))
		var idx = x + y * _row_width
		if(idx > -1 and idx < _colors.size()):
			to_return = idx
		return int(to_return)

	func _input_event( ev ):
		if ev.type == InputEvent.MOUSE_BUTTON:
			if ev.button_index == BUTTON_LEFT and ev.pressed:
				if(ev.x < _cell_size.x * _row_width):
					var idx = _get_color_at_location(ev)
					if(idx != -1):
						_selected_index = idx
						update()

	func set_size(s):
		_row_width = int(int(s.x) / _cell_size.x)
		if(_row_width < 1):
			_row_width = 1
		.set_size(s)
		update()

	func add_color(r, g, b):
		_colors.append(Color(r, g, b))

	func add_unique_color(r, g, b):
		if(!_colors.has(Color(r, g, b))):
			add_color(r, g, b)

var _asdf = null

func _ready():
	_asdf = PickerOfColors.new()
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
