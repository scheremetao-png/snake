extends Node2D

# Configurações do tabuleiro (Grid)
const TAMANHO_CELULA: int = 32  # Cada quadrado do jogo terá 32x32 pixels
const LARGURA_GRID: int = 20   # O tabuleiro terá 20 células de largura
const ALTURA_GRID: int = 15    # O tabuleiro terá 15 células de altura

# Variáveis do jogo
var direcao: Vector2 = Vector2.RIGHT
var cobra: Array[Vector2] = []
var comida: Vector2 = Vector2.ZERO
var score: int = 0
var tempo_passado: float = 0.0
var velocidade_atualizacao: float = 0.15  # A cobra se move a cada 0.15 segundos
var score_label: Label

func _ready():
	randomize()
	reiniciar_jogo()
	update_score()

func reiniciar_jogo():
	score = 0
	direcao = Vector2.RIGHT
	cobra = [Vector2(5, 5), Vector2(4, 5), Vector2(3, 5)]
	gerar_comida()
	
	# Libera a label de pontuação anterior (se houver)
	if score_label:
		score_label.queue_free()
	
# Atualiza a label de pontuação
	score_label = Label.new()
	score_label.text = "Score: " + str(score)
	score_label.position = Vector2(10, 10)
	add_child(score_label)


func gerar_comida():
	var posicao_valida = false
	while not posicao_valida:
		comida = Vector2(randi() % LARGURA_GRID, randi() % ALTURA_GRID)
		if not comida in cobra:
			posicao_valida = true

func _input(event: InputEvent):
	if event.is_action_pressed("ui_right") and direcao != Vector2.LEFT:
		direcao = Vector2.RIGHT
	elif event.is_action_pressed("ui_left") and direcao != Vector2.RIGHT:
		direcao = Vector2.LEFT
	elif event.is_action_pressed("ui_up") and direcao != Vector2.DOWN:
		direcao = Vector2.UP
	elif event.is_action_pressed("ui_down") and direcao != Vector2.UP:
		direcao = Vector2.DOWN

func _process(delta: float):
	tempo_passado += delta
	if tempo_passado >= velocidade_atualizacao:
		tempo_passado = 0.0
		mover_cobra()
		queue_redraw()

func mover_cobra():
	var nova_cabeca = cobra[0] + direcao
	
	if nova_cabeca.x < 0 or nova_cabeca.x >= LARGURA_GRID or nova_cabeca.y < 0 or nova_cabeca.y >= ALTURA_GRID or nova_cabeca in cobra:
		reiniciar_jogo()
		return
	
	cobra.insert(0, nova_cabeca)
	
	if nova_cabeca == comida:
		score += 1
		gerar_comida()
		update_score()
	else:
		cobra.pop_back()

func update_score():
	if score_label:
		score_label.text="Score: " + str(score)

func _draw():
	draw_rect(Rect2(0, 0, LARGURA_GRID * TAMANHO_CELULA, ALTURA_GRID * TAMANHO_CELULA), Color(0.1, 0.1, 0.1))
	
	var rect_comida = Rect2(comida * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA))
	draw_rect(rect_comida, Color.DARK_RED)
	
	for i in range(cobra.size()):
		var rect_bloco = Rect2(cobra[i] * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA))
		if i == 0:
			draw_rect(rect_bloco, Color.FOREST_GREEN)
		else:
			draw_rect(rect_bloco, Color.LIME_GREEN)
