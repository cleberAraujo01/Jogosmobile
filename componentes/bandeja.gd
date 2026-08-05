extends PanelContainer
## Bandeja rolável de peças. Mostra miniaturas (AtlasTexture da região de cada
## peça); arrastar a miniatura PARA CIMA inicia o arrasto da peça real,
## arrastar na horizontal rola a bandeja.

signal arrasto_iniciado(id: int, pos_global: Vector2)
signal arrasto_movido(id: int, pos_global: Vector2)
signal arrasto_solto(id: int, pos_global: Vector2)

@onready var _linha: HBoxContainer = %Linha

var _itens: Dictionary = {}   # id -> Miniatura


func preencher(itens: Array, altura_maxima: float) -> void:
	limpar()
	for dados in itens:
		var miniatura := Miniatura.new()
		miniatura.id = dados["id"]
		miniatura.texture = dados["textura"]
		var tam: Vector2 = dados["textura"].get_size()
		var escala: float = minf(altura_maxima / maxf(tam.x, tam.y), 1.0)
		miniatura.custom_minimum_size = tam * escala
		miniatura.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		miniatura.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		miniatura.mouse_filter = Control.MOUSE_FILTER_STOP
		miniatura.quer_arrastar.connect(
			func(pos: Vector2) -> void: arrasto_iniciado.emit(miniatura.id, pos))
		miniatura.movido.connect(
			func(pos: Vector2) -> void: arrasto_movido.emit(miniatura.id, pos))
		miniatura.solto.connect(
			func(pos: Vector2) -> void: arrasto_solto.emit(miniatura.id, pos))
		_linha.add_child(miniatura)
		_itens[miniatura.id] = miniatura


func limpar() -> void:
	for filho in _linha.get_children():
		filho.queue_free()
	_itens.clear()


## Esmaece a miniatura durante o arrasto (mantém o espaço na bandeja).
func ocultar_item(id: int) -> void:
	if _itens.has(id):
		_itens[id].modulate.a = 0.25


func restaurar_item(id: int) -> void:
	if _itens.has(id):
		_itens[id].modulate.a = 1.0


func remover_item(id: int) -> void:
	if _itens.has(id):
		_itens[id].queue_free()
		_itens.erase(id)


func posicao_global_item(id: int) -> Vector2:
	if _itens.has(id):
		return _itens[id].global_position
	return global_position


class Miniatura:
	extends TextureRect
	## Miniatura de peça na bandeja. Diferencia rolagem (horizontal) de
	## pegar a peça (subida além do limiar).

	signal quer_arrastar(pos_global: Vector2)
	signal movido(pos_global: Vector2)
	signal solto(pos_global: Vector2)

	const LIMIAR_SUBIDA := 40.0

	var id := -1
	var _pressionado := false
	var _arrastando := false
	var _origem := Vector2.ZERO

	func _gui_input(evento: InputEvent) -> void:
		if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT:
			if evento.pressed:
				_pressionado = true
				_origem = evento.global_position
			else:
				if _arrastando:
					solto.emit(evento.global_position)
					accept_event()
				_pressionado = false
				_arrastando = false
		elif evento is InputEventMouseMotion and _pressionado:
			if _arrastando:
				movido.emit(evento.global_position)
				accept_event()
			elif _origem.y - evento.global_position.y > LIMIAR_SUBIDA:
				_arrastando = true
				quer_arrastar.emit(evento.global_position)
				accept_event()
