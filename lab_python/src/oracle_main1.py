import oracledb


if __name__ == '__main__':
    print('oracledb 패키지 버젼 =', oracledb.__version__)

    # Oracle DB 접속 사용자 아이디
    user = 'scott'
    # Oracle DB 접속 사용자 비밀번호
    password = 'tiger'
    # Oracle DB 서버 정보(이름, IP주소/SID)
    dsn = 'localhost/xe'

    # Oracle DB에 접속
    conn = oracledb.connect(user=user, password=password, dsn=dsn)
    print('connection =', conn)

    # 접속한 DB에서 실행할 SQL 문장. (주의) 문장 끝에 세미콜론(;) 사용 불가
    sql = 'select * from emp'

    # Cursor 객체: DB에 SQL 문장을 전송, 실행 후 그 결과를 처리할 수 있는 객체
    cursor = conn.cursor() # 연결된 DB에서 Cursor 객체를 생성
    print('cursor=', cursor)

    # Cursor 객체를 사용해서 SQL 문장을 실행
    result = cursor.execute(sql)
    print('result =', result)

    # Cursor 객체는 iterable 타입 --> for-in 반복문에서 사용 가능.
    for row in cursor:
        print(row)

    # 사용했던 cursor 객체를 반드시 닫아야 함!!!!!!!!
    cursor.close()
    print('cursor 해제 성공')

    # Oracle DB 접속 해제
    conn.close()
    print('Oracle DB 접속 해제 성공')
