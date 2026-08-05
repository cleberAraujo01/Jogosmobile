extends Control
## Tabuleiro: área quadrada centralizada com prévia fantasma da imagem
## e a camada onde as peças encaixadas vivem. Reposiciona tudo ao redimensionar
## (rotação de tela, proporções 16:9 a 20:9).

const ALFA_FANTASMA_PADRAO := 0.08   # prévia sutil sempre visível (wireframe)
const ALFA_FANTASMA_FORTE := 0.4     # ao segurar o botão "olho"

var grade := 4
var tamanho_celula := Vector2.ZERO

@onready var quadro: Panel = %Quadro
@onready var camada_pecas: Node2D = %CamadaPecas
@onready var _fantasma: TextureRect = %Fantasma


func _ready() -> void:
	resized.connect(_relayout)
	_fantasma.modulate.a = ALFA_FANTASMA_PADRAO


func configurar(textura: Texture2D, nova_grade: int) -> void:
	grade = nova_grade
	_fantasma.texture = textura
	for peca in camada_pecas.get_children():
		peca.queue_free()
	_relayout()


func mostrar_fantasma(forte: bool) -> void:
	_fantasma.modulate.a = ALFA_FANTASMA_FORTE if forte else ALFA_FANTASMA_PADRAO


## Canto superior esquerdo da célula, em coordenadas globais de canvas.
func posicao_global_celula(indice: Vector2i) -> Vector2:
	return quadro.global_position + Vector2(indice) * tamanho_celula


func _relayout() -> void:
	var lado := minf(size.x, size.y)
	if lado <= 0.0 or grade <= 0:
		return
	quadro.size = Vector2(lado, lado)
	quadro.position = (size - quadro.size) / 2.0
	tamanho_celula = quadro.size / float(grade)
	# Peças já encaixadas acompanham o novo tamanho por escala.
	for peca in camada_pecas.get_children():
		peca.position = Vector2(peca.indice) * tamanho_celula
		peca.scale = tamanho_celula / peca.tamanho
