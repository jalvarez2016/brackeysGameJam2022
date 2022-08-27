extends Area2D

onready var txt = $Text

func _on_EatableArea_area_entered(area):
	var enemyHealth = get_owner().health
	if(area.get_owner().is_in_group("player") && enemyHealth == 0):
		txt.visible = true
		get_owner().dead = true
	pass

func _on_EatableArea_area_exited(area):
	if get_owner():
		txt.visible = false
		get_owner().dead = false
		pass
