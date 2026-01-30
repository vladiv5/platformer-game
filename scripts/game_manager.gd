extends Node

var score = 0
@onready var score_label = $"Score Label"

func add_point():
	score += 1
	print("+1 coin")
	score_label.text = "Your score is: " + str(score)
