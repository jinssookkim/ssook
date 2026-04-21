# DQL(Data Query Language): select
from oracledb import DatabaseError

from src.oracleutil.connect import get_connection


def select_all():
    """dept_ex 테이블의 모든 레코드를 검색해서 출력"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'select * from dept_ex'
                cursor.execute(sql)
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)


def select_by_deptno(deptno):
    """부서번호 deptno가 일치하는 레코드를 검색"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'select * from dept_ex where deptno = :id'  # :id는 아규먼트가 들어갈 자리 표현식(변수)
                cursor.execute(sql, id=deptno)
                # > sql 문장에서 :id를 아규먼트 deptno로 대체하고, 완성된 SQL 문장을 실행
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)


def select_by_dname(name):
    """dept_ex 테이블에서 dname 컬럼의 값이 아규먼트 name 문자열을 포함하는 레코드들을 검색"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                # sql = f"select * from dept_ex where lower(dname) like lower('%{name}%')" 도 가능. sql을 f-string 이용해 정의하면 keyword 변수 만들 필요 없음.
                sql = 'select * from dept_ex where lower(dname) like lower(:dept_name)'
                keyword = f'%{name}%'  # name이 문자열이어도 변수로 받아질 때는 작은 따옴표가 사라지기 때문에 다시 f-string으로 묶어줄 수 있음.
                cursor.execute(sql, dept_name=keyword)  # 여기에 dept_name = str(name) 이런 식으로 받을 순 없음. --> 'acc' 자체를 부서 이름으로 가진 데이터가 없으니까.
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)


if __name__ == '__main__':
    # select_all()
    # dno = int(input('부서 번호 입력>> '))
    # select_by_deptno(dno)
    select_by_dname('acc')