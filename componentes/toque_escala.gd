extends Button
## Comportamento de toque padrão do design system (seção 4):
## leve escala ao pressionar, 80ms, sem brilhos nem partículas.

@export var escala_pressionado: float = 0.97


func _ready() -> void:
	pivot_offset = size / 2.0
	resized.connect(func() -> void: pivot_offset = size / 2.0)
	button_down.connect(_ao_pressionar)
	button_up.connect(_ao_soltar)


func _ao_pressionar() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * escala_pressionado, 0.08) \
		.set_ease(Tween.EASE_OUT)


func _ao_soltar() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_ease(Tween.EASE_OUT)
