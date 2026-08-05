extends ModoBase
## Modo quebra-cabeça. A imagem é recortada em tempo de execução:
## cada peça é um Polygon2D com UV apontando para sua região da textura original.
## Sem tempo, sem vidas, sem punição — o público joga para relaxar.

const CENA_PECA := preload("res://componentes/peca.tscn")
const ESCALA_ARRASTO := 1.1        # peça cresce ~10% ao ser arrastada
const TOLERANCIA_ENCAIXE := 0.15   # 15% do tamanho da peça, por eixo
const ALTURA_MINIATURA := 200.0
const DESLOC_DEDO := Vector2(0, 80)  # peça flutua acima do dedo para não ficar escondida

var textura: Texture2D
var grade := 4
var total := 0
var encaixadas := 0
var restantes: Dictionary = {}     # id -> Vector2i (peças ainda na bandeja)
var peca_arrastada: Peca = null
var id_arrastado := -1

@onready var _tabuleiro: Control = %Tabuleiro
@onready var _bandeja: PanelContainer = %Bandeja
@onready var _camada_arrasto: Node2D = %CamadaArrasto


func _ready() -> void:
	_bandeja.arrasto_iniciado.connect(_ao_arrasto_iniciado)
	_bandeja.arrasto_movido.connect(_ao_arrasto_movido)
	_bandeja.arrasto_solto.connect(_ao_arrasto_solto)
	%BotaoDica.pressed.connect(func() -> void: usar_dica("encaixar"))


func iniciar(config: Dictionary) -> void:
	grade = int(config.get("grade", 4))
	textura = config.get("textura")
	total = grade * grade
	encaixadas = 0
	# Aguarda um frame para os containers terem tamanho válido.
	await get_tree().process_frame
	_tabuleiro.configurar(textura, grade)
	_montar_bandeja()
	progresso_alterado.emit(0, total)


func usar_dica(tipo: String) -> void:
	match tipo:
		"olho_mostrar":
			_tabuleiro.mostrar_fantasma(true)
		"olho_ocultar":
			_tabuleiro.mostrar_fantasma(false)
		"encaixar":
			_dica_encaixar()


func _montar_bandeja() -> void:
	restantes.clear()
	var indices: Array[Vector2i] = []
	for y in grade:
		for x in grade:
			indices.append(Vector2i(x, y))
	indices.shuffle()

	var tam_uv := _tamanho_uv()
	var itens: Array = []
	for id in indices.size():
		var indice := indices[id]
		restantes[id] = indice
		# Miniatura: recorte da textura original via AtlasTexture (nenhum PNG por peça).
		var atlas := AtlasTexture.new()
		atlas.atlas = textura
		atlas.region = Rect2(Vector2(indice) * tam_uv, tam_uv)
		itens.append({"id": id, "textura": atlas})
	_bandeja.preencher(itens, ALTURA_MINIATURA)


func _tamanho_uv() -> Vector2:
	return Vector2(textura.get_size()) / float(grade)


# ------------------------------------------------------------------ arrasto

func _ao_arrasto_iniciado(id: int, pos: Vector2) -> void:
	if peca_arrastada != null or not restantes.has(id):
		return
	id_arrastado = id
	var indice: Vector2i = restantes[id]
	var peca: Peca = CENA_PECA.instantiate()
	_camada_arrasto.add_child(peca)
	peca.construir(textura, indice, _tabuleiro.tamanho_celula,
			Vector2(indice) * _tamanho_uv(), _tamanho_uv())
	peca.scale = Vector2.ONE * ESCALA_ARRASTO
	peca_arrastada = peca
	_bandeja.ocultar_item(id)
	_mover_peca(pos)


func _ao_arrasto_movido(id: int, pos: Vector2) -> void:
	if peca_arrastada != null and id == id_arrastado:
		_mover_peca(pos)


