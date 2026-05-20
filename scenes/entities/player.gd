extends CharacterBody2D

@onready var standing_collision = $StandingCollisionShape2D
@onready var crouching_collision = $CrouchingCollisionShape2D

var SPEED: int = 100
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
	
	if Input.is_action_just_pressed("crouch"):
		state = States.CROUCHING
	
	if Input.is_action_just_released("crouch"):
		state = States.STANDING
	
	move_and_slide()

func _process(_delta) -> void:
	match state:
		States.STANDING:
			SPEED = 100
			if standing_collision.disabled:
				standing_collision.disabled = false
				crouching_collision.disabled = true
		States.CROUCHING:
			SPEED = 60
			if crouching_collision.disabled:
				crouching_collision.disabled = false
				standing_collision.disabled = true
