# Sistema de Design — Quebra-Cabeça Bíblico

Base de referência: **1080 x 1920 (retrato)**. Todos os valores em px nessa base.
Público: adultos 35–65, uso noturno, Android intermediário.
Sensação-alvo: papel, madeira clara, luz de fim de tarde, vitral. Sereno, acolhedor, legível.

---

## 1. Paleta de cores

Conceito: base de **papel/pergaminho quente**, primária em **verde-cedro profundo** (calma, madeira, oliveira — evita o azul frio corporativo e o roxo de match-3), secundária em **âmbar-dourado** (luz de fim de tarde, vitral) usada só como acento, nunca como texto sobre fundo claro.

### Tema claro

| Nome semântico        | Hex       | Justificativa |
|-----------------------|-----------|---------------|
| `fundo`               | `#F7F1E5` | Creme de papel envelhecido; descansa o olho, zero branco estourado. |
| `superficie`          | `#FFFDF7` | Papel mais claro para cards; separa do fundo sem borda dura. |
| `superficie_elevada`  | `#FFFFFF` | Modais e popups; camada mais alta da hierarquia. |
| `primaria`            | `#2F5D50` | Verde-cedro profundo: madeira, oliveira, serenidade; passa longe do visual predatório. |
| `primaria_pressionada`| `#234A3F` | Mesma matiz, 20% mais escura — feedback tátil claro. |
| `secundaria`          | `#B8862B` | Âmbar-dourado de vitral; só para acentos, moedas, estrelas e detalhes. |
| `texto_principal`     | `#3A2E24` | Marrom-café quase preto: legível e mais quente que `#000`. |
| `texto_secundario`    | `#6B5D4F` | Marrom médio para legendas; ainda passa de 4.5:1. |
| `sucesso`             | `#4A7C59` | Verde-folha discreto; celebra sem gritar. |
| `atencao`             | `#A85428` | Terracota; alerta caloroso, não vermelho de urgência. |
| `borda`               | `#DED3BE` | Bege-areia; delimita sem pesar. |
| `sobreposicao`        | `#3A2E24` a 60% | Escurece o fundo sob modais mantendo o tom quente. |

### Tema escuro (noturno — uso principal)

Marrom-carvão quente, **não** preto puro (preto puro + OLED gera smearing e é frio demais).

| Nome semântico        | Hex       | Justificativa |
|-----------------------|-----------|---------------|
| `fundo`               | `#211B14` | Marrom-carvão: escuro o bastante para a noite, quente como madeira à luz de vela. |
| `superficie`          | `#2B241C` | Um degrau acima do fundo. |
| `superficie_elevada`  | `#362E24` | Modais; elevação por clareamento, sem sombras pesadas. |
| `primaria`            | `#7FB89E` | Sálvia clara: a mesma família do verde-cedro, invertida para brilhar no escuro sem estourar. |
| `primaria_pressionada`| `#639C83` | Escurece ao toque. |
| `secundaria`          | `#D9A94E` | Âmbar mais luminoso para manter o dourado visível à noite. |
| `texto_principal`     | `#EFE6D8` | Creme (não branco puro): conforto em tela escura. |
| `texto_secundario`    | `#B3A692` | Bege médio, ainda acima de 4.5:1. |
| `sucesso`             | `#8FBF9B` | Verde-folha claro. |
| `atencao`             | `#D98B5A` | Terracota clara. |
| `borda`               | `#453B2E` | Sutil, apenas estrutura. |
| `sobreposicao`        | `#000000` a 55% | Sob modais. |

### Contrastes verificados (WCAG)

| Par | Razão | Status |
|-----|-------|--------|
| Claro: `texto_principal` #3A2E24 sobre `fundo` #F7F1E5 | **11,7:1** | AAA |
| Claro: `texto_secundario` #6B5D4F sobre `fundo` #F7F1E5 | **5,6:1** | AA ✓ |
| Claro: texto branco #FFFDF7 sobre `primaria` #2F5D50 | **7,5:1** | AAA |
| Claro: `atencao` #A85428 sobre `fundo` | **4,6:1** | AA ✓ |
| Escuro: `texto_principal` #EFE6D8 sobre `fundo` #211B14 | **13,6:1** | AAA |
| Escuro: `texto_secundario` #B3A692 sobre `fundo` #211B14 | **7,1:1** | AAA |
| Escuro: texto escuro #211B14 sobre `primaria` #7FB89E | **7,5:1** | AAA |

