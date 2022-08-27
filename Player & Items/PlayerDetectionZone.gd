extends Area2D

var player = null

func _can_see_Player():
	return player != null
	
func _on_PlayerDetectionZone_area_exited(area):
	player = null
	print("exited")

func _on_PlayerDetectionZone_area_entered(area):
	if area.find_parent('Player'):
		player = area.find_parent('Player').position
		#player.is_in_group("player")
		print("entered")

