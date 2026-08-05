extends Panel
## Seleção de fase dentro de um pacote: uma linha por ilustração,
## com um card por grade (3x3, 4x4, 6x6) mostrando o estado real do progresso.

const CENA_CARD_FASE := preload("res://componentes/card_fase.tscn")

var _pacote_id := ""


func _ready() -> void:
	_pacote_id = GerenciadorDados.selecao.get("pacote_id", "")
	if _pacote_id == "":
		# Cena aberta fora do fluxo (ex.: F6 no editor) — usa o primeiro pacote.
		var pacotes: Array = GerenciadorDados.pacotes()
		_pacote_id = pacotes[0].get("id", "") if not pacotes.is_empty() else ""

	%Barra.titulo = GerenciadorDados.pacote(_pacote_id).get("nome", "Fases")
	%Barra.voltar_pressionado.connect(func() -> void:
		get_tree().change_scene_to_file("res://cenas/mapa_pacotes.tscn"))
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void: _montar())
	_montar()


func _montar() -> void:
	for filho in %Lista.get_children():
		filho.queue_free()

	var indice := 0
	for ilustracao: Dictionary in GerenciadorDados.pacote(_pacote_id).get("ilustracoes", []):
		var id: String = ilustracao.get("id", "")
		var capa := GeradorImagemTeste.capa_ilustracao(self, ilustracao, indice)

		var nome := Label.new()
		nome.theme_type_variation = &"Subtitulo"
		nome.text = ilustracao.get("nome", "")
		%Lista.add_child(nome)

		var linha := HBoxContainer.new()
		linha.add_theme_constant_override("separation", 24)
		%Lista.add_child(linha)

		for grade: int in GerenciadorDados.grades():
			var card := CENA_CARD_FASE.instantiate()
			linha.add_child(card)
			var estado := "concluida" if GerenciadorProgresso.concluida(id, grade) \
					else "nao_iniciada"
			card.configurar("%dx%d" % [grade, grade], estado, capa)
			card.pressed.connect(_ao_escolher.bind(id, grade))
			_animar_entrada(card, indice * 3 + linha.get_child_count())
		indice += 1


## Entrada em cascata: fade + leve crescimento (120–250ms, ease out — motion do DS).
func _animar_entrada(item: Control, ordem: int) -> void:
	item.modulate.a = 0.0
	item.scale = Vector2.ONE * 0.96
	var tween := item.create_tween()
	tween.tween_interval(0.04 * ordem)
	tween.tween_property(item, "modulate:a", 1.0, 0.18).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(item, "scale", Vector2.ONE, 0.18) \
			.set_ease(Tween.EASE_OUT)


func _ao_escolher(ilustracao_id: String, grade: int) -> void:
	GerenciadorDados.selecao = {
		"pacote_id": _pacote_id,
		"ilustracao_id": ilustracao_id,
		"grade": grade,
	}
	get_tree().change_scene_to_file("res://cenas/jogo.tscn")
