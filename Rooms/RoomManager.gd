extends Node2D

onready var panel = $Panel
var scene = preload("res://Player & Items/Heart.tscn")

var playerHealth
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_nodes_in_group('player')[0]
	if player:
		playerHealth = player.health
		var heartLocation = Vector2(0, 0)
		var counter = 0
		while counter < playerHealth:
			var heartSprite = scene.instance()
			heartSprite.position = heartLocation
			add_child(heartSprite)
			heartLocation.x += 24
			counter += 1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player = get_tree().get_nodes_in_group('player')[0]
	var hearts = get_tree().get_nodes_in_group('heart')
	if player:
		playerHealth = player.health
		
		if playerHealth > hearts.size():
			#print("Adding hearts: ",playerHealth, " ", hearts.size())
			var heartLocation = Vector2(hearts.size() * 24, 0)
			var heartAmount = hearts.size()
			while heartAmount < playerHealth:
				var heartSprite = scene.instance()
				heartSprite.position = heartLocation
				add_child(heartSprite)
				heartAmount += 1
				
		if playerHealth < hearts.size() && hearts.size() > 0:
			#print("Removing Hearts: ", playerHealth, " ",hearts.size())
			var amountLoss = hearts.size() - playerHealth
			while amountLoss > 0 && hearts.size() > 0:
				var lostHeart = hearts.pop_back()
				lostHeart.queue_free()
				amountLoss -= 1
