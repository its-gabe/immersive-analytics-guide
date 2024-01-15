import pandas as pd
from sqlalchemy import create_engine


# ARQUIVO UTILIZADO APENAS PARA PEGAR OS ARQUIVOS DO MYSQL WORKBENCH E CRIAR O ARQUIVO SQL COM AS QUERIES REALIZADAS 
# NÃO EXECUTE NOVAMENTE POIS CRIARÁ OUTRO ARQUIVO EXCEL COM OS MESMOS DADOS 
# CASO QUEIRA FAZER A SUA PRÓPRIA ANÁLISE, UTILIZE ESSE ARQUIVO MAS MODIFIQUE AS VÁRIAVEIS NECESSÁRIAS PARA CONTER OS SEUS DADOS

user = 'root'
password = '12345'
host = '127.0.0.1'
database = 'e_storex'

# Criando a string de conexão do SQLAlchemy
connection_str = f'mysql+pymysql://{user}:{password}@{host}/{database}'

# Criando uma engine do SQLAlchemy
engine = create_engine(connection_str)

# Lista das queries
queries = [
    """
    SELECT concat(c.fname, ' ',c.lname) AS client_name, cpf, count(client_revision) AS quantity
        FROM clients c 
        LEFT JOIN revision r ON c.idclients = r.client_revision
        GROUP BY client_name, cpf
        ORDER BY quantity DESC;
    """,



    """
    SELECT
        CASE WHEN r.rate > 5 THEN 'high rate'
            WHEN r.rate <= 5 THEN 'low rate'
            END AS rates,
            COUNT(*) AS quantity
        FROM revision r
        GROUP BY rates;
    """,



    """
    SELECT p.p_name, sum(s.quantity) AS total_quantity_sold
        FROM sells s
        INNER JOIN product p ON p.idproduct = s.productid
        GROUP BY idproduct
        ORDER BY total_quantity_sold DESC;
    """,



    """
    SELECT concat(fname, ' ',lname) AS client_name, count(clientid) AS buy_quantity, round(sum(total_price), 2) AS total_expend
        FROM clients c
        INNER JOIN sells s ON c.idclients = s.clientid
        GROUP BY client_name
        ORDER BY total_expend DESC;
    """,




    """
    SELECT concat(c.fname, ' ',c.lname) AS client_name, count(client_revision) AS revision_quantity, r.comentary AS revision_comentary,
            CASE WHEN r.rate > 5 THEN 'high rate'
            ELSE 'low rate'
            END AS rates
        FROM clients c 
        LEFT JOIN revision r ON c.idclients = r.client_revision
        GROUP BY client_name, revision_comentary, rates
        ORDER BY client_name;
    """,



    """
    SELECT p.p_name, sum(s.quantity) AS total_sold, storages.quantity AS total_storage
        FROM sells s
        INNER JOIN product p ON p.idproduct = s.productid
        INNER JOIN storages ON storages.productid = p.idproduct
        GROUP BY idproduct, total_storage
        ORDER BY total_sold DESC;
    """,



    """
    SELECT p.p_name AS product_name, s.quantity AS storage_quantity, 
        CASE 
            WHEN s.quantity >= 1 THEN round((s.quantity * p.price), 2)
            ELSE p.price
        END AS quantity_worth
        FROM product p
        LEFT JOIN storages s ON p.idproduct = s.productid
        ORDER BY quantity_worth DESC;
    """
]

# Lista para armazenar os DataFrames resultantes de cada consulta
result_dataframes = []

# Executar as consultas e armazenar os resultados
for query in queries:
    result_df = pd.read_sql(query, engine)
    result_dataframes.append(result_df)

# Especificar o caminho para o arquivo Excel
excel_file_path = r'queries.xls'

# Salvar todos os DataFrames em folhas diferentes no arquivo Excel
with pd.ExcelWriter(excel_file_path, engine='xlsxwriter') as writer:
    for i, result_df in enumerate(result_dataframes, 1):
        result_df.to_excel(writer, sheet_name=f'Sheet{i}', index=False)

print(f'Dados exportados para {excel_file_path}')