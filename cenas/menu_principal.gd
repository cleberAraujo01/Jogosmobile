extends Panel
## Menu principal — título com ornamento devocional, destaque "Continuar"
## (próxima fase não concluída) e ações principais.


func _ready() -> void:
	%BotaoJogar.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://cenas/mapa_pacotes.tscn"))
	%BotaoTema.pressed.connect(_ao_alternar_tema)
	%Destaque.pressed.connect(_ao_continuar)
	GerenciadorTema.tema_alterado.connect(func(_nome: String) -> void:
		_montar_destaque()
		_atualizar_glow())
	_atualizar_rotulo_tema()
	_atualizar_glow()
	_montar_destaque()


## Procura a primeira fase (ilustração × grade) ainda não concluída
## nos pacotes desbloqueados, na ordem do JSON.
func _proxima_fase() -> Dictionary:
	for pacote: Dictionary in GerenciadorDados.pacotes():
		var pacote_id: String = pacote.get("id", "")
		if not pacote.get("gratuito", false) \
				and not GerenciadorCompras.pacote_desbloqueado(pacote_id):
			continue
		var indice := 0
		for ilustracao: Dictionary in pacote.get("ilustracoes", []):
			for grade: int in GerenciadorDados.grades():
				if not GerenciadorProgresso.concluida(ilustracao.get("id", ""), grade):
					return {
						"pacote_id": pacote_id,
						"ilustracao": ilustracao,
						"grade": grade,
						"indice": indice,
					}
			indice += 1
	return {}


func _montar_destaque() -> void:
	var fase := _proxima_fase()
	%Destaque.visible = not fase.is_empty()
	if fase.is_empty():
		return
	var ilustracao: Dictionary = fase["ilustracao"]
	%CapaDestaque.texture = GeradorImagemTeste.capa_ilustracao(
			self, ilustracao, fase["indice"])
	%NomeDestaque.text = "%s — %dx%d" % [
		ilustracao.get("nome", ""), fase["grade"], fase["grade"]]
	%ScrimDestaque.texture = _textura_scrim()
	# Sobre o scrim escuro, o texto usa a cor clara da paleta.
	var cor_clara: Color = GerenciadorTema.cor("texto_sobre_primaria")
	%NomeDestaque.add_theme_color_override("font_color", cor_clara)
	%RotuloContinuar.add_theme_color_override("font_color", cor_clara)


## Véu vertical (transparente → escuro) que ancora o texto sobre a imagem.
func _textura_scrim() -> Texture2D:
	var cor_base: Color = GerenciadorTema.cor("sobreposicao")
	var gradiente := Gradient.new()
	gradiente.set_color(0, Color(cor_base.r, cor_base.g, cor_base.b, 0.0))
	gradiente.set_color(1, Color(cor_base.r, cor_base.g, cor_base.b, 0.92))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 4
	textura.height = 256
	textura.fill_from = Vector2(0, 0)
	textura.fill_to = Vector2(0, 1)
	return textura


## Brilho radial dourado muito sutil atrás do título — profundidade sem ruído.
func _atualizar_glow() -> void:
	var cor: Color = GerenciadorTema.cor("secundaria")
	var gradiente := Gradient.new()
	gradiente.set_color(0, Color(cor.r, cor.g, cor.b, 0.10))
	gradiente.set_color(1, Color(cor.r, cor.g, cor.b, 0.0))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 512
	textura.height = 512
	textura.fill = GradientTexture2D.FILL_RADIAL
	textura.fill_from = Vector2(0.5, 0.5)
	textura.fill_to = Vector2(0.5, 0.0)
	%Glow.texture = textura


func _ao_continuar() -> void:
	var fase := _proxima_fase()
	if fase.is_empty():
		return
	GerenciadorDados.selecao = {
		"pacote_id": fase["pacote_id"],
		"ilustracao_id": fase["ilustracao"].get("id", ""),
		"grade": fase["grade"],
	}
	get_tree().change_scene_to_file("res://cenas/jogo.tscn")


func _ao_alternar_tema() -> void:
	GerenciadorTema.alternar_tema()
	_atualizar_rotulo_tema()


func _atualizar_rotulo_tema() -> void:
	# Texto explícito do que o botão FARÁ — nunca só um ícone ambíguo.
	%BotaoTema.text = ("Tema escuro" if GerenciadorTema.nome_tema == "claro"
			else "Tema claro")
