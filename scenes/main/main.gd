extends Node2D

@onready var face_1: Node2D = $world/face_1
@onready var face_2: Node2D = $world/face_2
@onready var face_3: Node2D = $world/face_3
@onready var face_4: Node2D = $world/face_4

@onready var move_left_area: Area2D = $move_left
@onready var move_right_area: Area2D = $move_right

func _ready():
	move_left_area.body_entered.connect(func(_a): if _a.is_in_group("player"): GameManager.move_to_left())
	move_right_area.body_entered.connect(func(_a): if _a.is_in_group("player"): GameManager.move_to_right())
