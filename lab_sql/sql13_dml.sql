/*
 * DML: INSERT, UPDATE, DELETE
 * DDL, DQL, DML, TCL
 */
 
-- INSERT INTO table_name [(column1, column2, ...)] VALUES (value1, value2, ...);
-- INSERT INTO table_name [(column1, column2, ...)] SELECT 문장;
-- SELECT의 결과를 'table_name'에 삽입(저장). 여러 개의 행들이 한 번에 삽입될 수 있음.

-- bonus 테이블에 이름, 업무, 급여, 수당을 삽입. 값 아무렇게나 넣어보기~
INSERT INTO bonus values ('김진숙', '마케터', 5000, 1200);

-- bonus 테이블에 이름, 급여를 삽입. 
INSERT INTO bonus (ename, sal) values ('천사', 2000);

-- emp 테이블에서 comm이 null이 아닌 직원들의 이름, 업무, 급여, 수당을 bonus 테이블에 삽입하기.
INSERT INTO bonus /* (ename, job, sal, comm) */     -- 생략해도 되는 이유는 emp테이블에서 select하는 순서가 bonus 행에 넣으려고 하는 값의 순서와 똑같기 때문.
SELECT ename, job, sal, comm 
FROM emp
WHERE comm is not null;

COMMIT;

SELECT * FROM bonus;


-- UPDATE 문장: 테이블의 특정 컬럼(들)의 값을 수정(업데이트)
-- UPDATE table_name SET column_name = update_values, ... [WHERE 조건절];
-- WHERE 절은 생략 가능. BUT!!!!!!! WHERE 절을 생략하면 테이블의 ** 모든 행들이 업데이트 ** 됨.

SELECT * FROM emp;

UPDATE emp SET job = 'CLERK' WHERE JOB is null;

-- ROLLBACK: 직전(마지막) COMMIT 상태로 되돌리는 명령어.
-- ROLLBACK;


-- 사번이 1004인 직원의 업무를 MANAGER, 입사일을 오늘 날짜로 업데이트
UPDATE emp 
SET job = 'MANAGER', HIREDATE = sysdate 
WHERE empno = 1004;

COMMIT;

-- 사번이 7369 직원의 급여를 1,000, 수당을 100으로 업데이트
UPDATE emp 
SET sal = 1000, comm = 100
WHERE empno = 7369;

ROLLBACK;

-- 업무가 CLERK인 직원들의 급여를 10% 인상
UPDATE emp
SET sal = sal * 1.1
WHERE job = 'CLERK';

-- 부서 ACCOUNTING 에서 일하는 직원들의 급여를 10% 인상
UPDATE
    (SELECT * FROM emp e JOIN dept d ON e.deptno = d.deptno)
SET sal = sal * 1.1
WHERE dname = 'ACCOUNTING';
-- 선생님 답
UPDATE emp
SET emp
WHERE deptno = (SELECT deptno FROM dept WHERE dname = 'ACCOUNTING');


-- SALGRADE가 1인 직원들의 급여를 20% 인상
UPDATE
    (SELECT * FROM emp e JOIN salgrade s ON e.sal between s.losal and s.hisal)
SET sal = sal * 1.2
WHERE grade = 1;
-- 선생님 답
UPDATE emp
SET sal = sal * 1.2
WHERE sal BETWEEN (SELECT losal FROM salgrade WHERE grade = 1)
            and
            (SELECT hisal FROM salgrade WHERE grade = 1);
-- 선생님 답2
UPDATE emp
SET sal = sal * 1.2
WHERE empno in (
        SELECT e.empno
        FROM empno e
            JOIN salgrade s ON e.sal between s.losal and s.hisal
        WHERE s.grade = 1
);

-- commission이 null인 직원을 찾아서 0으로 업데이트
UPDATE emp
SET comm = 0
WHERE comm is null;

SELECT * FROM emp;

-- emp 테이블에서 부서번호가 dept 테이블에 없는 직원의 부서번호를 null로 업데이트
UPDATE emp
SET deptno = null
WHERE deptno not in (
        SELECT deptno FROM dept);


/* 
 * '=' 연산자의 의미:
  (1) WHERE 절에서의 '=' 연산자: 비교 연산자
     (예) WHERE 컬럼 = 값: 컬럼이 값과 같으면. 
  (2) SET 절에서의 '=' 연산자: 할당(대입) 연산자
     (예) SET 컬럼 = 값: 컬럼에 값을 저장(할당).
  (참고) is 연산자: null인지를 비교할 때 사용하는 비교 연산자. --> 비교에 'x = null' 이라고 하면 false임.
 */


-- DELETE 문장: 테이블에서 (조건을 만족하는) 행(들)을 삭제하는 DML.
-- (비교) TRUNCATE, DROP: DDL
-- (문법) DELETE FROM table_name [WHERE 조건절]
-- 조건절은 생략 가능. 조건절이 없으면 테이블의 모든 행들이 삭제됨.

DELETE FROM emp; --모든 행 삭제
ROLLBACK;

-- 사번이 1004인 직원 정보를 테이블에서 삭제.
DELETE FROM emp WHERE empno = 1004; 

-- 이름이 smith인 직원 정보를 삭제
DELETE FROM emp WHERE ename = 'SMITH'; 

-- 급여 등급이 5인 직원 정보를 삭제
DELETE FROM emp WHERE sal BETWEEN (SELECT losal FROM salgrade WHERE grade = 5) and (SELECT hisal FROM salgrade WHERE grade = 5);

SELECT * FROM emp;

COMMIT;

-- 급여등급이 4인 직원(들)의 정보를 삭제

SELECT e.*, s.* 
FROM emp e
    JOIN salgrade s ON e.sal between s.losal and s.hisal
WHERE s.grade = 4;

DELETE FROM emp
WHERE empno in (
    SELECT empno FROM emp e
                    JOIN salgrade s ON e.sal between s.losal and s.hisal WHERE s.grade = 4
);