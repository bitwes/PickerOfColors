extends Control
onready var _ctrls = {
	r_slider = get_node("RSlider"),
	g_slider = get_node("GSlider"),
	b_slider = get_node("BSlider"),
	r_value = $RSlider/RedValue,
	g_value = $GSlider/GreenValue,
	b_value = $BSlider/BlueValue
}
var _color = Color(1,1,1)

signal value_changed(c)

func _ready():
	_ctrls.b_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.r_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.g_slider.connect('value_changed', self, '_on_slider_changed')

	set_selected_color(Color(.5, .5, .5))

func _update_controls():
	_ctrls.b_value.set_text(str(_ctrls.b_slider.get_value()))
	_ctrls.r_value.set_text(str(_ctrls.r_slider.get_value()))
	_ctrls.g_value.set_text(str(_ctrls.g_slider.get_value()))
	update()

func _on_slider_changed(value):
	_color = Color(_ctrls.r_slider.get_value(), _ctrls.g_slider.get_value(), _ctrls.b_slider.get_value())
	emit_signal('value_changed', _color)
	_update_controls()

func set_selected_color(color):
	#return
	_color = color
	_ctrls.b_slider.value = color.b
	_ctrls.r_slider.value = color.r
	_ctrls.g_slider.value = color.g
	_update_controls()

func get_selected_color():
	return _color
