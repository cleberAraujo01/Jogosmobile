extends "res://componentes/toque_escala.gd"
## Card de pacote "image-first": a capa preenche o card inteiro e o texto
## fica sobre um véu (scrim) escuro na base — contraste garantido em
## qualquer imagem e qualquer tema.
## Estados: normal, pressionado (escala 0.98) e bloqueado (sobreposição + selo).

@export var nome_pacote: String = "Pacote"
@export var capa: Texture2D
@export var progresso_atual: int = 0
@export var progresso_total: int = 20
@export var bloqueado: bool = false
@export var preco: String = ""

@onready var _capa: TextureRect = %Capa
@onready var _scrim: TextureRect = %Scrim
@onready var _nome: Label = %Nome
@onready var _barra: ProgressBar = %Barra
@onready var _rotulo_progresso: Label = %RotuloProgresso
@onready var _bloqueio: Control = %Bloqueio
@onready var _sombra: ColorRect = %Sombra
@onready var _icone_cadeado: TextureRect = %IconeCadeado
@onready var _rotulo_preco: Label = %RotuloPreco


func _ready() -> void:
	super()
	escala_pressionado = 0.98
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _atualizar())
	_atualizar()


func configurar(novo_nome: String, nova_capa: Texture2D, atual: int, total: int,
		esta_bloqueado: bool = false, novo_preco: String = "") -> void:
	nome_pacote = novo_nome
	capa = nova_capa
	progresso_atual = atual
	progresso_total = total
	bloqueado = esta_bloqueado
	preco = novo_preco
	_atualizar()


func _atualizar() -> void:
	if not is_node_ready():
		return
	_nome.text = nome_pacote
	_capa.texture = capa
	_scrim.texture = _textura_scrim()
	_barra.max_value = progresso_total
	_barra.value = progresso_atual
	# Texto sempre acompanha a barra — cor nunca é a única informação.
	_rotulo_progresso.text = "%d de %d fases" % [progresso_atual, progresso_total]
	# Sobre o scrim escuro, o texto usa a cor clara da paleta.
	var cor_clara: Color = GerenciadorTema.cor("texto_sobre_primaria")
	_nome.add_theme_color_override("font_color", cor_clara)
	_rotulo_progresso.add_theme_color_override("font_color", cor_clara)
	_bloqueio.visible = bloqueado
	if bloqueado:
		# Sobreposição a 40% sobre a capa (design system, card de pacote).
		var cor_sombra: Color = GerenciadorTema.cor("sobreposicao")
		cor_sombra.a = 0.4
		_sombra.color = cor_sombra
		_icone_cadeado.self_modulate = GerenciadorTema.cor("texto_principal")
		_rotulo_preco.text = preco


## Véu vertical (transparente → escuro) que ancora o texto sobre a imagem.
func _textura_scrim() -> Texture2D:
	var cor_base: Color = GerenciadorTema.cor("sobreposicao")
	var gradiente := Gradient.new()
	gradiente.set_color(0, Color(cor_base.r, cor_base.g, cor_base.b, 0.0))
	gradiente.set_color(1, Color(cor_base.r, cor_base.g, cor_base.b, 0.92))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 4
	textura.height = 256
	textura.fill_from = Vector2(0, 0)
	textura.fill_to = Vector2(0, 1)
	return textura
