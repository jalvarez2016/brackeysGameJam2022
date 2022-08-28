extends Area2D

func _on_Area2D_area_entered(area):
	var enemies = get_tree().get_nodes_in_group('enemy')
	var healths = []
	var zero = false
	if enemies.size() <= 0:
		get_tree().change_scene("res://HeartLessLand/Winning.tscn")
	for enemy in enemies:
		if enemy.health > 0:
			healths.append(enemy.health)
	if healths.size() == 0:
		get_tree().change_scene("res://HeartLessLand/Winning.tscn")
