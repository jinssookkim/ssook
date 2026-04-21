# DDL(Data Definition Language): create, alter, drop, truncate
from oracledb import DatabaseError

from src.oracleutil.connect import get_connection

def create_table():
    with get_connection() as conn:    # DB 접속
        with conn.cursor() as cursor: # Connection 객체 생성
            try:
                sql = 'create table dept_ex as select * from dept'
                cursor.execute(sql)  # SQL 문장 실행
                print('테이블 dept_ex 생성 성공')
            except DatabaseError as e:
                print(e)


def drop_table():
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'drop table dept_ex'
                cursor.execute(sql)
                print('테이블 dept_ex 삭제 성공')
            except DatabaseError as e:
                print(e)


if __name__ == '__main__':
    drop_table()
    create_table()