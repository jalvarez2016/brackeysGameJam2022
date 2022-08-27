extends KinematicBody2D

#var state
var knockback = Vector2.ZERO
var WALK_SPEED = 80
onready var playerDetectionZone = $PlayerDetectionZone
onready var player = get_node("/root/World/YSort/Player")
onready var sprite = $Sprite

enum {
	ATTACK,
	STAY
}
var state = STAY

export(float) var health = 3
export(bool) var dead = false

func _physics_process(delta):
	_damage_shade()
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	var playerVisible = playerDetectionZone._can_see_Player()
	#print(playerVisible)
	
	#enemy collision dmg logic
	for i in get_slide_count():
		var collision = get_slide_collision(i)
#		if collision.collider.name == "Player":
		var object = collision.collider
		if collision.collider.is_in_group("player")  && state == ATTACK:
#			print("die")
			object.dying(collision.collider_velocity)
		
	if playerVisible && health > 0:
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
				
func _damage_shade():
	sprite.material.set_shader_param("flash_modifier", 1 - (health/3))

func _on_Hurtbox_area_entered(area):
	health -= 1
	if health <= 0:
		#replace queue free with corpse logic
		state = STAY
	knockback = area.knockback_vector * 120
