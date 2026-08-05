extends Node
## Fachada de anúncios — implementação FALSA (log no console).
## O jogo inteiro fala só com esta fachada; trocar por AdMob depois
## não toca em mais nada.
## Regra de produto: nenhum anúncio interrompe uma partida em andamento.
## mostrar_intersticial() só pode ser chamado entre telas.

signal recompensado_concluido(sucesso: bool)

## Compra única "remover anúncios" silencia intersticiais.
var remover_anuncios_ativo := false

## Intersticial a cada N conclusões (configurável).
var frequencia_intersticial := 3

var _contador_conclusoes := 0


func _ready() -> void:
	# GerenciadorProgresso carrega antes (ordem dos autoloads no project.godot).
	remover_anuncios_ativo = GerenciadorProgresso.remover_anuncios()


## Vídeo recompensado (moedas/dicas). O callback recebe true se a recompensa
## deve ser concedida. Recompensado é opcional e continua disponível mesmo
## com remover_anuncios_ativo (é escolha da jogadora).
func mostrar_recompensado(callback: Callable) -> void:
	print("[Anuncios] Recompensado simulado — concedendo recompensa.")
	callback.call(true)
	recompensado_concluido.emit(true)


## Intersticial entre telas (ex.: ao voltar da conclusão). Nunca durante o jogo.
func mostrar_intersticial() -> void:
	if remover_anuncios_ativo:
		return
	_contador_conclusoes += 1
	if _contador_conclusoes % frequencia_intersticial == 0:
		print("[Anuncios] Intersticial simulado (entre telas).")
