extends Node2D

const TAMANHO_CELULA: int = 32

var body: Array[Vector2]
var head: Vector2
var grid: Grid
var direction: Vector2 = Vector2.RIGHT
var food: Food

func _ready():
	body = [Vector2(5, 5), Vector2(4, 5), Vector2(3, 5)]
	head = body[0]

func move():
	var new_head = head + direction
	if new_head in body or new_head in grid.walls:
		emit_signal("game_over")
	else:
		body.insert(0, new_head)
		if new_head == food.position:
			emit_signal("food_eaten")
		else:
			body.pop_back()
		head = new_head
func grow():
	body.append(body[-1])

func reset():
	body = [Vector2(5, 5), Vector2(4, 5), Vector2(3, 5)]
	head = body[0]

func _on_Food_food_eaten():
	grow()

func draw():
	for block in body:
		draw_rect(Rect2(block * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA)), Color.FOREST_GREEN)
