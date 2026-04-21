/*
 * SQL 문장의 종류:
 1. DDL(Data Definition Language): CREATE, ALTER, TRUNCATE, DROP
 2. DQL(Data Query Language): SELECT
 3. DML(Data Manipulation Language): INSERT, UPDATE, DELETE
 4. TCL(Transaction Control Language): COMMIT, ROLLBACK
 
 * 테이블 생성하기:
 CREATE table 테이블이름 (
                        컬럼이름 데이터타입 [[기본값] [제약조건]],
        .....
 );
 

 * 데이터 타입으로 사용되는 키워드들은 데이터베이스 종류에 따라서 다를 수 있음.
 오라클의 데이터 타입: number, varchar2(가변길이 문자열), date, timestamp
                      clob(character large object), blob(binary large object), ...
 */
 

/* 
 * 테이블 이름: ex_students
 * 컬럼:
     (1) stu_no: 아이디(학번). 숫자 타입(4자리 정수)
     (2) stu_name: 학생 이름. 문자열 타입(최대 10글자)
     (3) birthday: 학생 생일. 날짜 타입
 */ 
 
CREATE table ex_students (
        stu_no number(4, 0), 
        stu_name varchar2(10 char), 
        birthday date 
);

/*
 * 테이블에 행(row)을 삽입(저장):
   INSERT INTO 테이블이름 (컬럼이름, ...) values (값, ...);
 
 * 테이블에 삽입하는 값들의 개수가 컬럼 개수와 같고 값들의 순서가 테이블 컬럼 순서와 같으면,
 INSERT INTO 테이블이름 values(값, ...);
 */
 
INSERT INTO ex_students (stu_no, stu_name, birthday)
values (1001, '홍길동', '2025/11/27');

-- 테이블의 모든 컬럼에 테이블 컬럼 순서대로 값들을 삽입(저장)
INSERT INTO ex_students values (1002, '오쌤', '2000/12/01');
-- INSERT INTO ex_students values (2002, '김길동') --> 오류

SELECT * FROM ex_students;

-- INSERT INTO에서 컬럼 순서들은 테이블 컬럼 순서와 같아야 할 필요는 없음
INSERT INTO ex_students (birthday, stu_name, stu_no)
values ( '2010/01/01', 'SCOTT', 2000);
-- INSERT INTO ex_students values ('2025/11/27', 1234, '홍길동') --> 오류


-- 제약조건이 없으면 테이블의 모든 컬럼에 값을 삽입할 필요는 없음
INSERT INTO ex_students (stu_no, stu_name)
values (2001, 'KING');

COMMIT;
--> 커밋: DB에서 작업한(변경한) 내용을 영구적으로 저장 


--INSERT INTO ex_students (stu_no)
--values (12345);
--> 오류. stu_no에 저장할 수 있는 자릿수(4자리)보다 큰 값을 삽입하려고 해서.

-- varchar2 타입의 단위: byte(기본값) vs char
-- varchar2(10)는 varchar2(10 byte)와 같다.
-- 오라클에서 문자를 저장할 때 UTF-8 인코딩 타입을 사용하는 경우,
-- 영문자, 숫자, 특수기호 -> 1글자를 저장할 때 1byte를 사용함.
-- 한글 --> 1글자를 저장할 때 3byte를 사용함.
-- 테이블 컬럼의 데이터 타입이 varchar2(n char)인 경우, 한글/영문 상관없이 n개까지 문자를 저장할 수 있음.
-- 컬럼 데이터 타입이 varchar2(n byte)인 경우, 저장할 수 있는 한글/영문 문자 개수가 달라짐.

INSERT INTO ex_students (stu_name) values ('123456789');
-- INSERT INTO ex_students (stu_name) values ('01234567890');
--> 글자 수가 큼

INSERT INTO ex_students (stu_name) values ('가나다라마바사아자차');

COMMIT;

CREATE table ex_byte (
      col_str varchar(5)  -- varchar2(5 byte)와 같은 의미
);

INSERT INTO ex_byte values ('abc12');
-- 문자열 'abc12'의 길이는 5바이트이기 때문에 insert가 성공함.

-- INSERT INTO ex_byte values ('홍길동') --> 오류. 5byte 초과함.

COMMIT;


-- CREATE table 연습: emp 테이블과 같은 이름, 같은 타입의 컬럼들을 갖는 테이블 생성.
-- 테이블 이름: ex_emp

CREATE table ex_emp (
        empno       number(4, 0),
        ename       varchar2(10 byte),
        job         varchar(9 byte),
        mgr         number(4, 0),
        hiredate    date,
        sal         number(7, 2), --> 전체 자릿수 7, 정수 자릿수 5, 소수점 이하 자릿수 2.
        comm        number(7, 2),
        deptno      number(2, 0)
);


-- CREATE table as SELECT 구문: 테이블을 생성하면서 기존 테이블의 내용을 복사.
CREATE table dept_copy
as SELECT * FROM dept;

SELECT * FROM dept_copy;

-- dept 테이블 구조(컬럼 & 데이터 타입)는 복사, 데이터는 복사하지 않기.
CREATE table dept_copy2 
as SELECT * FROM dept WHERE deptno = -1;


-- emp 테이블에서 10번 부서 직원들의 사번, 이름, 부서번호, 급여를 복사한 테이블 생성
CREATE table emp_copy1
as SELECT empno, ename, deptno, sal FROM emp;


-- emp_copy2: emp 테이블과 dept 테이블을 INNER JOIN해서 emp 테이블의 모든 컬럼과 부서 이름, 위치 컬럼을 갖는 테이블 생성
CREATE table emp_copy2 as 
    SELECT e.*, d.dname, d.loc 
    FROM emp e
        JOIN dept d ON e.deptno = d.deptno
    ORDER BY e.empno;
                
SELECT * FROM emp_copy2;

-- CREATE table-as SELECT는 물리적인 테이블을 생성.
-- view: 가상 테이블
CREATE view vw_emp_dept as
    SELECT e.*, d.dname, d.loc
    FROM emp e 
        JOIN dept d ON e.deptno = d.deptno
    ORDER BY e.empno;

SELECT * FROM vw_emp_dept;

