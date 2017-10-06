extends "res://addons/gut/test.gd"

var PickerOfColors = load('res://addons/PickerOfColors/picker_of_colors.gd')
var PickerOfColor = load('res://addons/PickerOfColors/picker_of_color.gd')

const TEMP_FILE = 'user://__test_picker_of_color__.txt'
const TEMP_COLOR = 'user://__test_color_file__.txt'

var gr = {
	poc = null,
	other = null
}

func simulate_select(picker, index):
	picker.set_selected_index(index)
	picker.emit_signal('selected', picker.get_colors()[index])
	return picker.get_colors()[index]

func create_color_file():
	var p = PickerOfColor.new()
	p.add_color(.23, .99, .03)
	p.add_color(.1, .23, .45)
	p.add_color(.54, .3, .21)
	p.saveit(TEMP_COLOR)



func save_load():
	gr.poc.saveit(TEMP_FILE)
	gr.other = PickerOfColors.new()
	add_child(gr.other)
	gr.other.loadit(TEMP_FILE)
	gr.other.set_pos(Vector2(0, 400))
	return gr.other

# #############
# Seutp/Teardown
# #############
func setup():
	gr.poc = PickerOfColors.new()
	gr.poc.set_size(Vector2(300, 300))
	add_child(gr.poc)

func teardown():
	gr.poc.queue_free()
	gut.file_delete(TEMP_FILE)
	gut.file_delete(TEMP_COLOR)
	if(gr.other != null):
		remove_child(gr.other)

# #############
# Tests
# #############
func test_can_get_set_custom_slots():
	assert_get_set_methods(gr.poc, 'custom_slots', 0, 10)

func test_can_get_selected_color_when_preset_selected():
	gr.poc.load_default_presets()
	var sel_color = simulate_select(gr.poc.get_presets_picker(), 1)
	assert_eq(gr.poc.get_color(), sel_color)

func test_can_get_selected_color_when_custom_selected():
	gr.poc.set_custom_slots(5)
	gr.poc.get_custom_picker().add_color(1,1,1)
	gr.poc.get_custom_picker().add_color(2,2,2)
	var sel_color = simulate_select(gr.poc.get_custom_picker(), 1)
	assert_eq(gr.poc.get_color(), sel_color)

func test_has_selected_signal():
	assert_has_signal(gr.poc, 'selected')

func test_when_preset_selected_the_selected_signal_is_emitted():
	watch_signals(gr.poc)
	gr.poc.load_default_presets()
	simulate_select(gr.poc.get_presets_picker(), 1)
	assert_signal_emitted(gr.poc, 'selected')

func test_when_custom_selected_the_selected_signal_is_emitted():
	watch_signals(gr.poc)
	gr.poc.get_custom_picker().add_color(1,1,1)
	simulate_select(gr.poc.get_custom_picker(), 0)
	assert_signal_emitted(gr.poc, 'selected')

func test_can_load_custom_colors():
	create_color_file()
	gr.poc.load_custom_colors(TEMP_COLOR)
	assert_eq(gr.poc.get_custom_picker().get_colors().size(), 3)

func test_can_load_preset_colors():
	create_color_file()
	gr.poc.load_preset_colors(TEMP_COLOR)
	assert_eq(gr.poc.get_presets_picker().get_colors().size(), 3)

func test_can_get_set_cell_size():
	assert_get_set_methods(gr.poc, 'cell_size', Vector2(30,30), Vector2(50, 50))

func test_setting_cell_size_sets_custom_cell_size():
	gr.poc.set_cell_size(Vector2(100, 100))
	assert_eq(gr.poc.get_custom_picker().get_cell_size(), Vector2(100, 100))

func test_can_save_load__cell_size():
	gr.poc.set_cell_size(Vector2(100, 100))
	var other = save_load()
	assert_eq(other.get_cell_size(), Vector2(100, 100))

func test_save_load_when_defaults_loaded_reloads_defaults():
	gr.poc.load_default_presets(0.1)
	var num_colors = gr.poc.get_presets_picker().get_colors().size()
	var other = save_load()
	# This fails with 0.1 for some unknown crazy ass float string problem.
	assert_eq(other.get_presets_picker().get_colors().size(), num_colors)

func test_can_save_load_selected_preset():
	gr.poc.load_default_presets(0.5)
	var c = simulate_select(gr.poc.get_presets_picker(), 0)
	var other = save_load()
	assert_eq(other.get_color(), c, 'Color is set')
	assert_eq(other.get_presets_picker().get_selected_color(), c, 'Color is selected')

func test_can_save_load_custom_file():
	create_color_file()
	gr.poc.load_custom_colors(TEMP_COLOR)
	var other = save_load()
	assert_eq(other.get_custom_picker().get_colors().size(), 3)

func test_can_save_load_selected_custom():
	create_color_file()
	gr.poc.load_custom_colors(TEMP_COLOR)
	var c = simulate_select(gr.poc.get_custom_picker(), 0)
	var other = save_load()
	assert_eq(other.get_color(), c, 'Color is set')
	assert_eq(other.get_custom_picker().get_selected_color(), c, 'Color is selected')

func test_can_save_load_preset_file():
	create_color_file()
	gr.poc.load_preset_colors(TEMP_COLOR)
	var other = save_load()
	assert_eq(other.get_presets_picker().get_colors().size(), 3)
