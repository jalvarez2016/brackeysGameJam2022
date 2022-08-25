extends KinematicBody2D

#var state
var knockback = Vector2.ZERO
onready var playerDetectionZone = $PlayerDetectionZone

export(int) var health = 3

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func seekPlayer():
	if playerDetectionZone._can_see_Player():
		print("sees player")
		
func _on_Hurtbox_area_entered(area):
	health -= 1
	if health <= 0:
		#replace queue free with corpse logic
		queue_free()
	knockback = area.knockback_vector * 120
