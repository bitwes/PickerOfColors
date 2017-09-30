class PickerOfColors:
	extends CanvasItem

	# pass
	var _size = 30
	var _row_width = 10
	var _colors = []
	var _selected_index = -1
	var _selected_top_left = Vector2(400, 50)
	
	func _draw():
		_draw_colors(_colors)
	
	func _draw_color(x, y, color, selected=false):
		var outline_color = Color(1,1,1)
		var outline_extra = 0
		if(selected):
			outline_color = Color(0, 0, 0)
			outline_extra = 3
			
		# draw outline
		draw_line(Vector2(x, y), Vector2(x + _size, y), outline_color, _size + outline_extra)
		# draw color
		draw_line(Vector2(x + 1, y), Vector2(x + _size -1, y), color, _size -2)
		
	func _draw_colors(colors):
		var row = 0
		var col = 0
		for i in range(colors.size()):
			_draw_color(col * _size, row * _size + _size / 2, colors[i], _selected_index == i)
			col += 1
			if(col == _row_width):
				row += 1
				col = 0
		if(_selected_index != -1):
			_draw_color(_selected_top_left.x, _selected_top_left.y, colors[_selected_index])
	
	func add_color(r, g, b):
		_colors.append(Color(r, g, b))
	
	func add_unique_color(r, g, b):
		if(!_colors.has(Color(r, g, b))):
			add_color(r, g, b)
	
	func _on_Picker_input_event( ev ):
		if ev.type == InputEvent.MOUSE_BUTTON:
			if ev.button_index == BUTTON_LEFT and ev.pressed:	
				var x = ev.x / _size
				var y = ev.y / _size
				var idx = x + y * _row_width
				if(idx > -1 and idx < _colors.size()):
					_selected_index = idx
				update()



var _colors = null

func ready():
	_colors = PickerOfColors.new()
	add_child(_colors)
	_init_colors()
	_colors.update()

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
		add_unique_color(lr, lg, lb)

func _init_colors():
	#_colors.clear()
	_colors.add_range(1, 0, -1)
	_colors.add_range(1, 1, -1)
	
	_colors.add_range(1, -1, 0)
	_colors.add_range(1, -1, 1)

	_colors.add_range(1, -1, -1)
	
	
	_colors.add_range(1, -1, 1)
	
	_colors.add_range(0, 1, -1)
	_colors.add_range(-1, 1, 0)
	_colors.add_range(-1, 1, -1)
	
	_colors.add_range(0, -1, 1)
	_colors.add_range(-1, 0, 1)
	_colors.add_range(-1, -1, 1)
	
	_colors.add_range(-1, -1, -1)
	
	_colors.add_unique_color(1,1,1)
	_colors.add_unique_color(0, 0, 0)
	

			
