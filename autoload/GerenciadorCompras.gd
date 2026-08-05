extends Node
## Fachada de compras — implementação FALSA (log no console).
## Trocar por Google Play Billing depois não toca em mais nada.
## A persistência fica no GerenciadorProgresso.

signal compra_concluida(id: String)


func pacote_desbloqueado(id: String) -> bool:
	return GerenciadorProgresso.pacote_comprado(id)


func comprar_pacote(id: String) -> void:
	print("[Compras] Compra simulada do pacote: %s" % id)
	GerenciadorProgresso.registrar_compra_pacote(id)
	compra_concluida.emit(id)


func comprar_remover_anuncios() -> void:
	print("[Compras] Compra simulada: remover anúncios.")
	GerenciadorProgresso.registrar_remover_anuncios()
	GerenciadorAnuncios.remover_anuncios_ativo = true
	compra_concluida.emit("remover_anuncios")


func restaurar_compras() -> void:
	print("[Compras] Restauração de compras simulada.")
