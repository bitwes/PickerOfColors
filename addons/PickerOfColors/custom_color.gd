# #############################################################################
# #############################################################################
extends Control
tool 
var ColorWheel = load('res://addons/PickerOfColors/color_wheel.gd')
var _color = Color(1,1,1)
var _color_wheel = ColorWheel.new(24, 5)
export var _show_alpha = true setget set_show_alpha, get_show_alpha

signal value_changed(c)

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(240, 240)), _color)

func _ready():
	set_selected_color(Color(.5, .5, .5))

	_color_wheel.set_position(Vector2(120, 120))
	add_child(_color_wheel)
	_color_wheel.connect('selected', self, '_on_wheel_selected')
	_color_wheel.set_index(0)
	_color_wheel.set_value(1)
	$ValueSlider.set_value(1)
	$AlphaSlider.set_value(1)
	update()

func _on_wheel_selected(color):
	color.a = $AlphaSlider.get_value()
	set_selected_color(color)
	$DebugColor.set_text(str(color).replace(',', ', '))
	update()
	emit_signal("value_changed", color)

func set_selected_color(color):
	_color = color
	_color_wheel.set_color(color)
	$ValueSlider.set_value(color.v)
	$AlphaSlider.set_value(color.a)
	update()

func get_selected_color():
	return _color

func _on_ValueSlider_value_changed(value):
	_color_wheel.set_value(value)

func set_show_alpha(should):
	_show_alpha = should
	$HSlider.visible = should
	
func get_show_alpha():
	return _show_alpha

func _on_AlphaSlider_value_changed(value):
	_color.a = value
	update()

## #############################################################################
## #############################################################################
#class SuperSlider:
#	var _slider = null
#
#	signal value_changed
#
#	func _init(slider = null):
#		set_slider(slider)
#		slider.get_node('Value').set_text(str(_slider.get_value()))
#
#	func set_slider(slider):
#		_slider = slider
#		_slider.connect('value_changed', self, '_on_value_changed')
#
#	func _on_value_changed(value):
#		_slider.get_node('Value').set_text(str(value))
#		emit_signal('value_changed', value)
#
#	func slider():
#		return _slider
#
#	func get_value():
#		return _slider.get_value()
#


