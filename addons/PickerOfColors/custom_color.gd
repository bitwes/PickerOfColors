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
var _color_wheel = ColorWheel.new(20, 10)

func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(200, 200)), _color)


signal value_changed(c)

func _ready():
	_ctrls.b_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.r_slider.connect('value_changed', self, '_on_slider_changed')
	_ctrls.g_slider.connect('value_changed', self, '_on_slider_changed')

	set_selected_color(Color(.5, .5, .5))

	_color_wheel.set_position(Vector2(500, 300))
	add_child(_color_wheel)
	_color_wheel.connect('selected', self, '_on_wheel_selected')

func _on_wheel_selected(color):
	print(color)
	set_selected_color(color)

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
	_color = color
	_ctrls.b_slider.value = color.b
	_ctrls.r_slider.value = color.r
	_ctrls.g_slider.value = color.g
	_update_controls()

func get_selected_color():
	return _color

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

class Point:
	var x = 0
	var y = 0
	var h = 0
	var s = 0
	var v = 0
	var color = Color(0, 0, 0)
	
	func _init(x, y, h, s, v):
		self.x = x 
		self.y = y
		self.h = h
		self.s = s
		self.v = v
		self.color = Color(1,1,1).from_hsv(h, s, v)
	
	func get_position():
		return Vector2(x, y)
	
	func set_value(val):
		self.v = val
		self.color = Color(1,1,1).from_hsv(self.h, self.s, self.v)

class ColorWheel:
	extends Node2D

	var _radius = 40.0
	var _points = []
	var _value = 1
	var _ring_width = 5

	signal selected
	func _unhandled_input(event):
		if(event is InputEventMouseButton or event is InputEventScreenTouch):
			if(event.pressed and event.position.distance_to(global_position) <= _radius * _ring_width):
				_select_color_at(event.position - global_position)
	
	func _select_color_at(pos):
		print(pos)
		var found = false
		var i = 0
		while(!found and i < _points.size()):
			var rect = Rect2(_points[i].get_position(),  _pixel_size())
			if(rect.has_point(pos)):
				found = true
				emit_signal('selected', _points[i].color)
			else:
				i += 1
		if(!found):
			print('nope')
		
			
	func _pixel_size():
		return Vector2(_ring_width + 1, _ring_width + 1)
		
	func _init(radius=_radius, ring_width=_ring_width):
		_radius = radius
		_ring_width = ring_width
		_create_points()
	
	func set_value(val):
		for i in range(_points.size()):
			_points[i].set_value(val)
		update()
			
	func _create_points():
		_points = []
		for a in range(0, 360):
			for r in range(_radius):
				var rad = deg2rad(float(a))
				var where = polar2cartesian(r * _ring_width, rad)
				_points.append(Point.new(where.x, where.y,  float(a)/360.0, float(r)/_radius, _value))
	
	func draw_circle_arc(center, radius, angle_from, angle_to, color):
	    var nb_points = 32
	    var points_arc = PoolVector2Array()
	
	    for i in range(nb_points + 1):
	        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
	        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	    for index_point in range(nb_points):
	        draw_line(points_arc[index_point], points_arc[index_point + 1], color, 5)
		
	func _draw():
		for i in range(_points.size()):
			draw_rect(Rect2(_points[i].get_position(), _pixel_size()), _points[i].color)
		draw_circle_arc(Vector2(_ring_width -2, _ring_width -2), _radius * _ring_width + 1, 0, 360, Color(0, 0, 0))
