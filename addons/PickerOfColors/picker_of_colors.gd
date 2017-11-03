tool
extends Control


var _presets = null
var _custom = null
var _custom_slots = 0
var _cur_picker = null
var _cur_color = null
var _default_step = -1.0
var _customs_path = null
var _presets_path = null

const MODES = {
	PICK = 'pick',
	EDIT = 'edit'
}
var _mode = null

const D = 'd'
const U = 'u'
signal selected(color)
signal customs_changed

var Gui = load('res://addons/PickerOfColors/PickerOfColors.tscn')
var _gui = null

onready var _ctrls = {}

func _ready():
	_gui = Gui.instance()
	add_child(_gui)
	_gui.set_anchor(MARGIN_LEFT, ANCHOR_BEGIN)
	_gui.set_anchor(MARGIN_TOP, ANCHOR_BEGIN)
	_gui.set_anchor(MARGIN_BOTTOM, ANCHOR_END)
	_gui.set_anchor(MARGIN_RIGHT, ANCHOR_END)

	_ctrls = {
		preset_tab = _gui.get_node("Tabs/Preset"),
		custom_tab = _gui.get_node("Tabs/Custom"),

		custom_maker = _gui.get_node("Tabs/Custom/CustomColor"),
		edit_button = _gui.get_node("Tabs/Custom/EditButton"),
		clear_button = _gui.get_node("Tabs/Custom/ClearButton"),
		done_button = _gui.get_node("Tabs/Custom/DoneButton"),
		custom_scroll = _gui.get_node("Tabs/Custom/ScrollContainer"),

		preset_scroll = _gui.get_node("Tabs/Preset/ScrollContainer")
	}

	if(!get_tree().is_editor_hint()):
		_gui.get_node("Tabs").connect('tab_changed', self, '_on_TabContainer_tab_changed')

		_ctrls.custom_maker.connect('value_changed', self, '_on_custom_maker_changed')
		_ctrls.clear_button.connect('pressed', self, '_on_clear_button_pressed')
		_ctrls.edit_button.connect('pressed', self, '_on_edit_button_pressed')
		_ctrls.done_button.connect('pressed', self, '_on_done_button_pressed')

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
		set_mode(MODES.PICK)

func _increase_custom_slots_to(num):
	for i in range(_custom.get_colors().size(), num):
		_custom.add_color(null)
	_custom.update()

func _get_val(dir, x, step=.1):
	var val = 0
	if(dir == U):
		val = step * x
	if(dir == D):
		val = 1 - step * x
	return val

func _is_dir(val):
	return str(val) == U or str(val) == D

# ##########
# Events
# ##########
func _on_preset_selected(color):
	emit_signal('selected', color)
	_custom.set_selected_index(-1)
	_cur_color = color

func _on_custom_selected(color):
	# switch to edit mode when an unset color is picked.
	if(color == null):
		set_mode(MODES.EDIT)
	else:
		_ctrls.custom_maker.set_color(color)

	_ctrls.clear_button.set_disabled(color == null)

	if(_mode == MODES.PICK):
		if(color != null):
			emit_signal('selected', color)
			_presets.set_selected_index(-1)
		_cur_color = color


func _on_clear_button_pressed():
	_custom.set_color(_custom.get_selected_index(), null)
	emit_signal('customs_changed')

func _on_edit_button_pressed():
	set_mode(MODES.EDIT)

func _on_done_button_pressed():
	set_mode(MODES.PICK)

func _on_custom_maker_changed(color):
	_custom.set_color(_custom.get_selected_index(), _ctrls.custom_maker.get_color())
	emit_signal('selected', color)
	emit_signal('customs_changed')
	_ctrls.clear_button.set_disabled(color == null)

func _on_TabContainer_tab_changed( tab ):
	if(tab == 0):
		_cur_picker = _presets
	elif(tab == 1):
		_cur_picker = _custom

# ##########
# Public
# ##########
func get_custom_slots():
	return _custom_slots

