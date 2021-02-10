import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

#### Funções:
# Função que adiciona o label nas barras e a unidade de porcentagem (%).
def define_label (ax, rects, values):
    for rect, value in zip(rects, values):
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width() / 2, height, f'{value}%', ha='center', va='bottom')


arquivo = './input/spi.classes.pantanal.txt'  # Nome do arquivo a ser utilizado.

# Abertura do arquivo utilizando o separador espaço e adicionando título como primeira linha.
df = pd.read_csv(arquivo, sep= ' ', names=['2019','2020'])
df = df.astype(int)  # Define o conjunto de dados como valor inteiro.

total_classes = 3  # Total de classes avaliada.
classes = ['Eventos Úmidos', 'Eventos Normais', 'Eventos Secos']  # Nome dos rótulos que vão aparecer no eixo x.
ANO_ANTERIOR='2019'
ANO_ATUAL='2020'
ano2019 = df[ANO_ANTERIOR].values  # Valores percentuais.
ano2020 = df[ANO_ATUAL].values  # Valores percentuais.
largura_barra = 0.25  # Largura da barra.

r1 = np.arange(len(classes))  # [0, 1, 2]. Vetor com os índices.
x1 = [y - 0.13 for y in r1]  # [-0.13, 0.87, 1.87]. Valores do eixo x para desenhar a primeira barra.
x2 = [y + 0.13 for y in r1]  # [0.13, 1.13, 2.13]. Valores do eixo x para desenhar a segunda barra.

fig, ax = plt.subplots()

#  Plota o gráfico da primeira barra:
ax.bar(x1, ano2019, width=largura_barra, color='#81d4fa', label=ANO_ANTERIOR)
#  Plota o gráfico da segunda barra:
ax.bar(x2, ano2020, width=largura_barra, color='#dceec8', label=ANO_ATUAL)

# Chama a função para adicionar os valores em cada uma das barras.
define_label(ax, ax.containers[0].patches, ano2019)
define_label(ax, ax.containers[1].patches, ano2020)

#  Formatação do eixo y:
plt.ylim(0, 100)  # Define o mínimo e máximo valor do eixo y.
plt.yticks(fontsize=10)  # Tamanho dos rótulos do eixo y.
plt.tick_params(axis='y', which='both', left=False, right=False, labelleft=False)  # Desabilita os rótulos de ambos os eixos esquerdo e direito.

#  Formatação do eixo x:
plt.xticks(np.arange(total_classes),classes, fontsize=10)  # Rótulos do eixo x e tamanho.

#  Gera a legenda:
plt.legend(frameon =False)  # Desliga a borda da legenda.

#  Salva a figura:
plt.savefig('ex02.jpg', transparent=True, dpi=300, bbox_inches='tight', pad_inches=0)  # Salva a figura no formato ".png" com dpi=300 e remove espaços excedentes.

#  Mostra o gráfico na tela:
#plt.show()
