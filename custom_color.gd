onready var _ctrls = {
	r_slider = get_node("RSlider"),
	g_slider = get_node("GSlider"),
	b_slider = get_node("BSlider"),
	r_value = get_node("RedValue"),
	g_value = get_node("GreenValue"),
	b_value = get_node("BlueValue")
}
var _color = Color(1,1,1)

func _draw():
	draw_rect(Rect2(0, 0, get_size().x, 30), _color)

func _ready():
	_ctrls.b_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.r_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.g_slider.connect('value_changed', self, '_on_slider_changed')
	
	set_color(Color(.5, .5, .5))

func _update_controls():
	_ctrls.b_value.set_text(str(_ctrls.b_slider.get_value()))
	_ctrls.r_value.set_text(str(_ctrls.r_slider.get_value()))
	_ctrls.g_value.set_text(str(_ctrls.g_slider.get_value()))
	update()
	
func _on_slider_changed(value):
	_color = Color(_ctrls.r_slider.get_value(), _ctrls.g_slider.get_value(), _ctrls.b_slider.get_value())
	_update_controls()
	
func set_color(color):
	_color = color
	_ctrls.b_slider.set_value(color.b)
	_ctrls.r_slider.set_value(color.r)
	_ctrls.g_slider.set_value(color.g)
	_update_controls()
	
func get_color():
	return _color