func _ao_arrasto_solto(id: int, pos: Vector2) -> void:
	if peca_arrastada == null or id != id_arrastado:
		return
	_mover_peca(pos)
	var indice: Vector2i = restantes[id]
	var celula: Vector2 = _tabuleiro.tamanho_celula
	var centro: Vector2 = peca_arrastada.global_position \
			+ peca_arrastada.tamanho * peca_arrastada.scale.x / 2.0
	var alvo: Vector2 = _tabuleiro.posicao_global_celula(indice) + celula / 2.0
	var desvio: Vector2 = (centro - alvo).abs()
	if desvio.x <= celula.x * TOLERANCIA_ENCAIXE and desvio.y <= celula.y * TOLERANCIA_ENCAIXE:
		_encaixar(id, peca_arrastada)
	else:
		_devolver(id, peca_arrastada)
	peca_arrastada = null
	id_arrastado = -1


func _mover_peca(pos: Vector2) -> void:
	var tam: Vector2 = peca_arrastada.tamanho * ESCALA_ARRASTO
	peca_arrastada.global_position = pos - tam / 2.0 - DESLOC_DEDO


func _encaixar(id: int, peca: Peca) -> void:
	var indice: Vector2i = restantes[id]
	restantes.erase(id)
	_bandeja.remover_item(id)
	peca.reparent(_tabuleiro.camada_pecas)
	peca.encaixada = true
	var tween := create_tween().set_parallel()
	tween.tween_property(peca, "position", Vector2(indice) * _tabuleiro.tamanho_celula, 0.12) \
			.set_ease(Tween.EASE_OUT)
	tween.tween_property(peca, "scale", Vector2.ONE, 0.12).set_ease(Tween.EASE_OUT)
	GerenciadorAudio.tocar("encaixe")
	encaixadas += 1
	progresso_alterado.emit(encaixadas, total)
	if encaixadas == total:
		await tween.finished
		_celebrar()


func _devolver(id: int, peca: Peca) -> void:
	# Sem punição: a peça só volta calmamente para a bandeja.
	var destino: Vector2 = _bandeja.posicao_global_item(id)
	var tween := create_tween().set_parallel()
	tween.tween_property(peca, "global_position", destino, 0.18).set_ease(Tween.EASE_OUT)
	tween.tween_property(peca, "scale", Vector2.ONE * 0.4, 0.18).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(func() -> void:
		peca.queue_free()
		_bandeja.restaurar_item(id))


func _dica_encaixar() -> void:
	if restantes.is_empty() or peca_arrastada != null:
		return
	var id: int = restantes.keys().pick_random()
	var indice: Vector2i = restantes[id]
	var peca: Peca = CENA_PECA.instantiate()
	_camada_arrasto.add_child(peca)
	peca.construir(textura, indice, _tabuleiro.tamanho_celula,
			Vector2(indice) * _tamanho_uv(), _tamanho_uv())
	peca.global_position = _bandeja.posicao_global_item(id)
	peca.scale = Vector2.ONE * 0.4
	# A peça voa da bandeja até o lugar certo.
	var tween := create_tween().set_parallel()
	tween.tween_property(peca, "global_position",
			_tabuleiro.posicao_global_celula(indice), 0.35).set_ease(Tween.EASE_OUT)
	tween.tween_property(peca, "scale", Vector2.ONE, 0.35).set_ease(Tween.EASE_OUT)
	await tween.finished
	_encaixar(id, peca)


func _celebrar() -> void:
	# União + brilho suave: a única animação longa permitida (design system, seção 7).
	var camada: Node2D = _tabuleiro.camada_pecas
	var tween := create_tween()
	tween.tween_interval(0.2)
	tween.tween_property(camada, "modulate", Color(1.25, 1.2, 1.05), 0.5) \
			.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camada, "modulate", Color.WHITE, 0.6).set_ease(Tween.EASE_IN_OUT)
	GerenciadorAudio.tocar("conclusao")
	await tween.finished
	concluido.emit()
