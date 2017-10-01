
var _presets = null
var _custom = null
var _custom_slots = 0

signal selected

onready var _ctrls = {
	preset_tab = get_node("Preset"),
	custom_tab = get_node("Custom"),
	custom_maker = get_node("Custom/CustomColor")
}

func _ready():
	_presets = load('res://picker_of_color.gd').new()
	_ctrls.preset_tab.add_child(_presets)
	_presets.set_size(_ctrls.preset_tab.get_size())
	_presets.connect('selected', self, '_on_preset_selected')

	_custom = load('res://picker_of_color.gd').new()
	_custom.set_size(_ctrls.custom_tab.get_size() - Vector2(0, _ctrls.custom_maker.get_pos().y + 50))
	get_node("Custom").add_child(_custom)

func _on_preset_selected(color):
	emit_signal('selected', color)


func get_custom_slots():
	return _custom_slots

func set_custom_slots(custom_slots):
	_custom_slots = custom_slots
	for i in range(_custom_slots):
		_custom.add_color(null)
	_custom.update()












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
		_presets.add_unique_color(lr, lg, lb)

func load_default_presets():
	# red
	add_range(1, 0, -1)
	add_range(.75, 0, -1)
	add_range(.5, 0, -1)
	add_range(.25, 0, -1)
	add_range(1, -1, 0)

	# yellow
	add_range(1, 1, -1)
	add_range(.75, .75, -1)
	add_range(.5, .5, -1)


	# green
	add_range(0, 1, -1)
	add_range(0, .75, -1)
	add_range(0, .5, -1)

	# blue
	add_range(0, -1, 1)
	add_range(-1, -1, .75)
	add_range(.5, -1, .5)

	# add_range(-1, 0, 1)
	# add_range(-1, -1, 1)


	# ?
	# add_range(-1, 1, 0)
	# add_range(-1, 1, -1)
	#
	#
	# add_range(1, -1, 1)
	# add_range(1, -1, -1)
	# add_range(1, -1, 1)
	#
	#
	#
	# add_range(-1, -1, -1)

	_presets.add_unique_color(1,1,1)
	_presets.add_unique_color(0, 0, 0)
	_presets.add_color(null)
	_presets.add_color(null)
	_presets.update()
