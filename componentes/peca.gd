class_name Peca
extends Node2D
## Peça de quebra-cabeça. A imagem NUNCA é fatiada em arquivos: a peça é um
## Polygon2D com a textura original inteira e UV mapeado só para a sua região.
## MVP: contorno retangular. As abas bezier entrarão substituindo _gerar_contorno().

var indice: Vector2i          # posição na grade (coluna, linha)
var tamanho: Vector2          # tamanho da célula no tabuleiro, em px
var origem_uv: Vector2        # canto da região da peça na textura, em px
var tamanho_uv: Vector2       # tamanho da região na textura, em px
var encaixada := false

@onready var _poligono: Polygon2D = $Poligono


## Monta a geometria e o mapeamento de textura. Chamar depois de add_child().
func construir(textura: Texture2D, novo_indice: Vector2i, novo_tamanho: Vector2,
		nova_origem_uv: Vector2, novo_tamanho_uv: Vector2) -> void:
	indice = novo_indice
	tamanho = novo_tamanho
	origem_uv = nova_origem_uv
	tamanho_uv = novo_tamanho_uv

	var contorno := _gerar_contorno()
	_poligono.texture = textura
	_poligono.polygon = contorno
	# UV em pixels da textura: cada ponto do contorno é projetado na região da peça.
	var uv := PackedVector2Array()
	for ponto in contorno:
		uv.append(origem_uv + (ponto / tamanho) * tamanho_uv)
	_poligono.uv = uv


## Contorno da peça em coordenadas locais (0..tamanho).
## Futuro: gerar abas bezier por lado (macho/fêmea combinando com as vizinhas)
## e devolver o polígono aproximado — o mapeamento de UV acima já funciona
## para qualquer contorno, inclusive pontos fora do retângulo da célula.
func _gerar_contorno() -> PackedVector2Array:
	return PackedVector2Array([
		Vector2.ZERO,
		Vector2(tamanho.x, 0),
		tamanho,
		Vector2(0, tamanho.y),
	])
