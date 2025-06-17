# ETL Pipeline and Data Warehouse Project - ID/X Partners Data Engineer

## Project Overview

This project aims to build a data warehouse using an ETL pipeline implemented with **SQL Server Management Studio (SSMS 19)** and **Python**. The project consists of the following steps:

1. Create two databases:  
   - A **staging** database for raw data  
   - A **DWH** (Data Warehouse) database for the final structured data

2. Restore backup files and import raw data into the **Staging** database.

3. Design and create **Fact** and **Dimension** tables in the **DWH** database.

4. Perform **Extract** and **Transform** operations using **Python**, with libraries such as `SQLAlchemy` and `pandas`.

5. **Load** the transformed data into the **DWH** database.

6. Create several **Stored Procedures** to support analytical needs such as daily transaction summaries and customer balance reports.

---

## Tools Used

- **SQL Server Management Studio (SSMS) 19**
- **Python** (JupyterLab)
  - `pandas`
  - `SQLAlchemy`
  - `pyodbc`
