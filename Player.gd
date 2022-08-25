extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500
var velocity = Vector2.ZERO
var IsStrong = false
var isSprinting = false
var money = 0
var lastKnownDirection = 0

onready var animationPlayer = $AnimationPlayer
export(float) var health = 5

func loseHealth(amount):
	health = health - amount

func gainHealth(amount):
	health = health + amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		lastKnownDirection = input_vector.x
		#animation logic
		if input_vector.x > 0:
			if IsStrong :
				animationPlayer.play("WalkRightStrong")
			else:
				animationPlayer.play("WalkRightNormal")
		else:
			if IsStrong :
				animationPlayer.play("WalkLeftStrong")
			else:
				animationPlayer.play("WalkLeftNormal")
			
		
		#sprinting logic
		isSprinting = Input.is_action_pressed("ui_sprint")
		if Input.is_action_just_released("ui_sprint"):
			isSprinting = false
		
		if isSprinting:
			velocity = velocity.move_toward(input_vector * MAX_SPEED * 2, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
		
	else:
		#animation logic
		if lastKnownDirection > 0:
			if IsStrong :
				animationPlayer.play("IdleRightStrong")
			else:
				animationPlayer.play("IdleRightNormal")
		else:
			if IsStrong :
				animationPlayer.play("IdleLeftStrong")
			else:
				animationPlayer.play("IdleLeftNormal")

		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
