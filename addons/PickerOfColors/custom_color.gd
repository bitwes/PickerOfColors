# #############################################################################
# #############################################################################
extends Control

onready var _ctrls = {
	r_slider = SuperSlider.new(get_node("RSlider")),
	g_slider = SuperSlider.new(get_node("GSlider")),
	b_slider = SuperSlider.new(get_node("BSlider")),
	vslider = SuperSlider.new(get_node('VSlider')),
	radius_slider = SuperSlider.new(get_node('RadiusSlider')),
	ring_slider = SuperSlider.new(get_node('RingWidthSlider'))
}

var ColorWheel = load('res://addons/PickerOfColors/color_wheel.gd')
var _color = Color(1,1,1)
var _color_wheel = ColorWheel.new(20, 10)

signal value_changed(c)

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(200, 200)), _color)

func _ready():
	_ctrls.b_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.r_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.g_slider.connect('value_changed', self, '_on_slider_changed')

	set_selected_color(Color(.5, .5, .5))

	_color_wheel.set_position(Vector2(500, 300))
	add_child(_color_wheel)
	_color_wheel.connect('selected', self, '_on_wheel_selected')

func _on_wheel_selected(color):
	set_selected_color(color)

func _on_slider_changed(value):
	_color = Color(_ctrls.r_slider.get_value(), _ctrls.g_slider.get_value(), _ctrls.b_slider.get_value())
	emit_signal('value_changed', _color)
	update()

func _on_VSlider_value_changed(value):
	_color_wheel.set_value(value)

func _on_RadiusSlider_value_changed(value):
	_color_wheel._radius = value
	_color_wheel._create_points()
	_color_wheel.update()
	
func _on_RingWidthSlider_value_changed(value):
	_color_wheel._ring_width = value
	_color_wheel._create_points()
	_color_wheel.update()

func set_selected_color(color):
	_color = color
	_ctrls.b_slider.slider().value = color.b
	_ctrls.r_slider.slider().value = color.r
	_ctrls.g_slider.slider().value = color.g

func get_selected_color():
	return _color

# #############################################################################
# #############################################################################
class SuperSlider:
	var _slider = null
	
	signal value_changed
	
	func _init(slider = null):
		set_slider(slider)
		slider.get_node('Value').set_text(str(_slider.get_value()))
		
	func set_slider(slider):
		_slider = slider
		_slider.connect('value_changed', self, '_on_value_changed')
		
	func _on_value_changed(value):
		_slider.get_node('Value').set_text(str(value))
		emit_signal('value_changed', value)
	
	func slider():
		return _slider
	
	func get_value():
		return _slider.get_value()
	

	