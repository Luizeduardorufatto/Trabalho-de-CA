# PROJETO FILTROS PASSIVO DE SEGUNDA ORDEM (WOOFER E TWEETER)

### Projeto e simulação de crossover passivo de segunda ordem butterworth.

## Luiz Eduardo Rufatto

### Este projeto se desenvolve na resolução do problema para o crossover passivo de dois sinais de um sistema de som. A função deste sistema é dividir frequências vindo do amplificador, direcionando baixas frequências para o woofer e altas para o tweeter. O desafio é realizar a filtragem mantendo a fidelidade do sinal e transição suave entre as caixas de som, tudo isto usando as listas com valores definidos, e valores individuais recebidos por cada aluno.

### Objetivos e especificações do projeto: Projetar um filtro Passa-Baixas (LPF) e um Passa-Altas (HPF), ambos de segunda ordem com resposta Butterworth**.

**Parâmetros Designados :**
* **Impedância da Carga ($R_L$):** $8~\Omega$
* **Frequência de Corte ($f_c$):** $2.5~\text{kHz}$

### Funções de Transferência e Fórmulas

#### . Cálculo dos Componentes Ideais

Para Butterworth ($\zeta = 0.707$) na frequência ($\omega_c = 2\pi f_c$):
$$L_{ideal} = \frac{\sqrt{2} \cdot R_L}{\omega_c}$$
$$C_{ideal} = \frac{\sqrt{2}}{\omega_c \cdot R_L}$$

#### . Funções de Transferência
* **LPF (Woofer):** $H(s) = \frac{\omega_c^2}{s^2 + \sqrt{2}\omega_c s + \omega_c^2}$
* **HPF (Tweeter):** $H(s) = \frac{s^2}{s^2 + \sqrt{2}\omega_c s + \omega_c^2}$

### Lógica do Programa
O código apresentado, feito em MATLAB, segue a seguinte linha de raciocínio:
1.  Resolver cálculos : Determina $L$ e $C$ exatos para $2.5~\text{kHz}$ e $8~\Omega$.
2.  Buscar correspondentes próximos: Percorre vetores contendo os valores das séries comerciais e seleciona o componente com a menor diferença quanto ao ideal.
3.  Simulação: Plota os gráfico de Bode, comparando Ideal vs Real, para visualizar o diferencial entre ambos.

### Como executar o código:
. Abra o Matlab online, entre em sua conta, de upload no arquivo do código, com um clique direito do mouse, escolha open in Matlab online, quando aberto, clique em Run no canto superior direito, com isto, no console devem aparecer os textos, e ao lado direito da tela, os gráfico de Bode.
  

### Análise dos Resultados

#### Valores Obtidos
O programa calculou os seguintes valores para atingir $f_c = 2.5~\text{kHz}$:

| Componente | Valor Ideal Calculado | Valor Comercial Selecionado | Erro (%) | <br>
| **Indutor ($L$)** | $0.7203~\text{mH}$ | **$0.68~\text{mH}$** | $5.59\%$ | <br>
| **Capacitor ($C$)** | $11.25~\mu\text{F}$ | **$12~\mu\text{F}$** | $6.62\%$ | <br>


#### Gráficos de Bode 
(Graf1.png)

(Graf2.png)

### Análise Crítica

A substituição dos componentes ideais pelos comerciais geraria grandes alterações notáveis no filtro, como:

. A combinação de $L=0.68~\text{mH}$ e $C=12~\mu\text{F}$ resulta em uma nova frequência de ressonância ($f_0$) de aproximadamente **$1.76~\text{kHz}$**, um desvio de quase $30\%$ em comparação ao ideal de $2.5~\text{kHz}$. O ponto de cruzamento entre o woofer e o tweeter diminui bastante.

. O fator de amortecimento ($\zeta$) do filtro Passa-Baixas real caiu para aproximadamente **$0.47$** (o ideal é $0.707$).

. O desvio de $2.5~\text{kHz}$ para $1.76~\text{kHz}$ alteraria a função dos alto-falantes. O tweeter receberá frequências médias que não suporta bem, e o pico de ressonância causado pelo baixo amortecimento causara distorções no volume nessa faixa de frequência, fazendo o som possivelmente ficar estridente ou esquisito na transição.

### Conclusões
. O projeto atingiu o objetivo, seguiu a metodologia e cálculo pedidos, mas os componentes comerciais foram insuficientes, o filtro real não atingiu a especificação de $2.5~\text{kHz}$ com precisão.
Isso mostra que na prática, muitas vezes não é possível usar apenas valores direto dos cálculos para aplicações que necessitam de precisão. Sem aceitar tolerâncias grandes se tem a necessidade de recorrer a outros componentes , ou associações de componentes (série, paralelo, etc) para obter valores específicos com uma margem infima.
