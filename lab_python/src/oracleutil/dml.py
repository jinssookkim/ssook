# DML(Data Manipulation Language): insert, update, delete
from jedi.inference.gradual.typeshed import try_to_load_stub_cached
from oracledb import DatabaseError

from src.oracleutil.connect import get_connection


def insert_dept(dept_no, dept_name, location):
    """dept_ex 테이블에 새로운 행을 삽입."""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'insert into dept_ex values (:dept_no, :dept_name, :location)'

                # 가변길이 키워드 아규먼트 방식으로 아규먼트들을 전달
                # cursor.execute(sql, dept_no=dept_no, dept_name=dept_name, location=location)

                # positional argument 방식으로 아규먼트들을 전달
                cursor.execute(sql, {      # dict가 또 하나의 argument ==> positional
                    'dept_no': dept_no,    # key(문자열)가 sql문장에서 작성된 parameter, value가 argument.
                    'dept_name': dept_name,
                    'location': location
                })
                conn.commit()
                print('1개 행 삽입 성공')
            except DatabaseError as e:
                print(e)



def update_dept(dept_no, dept_name, location):
    """dept_ex 테이블에서 해당 부서번호(dept_no)의 부서이름(dept_name)과 위치(location)을 업데이트"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'update dept_ex set dname = upper(:dept_name), loc = upper(:location) where deptno = :dept_no'
                cursor.execute(sql, {
                    'dept_no': dept_no,
                    'dept_name': dept_name,
                    'location': location
                })
                conn.commit()
                print(f"부서 '{dept_no}번' 정보 업데이트 성공")
            except DatabaseError as e:
                print(e)

#
def delete_dept_by_deptno(dept_no):
    """dept_ex 테이블에서 해당 부서번호(deptno)의 행을 삭제"""
    # if isinstance(dept_no, int):   # 입력받을 argument가 int여야만 된다는 조건 주기
    #     raise TypeError
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = 'delete from dept_ex where deptno = :dept_no'
                cursor.execute(sql, dept_no=dept_no)

                # positional argument 방식(dict 지정)으로
                #cursor.execute(sql, {'dept_no: dept_no})
                conn.commit()
                print(f'{dept_no} 부서 정보 삭제 성공')
            except DatabaseError as e:
                print(e)



# if __name__ == '__main__':
    # insert_dept(60, 'DEVELOPMENT', 'BUSAN')
    # update_dept(50, 'IT', 'Jeju')
    # delete_dept(60)