extends Control

var _cell_size = Vector2(30, 30)
var _row_width = 1
var _colors = []
var _selected_index = -1
var _selected_top_left = Vector2(400, 50)

signal selected

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

func _handle_click(ev):
	if(ev.x < _cell_size.x * _row_width):
		var idx = _get_color_at_location(ev)
		if(idx != -1):
			_selected_index = idx
			emit_signal('selected', _colors[idx])
			update()

func _input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == BUTTON_LEFT and ev.pressed:
			_handle_click(ev)

func set_size(s):
	_row_width = int(int(s.x) / _cell_size.x)
	if(_row_width < 1):
		_row_width = 1
	.set_size(s)
	update()

func add_color(r, g=-1, b=-1):
	if(g == -1):
		_colors.append(r)
	else:
		_colors.append(Color(r, g, b))

func add_unique_color(r, g, b):
	if(!_colors.has(Color(r, g, b))):
		add_color(r, g, b)

func get_cell_size():
	return _cell_size

func set_cell_size(cell_size):
	_cell_size = cell_size

func get_selected_index():
	return _selected_index

func set_selected_index(selected_index):
	if(selected_index < _colors.size()):
		_selected_index = selected_index
		update()

func get_selected_color():
	var c = null
	if(_selected_index != -1):
		c = _colors[_selected_index]
	return c

func set_selected_color(c):
	var idx = _colors.find(c)
	if(idx != -1):
		_selected_index = idx
		update()

func get_colors():
	return _colors

func clear():
	_colors.clear()
	update()

func saveit(path):
	var f = ConfigFile.new()
	f.set_value('colors', 'all_colors', _colors)
	f.save(path)

func loadit(path):
	var f = ConfigFile.new()
	f.load(path)
	_colors = f.get_value('colors', 'all_colors', [])
