extends Node
## Gerencia o tema visual (claro/escuro) do jogo inteiro.
## Único ponto de verdade para cores: tudo vem dos arquivos .tres em res://temas/.

signal tema_alterado(nome: String)

const CAMINHO_CONFIG := "user://configuracao.json"
const VERSAO_CONFIG := 1

var _tema_claro: Theme = preload("res://temas/tema_claro.tres")
var _tema_escuro: Theme = preload("res://temas/tema_escuro.tres")
var nome_tema: String = "claro"


func _ready() -> void:
	_carregar_configuracao()
	aplicar_tema(nome_tema)


## Aplica o tema pelo nome ("claro" ou "escuro") em tempo real.
func aplicar_tema(nome: String) -> void:
	nome_tema = nome
	get_window().theme = tema_atual()
	_salvar_configuracao()
	tema_alterado.emit(nome_tema)


## Alterna entre claro e escuro.
func alternar_tema() -> void:
	aplicar_tema("escuro" if nome_tema == "claro" else "claro")


func tema_atual() -> Theme:
	return _tema_escuro if nome_tema == "escuro" else _tema_claro


## Consulta uma cor semântica da paleta do tema ativo (tipo "Paleta" no .tres).
## Uso: GerenciadorTema.cor("sobreposicao"), GerenciadorTema.cor("secundaria")...
func cor(nome_cor: StringName) -> Color:
	return tema_atual().get_color(nome_cor, "Paleta")


func _carregar_configuracao() -> void:
	if not FileAccess.file_exists(CAMINHO_CONFIG):
		return
	var arquivo := FileAccess.open(CAMINHO_CONFIG, FileAccess.READ)
	if arquivo == null:
		return
	var dados: Variant = JSON.parse_string(arquivo.get_as_text())
	if dados is Dictionary and dados.get("tema") in ["claro", "escuro"]:
		nome_tema = dados["tema"]


func _salvar_configuracao() -> void:
	var arquivo := FileAccess.open(CAMINHO_CONFIG, FileAccess.WRITE)
	if arquivo == null:
		push_warning("Não foi possível salvar a configuração de tema.")
		return
	arquivo.store_string(JSON.stringify({
		"versao": VERSAO_CONFIG,
		"tema": nome_tema,
	}))
