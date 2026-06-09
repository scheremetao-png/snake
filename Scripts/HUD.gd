extends Node2D

var score_label: Label

func _ready():
	score_label = Label.new()
	score_label.position = Vector2(10, 10)
	add_child(score_label)

func update_score(score: int):
	score_label.text = "Score: " + str(score)

func draw():
	# Placeholder for HUD drawing
	pass
