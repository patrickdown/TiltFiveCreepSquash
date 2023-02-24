extends Node

export (PackedScene) var player_scene
export (PackedScene) var mob_scene

var player: Node


func _ready():
	if not $T5Manager.start_service():
		get_tree().quit()
	randomize()

func start_game():
	player = player_scene.instance()
	add_child(player)
	player.connect("hit", self, "_on_Player_hit")
	$UserInterface/Start.hide()
	$UserInterface/ScoreLabel.reset_score()
	$MobTimer.start()
	

func _on_MobTimer_timeout():
	if not player:
		return
	
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.unit_offset = randf()


	var player_position = player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)

	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing one.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")

func _on_Player_hit():
	player = null
	$MobTimer.stop() # Replace with function body.
	$UserInterface/Start.show()

func _unhandled_input(event):
	if event.is_action_pressed("jump") and $UserInterface/Start.visible:
		start_game()
	elif event.is_action_pressed("quit") and $UserInterface/Start.visible:
		get_tree().quit()

func _on_T5Manager_glasses_available():
	$T5Manager.reserve_glasses()


func _on_T5Manager_glasses_reserved(success):
	get_viewport().arvr = true
