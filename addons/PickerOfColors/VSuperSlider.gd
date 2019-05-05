tool
extends VSlider

export var _grabber_color = Color(1, 1, 1, 1)
export var _border_color = Color(0, 0, 0, 1)

func _disp_value():
	$Value.set_text(str(self.value))

func _ready():
	_disp_value()

func _calc_grabber_loc():
	var to_return = Vector2(0, 0)
	var percent = self.value / self.max_value
	to_return.y = get_rect().size.y - get_rect().size.y * percent
	to_return.x = get_rect().size.x / 2

	return to_return

func draw_grabber(pos):
	draw_circle(pos, self.get_rect().size.x/2, _border_color)
	draw_circle(pos, (self.get_rect().size.x/2) * .90, _grabber_color)

func _draw():
	draw_grabber(_calc_grabber_loc())

func get_grabber_color():
	return _grabber_color

func set_grabber_color(color):
	_grabber_color = color

func _on_VSlider_value_changed(value):
	_disp_value()
