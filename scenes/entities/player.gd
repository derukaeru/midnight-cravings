extends CharacterBody2D

const SPEED: int = 100
enum States {
	CROUCHING,
	STANDING
}
var state: States = States.STANDING

func _physics_process(_delta) -> void:
	var dir = Input.get_axis("move_left", "move_right")
	if dir:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _process(_delta):
	pass
