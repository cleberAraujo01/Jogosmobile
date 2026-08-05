class_name GeradorImagemTeste
extends RefCounted
## Gera uma imagem de teste em tempo de execução (gradiente + números por célula).
## Prova que o recorte funciona com QUALQUER textura, sem depender de arte.
## Some do fluxo quando as ilustrações reais chegarem (Etapa 4+).


## Capa/miniatura de uma ilustração: usa o arquivo do campo "imagem" do JSON
## se existir; senão cai no gradiente placeholder.
static func capa_ilustracao(no_pai: Node, ilustracao: Dictionary, indice: int) -> Texture2D:
	var caminho: String = ilustracao.get("imagem", "")
	if caminho != "" and ResourceLoader.exists(caminho):
		return load(caminho)
	return gradiente_capa(no_pai, indice)


## Capa/miniatura placeholder: gradiente da paleta, variando a direção pelo
## índice para diferenciar ilustrações a olho nu. Some com as artes reais.
static func gradiente_capa(no_pai: Node, indice: int) -> Texture2D:
	var gerenciador_tema: Node = no_pai.get_node("/root/GerenciadorTema")
	var gradiente := Gradient.new()
	gradiente.set_color(0, gerenciador_tema.cor("primaria"))
	gradiente.set_color(1, gerenciador_tema.cor("secundaria"))
	var textura := GradientTexture2D.new()
	textura.gradient = gradiente
	textura.width = 512
	textura.height = 512
	var direcoes: Array[Vector2] = [
		Vector2(1, 1), Vector2(1, 0), Vector2(0, 1),
		Vector2(1, 0.5), Vector2(0.5, 1), Vector2(0.25, 1),
	]
	textura.fill_to = direcoes[indice % direcoes.size()]
	return textura


## Renderiza a imagem num SubViewport e devolve como textura independente.
static func gerar(no_pai: Node, grade: int, lado := 1024) -> Texture2D:
	var gerenciador_tema: Node = no_pai.get_node("/root/GerenciadorTema")

	var viewport := SubViewport.new()
	viewport.size = Vector2i(lado, lado)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	var raiz := Control.new()
	raiz.size = Vector2(lado, lado)
	raiz.theme = gerenciador_tema.tema_atual()

	# Fundo: gradiente diagonal com cores da própria paleta (nenhuma cor solta).
	var gradiente := Gradient.new()
	gradiente.set_color(0, gerenciador_tema.cor("primaria"))
	gradiente.set_color(1, gerenciador_tema.cor("secundaria"))
	var textura_gradiente := GradientTexture2D.new()
	textura_gradiente.gradient = gradiente
	textura_gradiente.width = lado
	textura_gradiente.height = lado
	textura_gradiente.fill_to = Vector2(1, 1)
	var fundo := TextureRect.new()
	fundo.texture = textura_gradiente
	fundo.size = Vector2(lado, lado)
	raiz.add_child(fundo)

	# Um número por célula, para conferir posição das peças a olho nu.
	var celula := lado / float(grade)
	for y in grade:
		for x in grade:
			var rotulo := Label.new()
			rotulo.theme_type_variation = &"Display"
			rotulo.text = str(y * grade + x + 1)
			rotulo.position = Vector2(x, y) * celula
			rotulo.size = Vector2(celula, celula)
			rotulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			rotulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			raiz.add_child(rotulo)

	viewport.add_child(raiz)
	no_pai.add_child(viewport)
	await RenderingServer.frame_post_draw
	var imagem := viewport.get_texture().get_image()
	viewport.queue_free()
	return ImageTexture.create_from_image(imagem)
