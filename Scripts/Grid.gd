extends Node2D

const TAMANHO_CELULA: int = 32
const LARGURA_GRID: int = 20
const ALTURA_GRID: int = 15

var walls: Array[Vector2]
var body: Array[Vector2]

func _ready():
	walls = []
	generate_walls()

func generate_walls():
	for i in range(LARGURA_GRID):
		walls.append(Vector2(i, 0))
		walls.append(Vector2(i, ALTURA_GRID - 1))
	for i in range(ALTURA_GRID):
		walls.append(Vector2(0, i))
		walls.append(Vector2(LARGURA_GRID - 1, i))

func draw():
	draw_rect(Rect2(0, 0, LARGURA_GRID * TAMANHO_CELULA, ALTURA_GRID * TAMANHO_CELULA), Color(0.1, 0.1, 0.1))
	for wall in walls:
		draw_rect(Rect2(wall * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA)), Color(0.5, 0.5, 0.5))

func _process(_delta):
	pass
