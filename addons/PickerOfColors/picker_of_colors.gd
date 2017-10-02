tool
extends Control

var _presets = null
var _custom = null
var _custom_slots = 0
var _cur_picker = null
var _cur_color = null

signal selected

#export (Vector2) var cell_size setget set_cell_size,get_cell_size

onready var _ctrls = {
	preset_tab = get_node("Tabs/Preset"),
	custom_tab = get_node("Tabs/Custom"),
	custom_maker = get_node("Tabs/Custom/CustomColor"),
	set_button = get_node("Tabs/Custom/SetButton"),
	preset_scroll = get_node("Tabs/Preset/ScrollContainer"),
	custom_scroll = get_node("Tabs/Custom/ScrollContainer")
}

func _ready():
	_presets = _ctrls.preset_scroll.get_node("PickerOfColor")
	_presets.set_size(Vector2(_ctrls.preset_tab.get_size().x -15, 300))
	_presets.set_custom_minimum_size(_presets.get_size())
	_presets.connect('selected', self, '_on_preset_selected')
	#_ctrls.preset_scroll.queue_sort()

	_custom = _ctrls.custom_scroll.get_node("PickerOfColor")
	_custom.set_size(Vector2(_ctrls.custom_tab.get_size().x -15, 200))
	_custom.set_custom_minimum_size(_custom.get_size())
	_custom.connect('selected', self, '_on_custom_selected')
	#_ctrls.custom_scroll.queue_sort()

	_cur_picker = _presets

func _on_preset_selected(color):
	emit_signal('selected', color)
	_custom.set_selected_index(-1)
	_cur_color = color

func _on_custom_selected(color):
	if(color != null):
		_ctrls.custom_maker.set_color(color)
		emit_signal('selected', color)
		_presets.set_selected_index(-1)
	_ctrls.set_button.set_disabled(false)
	_cur_color = color

func _on_Set_pressed():
	_custom.set_color(_custom.get_selected_index(), _ctrls.custom_maker.get_color())

func get_custom_slots():
	return _custom_slots

func set_custom_slots(custom_slots):
	_custom_slots = custom_slots
	for i in range(_custom_slots):
		_custom.add_color(null)
	_custom.update()

func get_cell_size():
	return _presets.get_cell_size()

func set_cell_size(cs):
	_presets.set_cell_size(cs)
	_custom.set_cell_size(cs)

func get_presets_picker():
	return _presets

func get_custom_picker():
	return _custom

func get_active_picker():
	return _cur_picker

func _get_val(dir, x, step=.1):
	var val = 0
	if(dir == 'u'):
		val = step * x
	if(dir == 'd'):
		val = 1 - step * x
	return val

func _is_dir(val):
	return str(val) == 'u' or str(val) == 'd'

func add_range(r, g, b, step=.05):
	var lr = r
	var lg = g
	var lb = b

	for i in range(int(1.0/step) + 1):
		if(_is_dir(r)):
			lr = _get_val(r, i, step)
		if(_is_dir(b)):
			lb = _get_val(b, i, step)
		if(_is_dir(g)):
			lg = _get_val(g, i, step)
		_presets.add_unique_color(lr, lg, lb)

func load_default_presets(step=.05):
	var U = 'u'
	var D = 'd'
	add_range(1, U, 0, step)
	add_range(D, 1, 0, step)
	add_range(0, 1, U, step)
	add_range(0, D, 1, step)
	add_range(U, 0, 1, step)
	add_range(1, 0, D, step)

	add_range(U, U, U, step)
	_presets.update()

func _on_TabContainer_tab_changed( tab ):
	if(tab == 0):
		_cur_picker = _presets
	elif(tab == 1):
		_cur_picker = _custom

func get_color():
 	return _cur_color
