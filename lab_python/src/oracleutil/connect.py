import oracledb

def get_connection():
    user = 'scott'
    password = 'tiger'
    dsn = 'localhost/xe'
    port = 1521
    return oracledb.connect(user=user, password=password, dsn=dsn, port=port)

def close_connection(connection):
    connection.close()

if __name__ == '__main__':
    conn = get_connection()
    print('conn =', conn)

    close_connection(conn)
    print('DB 연결 해제 성공')