func set_custom_slots(custom_slots):
	if(_custom_slots < custom_slots):
		_custom_slots = custom_slots
		_increase_custom_slots_to(_custom_slots)
		emit_signal('customs_changed')

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

func add_range(r, g, b, step=.05):
	var lr = r
	var lg = g
	var lb = b
	var howmany = int(1.0 / step)
	for i in range(howmany + 1.0):
		if(_is_dir(r)):
			lr = _get_val(r, i, step)
		if(_is_dir(b)):
			lb = _get_val(b, i, step)
		if(_is_dir(g)):
			lg = _get_val(g, i, step)
		_presets.add_unique_color(lr, lg, lb)

func load_default_presets(step=.05):
	_default_step = step

	add_range(1, U, 0, step)
	add_range(D, 1, 0, step)
	add_range(0, 1, U, step)
	add_range(0, D, 1, step)
	add_range(U, 0, 1, step)
	add_range(1, 0, D, step)
	# grey
	add_range(U, U, U, step)

	_presets.update()


func set_color(color):
	_presets.set_selected_index(-1)
	_custom.set_selected_index(-1)
	_presets.set_selected_color(color)
	_cur_color = _presets.get_selected_color()
	if(_cur_color == null):
		_custom.set_selected_color(color)
		_cur_color = _custom.get_selected_color()

func get_color():
 	return _cur_color

func load_custom_colors(path):
	_custom.loadit(path)
	_customs_path = path
	if(_custom.get_colors().size() < _custom_slots):
		_increase_custom_slots_to(_custom_slots)
	else:
		_custom_slots = _custom.get_colors().size()

func load_preset_colors(path):
	_presets.loadit(path)
	_presets_path = path

func get_mode():
	return _mode

func set_mode(mode):
	var cs = _ctrls.custom_scroll.get_size()
	if(mode == MODES.EDIT):
		_ctrls.custom_maker.show()
		_ctrls.clear_button.show()
		_ctrls.done_button.show()

		_ctrls.edit_button.hide()
		_ctrls.custom_scroll.set_size(Vector2(cs.x, _ctrls.custom_maker.get_pos().y -10))
	elif(mode == MODES.PICK):
		_ctrls.custom_maker.hide()
		_ctrls.clear_button.hide()
		_ctrls.done_button.hide()

		_ctrls.edit_button.show()
		_ctrls.custom_scroll.set_size(Vector2(cs.x, _ctrls.edit_button.get_pos().y -10))

	_mode = mode

func saveit(path):
	var f = ConfigFile.new()
	f.set_value('settings', 'cell_size', get_cell_size())
	f.set_value('settings', 'default_step', _default_step)
	f.set_value('settings', 'color', get_color())
	f.set_value('settings', 'customs_path', _customs_path)
	f.set_value('settings', 'presets_path', _presets_path)

	if(_custom.get_selected_index() != -1):
		f.set_value('settings', 'color_tab', 'custom')
	elif(_presets.get_selected_index() != -1):
		f.set_value('settings', 'color_tab', 'presets')

	f.save(path)

func loadit(path):
	var f = ConfigFile.new()
	f.load(path)
	set_cell_size(f.get_value('settings', 'cell_size', get_cell_size()))
	_cur_color = f.get_value('settings', 'color')

	_default_step = float(f.get_value('settings', 'default_step', -1.0))
	if(_default_step != -1.0):
		_presets.clear()
		load_default_presets(_default_step)

	_presets_path = f.get_value('settings', 'presets_path')
	if(_presets_path != null):
		load_preset_colors(_presets_path)

	_customs_path = f.get_value('settings', 'customs_path')
	if(_customs_path != null):
		load_custom_colors(_customs_path)

	var tab = f.get_value('settings', 'color_tab', 'none')
	if(tab == 'custom'):
		_custom.set_selected_color(_cur_color)
	elif(tab == 'presets'):
		_presets.set_selected_color(_cur_color)
