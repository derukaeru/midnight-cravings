extends Node

signal ui_opened
signal ui_closed

signal turn_done

var ui_open: bool = false
var current_face: int = 1

var viewport_width: int = 384
var midground_offset: float = 24.0

var turn_speed: float = 0.6
var turning: bool = false

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
	
	turn_done.connect(func(): turning = false)
	
	DialogueManager.dialogue_box = dialogue_box
	DialogueManager.dialogue_label = dialogue_box.get_node("dialogue")
	
	DialogueManager.say_line(Dialogues.list["intro"]["player"])

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

func turn_tween_left(old_face: Node2D, new_face: Node2D) -> void:
	var tween = get_tree().create_tween()
	
	old_face.scale = Vector2(1.0, 1.0)
	new_face.scale = Vector2(1.0, 1.0)
	
	# midground
	old_face.midground.scale = Vector2(1.0, 1.0)
	old_face.midground.position = Vector2(midground_offset, 0.0)
	tween.tween_property(old_face.midground, "scale:x", 0.0, turn_speed)
	tween.parallel().tween_property(old_face.midground, "position:x", viewport_width - midground_offset, turn_speed)

	new_face.midground.scale = Vector2(0.0, 1.0)
	new_face.midground.position = Vector2(midground_offset, 0.0)
	tween.parallel().tween_property(new_face.midground, "scale:x", 1.0, turn_speed)
	
	
	# player
	tween.parallel().tween_property(Util.get_player(), "position:x", viewport_width - 17, turn_speed)
	
	# at he end
	tween.tween_callback(func(): turn_done.emit())
	tween.parallel().tween_callback(func(): 
		current_face += 1
		if current_face >= 5: current_face = 1
		Util.get_player().can_move = true
	)

func turn_tween_right(old_face, new_face) -> void:
	var tween = get_tree().create_tween()
	
	old_face.midground.scale = Vector2(1.0, 1.0)
	old_face.midground.position = Vector2(midground_offset, 0.0)
	tween.tween_property(old_face.midground, "scale:x", 0.0, turn_speed)
	
	new_face.midground.scale = Vector2(0.0, 1.0)
	new_face.midground.position = Vector2(viewport_width - midground_offset, 0.0)
	
	tween.parallel().tween_property(new_face.midground, "scale:x", 1.0, turn_speed)
	tween.parallel().tween_property(new_face.midground, "position:x", midground_offset, turn_speed)
	tween.parallel().tween_property(Util.get_player(), "position:x", 17, turn_speed)
	
	tween.tween_callback(func(): turn_done.emit())
	tween.parallel().tween_callback(func(): 
		current_face -= 1
		if current_face <= 0: current_face = 4
		Util.get_player().can_move = true
	)


func move_to_left() -> void:
	if turning: return
	turning = true
	
	Util.get_player().can_move = false
	
	match current_face:
		1:
			var face_1 = Util.get_main().face_1
			var face_2 = Util.get_main().face_2
			turn_tween_left(face_1, face_2)
		2: 
			var face_2 = Util.get_main().face_2
			var face_3 = Util.get_main().face_3
			
			turn_tween_left(face_2, face_3)
		3: 
			pass
			var face_3 = Util.get_main().face_3
			var face_4 = Util.get_main().face_4
			
			turn_tween_left(face_3, face_4)
		4: 
			var face_4 = Util.get_main().face_4
			var face_1 = Util.get_main().face_1
			
			turn_tween_left(face_4, face_1)

func move_to_right() -> void:
	if turning: return
	turning = true
	
	Util.get_player().can_move = false
	
	match current_face:
		1:
			var face_1 = Util.get_main().face_1
			var face_4 = Util.get_main().face_4
			turn_tween_right(face_1, face_4)
		2: 
			var face_2 = Util.get_main().face_2
			var face_1 = Util.get_main().face_1
			
			turn_tween_right(face_2, face_1)
		3: 
			pass
			var face_3 = Util.get_main().face_3
			var face_2 = Util.get_main().face_2
			
			turn_tween_right(face_3, face_2)
		4: 
			var face_4 = Util.get_main().face_4
			var face_3 = Util.get_main().face_3
			
			turn_tween_right(face_4, face_3)
