/*
 * JOIN: 관계형 데이터베이스(RDBMS)에서 2개 이상의 테이블에서 필요한 정보들을 검색하는 방법
 ** RDBMS: Relational Database Management System
 * JOIN의 종류:
 1. (inner) JOIN
 2. outer JOIN
    (1) LEFT (outer) JOIN
    (2) RIGHT (outer) JOIN
    (3) FULL (outer) JOIN
 * JOIN 문법
 1. ANSI 표준 문법:
    SELECT 컬럼, ... 
    FROM 테이블1 [테이블1별명] JOIN종류 테이블2 [테이블2별명] ON JOIN조건; << FROM에서 테이블 별명**
 2. Oracle 문법:
    SELECT 컬럼, ...
    FROM 테이블1 [테이블1별명], 테이블2 [테이블2별명], ... << FROM에서 테이블 별명**
    WHERE JOIN조건;
 */

-- INNER JOIN과 OUTER JOIN의 차이점을 비교하기 위한 데이터 삽입
INSERT INTO emp (empno, ename, sal, deptno)
VALUES (1004, '오쌤', 4500, 50);
COMMIT;

SELECT * FROM emp; -- 사번, 직원이름, 업무, 매니저사번, 입사일, 급여, 수당, 부서번호
SELECT * FROM dept; -- 부서번호, 부서이름, 위치(도시)


-- 직원이름, 부서번호, 부서이름 검색
-- (1) ANSI 표준 문법
SELECT 
    ename, emp.deptno, dname
FROM emp 
    JOIN dept ON emp.deptno = dept.deptno
ORDER BY deptno, ename;
--> 컬럼 이름이 한 테이블에만 있는 경우에는 테이블이름.을 생략해도 됨
--> 컬럼 이름이 두 개 이상의 테이블에 존재하는 경우, 테이블이름.을 생략할 수 없음

-- (2) Oracle 문법
SELECT
    ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno, ename;


-- LEFT (OUTER) JOIN: 직원이름, 부서번호, 부서이름
-- (1) ANSI 문법
SELECT 
    ename, e.deptno, d.deptno, dname
FROM emp e 
    LEFT JOIN dept d ON e.deptno = d.deptno
ORDER BY e.deptno, ename;

-- (2) Oracle 문법
SELECT ename, e.deptno, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno(+);


-- RIGHT (OUTER) JOIN: 직원이름, 부서번호, 부서이름
-- (1) ANSI 문법
SELECT ename, e.deptno, d.deptno, dname
FROM emp e
    RIGHT JOIN dept d ON e.deptno = d.deptno;

-- (2) Oracle 문법
SELECT ename, e.deptno, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;


-- FULL (OUTER) JOIN: 직원이름, 부서번호, 부서이름
-- (1) ANSI 문법
SELECT ename, e.deptno, d.deptno, dname
FROM emp e
    FULL JOIN dept d ON e.deptno = d.deptno;

-- (2) Oracle 문법
-- 오라클에서는 FULL OUTER JOIN 문법을 제공하지 않음!!!!!!!!!
-- 오라클에서는 LEFT OUTER JOIN의 결과와 RIGHT OUTER JOIN의 결과를 ***"합집합(UNION)"***
SELECT ename, e.deptno, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno(+)
UNION
SELECT ename, e.deptno, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;


-- EQUI-JOIN: 조인 조건식이 등호(=)로 작성된 경우
-- NON-EQUI JOIN: 조인 조건식이 부등호(>, >=, <, <=, ...)로 작성된 경우
-- emp와 salgrade 테이블에서 사번, 이름, 급여, 급여등급을 검색(INNER JOIN)
-- (1) ANSI 문법
SELECT empno, ename, sal, grade
FROM emp e 
    JOIN salgrade s ON e.sal >= s.losal and e.sal <= s.hisal;
-- ORDER BY ename;
    
-- (2) Oracle 문법
SELECT empno, ename, sal, grade
FROM emp e, salgrade s
WHERE e.sal between s.losal and s.hisal
ORDER BY grade;

-- SELF-JOIN: 같은 테이블에서 JOIN을 하는 것
-- 직원사번, 직원이름, 매니저사번, 매니저이름 검색
-- INNER JOIN
-- (1) ANSI 문법
SELECT e1.empno 직원사번, 
       e1.ename 직원이름, 
       e1.mgr 매니저사번,
       e2.ename 매니저이름
FROM emp e1
    JOIN emp e2 ON e1.mgr = e2.empno;

-- (2) Oracle 문법
SELECT e1.empno 직원사번, 
       e1.ename 직원이름, 
       e1.mgr 매니저사번,
       e2.ename 매니저이름
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;

-- LEFT OUTER JOIN
-- (1) ANSI 문법
SELECT e1.empno,
       e1.ename,
       e1.mgr,
       e2.ename
FROM emp e1
    LEFT JOIN emp e2 ON e1.mgr = e2.empno;

-- (2) Oracle 문법
SELECT e1.empno 직원사번, 
       e1.ename 직원이름, 
       e1.mgr 매니저사번,
       e2.ename 매니저이름
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno(+);
