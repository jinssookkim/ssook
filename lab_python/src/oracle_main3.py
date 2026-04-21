import src.oracleutil as orautil


def input_integer(msg):
    while True:
        try:
            number = int(input(msg))  # input으로 받은 값은 무조건 문자열로 반환
            return number
        except ValueError:
            print('입력값은 정수여야 합니다.')


def show_main_menu():
    print()
    print('[0]종료 [1]테이블 생성 [2]테이블 삭제 [3]전체 검색 [4]부서번호 검색 [5]부서이름 검색 [6]신규부서 입력 '
          '[7]업데이트 [8]삭제')
    menu = input_integer('메뉴 선택>> ')
    return menu


def search_by_dept_no():
    dept_no = input_integer('부서번호 입력>> ')
    orautil.select_by_deptno(dept_no)


def search_by_dept_name():
    dept_name = input('부서이름 입력>> ')
    orautil.select_by_dname(dept_name)


def input_new_row():
    number = input_integer('추가할 부서번호 입력>> ')   # deptno는 character가 number임
    name = input('추가할 부서이름 입력>> ')
    location = input('추가할 부서위치 입력>> ')
    orautil.insert_dept(number, name, location)


def update_data():
    number = input_integer('수정할 부서 번호 입력>> ')
    name =  input('새로운 부서 이름 입력>> ')
    location = input('새로운 부서 위치 입력>> ')
    orautil.update_dept(number, name, location)


def delete_data():
    number = input('삭제할 부서 번호 입력>> ')
    orautil.delete_dept_by_deptno(number)


def main():
    run = True
    while run:
        menu = show_main_menu()
        if menu == 0:
            run = False
        elif menu == 1:
            orautil.create_table()  # dept_ex 테이블 생성
        elif menu == 2:
            orautil.drop_table()    # dept_ex 테이블 삭제
        elif menu == 3:
            orautil.select_all()    # dept_ex 테이블 내 전체 검색
        elif menu == 4:
            search_by_dept_no()
        elif menu == 5:
            search_by_dept_name()
        elif menu == 6:
            input_new_row()
        elif menu == 7:
            update_data()
        elif menu == 8:
            delete_data()
        else:
            print('메뉴 번호는 0~8까지 정수만 가능합니다.')

    print('===== 프로그램을 종료합니다. =====')


if __name__ == '__main__':
    main()
