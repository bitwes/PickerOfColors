extends Button

var _color = null
var _selected = false
var _style_box = null
var _border_color = Color(0, 0, 0)

signal color_picked


func _draw():
	if(_color == null):
		var size = get_size() * .4
		var rect = Rect2((get_size() - size)/2, size)
		draw_rect(rect, Color(0, 0, 0))		

func _init(c=null):
	_color = c
	_style_box = self.get('custom_styles/normal').duplicate()

	set('custom_styles/hover', _style_box)
	set('custom_styles/pressed', _style_box)
	set('custom_styles/focus', _style_box)
	set('custom_styles/disabled', _style_box)
	set('custom_styles/normal', _style_box)


func _ready():
	if(_color):
		set_the_color(_color)

func set_the_color(c):
	_color = c
	if(c != null):
		_style_box.set_bg_color(c)
		_style_box.set_border_color(c)
		set_selected(_selected)
	else:
		_style_box.set_bg_color(Color(1, 1, 1))
		_style_box.set_border_color(Color(1, 1, 1))

func get_the_color():
	return _color

func _on_ColorButton_pressed():
	emit_signal('color_picked', _color)
	set_selected(true)


func is_selected():
	return _selected

func set_selected(is_it):
	_selected = is_it
	if(_selected):
		_style_box.set_border_color(_border_color)
	else:
		if(_color == null):
			_style_box.set_border_color(Color(1, 1, 1))
		else:
			_style_box.set_border_color(_color)

func get_border_color():
	return _border_color

func set_border_color(c):
	_border_color = c
