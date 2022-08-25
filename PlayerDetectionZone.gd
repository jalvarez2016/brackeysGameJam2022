extends Area2D

var player = null

func _can_see_Player():
	player != null

func _on_PlayerDetectionZone_area_exited(area):
	player = null

func _on_PlayerDetectionZone_area_entered(area):
	print('entered area')
	player = area
