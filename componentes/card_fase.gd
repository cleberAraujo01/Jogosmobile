extends "res://componentes/toque_escala.gd"
## Card de fase (grade de seleção). 312x312.
## Estados: "concluida", "nao_iniciada", "bloqueada".
## Bloqueio sempre com cadeado + texto — cor nunca é a única informação.

@export var grade: String = "3x3"
@export_enum("concluida", "nao_iniciada", "bloqueada") var estado: String = "nao_iniciada"
@export var miniatura: Texture2D

@onready var _miniatura: TextureRect = %Miniatura
@onready var _scrim: TextureRect = %Scrim
@onready var _chip_grade: Label = %ChipGrade
@onready var _icone_check: TextureRect = %IconeCheck
@onready var _bloqueio: Control = %Bloqueio
@onready var _sombra: ColorRect = %Sombra
@onready var _icone_cadeado: TextureRect = %IconeCadeado


func _ready() -> void:
	super()
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _atualizar())
	_atualizar()


func configurar(nova_grade: String, novo_estado: String, nova_miniatura: Texture2D) -> void:
	grade = nova_grade
	estado = novo_estado
	miniatura = nova_miniatura
	_atualizar()


func _atualizar() -> void:
	if not is_node_ready():
		return
	_chip_grade.text = grade
	_miniatura.texture = miniatura
	_scrim.texture = _textura_scrim()
	# Sobre o scrim escuro, o texto usa a cor clara da paleta.
	_chip_grade.add_theme_color_override("font_color",
			GerenciadorTema.cor("texto_sobre_primaria"))
	_icone_check.visible = estado == "concluida"
	_icone_check.self_modulate = GerenciadorTema.cor("sucesso")
	_bloqueio.visible = estado == "bloqueada"
	_sombra.color = GerenciadorTema.cor("sobreposicao")
	_icone_cadeado.self_modulate = GerenciadorTema.cor("texto_principal")
	# Não iniciada: prévia parcial (por enquanto via opacidade; dessaturação real
	# virá com shader quando houver ilustrações definitivas).
	_miniatura.modulate = Color(1, 1, 1, 0.55) if estado == "nao_iniciada" else Color.WHITE
	disabled = estado == "bloqueada"


## Véu vertical (transparente → escuro) que ancora o texto sobre a imagem.
func _textura_scrim() -> Texture2D:
	var cor_base: Color = GerenciadorTema.cor("sobreposicao")
	var gradiente := Gradient.new()
	gradiente.set_color(0, Color(cor_base.r, cor_base.g, cor_base.b, 0.0))
	gradiente.set_color(1, Color(cor_base.r, cor_base.g, cor_base.b, 0.92))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 4
	textura.height = 128
	textura.fill_from = Vector2(0, 0)
	textura.fill_to = Vector2(0, 1)
	return textura
