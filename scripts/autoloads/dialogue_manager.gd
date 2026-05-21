extends Node

signal done_typing
signal typed_letter

var dialogue_box: CanvasLayer
var dialogue_label: Label

var type_speed: float = 0.05
var fade_speed: float = 1.4

var typing: bool = false
var click_to_continue: bool = false

var array_of_text: Array = []
var text_array_progress: int = 0

var text_to_type: String = ""
var current_text: String = ""

var letter_progress: int = 0

var letter_timer: Timer
var fade_timer: Timer

func say_section(_text_array: Array, _ignore_current_dialogue: bool = true):
	pass

func say_line(text_array: Array, ignore_current_dialogue: bool = true):
	array_of_text = text_array
	text_array_progress = 0
	
	clear_text()
	say(array_of_text[text_array_progress], ignore_current_dialogue)

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
	dialogue_label.text = current_text
	
	if letter_progress >= text_to_type.length():
		done_typing.emit()
		
		fade_timer = Timer.new()
		fade_timer.wait_time = fade_speed
		fade_timer.timeout.connect(next_text)
		
		add_child(fade_timer)
		fade_timer.start()
		
		return
	
	letter_timer = Timer.new()
	letter_timer.wait_time = type_speed
	
	letter_timer.one_shot = true
	letter_timer.timeout.connect(start_typing)
	
	add_child(letter_timer)
	
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
	
	dialogue_label.text = current_text
	
	letter_progress = 0
	typing = false

func next_text():
	clear_text()
	
	text_array_progress += 1
	if len(array_of_text) <= text_array_progress:
		array_of_text = []
		text_array_progress = 0
		
		return
	
	say(array_of_text[text_array_progress])
	typing = true
