extends Panel
## Mapa de pacotes: lista os pacotes do JSON com progresso real.
## Pacote bloqueado abre o modal de compra (fachada falsa por enquanto).

const CENA_CARD_PACOTE := preload("res://componentes/card_pacote.tscn")

var _pacote_pendente := ""


func _ready() -> void:
	%Barra.voltar_pressionado.connect(func() -> void:
		get_tree().change_scene_to_file("res://cenas/menu_principal.tscn"))
	%PopupModal.confirmado.connect(_ao_confirmar_compra)
	GerenciadorCompras.compra_concluida.connect(_ao_compra_concluida)
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _montar())
	_montar()


func _montar() -> void:
	for filho in %Lista.get_children():
		filho.queue_free()

	var indice := 0
	for pacote: Dictionary in GerenciadorDados.pacotes():
		var id: String = pacote.get("id", "")
		var bloqueado: bool = (not pacote.get("gratuito", false)
				and not GerenciadorCompras.pacote_desbloqueado(id))
		var progresso: Dictionary = GerenciadorProgresso.progresso_pacote(id)

		# Capa do pacote = imagem da primeira ilustração (ou placeholder).
		var ilustracoes: Array = pacote.get("ilustracoes", [])
		var primeira: Dictionary = ilustracoes[0] if not ilustracoes.is_empty() else {}

		var card := CENA_CARD_PACOTE.instantiate()
		%Lista.add_child(card)
		card.configurar(
			pacote.get("nome", ""),
			GeradorImagemTeste.capa_ilustracao(self, primeira, indice),
			progresso["atual"],
			progresso["total"],
			bloqueado,
			pacote.get("preco", ""),
		)
		card.pressed.connect(_ao_tocar_pacote.bind(id, bloqueado))
		_animar_entrada(card, indice)
		indice += 1


## Entrada em cascata: fade + leve crescimento (120–250ms, ease out — motion do DS).
func _animar_entrada(item: Control, indice: int) -> void:
	item.modulate.a = 0.0
	item.scale = Vector2.ONE * 0.96
	var tween := item.create_tween()
	tween.tween_interval(0.05 * indice)
	tween.tween_property(item, "modulate:a", 1.0, 0.18).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(item, "scale", Vector2.ONE, 0.18) \
			.set_ease(Tween.EASE_OUT)


func _ao_tocar_pacote(id: String, bloqueado: bool) -> void:
	if bloqueado:
		_pacote_pendente = id
		var pacote: Dictionary = GerenciadorDados.pacote(id)
		%PopupModal.abrir(
			"Desbloquear pacote?",
			"\"%s\" ficará disponível para sempre por %s." % [
				pacote.get("nome", ""), pacote.get("preco", "")],
			"Desbloquear",
			"Agora não",
		)
		return
	GerenciadorDados.selecao = {"pacote_id": id}
	get_tree().change_scene_to_file("res://cenas/selecao_fase.tscn")


func _ao_confirmar_compra() -> void:
	if _pacote_pendente != "":
		GerenciadorCompras.comprar_pacote(_pacote_pendente)
		_pacote_pendente = ""


func _ao_compra_concluida(id: String) -> void:
	_montar()
	var pacote: Dictionary = GerenciadorDados.pacote(id)
	%Toast.mostrar("Pacote \"%s\" desbloqueado!" % pacote.get("nome", ""))