Regra derivada: `secundaria` (dourado) **nunca** é usada como cor de texto sobre `fundo`/`superficie` no tema claro (ficaria ~3:1). Dourado só em ícones grandes (≥48px), preenchimentos e detalhes decorativos, sempre acompanhado de rótulo em `texto_principal`.

Cor nunca é a única informação: estados usam cor **+ ícone + texto** (ex.: fase bloqueada = cadeado + rótulo "Bloqueada", não só card acinzentado).

---

## 2. Tipografia

Duas famílias, ambas Google Fonts / licença OFL (uso comercial livre):

- **Lora** (serifada) — títulos e versículos. Serifa calorosa de inspiração caligráfica; dá o tom devocional e "de livro" sem parecer infantil nem fria.
- **Nunito Sans** (sem serifa) — interface. Humanista, aberta e muito legível em telas; arredondada o suficiente para acolher, sem ser "gordinha" de jogo infantil.

### Escala (base 1080 de largura — mínimo absoluto 32px)

| Papel      | Família     | Tamanho | Peso     | Altura de linha | Uso |
|------------|-------------|---------|----------|-----------------|-----|
| `display`  | Lora        | 64px    | SemiBold | 1.25 (80px)     | Título do jogo, versículo na conclusão. |
| `titulo`   | Lora        | 48px    | SemiBold | 1.3 (62px)      | Títulos de tela, nome do pacote. |
| `subtitulo`| Nunito Sans | 40px    | Bold     | 1.3 (52px)      | Seções, nome da fase. |
| `corpo`    | Nunito Sans | 34px    | Regular  | 1.5 (51px)      | Texto corrido, descrições. |
| `legenda`  | Nunito Sans | 32px    | SemiBold | 1.4 (45px)      | Metadados, contadores. Piso da escala. |
| `botao`    | Nunito Sans | 36px    | Bold     | 1.2 (43px)      | Rótulos de botão. Sem CAIXA ALTA (mais difícil de ler). |

Versículos: Lora **Italic** no tamanho `display` ou `titulo` conforme o comprimento; referência (ex.: "Salmos 23:1") em Lora Regular `legenda`+cor `texto_secundario`.

---

## 3. Espaçamento e raios

**Escala de espaçamento (px):** `4, 8, 16, 24, 32, 48, 64, 96`
- Margem lateral de tela: **48**
- Entre cards de uma lista: **24**
- Padding interno de card: **32**
- Entre ícone e rótulo: **16**
- Respiro acima/abaixo de títulos: **48 / 32**

**Raios de canto (px):** `12` (chips, badges) · `16` (botões, campos) · `24` (cards) · `32` (modais) · `pill` (barras de progresso, toggle)

Cantos generosos mas não circulares — "papel com cantos aparados", não bolha.

---

## 4. Componentes

Estados padrão de todos: `normal`, `pressionado`, `desabilitado`, e onde couber `bloqueado`.
Área tocável mínima universal: **120x120**. Feedback de toque universal: mudança de cor + leve escala (0.97) em 80ms — nada de brilhos ou partículas em botões.

