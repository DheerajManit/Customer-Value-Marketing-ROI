import os
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# =====================================================
# MySQL Configuration
# =====================================================

USERNAME = "root"
PASSWORD = "MySQL@123"
HOST = "127.0.0.1"
PORT = 3306
DATABASE = "ecommerce_analytics"

# =====================================================
# Create Connection
# =====================================================

connection_url = URL.create(
    drivername="mysql+pymysql",
    username=USERNAME,
    password=PASSWORD,
    host=HOST,
    port=PORT,
    database=DATABASE,
)

engine = create_engine(connection_url)

try:
    with engine.connect():
        print("✅ Connected to MySQL Successfully!")
except Exception as e:
    print("❌ Connection Failed")
    print(e)
    exit()

# =====================================================
# CSV Folder
# =====================================================

DATA_FOLDER = "data/raw"

csv_files = [
    "customers.csv",
    "products.csv",
    "campaigns.csv",
    "orders.csv",
    "payments.csv",
    "reviews.csv",
    "returns.csv",
]

# =====================================================
# Import CSV Files
# =====================================================

for csv_file in csv_files:

    file_path = os.path.join(DATA_FOLDER, csv_file)

    if not os.path.exists(file_path):
        print(f"❌ {csv_file} not found.")
        continue

    table_name = csv_file.replace(".csv", "")

    print(f"\n📂 Importing {csv_file}...")

    df = pd.read_csv(file_path)

    # Remove duplicate emails if importing customers
    if table_name == "customers":
        before = len(df)
        df = df.drop_duplicates(subset=["Email"])
        after = len(df)

        if before != after:
            print(f"⚠ Removed {before-after} duplicate customer emails.")

    # Remove duplicate rows (optional safety)
    df = df.drop_duplicates()

    # Import table
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="replace",
        index=False,
    )

    print(f"✅ {table_name} imported successfully.")

print("\n🎉 ALL TABLES IMPORTED SUCCESSFULLY!")