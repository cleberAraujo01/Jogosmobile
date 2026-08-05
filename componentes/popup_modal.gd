extends Control
## Popup modal padrão. Fade + escala 0.95→1.0 em 180ms.
## Fecha pelo X, pelo toque na sobreposição ou pelos botões — nunca prende a jogadora.

signal confirmado
signal cancelado
signal fechado

@onready var _sombra: ColorRect = %Sombra
@onready var _painel: PanelContainer = %Painel
@onready var _titulo: Label = %TituloModal
@onready var _corpo: Label = %CorpoModal
@onready var _botao_confirmar: Button = %BotaoConfirmar
@onready var _botao_cancelar: Button = %BotaoCancelar


func _ready() -> void:
	visible = false
	_atualizar_cores()
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _atualizar_cores())
	_sombra.gui_input.connect(_ao_tocar_sombra)
	%BotaoFechar.pressed.connect(fechar)
	_botao_confirmar.pressed.connect(func() -> void:
		confirmado.emit()
		fechar())
	_botao_cancelar.pressed.connect(func() -> void:
		cancelado.emit()
		fechar())


func abrir(titulo: String, corpo: String, texto_confirmar: String = "OK",
		texto_cancelar: String = "") -> void:
	_titulo.text = titulo
	_corpo.text = corpo
	_botao_confirmar.text = texto_confirmar
	_botao_cancelar.text = texto_cancelar
	_botao_cancelar.visible = texto_cancelar != ""
	visible = true
	_painel.pivot_offset = _painel.size / 2.0
	_painel.scale = Vector2.ONE * 0.95
	modulate.a = 0.0
	var tween := create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 1.0, 0.18).set_ease(Tween.EASE_OUT)
	tween.tween_property(_painel, "scale", Vector2.ONE, 0.18).set_ease(Tween.EASE_OUT)


func fechar() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func() -> void:
		visible = false
		fechado.emit())


func _ao_tocar_sombra(evento: InputEvent) -> void:
	if evento is InputEventMouseButton and evento.pressed:
		fechar()


func _atualizar_cores() -> void:
	_sombra.color = GerenciadorTema.cor("sobreposicao")
