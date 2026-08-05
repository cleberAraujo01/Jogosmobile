extends Panel
## Tela de jogo — hospeda o modo quebra-cabeça e a tela de conclusão.
## Recebe a fase escolhida via GerenciadorDados.selecao (pacote/ilustração/grade)
## e registra a conclusão no GerenciadorProgresso.

const CENA_MODO_QUEBRA_CABECA := preload("res://modos/quebra_cabeca/quebra_cabeca.tscn")
const CENA_BOTAO_ICONE := preload("res://componentes/botao_icone.tscn")
const ICONE_OLHO := preload("res://recursos/icones/olho.svg")

var _modo: ModoBase = null
var _pacote_id := ""
var _ilustracao: Dictionary = {}
var _grade := 3
var _textura_atual: Texture2D = null

@onready var _barra := %Barra
@onready var _area_modo: Control = %AreaModo
@onready var _conclusao: Control = %Conclusao
@onready var _sombra_conclusao: ColorRect = %SombraConclusao
@onready var _rotulo_progresso: Label


func _ready() -> void:
	_carregar_selecao()

	_barra.voltar_pressionado.connect(_ao_voltar)
	%BotaoNovamente.pressed.connect(_iniciar_jogo)
	%BotaoVoltarFases.pressed.connect(_ao_voltar)

	_montar_slot_direita()
	_atualizar_sombra()
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _atualizar_sombra())

	_iniciar_jogo()


func _carregar_selecao() -> void:
	var selecao: Dictionary = GerenciadorDados.selecao
	_pacote_id = selecao.get("pacote_id", "")
	_grade = selecao.get("grade", 3)
	if _pacote_id == "":
		# Cena aberta fora do fluxo (ex.: F6 no editor) — primeira fase do jogo.
		var pacotes: Array = GerenciadorDados.pacotes()
		_pacote_id = pacotes[0].get("id", "") if not pacotes.is_empty() else ""
	var ilustracao_id: String = selecao.get("ilustracao_id", "")
	if ilustracao_id == "":
		var ilustracoes: Array = GerenciadorDados.pacote(_pacote_id).get("ilustracoes", [])
		_ilustracao = ilustracoes[0] if not ilustracoes.is_empty() else {}
	else:
		_ilustracao = GerenciadorDados.ilustracao(_pacote_id, ilustracao_id)


## Rótulo de progresso + botão "olho" (segurar para ver a imagem completa).
func _montar_slot_direita() -> void:
	_rotulo_progresso = Label.new()
	_rotulo_progresso.theme_type_variation = &"Legenda"
	_rotulo_progresso.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_barra.slot_direita.add_child(_rotulo_progresso)

	var botao_olho: Button = CENA_BOTAO_ICONE.instantiate()
	botao_olho.icon = ICONE_OLHO
	_barra.slot_direita.add_child(botao_olho)
	# Segurar mostra o fantasma forte; soltar volta ao sutil.
	botao_olho.button_down.connect(func() -> void:
		if _modo != null:
			_modo.usar_dica("olho_mostrar"))
	botao_olho.button_up.connect(func() -> void:
		if _modo != null:
			_modo.usar_dica("olho_ocultar"))


func _iniciar_jogo() -> void:
	_conclusao.visible = false

	if _modo != null:
		_modo.queue_free()
		_modo = null

	_barra.titulo = "%s — %dx%d" % [_ilustracao.get("nome", "Quebra-cabeça"), _grade, _grade]
	_rotulo_progresso.text = ""

	# Ilustração real se existir no JSON; senão, imagem de teste gerada em código.
	var caminho: String = _ilustracao.get("imagem", "")
	if caminho != "" and ResourceLoader.exists(caminho):
		_textura_atual = load(caminho)
	else:
		_textura_atual = await GeradorImagemTeste.gerar(self, _grade)

	_modo = CENA_MODO_QUEBRA_CABECA.instantiate()
	_area_modo.add_child(_modo)
	_modo.concluido.connect(_ao_concluir)
	_modo.progresso_alterado.connect(_ao_progresso)
	_modo.iniciar({"grade": _grade, "textura": _textura_atual})


func _ao_progresso(atual: int, total: int) -> void:
	_rotulo_progresso.text = "%d/%d" % [atual, total]


func _ao_concluir() -> void:
	GerenciadorProgresso.registrar_conclusao(_ilustracao.get("id", ""), _grade)

	# Pequena pausa para a jogadora ver o brilho de conclusão antes do painel.
	await get_tree().create_timer(1.2).timeout

	%ImagemCompleta.texture = _textura_atual
	%VersiculoLabel.text = _ilustracao.get("versiculo", "")
	%ReferenciaLabel.text = _ilustracao.get("referencia", "")

	_conclusao.modulate.a = 0.0
	_conclusao.visible = true
	var tween := create_tween()
	tween.tween_property(_conclusao, "modulate:a", 1.0, 0.25) \
		.set_ease(Tween.EASE_OUT)

	# Intersticial só entre telas — nunca durante a partida.
	GerenciadorAnuncios.mostrar_intersticial()


func _ao_voltar() -> void:
	get_tree().change_scene_to_file("res://cenas/selecao_fase.tscn")


func _atualizar_sombra() -> void:
	_sombra_conclusao.color = GerenciadorTema.cor("sobreposicao")
