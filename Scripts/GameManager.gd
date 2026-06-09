extends Node2D

var grid: Grid
var snake: Snake
var food: Food
var hud: HUD
var score: int = 0

func _ready():
	grid = $Grid
	snake = $Snake
	food = $Food
	hud = $HUD
	update_score()
	get_tree().create_timer(0.15, callback=self, function="update_game")

func update_game():
	snake.move()
	check_collision()
	update_score()
	queue_redraw()

func check_collision():
	if snake.head in grid.walls or snake.head in snake.body:
		emit_signal("game_over")
	else:
		snake.move()
		check_collision()
		update_score()
		queue_redraw()
		reset_game()

func reset_game():
	snake.reset()
	food.generate()
	update_score()

func update_score():
	hud.update_score(score)
