class_name ModoBase
extends Control
## Interface de modo de jogo plugável. Todo modo (quebra-cabeça, caça-palavras...)
## é uma cena cujo script herda daqui. A cena jogo.tscn hospeda o modo e conversa
## apenas por esta interface — nunca com detalhes internos do modo.

## Emitido quando a fase termina.
signal concluido

## Emitido a cada avanço (ex.: peça encaixada). Sem cronômetro, sem punição.
signal progresso_alterado(atual: int, total: int)


## Inicia a fase. config traz, no mínimo: {"grade": int, "textura": Texture2D}.
func iniciar(_config: Dictionary) -> void:
	push_error("iniciar() deve ser implementado pelo modo de jogo.")


## Aciona uma dica. Tipos padrão: "olho_mostrar", "olho_ocultar", "encaixar".
func usar_dica(_tipo: String) -> void:
	pass
