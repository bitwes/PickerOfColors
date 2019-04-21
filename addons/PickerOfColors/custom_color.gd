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

	var cw = ColorWheel.new()
	cw.set_position(Vector2(300, 300))
	add_child(cw)

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









	# for (let x = -radius; x < radius; x++) {
    #    for (let y = -radius; y < radius; y++) {
    #      let distance = Math.sqrt(x*x + y*y);
	#
    #      if (distance > radius) {
    #        // skip all (x,y) coordinates that are outside of the circle
    #        continue;
    #      }
	#
    #      // Figure out the starting index of this pixel in the image data array.
    #      let rowLength = 2*radius;
    #      let adjustedX = x + radius; // convert x from [-50, 50] to [0, 100] (the coordinates of the image data array)
    #      let adjustedY = y + radius; // convert y from [-50, 50] to [0, 100] (the coordinates of the image data array)
    #      let pixelWidth = 4; // each pixel requires 4 slots in the data array
    #      let index = (adjustedX + (adjustedY * rowLength)) * pixelWidth;
    #      data[index] = red;
    #      data[index+1] = green;
    #      data[index+2] = blue;
    #      data[index+3] = alpha;
    #    }









class ColorWheel:
	extends Node2D
	var _radius = 50


	func _draw():

		for x in range(_radius * -1, _radius):
			for y in range(_radius * -1, _radius):
				var dist = sqrt(x * x + y * y)
				draw_circle(Vector2(0, 0), 1, Color(0, 1, 1))
