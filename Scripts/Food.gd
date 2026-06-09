extends Node2D

const TAMANHO_CELULA: int = 32

var snake_position: Vector2
var grid: Grid

func _ready():
	generate()

func generate():
	var posicao_valida = false
	while not posicao_valida:
		snake_position = Vector2(randi() % grid.LARGURA_GRID, randi() % grid.ALTURA_GRID)
		if not snake_position in grid.walls and not snake_position in grid.body:
			posicao_valida = true

func draw():
	draw_rect(Rect2(snake_position * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA)), Color.DARK_RED)
	
func _process(_delta):
	pass
