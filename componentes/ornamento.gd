extends Control
## Divisor decorativo devocional: linha fina com losango central,
## na cor secundária (dourado) do tema ativo. Puramente estético —
## nunca carrega informação (acessibilidade preservada).

const ALTURA := 24.0
const LADO_LOSANGO := 8.0
const ESPESSURA := 2.0
const FOLGA := 16.0


func _ready() -> void:
	custom_minimum_size = Vector2(0, ALTURA)
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: queue_redraw())
	resized.connect(queue_redraw)


func _draw() -> void:
	var cor: Color = GerenciadorTema.cor("secundaria")
	var meio := size / 2.0
	# Linhas laterais, com folga em volta do losango.
	draw_line(Vector2(0, meio.y), Vector2(meio.x - LADO_LOSANGO - FOLGA, meio.y),
			cor, ESPESSURA, true)
	draw_line(Vector2(meio.x + LADO_LOSANGO + FOLGA, meio.y), Vector2(size.x, meio.y),
			cor, ESPESSURA, true)
	# Losango central.
	draw_colored_polygon(PackedVector2Array([
		meio + Vector2(0, -LADO_LOSANGO),
		meio + Vector2(LADO_LOSANGO, 0),
		meio + Vector2(0, LADO_LOSANGO),
		meio + Vector2(-LADO_LOSANGO, 0),
	]), cor)
