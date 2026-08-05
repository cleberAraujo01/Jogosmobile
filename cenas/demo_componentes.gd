extends Panel
## Tela de demonstração: dois temas lado a lado + troca de tema global em tempo real.


func _ready() -> void:
	%BotaoAlternar.pressed.connect(GerenciadorTema.alternar_tema)
	for amostra in [%AmostraClara, %AmostraEscura]:
		amostra.pedir_modal.connect(_abrir_modal)
		amostra.pedir_toast.connect(_mostrar_toast)


func _abrir_modal() -> void:
	%PopupModal.abrir(
		"Remover anúncios?",
		"Uma única compra remove todos os anúncios para sempre.",
		"Comprar",
		"Agora não")


func _mostrar_toast() -> void:
	%Toast.mostrar("Peça encaixada!", preload("res://recursos/icones/check.svg"))
