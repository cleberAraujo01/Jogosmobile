extends "res://componentes/toque_escala.gd"
## Chip de moedas. Tocável (leva à loja). Ganho animado por contagem (~400ms),
## sem chuva de moedas (design system, seção 4).

@export var quantidade: int = 0 :
	set(valor):
		quantidade = valor
		if is_node_ready():
			text = str(quantidade)

var _valor_exibido: float = 0.0


func _ready() -> void:
	super()
	text = str(quantidade)
	_valor_exibido = float(quantidade)


func definir_quantidade(valor: int, animar: bool = true) -> void:
	if not animar:
		quantidade = valor
		_valor_exibido = float(valor)
		return
	quantidade = valor
	var tween := create_tween()
	tween.tween_method(_atualizar_contagem, _valor_exibido, float(valor), 0.4) \
		.set_ease(Tween.EASE_OUT)


func _atualizar_contagem(valor: float) -> void:
	_valor_exibido = valor
	text = str(int(round(valor)))
