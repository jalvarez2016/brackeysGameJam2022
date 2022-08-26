extends KinematicBody2D

#var state
var knockback = Vector2.ZERO
var WALK_SPEED = 80
onready var playerDetectionZone = $PlayerDetectionZone
onready var player = get_node("/root/World/YSort/Player")

enum {
	ATTACK,
	STAY
}
var state = STAY

export(int) var health = 3

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	var playerVisible = playerDetectionZone._can_see_Player()
	#print(playerVisible)
	if playerVisible && state != ATTACK:
		state = ATTACK
	else:
		state = STAY
		
	if player:
		match state:
			ATTACK:
				var direction = (player.position - position).normalized()
				direction = move_and_slide(direction * WALK_SPEED)
				pass
			STAY:
				pass

func _on_Hurtbox_area_entered(area):
	health -= 1
	if health <= 0:
		#replace queue free with corpse logic
		queue_free()
	knockback = area.knockback_vector * 120
