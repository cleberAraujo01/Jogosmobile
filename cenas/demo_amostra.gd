extends Panel
## Coluna de demonstração com todos os componentes do design system.
## Com tema_forcado definido, a coluna trava naquele tema (comparação lado a lado).

signal pedir_modal
signal pedir_toast


@export_enum("global", "claro", "escuro") var tema_forcado: String = "global"


func _ready() -> void:
	if tema_forcado != "global":
		theme = load("res://temas/tema_%s.tres" % tema_forcado)
	%RotuloTema.text = "Tema %s" % tema_forcado
	%BotaoModal.pressed.connect(func() -> void: pedir_modal.emit())
	%BotaoToast.pressed.connect(func() -> void: pedir_toast.emit())
	%Moedas.pressed.connect(func() -> void:
		%Moedas.definir_quantidade(%Moedas.quantidade + 50))
	_preencher_cards()


func _preencher_cards() -> void:
	# Placeholder de ilustração: gradiente com cores da própria paleta.
	var tema_ref: Theme = theme if theme != null else GerenciadorTema.tema_atual()
	var gradiente := Gradient.new()
	gradiente.set_color(0, tema_ref.get_color("primaria", "Paleta"))
	gradiente.set_color(1, tema_ref.get_color("secundaria", "Paleta"))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 512
	textura.height = 288
	textura.fill_to = Vector2(1, 1)

	%CardPacote.configurar("Salmos", textura, 12, 20)
	%CardPacoteBloqueado.configurar("Parábolas", textura, 0, 20, true, "R$ 9,90")
	%CardFase1.configurar("3x3", "concluida", textura)
	%CardFase2.configurar("4x4", "nao_iniciada", textura)
	%CardFase3.configurar("6x6", "bloqueada", textura)
