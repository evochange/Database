import sqlite3
import pandas as pd

# Ligação à base de dados
conn = sqlite3.connect("evochange.db")
cursor = conn.cursor()

# Ler o excel
excel_file = "DummyData.xlsx"
xls = pd.ExcelFile(excel_file)

# Busca atributos default
def get_defaults(table_name):
    cursor.execute(f"PRAGMA table_info({table_name})")
    return {
        row[1]: row[4]
        for row in cursor.fetchall()
        if row[4] is not None
    }

# Loop por cada sheet do excel
for sheet in xls.sheet_names:

    print(f"Importing {sheet}...")

    df = pd.read_excel(excel_file, sheet_name=sheet)

    defaults = get_defaults(sheet)

    # Converter datas
    for col in df.columns:
        if pd.api.types.is_datetime64_any_dtype(df[col]):
            df[col] = df[col].dt.strftime('%d-%m-%Y')

    # Substituir valores vazios para None
    df = df.astype(object).where(pd.notnull(df), None)

    columns = list(df.columns)

    # Loop por cada linha
    for row in df.itertuples(index=False, name=None):

        filtered_values = []
        filtered_columns = []

        for col, value in zip(columns, row):

            # Se está vazio e existe default, não envia a coluna e ativa o default no sqlite
            if value is None and col in defaults:
                continue

            # Se não, insere
            filtered_columns.append(col)
            filtered_values.append(value)

        placeholders = ", ".join(["?"] * len(filtered_columns))
        column_names = ", ".join(filtered_columns)

        # Criar query final
        sql = f"""
        INSERT OR IGNORE INTO {sheet}
        ({column_names})
        VALUES ({placeholders})
        """

        # Executar a query final
        cursor.execute(sql, filtered_values)

# Guardar e fechar a ligação
conn.commit()
conn.close()

print("Done!")