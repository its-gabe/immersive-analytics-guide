import pandas as pd

# Ler todas as planilhas do arquivo Excel
excel_file = pd.ExcelFile('queries.xls')

# Obter nomes de todas as planilhas disponíveis
sheet_names = excel_file.sheet_names

dfs={}

for idx, sheet_name in enumerate(sheet_names, start=1):
    dfs[f'df{idx}'] = pd.read_excel('queries.xls', sheet_name)

# CADA DATAFRAME E SUA RESPECTIVA QUERIE
# df1 CLIENTES QUE MAIS FIZERAM REVISÕES
# df2 NOTAS BAIXAS E ALTAS
# df3 QUANTIDADE DE PRODUTOS VENDIDOS
# df4 QUANTO CADA CLIENTE GASTOU NO TOTAL
# df5 COMPRA REALIZADA POR CADA CLIENTE E DEPOIS SE A NOTA DESSA REVISÃO FOI HIGH OU LOW
# df6 QUANTIDADE VENDIDA E A QUANTIDADE DE ESTOQUE QUE O PRODUTO POSSUI
# df7 PRODUTO, QUANTIDADE DE ESTOQUE E QUANTO O ESTOQUE VALE
# df8 NOTA DE CADA CLIENT

# OS 3 KPIS DE ANÁLISE QUE UTILIZAREI NESTE DESAFIO

def calcular_taxa_giro_estoque(dados_venda, dados_estoque):
    turnover_rate = dados_venda / dados_estoque
    return print(f'Taxa de Giro de Estoque: {turnover_rate:.2%}')

def calcular_margem_lucro(custo_produto, preco_venda):
    total_profit = (preco_venda - custo_produto) / preco_venda
    return print(f'Margem de lucro total: {total_profit:.2%}')

def calcular_indice_satisfacao(reviews):
    return print(f'Indice de satisfação: {reviews}')


# ----------------------------------------------------------------------------------------------------------------------------------

# TAXA DE GIRO DE ESTOQUE
sales_data = int(dfs['df4']['total_expend'].sum())  


inventory_data = int(dfs['df7']['quantity_worth'].sum())  


dfs['df7']['product_value'] = dfs['df7']['quantity_worth'] / dfs['df7']['storage_quantity'].fillna(1)


product_values = dfs['df7'][['product_name', 'product_value']]

# calcular_taxa_giro_estoque(sales_data, inventory_data)

# ----------------------------------------------------------------------------------------------------------------------------------

# MARGEM DE LUCRO

# Calcular o custo do produto (assumindo 70% do valor do produto)
product_values['product_cost'] = product_values['product_value']
product_cost = int(product_values['product_cost'].sum() * 0.7)

products_price_total = int(product_values['product_value'].sum())
# calcular_margem_lucro(product_cost, products_price_total)

# ----------------------------------------------------------------------------------------------------------------------------------

# ÍNDICE DE SATISFAÇÃO

media_satisfacao = dfs['df8']['rate'].mean()

# calcular_indice_satisfacao(media_satisfacao)

# ----------------------------------------------------------------------------------------------------------------------------------