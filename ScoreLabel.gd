extends Label3D

var score = 0

func _on_Mob_squashed():
	score += 1
	text = "Score: %s" % score

func reset_score():
	score = 0
	text = "Score: %s" % score
