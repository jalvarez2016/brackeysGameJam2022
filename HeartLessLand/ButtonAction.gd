extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



#Starting Scene(2 buttons)
func _on_StartButton_pressed():
	get_tree().change_scene("res://HeartLessLand/World.tscn")
	

func _on_TutorialButton_pressed():
	get_tree().change_scene("res://HeartLessLand/Tutorial.tscn")
	
	
#Tutorial Scene
func _on_ReadyButton_pressed():
	get_tree().change_scene("res://HeartLessLand/World.tscn")

#Game Over Scene
func _on_GameOverButton_pressed():
	get_tree().change_scene("res://HeartLessLand/World.tscn")


func _on_MainMenuButton_pressed():
	pass # Replace with function body.
