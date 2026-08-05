extends PanelContainer
## Barra superior padrão: voltar à esquerda, título no centro,
## slot "Direita" para moedas/configurações (preenchido por quem instancia).

signal voltar_pressionado

@export var titulo: String = "" :
	set(valor):
		titulo = valor
		if is_node_ready():
			%TituloTela.text = titulo
@export var mostrar_voltar: bool = true :
	set(valor):
		mostrar_voltar = valor
		if is_node_ready():
			%BotaoVoltar.visible = mostrar_voltar

@onready var slot_direita: HBoxContainer = %Direita


func _ready() -> void:
	%TituloTela.text = titulo
	%BotaoVoltar.visible = mostrar_voltar
	%BotaoVoltar.pressed.connect(func() -> void: voltar_pressionado.emit())
