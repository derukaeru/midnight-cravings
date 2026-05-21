extends Node

signal ui_opened
signal ui_closed

var ui_open: bool = false

@onready var dialogue_box = load(Registry.UID["dialogue_box"]).instantiate()
@onready var pause_screen = load(Registry.UID["pause_screen"]).instantiate()
var canvas_layer = CanvasLayer.new()

func _ready() -> void:
	add_child(canvas_layer)
	canvas_layer.layer = 5
	
	canvas_layer.add_to_group("global_canvas", true)
	canvas_layer.add_child(pause_screen)
	canvas_layer.add_child(dialogue_box)
	
	pause_screen.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	ui_closed.connect(func(): ui_open = false)
	ui_opened.connect(func(): ui_open = true)
	
	DialogueManager.dialogue_box = dialogue_box
	DialogueManager.dialogue_label = dialogue_box.get_node("dialogue")
	
	DialogueManager.say("testing testing testing testing testing testing testing testing testing testing")

func _process(_d) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			pause_screen.hide()
			Util.mouse_captured()
		else:
			get_tree().paused = true
			pause_screen.show()
			Util.mouse_visible()
