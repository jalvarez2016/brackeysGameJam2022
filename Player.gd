extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 120
const FRICTION = 500
var velocity = Vector2.ZERO
var SPRINTSPEED = 1


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Sprinting needs fixing
		if Input.is_action_pressed("ui_sprint"):
			SPRINTSPEED = 2
			print("sprinting!!")
		velocity = velocity.move_toward(input_vector * MAX_SPEED * SPRINTSPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
