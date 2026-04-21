import oracledb


if __name__ == '__main__':
    user = 'scott'  # Oracle DB 접속 계정
    pw = 'tiger'    # Oracle DB 접속 비밀번호
    dsn = 'localhost/xe'  # Oracle DB 서버 이름/SID
    port = 1521     # Oracle DB 서버 포트 번호


    # with-as 구문을 사용한 Connection, Cursor 객체 자동 해제(close)
    with oracledb.connect(user=user, password=pw, dsn=dsn, port=port) as conn:
        with conn.cursor() as cursor:
            sql = 'select * from dept'  # DB에서 실행할 SQL
            cursor.execute(sql)  # SQL 문장을 DB로 전송하고 실행
            for row in cursor:
                print(row)
