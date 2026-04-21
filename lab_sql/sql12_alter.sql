/*
 * ALTER table: 테이블 (정의) 변경.
 1. 이름 변경: ALTER table ... RENAME ... TO ... ;
 2. 추가: ALTER table ... ADD ...;
 3. 삭제: ALTER table ... DROP ...;
 4. 수정: ALTER table ... MODIFY ...;
 */
 
 
-- 1. 이름 변경(RENAME): 테이블 이름, 컬럼 이름, 제약조건 이름 변경
-- (1) 테이블 이름: ALTER TABLE table_name RENAME TO new_table_name;
-- 테이블 ex_students의 이름을 students로 변경
ALTER TABLE ex_students RENAME TO students;

-- (2) 컬럼 이름 변경: ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name;
-- students 테이블의 stu_no 컬럼 이름을 id로 변경
ALTER TABLE students RENAME COLUMN stu_no TO id;

-- students 테이블의 stu_name 컬럼 이름을 name으로 변경
ALTER TABLE students RENAME COLUMN stu_name TO name;

-- (3) 제약조건 이름 변경
-- ALTER TABLE table_name RENAME CONSTRAINT original_name TO new_name;
-- ex_tbl1 테이블의 제약조건 SYS_C008351 이름을 tbl1_pk로 변경
ALTER TABLE ex_tbl1 RENAME CONSTRAINT SYS_C008351 TO tbl1_pk;



-- 2. 추가(ADD): 컬럼 추가, 제약조건 추가
-- (1) 컬럼 추가: ALTER TABLE table_name ADD new_column data_type [DEFAULT CONSTRAINT];
-- students 테이블에 grade 컬럼(2자리 정수)을 추가. 
ALTER TABLE students ADD grade number(2);

-- students 테이블에 email 컬럼(가변길이 문자열 100byte, 기본값 '')을 추가
ALTER TABLE students ADD email varchar2(100) default ''; -- Oracle에서는 ''를 null로 인식함.

INSERT into students (id, name) values (1234, '김길동');
COMMIT;

SELECT * FROM students;

-- (2) 제약조건 추가
-- ALTER TABEL table_name ADD CONSTRAINT constraint_name constraint_content;
-- students 테이블에 id 컬럼에 고유키 제약조건을 추가
ALTER TABLE students ADD CONSTRAINT students_pk primary key (id); 
-- 오류나는 문장. 이미 id 컬럼에 null 값이 있기 때문에 primary key가 될 수 없음.
--> ID가 null인 행(row)들을 먼저 삭제하고 COMMIT한 뒤 primary key 줄 수 있는 윗 문장 실행하기.
DELETE FROM students WHERE id is null;
COMMIT;


-- 3. 삭제(DROP): 컬럼 삭제, 제약조건 삭제
-- (1) 컬럼 삭제
-- ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE students DROP COLUMN birthday;

-- (2) 제약조건 삭제
-- ALTER TABLE table_name DROP CONSTRAINT constraint_name;
ALTER TABLE students DROP CONSTRAINT students_pk;



-- (참고) 메타 테이블: 테이블을 관리하기 위한 테이블. (예) user_tables, user_constraints
SELECT * FROM user_tables;
--> 현재 접속 계정(ssook)에서 생성한 테이블들의 정보를 보여줌.

SELECT table_name FROM user_tables;

-- 'ex_'로 시작하는 모든 테이블 이름들을 찾아보세요
SELECT table_name FROM user_tables WHERE lower(table_name) like 'ex_%';
-- WHERE UPPER(table_name) like 'EX_%';
--> 오라클은 '테이블_이름/컬럼_이름/제약조건_이름'들을 메타 테이블에 저장할 때 대문자로만 저장.
--> 메타 테이블에서 테이블 이름 또는 제약조건 이름을 찾고 싶을 때는 대문자 비교를 사용.

SELECT * FROM user_constraints;

-- ex_tbl1 테이블에 설정된 제약조건 이름, 타입, 내용(search_condition)을 출력
SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE LOWER(table_name) = 'ex_tbl1';

-- 'SYS_'로 시작하는 제약조건 이름들을 찾으세요.
SELECT constraint_name FROM user_constraints
WHERE constraint_name like 'SYS_%';


-- 4. 수정: 컬럼 정의(데이터 타입, 기본값, null 여부, ...) 수정. 
-- ALTER TABLE table_name MODIFY column_name data_type [DEFAULT CONSTRAINT]
-- MODIFY는 제약조건 내용을 변경할 수는 없음!
-- 제약조건 변경은 1) 기존 제약조건 삭제, 2) 새로운 제약조건 추가 단계로 진행해야 함.


-- students 테이블에서 grade 컬럼의 데이터 타입을 number(1)로 변경
ALTER TABLE students MODIFY grade number(1);

-- students 테이블에서 name 컬럼을 20글자까지 저장하도록, null이 되지 않도록 변경
ALTER TABLE students MODIFY name varchar2(20 char) not null;

-- DDL(Data Definition Language): CREATE, ALTER, TRUNCATE, DROP 
-- TRUNCATE TABLE table_name; --> 테이블의 모든 행들을 삭제. 주의!!!!! ROLLBACK이 되지 않음!
SELECT * FROM students;
TRUNCATE TABLE students;

-- DROP TABLE table_name [CASCADE CONSTRAINTS] [PURGE];
DROP TABLE students;
--> 테이블 객체를 휴지통(recycler)에 버림. 
PURGE TABLE students;
--> 휴지통의 테이블 객체를 완전 삭제.

DROP TABLE ex_test PURGE;


-- PK와 FK 관계로 연결된 두 개의 테이블이 있을 때, 삭제 순서가 중요함
-- (1) FK가 설정된 테이블을 먼저 삭제, PK를 가지고 있는 테이블을 나중에 삭제.
-- (2) FK 제약조건을 삭제, 테이블들을 삭제.
-- (3) DROP 테이블에서 연관된 FK 제약조건(들)을 함께 삭제 - cascade constraints

-- ex_dept 테이블에서 id 컬럼이 PK 
-- ex_emp2 테이블에서 dept_id 컬럼에는 ex_dept.id(PK)를 참조하는 FK 제약조건이 설정.
DROP TABLE ex_dept;
--> 에러 발생

DROP TABLE ex_dept CASCADE CONSTRAINTS;
--> (1) ex_emp2 테이블의 FK 제약조건 삭제, (2) ex_dept 테이블을 삭제.

SELECT constraint_name, table_name
FROM user_constraints
WHERE table_name = 'EX_EMP2';

-- (참고) HR계정: employees <----> departments
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE table_name in ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name;

DROP TABLE employees;
DROP TABLE dept;
--> 둘 다 오류
DROP TABLE employees CASCADE CONSTRAINTS;
