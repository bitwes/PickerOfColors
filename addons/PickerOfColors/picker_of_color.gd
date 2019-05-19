tool
extends GridContainer

var ColorButton = load('res://addons/PickerOfColors/ColorButton.tscn')
var _colors = []
var _buttons = []
var _selected_index = -1
var _selected_button = null

export(Vector2) var _cell_size = Vector2(30, 30) setget set_cell_size, get_cell_size

signal selected(color)

func _set_selected_button(button):
	if(_selected_button != null):
		_selected_button.set_selected(false)
	_selected_button = button
	button.set_selected(true)

func _on_color_button_picked(color, button, index):
	_set_selected_button(button)
	_selected_index = index
	emit_signal('selected', color)

func _ready():
	update()
	set_process_input(true)

func _is_in_editor():
	var to_return = false

	if(get_parent() and Engine.is_editor_hint()):
		to_return = true
	return to_return

func set_size(s):
	.set_size(s)
	# if the minimum size is set in the editor then you can never make it
	# smaller so we don't set it when in the editor.
	update()
	if(!_is_in_editor()):
		# The minimum size has to be set so that the scroll bars on the scroll
		# container work as expected.  This has the side effect that you
		# probably cannot make it smaller at runtime.
		set_custom_minimum_size(get_size())

func add_color(r, g=-1, b=-1):
	var c = r
	if(g != -1):
		c = Color(r, g, b)
	_colors.append(c)

	var button = ColorButton.instance()
	_buttons.append(button)

	button.set_the_color(c)
	button.set_custom_minimum_size(_cell_size)
	add_child(button)
	button.connect('color_picked', self, '_on_color_button_picked', [button, _colors.size() -1])

	columns = max(int(self.get_size().x / _cell_size.x), 1.0)
	set_columns(columns)
	update()

func add_unique_color(r, g, b):
	if(!_colors.has(Color(r, g, b))):
		add_color(r, g, b)

func get_cell_size():
	return _cell_size

func set_cell_size(cell_size):
	_cell_size = cell_size
	var btns = get_children()
	for i in range(btns.size()):
		btns[i].set_custom_minimum_size(_cell_size)
	if(get_parent()):
		columns = int(get_parent().get_size().x / _cell_size.x)
		set_columns(columns)

func get_selected_index():
	return _selected_index

func set_selected_index(selected_index):
	if(selected_index < _colors.size() and selected_index > 0):
		_set_selected_button(_buttons[selected_index])
		_selected_index = selected_index
	elif(selected_index == -1):
		if(_selected_index != -1):
			_buttons[_selected_index].set_selected(false)
		selected_index = -1
		#update()

func get_selected_color():
	var c = null
	if(_selected_index != -1):
		c = _colors[_selected_index]
	return c

func set_selected_color(c):
	var idx = _colors.find(c)
	if(idx != -1):
		_selected_index = idx
		_set_selected_button(_buttons[idx])
		update()

func get_colors():
	return _colors

func clear():
	_colors.clear()
	for i in range(_buttons.size()):
		remove_child(_buttons[i])
	_buttons.clear()
	update()

func saveit(path):
	var f = ConfigFile.new()
	f.set_value('colors', 'all_colors', _colors)
	f.save(path)

func loadit(path):
	var f = ConfigFile.new()
	f.load(path)
	clear()
	var colors = f.get_value('colors', 'all_colors', [])
	for i in range(colors.size()):
		add_color(colors[i])

func set_selected_button_color(c):
	var idx = _buttons.find(_selected_button)
	if(idx != -1):
		_selected_button.set_the_color(c)
		_colors[idx] = c
