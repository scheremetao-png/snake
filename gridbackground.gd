extends Node2D
class_name GridBackground

@export var cells : int = 21
@export var cell_size : int = 50

func _draw(): 

# Cores do xadrez
	var color1 = Color(0.438, 0.616, 1.0, 1.0)
	var color2 = Color(0.199, 0.428, 1.0, 1.0)
	
# O loop desenha os quadrados para formar o tabuleiro
	for x in range(cells):
		for y in range(cells):
			var rect = Rect2(x * cell_size, y * cell_size, cell_size, cell_size)
			var color = color1 if (x + y) % 2 == 0 else color2
			draw_rect(rect, color) # Comando de desenho customizado
