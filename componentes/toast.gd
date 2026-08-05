extends PanelContainer
## Toast: aviso curto na parte inferior. 2,5s, fade in/out, nunca cobre botões de ação.

@onready var _rotulo: Label = %RotuloToast
@onready var _icone: TextureRect = %IconeToast

var _tween: Tween


func _ready() -> void:
	visible = false
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _atualizar_cores())


func mostrar(texto: String, icone: Texture2D = null) -> void:
	_rotulo.text = texto
	_icone.texture = icone
	_icone.visible = icone != null
	_atualizar_cores()
	if _tween and _tween.is_valid():
		_tween.kill()
	visible = true
	modulate.a = 0.0
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, 0.18)
	_tween.tween_interval(2.5)
	_tween.tween_property(self, "modulate:a", 0.0, 0.25)
	_tween.tween_callback(func() -> void: visible = false)


func _atualizar_cores() -> void:
	_icone.self_modulate = GerenciadorTema.cor("texto_principal")
