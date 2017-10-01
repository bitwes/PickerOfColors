var _presets = null
var _custom = null
var _custom_slots = 0

signal selected

onready var _ctrls = {
	preset_tab = get_node("Preset"),
	custom_tab = get_node("Custom"),
	custom_maker = get_node("Custom/CustomColor"),
	set_button = get_node("Custom/SetButton"),
	preset_scroll = get_node("Preset/ScrollContainer"),
	custom_scroll = get_node("Custom/ScrollContainer")
}

func _ready():
	_presets = _ctrls.preset_scroll.get_node("PickerOfColor")
	_ctrls.preset_scroll.add_child(_presets)
	_presets.set_size(Vector2(_ctrls.preset_tab.get_size().x -15, 500))
	_presets.set_custom_minimum_size(_presets.get_size())
	_presets.connect('selected', self, '_on_preset_selected')
	_ctrls.preset_scroll.queue_sort()

	_custom = _ctrls.custom_scroll.get_node("PickerOfColor")
	_custom.set_size(_ctrls.custom_tab.get_size() - Vector2(0, _ctrls.custom_maker.get_pos().y + 50))
	_ctrls.custom_tab.add_child(_custom)
	_custom.connect('selected', self, '_on_custom_selected')
	_ctrls.custom_scroll.queue_sort()

func _on_preset_selected(color):
	emit_signal('selected', color)

func _on_custom_selected(color):
	if(color != null):
		_ctrls.custom_maker.set_color(color)
		emit_signal('selected', color)
	_ctrls.set_button.set_disabled(false)

func _on_Set_pressed():
	_custom.set_color(_custom.get_selected_index(), _ctrls.custom_maker.get_color())

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

	# grey
	add_range(-1, -1, -1)

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

	_presets.add_unique_color(1,1,1)
	_presets.add_unique_color(0, 0, 0)
	_presets.update()
