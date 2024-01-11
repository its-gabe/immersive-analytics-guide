import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

taxa_giro = 66
margem_lucro = 30
indice_satisfacao = 7.2

data = {'KPI': ['Taxa de Giro de Estoque', 'Margem de Lucro', 'Índice de Satisfação'],
        'Valor': [taxa_giro, margem_lucro, indice_satisfacao]}

df = pd.DataFrame(data)


# Gráfico de Barras para Margem de Lucro
plt.bar(['Margem de Lucro'], [margem_lucro], color='green')
plt.title('Margem de Lucro')
plt.ylabel('Valor (%)')
plt.ylim(0, 100)
plt.show()


# Gráfico de Linhas para Giro de Estoque (mantendo proporção)
tempo = [1, 2, 3, 4, 5]
giro_estoque_tendencia = [5.1, 5.3, 4.9, 5.5, 5.0]
proporcao_inicial = giro_estoque_tendencia[0] / taxa_giro
giro_estoque_ajustado = [taxa_giro * proporcao_inicial * proporcao for proporcao in giro_estoque_tendencia]

plt.plot(tempo, giro_estoque_ajustado, marker='o')
plt.title('Giro de Estoque ao Longo do Tempo (Proporção)')
plt.xlabel('Tempo')
plt.ylabel('Valor (%)')
plt.ylim(0, 100)
plt.show()

# Gráfico de Pizza para Índice de Satisfação
classificacoes = [9,10,5,2,7,7,10,3,9,10]
client_names = ['Alice Smith', 'Bob Johnson', 'Charlie Brown', 'David Wilson', 'Emma Davis', 'Frank Anderson', 'Grace Thomas', 'Henry Miller', 'Ivy Garcia', 'Jack Perez']
labels = [f"{nome}\nNota: {nota}" for nome, nota in zip(client_names, classificacoes)]
plt.pie(classificacoes, labels=labels, autopct='%1.1f%%', startangle=90, colors=plt.cm.viridis(classificacoes))
plt.title('Distribuição de Índice de Satisfação')
plt.show()