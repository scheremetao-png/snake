extends Node2D

# Configurações do tabuleiro (Grid)
const TAMANHO_CELULA : int = 32  # Cada quadrado do jogo terá 32x32 pixels
const LARGURA_GRID : int = 20   # O tabuleiro terá 20 células de largura
const ALTURA_GRID : int = 15    # O tabuleiro terá 15 células de altura

# Variáveis do jogo (A sintaxe é idêntica ao Python)
var direcao_atual_movida : Vector2 = Vector2.RIGHT # Nova trava de segurança
var cobra : Array[Vector2] = [] # Lista de coordenadas que formam o corpo da cobra
var direcao : Vector2 = Vector2.RIGHT # Direção inicial (andando para a direita)
var comida : Vector2 = Vector2.ZERO # Posição atual da comida
var score : int = 0

# Controle de tempo (Velocidade da cobra)
var tempo_passado : float = 0.0
var velocidade_atualizacao : float = 0.15 # A cobra se move a cada 0.15 segundos

func _ready() -> void:
	randomize() # Inicializa o gerador de números aleatórios
	reiniciar_jogo()

func reiniciar_jogo() -> void:
	score = 0
	direcao = Vector2.RIGHT
	direcao_atual_movida = Vector2.RIGHT # Reseta a trava
	cobra = [
		Vector2(5, 5),
		Vector2(4, 5),
		Vector2(3, 5)
	]
	
	gerar_comida()

func gerar_comida() -> void:
	# Escolhe uma posição aleatória dentro dos limites do grid
	var posicao_valida = false
	while not posicao_valida:
		comida = Vector2(
			randi() % LARGURA_GRID,
			randi() % ALTURA_GRID
		)
		# Garante que a comida não vai nascer em cima da cobra
		if not comida in cobra:
			posicao_valida = true

func _input(event: InputEvent) -> void:
	# Agora comparamos com 'direcao_atual_movida' para evitar o bug do clique rápido
	if event.is_action_pressed("ui_right") and direcao_atual_movida != Vector2.LEFT:
		direcao = Vector2.RIGHT
	elif event.is_action_pressed("ui_left") and direcao_atual_movida != Vector2.RIGHT:
		direcao = Vector2.LEFT
	elif event.is_action_pressed("ui_up") and direcao_atual_movida != Vector2.DOWN:
		direcao = Vector2.UP
	elif event.is_action_pressed("ui_down") and direcao_atual_movida != Vector2.UP:
		direcao = Vector2.DOWN

func _process(delta: float) -> void:
	# O _process roda a cada frame. Usamos delta para contar o tempo real.
	tempo_passado += delta
	if tempo_passado >= velocidade_atualizacao:
		tempo_passado = 0.0
		mover_cobra()
		queue_redraw() # Avisa a Godot para redesenhar a tela

func mover_cobra() -> void:
	# Atualiza a trava: a cobra confirma que está executando este movimento agora
	direcao_atual_movida = direcao
	
	var nova_cabeca = cobra[0] + direcao
	
	if nova_cabeca.x < 0 or nova_cabeca.x >= LARGURA_GRID or nova_cabeca.y < 0 or nova_cabeca.y >= ALTURA_GRID:
		reiniciar_jogo()
		return
		
	if nova_cabeca in cobra:
		reiniciar_jogo()
		return
		
	cobra.insert(0, nova_cabeca)
	
	if nova_cabeca == comida:
		score += 1
		gerar_comida()
	else:
		cobra.pop_back()

func _draw() -> void:
	# Esta função nativa desenha elementos geométricos na tela a cada atualização
	
	# Desenha o fundo do tabuleiro (um retângulo escuro)
	draw_rect(Rect2(0, 0, LARGURA_GRID * TAMANHO_CELULA, ALTURA_GRID * TAMANHO_CELULA), Color(0.1, 0.1, 0.1))
	
	# Desenha a comida (Quadrado Vermelho)
	var rect_comida = Rect2(comida * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA))
	draw_rect(rect_comida, Color.DARK_RED)
	
	# Desenha a cobra (Quadrados Verdes)
	for i in range(cobra.size()):
		var rect_bloco = Rect2(cobra[i] * TAMANHO_CELULA, Vector2(TAMANHO_CELULA, TAMANHO_CELULA))
		if i == 0:
			draw_rect(rect_bloco, Color.FOREST_GREEN) # Cabeça um pouco mais escura
		else:
			draw_rect(rect_bloco, Color.LIME_GREEN) # Corpo brilhante