### Botão primário
- Dimensões: altura **144**, largura mínima 480, raio 16. Padding horizontal 48.
- Fundo `primaria`, texto branco-papel (#FFFDF7 claro / #211B14 escuro sobre sálvia), fonte `botao`.
- Pressionado: `primaria_pressionada` + escala 0.97.
- Desabilitado: fundo `borda`, texto `texto_secundario` a 70%, sem sombra. (Contraste reduzido é aceitável em desabilitado, mas mantém ≥3:1.)
- Um por tela, no máximo. É a ação que queremos que a jogadora encontre sem procurar.

### Botão secundário
- Mesmas dimensões. Fundo transparente, borda 3px em `primaria`, texto `primaria`.
- Pressionado: fundo `primaria` a 12%.
- Desabilitado: borda e texto em `borda`/`texto_secundario` a 70%.

### Botão de ícone
- **120x120**, raio 16 (ou círculo no tabuleiro). Ícone 56x56 centralizado, cor `texto_principal` (ou `primaria` quando é ação).
- Fundo `superficie` com borda 2px `borda`; pressionado: fundo `borda`.
- Sempre com `tooltip`/rótulo acessível; ícones ambíguos (dica, olho) ganham rótulo de texto embaixo (`legenda`).

### Card de pacote
- Largura: tela − 96 (margens). Altura ~560. Raio 24. Fundo `superficie`, borda 2px `borda`.
- Topo: ilustração de capa (proporção 16:9, cantos superiores arredondados).
- Corpo (padding 32): nome em `titulo`, "12 de 20 concluídas" em `legenda` + barra de progresso.
- Bloqueado (pago): capa com `sobreposicao` a 40%, ícone cadeado 64px + selo de preço em `superficie_elevada` com texto `texto_principal`. **Sem** dourado piscando.
- Pressionado: escala 0.98.

### Card de fase (grade de seleção)
- **312x312** (3 por linha com margens 48 e espaços 24), raio 24.
- Miniatura da ilustração; embaixo, chip com a grade ("4x4") em `legenda`.
- Concluída: check 40px em `sucesso` no canto + miniatura colorida.
- Não iniciada: miniatura em 30% de saturação (prévia parcial — mantém curiosidade sem esconder tudo).
- Bloqueada: cadeado + rótulo "Bloqueada"; miniatura com sobreposição.
- Pressionado: escala 0.97.

### Barra superior
- Altura **160** (inclui respiro para status bar). Fundo `fundo` (integrada, sem sombra; divisor 1px `borda` só quando a lista rola por baixo).
- Esquerda: botão de ícone "voltar". Centro: título da tela (`subtitulo`). Direita: indicador de moedas e/ou configurações.

### Popup modal
- Largura: tela − 128. Raio 32. Fundo `superficie_elevada`, padding 48. Surge sobre `sobreposicao`.
- Título `titulo` centralizado, corpo `corpo`, até 2 botões empilhados (primário em cima, secundário embaixo, espaço 24).
- Fechar: botão X (120x120) no canto superior direito **e** toque na sobreposição. Nunca prender a jogadora.
- Animação: fade + escala 0.95→1.0 em 180ms.

### Toast
- Parte inferior, acima da área de gesto (margem inferior 96). Fundo `superficie_elevada`, raio pill, padding 32x24, texto `corpo`, ícone opcional 40px.
- Duração 2,5s, fade in/out. Nunca cobre botões de ação.

### Barra de progresso
- Altura **20**, raio pill. Trilho `borda`, preenchimento `primaria` (ou `sucesso` quando 100%).
- Sempre acompanhada de texto ("12/20") — a cor não é a única informação.

### Indicador de moedas
- Chip: altura 88, raio pill, fundo `superficie`, borda 2px `borda`.
- Ícone moeda 48px em `secundaria` + valor em `legenda` `texto_principal`. Padding 24x16.
- Tocável (leva à loja): área expandida para 120 de altura via margem invisível.
- Ganho de moedas: contagem animada de ~400ms; **sem** chuva de moedas.

---

## 5. Ícones

`recursos/icones/*.svg` — 16 ícones, grade **48x48**, traço 4px, pontas e junções arredondadas, monocromáticos (`#000`, prontos para colorir pelo tema via modulate/ícone de Theme). Sem preenchimento; estilo de linha única, consistente com a serenidade do jogo.

`voltar, menu, configuracoes, som_ligado, som_desligado, dica, moeda, cadeado, estrela, olho, calendario, loja, reiniciar, check, fechar, compartilhar`

Uso típico: 56x56 em botões de ícone, 40–48 em chips e cards, 64 em estados vazios/bloqueio.

---

## 6. Wireframes

Convenções: `[ ]` botão, `( )` ícone, `═` destaque primário.

### Splash
```
┌──────────────────────────────┐
│                              │
│                              │
│         (logotipo)           │   Ilustração suave ao fundo (vitral desfocado)
│      Nome do Jogo (Lora)     │   Sem barra de progresso se carregar < 2s;
│                              │   senão, barra fina na parte inferior.
│                              │
│        "carregando..."       │
└──────────────────────────────┘
```

### Menu principal
```
┌──────────────────────────────┐
│ (config)          (moedas 🅒)│  barra superior
│                              │
│      Ilustração do dia       │  destaque: última fase jogada
│      (card grande, capa)     │  ou próxima sugerida — "Continuar"
│                              │
│ ══[ Continuar / Jogar ]══    │  botão primário
│                              │
│  [ (calendario) Desafio ]    │  secundário — desabilitado no MVP
│  [ (loja) Pacotes ]          │  secundário
│                              │
└──────────────────────────────┘
```
Hierarquia: uma ação dominante ("Continuar"), resto discreto. Sem carrossel de promoções.

### Mapa de pacotes
```
┌──────────────────────────────┐
│ (voltar)  Pacotes   (moedas) │
│ ┌──────────────────────────┐ │
│ │ [capa: Salmos]           │ │  card de pacote
│ │ Salmos   ▓▓▓▓░░ 12/20    │ │
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ [capa 40% + (cadeado)]   │ │  pacote pago
│ │ Parábolas   R$ 9,90      │ │
│ └──────────────────────────┘ │
│           (rolagem ↓)        │
└──────────────────────────────┘
```

### Seleção de fase
```
┌──────────────────────────────┐
│ (voltar)  Salmos    (moedas) │
│  Ilustração: "O Bom Pastor"  │  ao tocar uma ilustração, escolhe a grade
│ ┌─────┐ ┌─────┐ ┌─────┐      │
│ │ 3x3 │ │ 4x4 │ │ 6x6 │      │  cards de fase (312x312)
│ │ (✓) │ │     │ │(cad)│      │  ✓=concluída, cadeado=bloqueada
│ └─────┘ └─────┘ └─────┘      │
│ ┌─────┐ ┌─────┐ ┌─────┐      │
│ │ 8x8 │ │10x10│ │12x12│      │
│ └─────┘ └─────┘ └─────┘      │
└──────────────────────────────┘
```

### Tela de jogo
```
┌──────────────────────────────┐
│ (voltar)  4x4        (olho)  │  olho = ver imagem completa (dica)
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │      TABULEIRO           │ │  área guia com contorno sutil `borda`
│ │      (imagem-alvo)       │ │  e prévia fantasma a ~8% de opacidade
│ │                          │ │
│ └──────────────────────────┘ │
│  (dica 🅒)                    │  dica paga: encaixa uma peça
│ ┌──────────────────────────┐ │
│ │ ◄ [peça][peça][peça] ►   │ │  bandeja rolável
│ └──────────────────────────┘ │
└──────────────────────────────┘
```
Zero cronômetro, zero contador de erros. A UI do jogo é a mais silenciosa de todas.

### Conclusão
```
┌──────────────────────────────┐
│                              │
│    Imagem completa (brilho   │  animação de união + luz suave
│    suave, moldura fina)      │
│                              │
│   "O Senhor é o meu pastor;  │  versículo — Lora Italic, display
│    nada me faltará."         │
│         Salmos 23:1          │  referência — legenda, texto_secundario
│                              │
│  ══[ Próxima fase ]══        │
│  [ (compartilhar) ] [ menu ] │
└──────────────────────────────┘
```
O versículo é a recompensa — ocupa o palco, sem estrelas pulando na frente.

### Desafio diário (pós-MVP)
```
┌──────────────────────────────┐
│ (voltar)  Desafio de hoje    │
│    (calendario)  4 de agosto │
│    Ilustração misteriosa     │  prévia borrada/silhueta
│    "Complete para revelar    │
│     o versículo de hoje"     │
│  ══[ Jogar desafio ]══       │
│  ✓ seg ✓ ter · qua …         │  sequência da semana (check + texto)
└──────────────────────────────┘
```

### Loja (pós-MVP)
```
┌──────────────────────────────┐
│ (voltar)  Loja      (moedas) │
│ ┌──────────────────────────┐ │
│ │ Remover anúncios  R$ X   │ │  card destacado, uma vez só
│ └──────────────────────────┘ │
│  Pacotes de ilustrações      │
│  [cards de pacote pagos]     │
│  Moedas                      │
│  [ (video) +50 assistindo ]  │  recompensado — claro e honesto
└──────────────────────────────┘
```

### Configurações
```
┌──────────────────────────────┐
│ (voltar)  Configurações      │
│  Tema        [Claro|Escuro|  │  seletor de 3 estados (Auto = sistema)
│               Auto]          │
│  Som         (som_ligado) ⬤─ │  toggle grande (pill)
│  Música      (som_ligado) ─⬤ │
│  ──────────────────────────  │
│  Remover anúncios  [botão]   │
│  Restaurar compras           │
│  Política de privacidade     │
└──────────────────────────────┘
```

---

## 7. Movimento

Princípio único: **calmo e curto**. Easing suave (ease_out), durações 120–250ms. A única animação longa permitida é a celebração de conclusão (~1,5s de brilho + união das peças). Nada pisca, nada pulsa, nada treme para chamar atenção.
