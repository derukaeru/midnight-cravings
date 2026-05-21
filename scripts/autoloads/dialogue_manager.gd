extends Node

signal done_typing
signal typed_letter

var dialogue_label: Label

var type_speed = 0.05
var typing: bool = false
var text_to_type: String = ""
var current_text: String = ""
var letter_progress: int = 0

var letter_timer: Timer
var fade_timer: Timer

func  _ready() -> void:
	while dialogue_label == null:
		
	
	dialogue_label.text = ""

func say(text: String, ignore_current_dialogue: bool = true) -> void:
	if not ignore_current_dialogue: return
	
	clear_text()
	
	text_to_type = text
	typing = true
	
	start_typing()

func start_typing() -> void:
	if not typing: return
	
	letter_progress += 1
	current_text = text_to_type.substr(0, letter_progress)
	
	if letter_progress >= text_to_type.length():
		done_typing.emit()
		
		fade_timer = Timer.new()
		fade_timer.timeout.connect(clear_text)
		
		return
	
	letter_timer = Timer.new()
	letter_timer.wait_time = type_speed
	
	letter_timer.one_shot = true
	letter_timer.timeout.connect(start_typing)
	
	letter_timer.start()
	typed_letter.emit()

func clear_text() -> void:
	if letter_timer:
		letter_timer.stop()
		letter_timer = null
	
	if fade_timer:
		fade_timer.stop()
		fade_timer = null
	
	text_to_type = ""
	current_text = ""
	
	letter_progress = 0
	typing = false
