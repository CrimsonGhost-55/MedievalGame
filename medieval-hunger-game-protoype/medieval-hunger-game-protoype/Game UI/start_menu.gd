class_name StartMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var controls_button = $MarginContainer/HBoxContainer/VBoxContainer/ControlsButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var margin_container = $MarginContainer as MarginContainer
@onready var control_menu = $OptionMenu as ControlsMenu

@onready var start_level = preload("res://Levels/levelLayout.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	control_menu.set_process(true)
	control_menu.visible = true

func on_exit_controls_menu() -> void:
	margin_container.visible = true
	control_menu.visible = false

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	controls_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	control_menu.exit_controls_menu.connect(on_exit_controls_menu)
