extends Node
## Persistência do progresso em user://progresso.json (com campo de versão
## para migrações futuras). Guarda conclusões por ilustração+grade e também
## as compras (pacotes desbloqueados, remover anúncios) — as fachadas de
## compras/anúncios leem e escrevem por aqui.

const CAMINHO_PROGRESSO := "user://progresso.json"
const VERSAO_PROGRESSO := 1

## conclusoes: { ilustracao_id: [grades concluídas, ex.: [3, 4]] }
var _conclusoes: Dictionary = {}
var _pacotes_comprados: Array = []
var _remover_anuncios := false


func _ready() -> void:
	_carregar()


func concluida(ilustracao_id: String, grade: int) -> bool:
	return grade in _conclusoes.get(ilustracao_id, [])


func registrar_conclusao(ilustracao_id: String, grade: int) -> void:
	var grades: Array = _conclusoes.get(ilustracao_id, [])
	if grade in grades:
		return
	grades.append(grade)
	_conclusoes[ilustracao_id] = grades
	_salvar()


## Quantas fases (ilustração × grade) do pacote já foram concluídas.
func progresso_pacote(pacote_id: String) -> Dictionary:
	var atual := 0
	var total := 0
	var grades: Array = GerenciadorDados.grades()
	for ilustracao: Dictionary in GerenciadorDados.pacote(pacote_id).get("ilustracoes", []):
		for grade in grades:
			total += 1
			if concluida(ilustracao.get("id", ""), grade):
				atual += 1
	return {"atual": atual, "total": total}


func pacote_comprado(id: String) -> bool:
	return id in _pacotes_comprados


func registrar_compra_pacote(id: String) -> void:
	if id in _pacotes_comprados:
		return
	_pacotes_comprados.append(id)
	_salvar()


func remover_anuncios() -> bool:
	return _remover_anuncios


func registrar_remover_anuncios() -> void:
	_remover_anuncios = true
	_salvar()


func _carregar() -> void:
	if not FileAccess.file_exists(CAMINHO_PROGRESSO):
		return
	var arquivo := FileAccess.open(CAMINHO_PROGRESSO, FileAccess.READ)
	if arquivo == null:
		return
	var dados: Variant = JSON.parse_string(arquivo.get_as_text())
	if not dados is Dictionary:
		return
	# versao 1 — quando o formato mudar, migrar aqui conforme dados["versao"].
	var conclusoes: Dictionary = dados.get("conclusoes", {})
	for id: String in conclusoes:
		# JSON devolve floats; normaliza para ints.
		var grades: Array = []
		for g in conclusoes[id]:
			grades.append(int(g))
		_conclusoes[id] = grades
	_pacotes_comprados = dados.get("pacotes_comprados", [])
	_remover_anuncios = dados.get("remover_anuncios", false)


func _salvar() -> void:
	var arquivo := FileAccess.open(CAMINHO_PROGRESSO, FileAccess.WRITE)
	if arquivo == null:
		push_warning("Não foi possível salvar o progresso.")
		return
	arquivo.store_string(JSON.stringify({
		"versao": VERSAO_PROGRESSO,
		"conclusoes": _conclusoes,
		"pacotes_comprados": _pacotes_comprados,
		"remover_anuncios": _remover_anuncios,
	}))
