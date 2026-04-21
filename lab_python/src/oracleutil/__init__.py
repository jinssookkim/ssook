from src.oracleutil.connect import get_connection, close_connection
from src.oracleutil.ddl import create_table, drop_table
from src.oracleutil.dql import select_all, select_by_dname, select_by_deptno
from src.oracleutil.dml import insert_dept, update_dept, delete_dept_by_deptno