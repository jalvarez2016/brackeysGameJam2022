extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500
var velocity = Vector2.ZERO
var isSprinting = false
var isAttacking = false
var isEating = false
var money = 0
var lastKnownDirection = 0
var amount = 1
var eatableEnemy
onready var animationPlayer = $AnimationPlayer
onready var attackBox = $AttackBox
onready var damageTimer = $DamageTimer
onready var strongTimer = $StrongTimer
onready var sprite = $Sprite
export(float) var health = 5
export(bool) var isStrong = false

enum {
	ATTACK,
	STAY,
	EATING,
	WALK
}
var state = STAY

func dying(colVel):
	loseHealth(0.5)
	velocity = Vector2(colVel.x, colVel.y).normalized()
	velocity = move_and_slide(velocity * 600)
	flash_damage()

func flash_damage():
	sprite.material.set_shader_param("flash_modifier", 0.7)
	freeze_frame(0.05, 0.05)
	damageTimer.start()

func loseHealth(amount):
	health = health - amount

func gainHealth(amount):
	health = health + amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(health <= 0):
		get_tree().change_scene("res://HeartLessLand/GO.tscn")
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	var enemies = get_tree().get_nodes_in_group('enemy')
	var canEat = false
	for enemy in enemies:
		if enemy.dead:
			canEat = true
			eatableEnemy = enemy
	
	if !isAttacking && !isEating:
		if input_vector != Vector2.ZERO:
			state = WALK
			lastKnownDirection = input_vector.x
		else:
			state = STAY
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
		isAttacking = true
	if Input.is_action_just_pressed("ui_eat") && canEat:
		state = EATING
		isEating = true
	
	match state:
		WALK:
			#animation logic
			if input_vector.x > 0:
				if isStrong :
					animationPlayer.play("WalkRightStrong")
				else:
					animationPlayer.play("WalkRightNormal")
			else:
				if isStrong :
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
				
		ATTACK:
			attackBox.monitorable = true
			attackBox.monitoring = true
			if lastKnownDirection < 0:
				attackBox.position.x = -28
			else:
				attackBox.position.x = 28

			#animation logic
			if isStrong:
				if lastKnownDirection < 0:
					animationPlayer.play("AttackLeftStrong")
				else:
					animationPlayer.play("AttackRightStrong")
			else:
				if lastKnownDirection < 0:
					animationPlayer.play("AttackLeftNormal")
				else:
					animationPlayer.play("AttackRightNormal")
			
		STAY:
			#animation logic
			if lastKnownDirection > 0:
				if isStrong :
					animationPlayer.play("IdleRightStrong")
				else:
					animationPlayer.play("IdleRightNormal")
			else:
				if isStrong :
					animationPlayer.play("IdleLeftStrong")
				else:
					animationPlayer.play("IdleLeftNormal")

			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

		EATING:
			if eatableEnemy:
				if isStrong:
					animationPlayer.play("EatStrong")
				else:
					animationPlayer.play("EatNormal")
				velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)

func _on_DamageTimer_timeout():
	sprite.material.set_shader_param("flash_modifier", 0)

func freeze_frame(timescale, duration):
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale), "timeout")
	Engine.time_scale = 1.0

func _on_StrongTimer_timeout():
	isStrong = false

func _end_Attack():
	isAttacking = false
	attackBox.monitorable = false
	attackBox.monitoring = false

func _end_Eating():
	eatableEnemy.queue_free()
	isStrong = true
	strongTimer.start()
	isEating = false

func on_play_walk_sfc():
	if !$steps.playing:
		$steps.play()

func on_play_attack_sfc():
	if !$sword.playing:
		$sword.play()
		
func on_play_eating_sfc():
	if !$eating.playing:
		$eating.play()
