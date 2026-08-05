extends Node
## Carrega o conteúdo do jogo (pacotes e ilustrações) de res://dados/pacotes.json.
## Também guarda a seleção atual (pacote/ilustração/grade) para a troca de cenas —
## cenas nunca conversam entre si diretamente, só via autoloads.

const CAMINHO_DADOS := "res://dados/pacotes.json"

## Contexto da partida escolhida na seleção de fase.
## Chaves: "pacote_id", "ilustracao_id", "grade". Vazio = nenhuma seleção.
var selecao: Dictionary = {}

var _dados: Dictionary = {}


func _ready() -> void:
	_carregar()


func grades() -> Array:
	return _dados.get("grades", [3, 4, 6])


func pacotes() -> Array:
	return _dados.get("pacotes", [])


func pacote(id: String) -> Dictionary:
	for p: Dictionary in pacotes():
		if p.get("id", "") == id:
			return p
	return {}


func ilustracao(pacote_id: String, ilustracao_id: String) -> Dictionary:
	for i: Dictionary in pacote(pacote_id).get("ilustracoes", []):
		if i.get("id", "") == ilustracao_id:
			return i
	return {}


func _carregar() -> void:
	var arquivo := FileAccess.open(CAMINHO_DADOS, FileAccess.READ)
	if arquivo == null:
		push_error("Não foi possível abrir %s" % CAMINHO_DADOS)
		return
	var dados: Variant = JSON.parse_string(arquivo.get_as_text())
	if dados is Dictionary:
		_dados = dados
	else:
		push_error("JSON inválido em %s" % CAMINHO_DADOS)
