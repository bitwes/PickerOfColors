extends Control

var _cell_size = Vector2(30, 30)
var _num_per_row = 1
var _colors = []
var _selected_index = -1
var _selected_top_left = Vector2(400, 50)

signal selected

func _draw():
	#draw_rect(Rect2(Vector2(0,0), get_size()), Color(.5, .5, .5))
	_draw_colors(_colors)

func _draw_color(x, y, color, selected=false):
	var outline_color = Color(1,1,1)
	var outline_extra = 0
	if(selected):
		outline_color = Color(0, 0, 0)
		outline_extra = 5

	# draw outline
	draw_rect(Rect2(x - outline_extra, y - outline_extra, _cell_size.x + outline_extra * 2, _cell_size.y + outline_extra * 2), outline_color)
	# draw color
	if(color != null):
		draw_rect(Rect2(x + 1, y + 1, _cell_size.x -1, _cell_size.y -1), color)
	else:
		# draw a black box with a white X in it.
		var tl = Vector2(x + 1, y + 1)
		var br = Vector2(x + _cell_size.x -1, y +_cell_size.y -1)
		draw_rect(Rect2(tl, Vector2(_cell_size.x -1, _cell_size.y -1)), Color(0,0,0))
		draw_line(tl, br, Color(1,1,1))
		draw_line(Vector2(br.x, tl.y), Vector2(tl.x, br.y), Color(1,1,1))

func _draw_colors(colors):
	var row_width = int(int(get_size().x) / _cell_size.x)
	for i in range(colors.size()):
		var l = _get_color_location(i)
		_draw_color(l.x, l.y, colors[i])

	if(_selected_index != -1 and _selected_index < colors.size()):
		var l = _get_color_location(_selected_index)
		_draw_color(l.x, l.y, colors[_selected_index], true)

func _get_color_location(index):
	var to_return = Vector2(0, 0)
	to_return.x = fmod(index, _num_per_row) * _cell_size.x #+ int(_size/2)
	to_return.y = int(index/_num_per_row) * _cell_size.y
	return to_return

func _get_color_at_location(loc):
	var to_return = -1
	var x = int(int(loc.x) / int(_cell_size.x))
	var y = int(int(loc.y) / int(_cell_size.y))
	var idx = x + y * _num_per_row
	if(idx > -1 and idx < _colors.size()):
		to_return = idx
	return int(to_return)

func _handle_click(ev):
	if(ev.x < _cell_size.x * _num_per_row):
		var idx = _get_color_at_location(ev)
		if(idx != -1):
			_selected_index = idx
			emit_signal('selected', _colors[idx])
			update()

func _input_event( ev ):
	if ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == BUTTON_LEFT and ev.pressed:
			_handle_click(ev)

func _recalc_num_per_row():
	_num_per_row = int(int(get_size().x) / _cell_size.x)
	if(_num_per_row < 1):
		_num_per_row = 1
	update()

func _fit_vertically():
	var new_y = int(int(_colors.size()) / _num_per_row) * _cell_size.y + _cell_size.y
	if(get_size().y < new_y):
		set_size(Vector2(get_size().x, new_y))
	update()

func set_size(s):
	.set_size(s)
	_recalc_num_per_row()
	set_custom_minimum_size(get_size())
	# if(get_parent() and get_parent().has_method('queue_sort')):
	# 	get_parent().queue_sort()
	update()

func add_color(r, g=-1, b=-1):
	if(g == -1):
		_colors.append(r)
	else:
		_colors.append(Color(r, g, b))
	_fit_vertically()

func add_unique_color(r, g, b):
	if(!_colors.has(Color(r, g, b))):
		add_color(r, g, b)

func get_cell_size():
	return _cell_size

func set_cell_size(cell_size):
	_cell_size = cell_size
	_recalc_num_per_row()
	_fit_vertically()

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

func set_color(index, color):
	_colors[index] = color
	update()

func clear():
	_colors.clear()
	update()

func saveit(path):
	var f = ConfigFile.new()
	f.set_value('colors', 'all_colors', _colors)
	f.set_value('colors', 'selected', _selected_index)
	f.save(path)

func loadit(path):
	var f = ConfigFile.new()
	f.load(path)
	_colors = f.get_value('colors', 'all_colors', [])
	_selected_index = f.get_value('colors', 'selected', -1)
