/*
 * SUB QUERY(서브 쿼리): SQL 문장의 일부로 다른 SQL 문장이 포함되는 것
 (1) SELECT 절의 서브 쿼리
 (2) FROM 절의 서브 쿼리
 (3) WHERE 절의 서브 쿼리
 (4) HAVING 절의 서브 쿼리
 (주의) 서브 쿼리는 반드시 () 안에 작성. 서브 쿼리에서는 세미콜론(;)을 사용하지 않음.
 */
 
 
-- ALLEN의 급여보다 더 많은 급여를 받는 직원 WHO?
-- STEP 1: ALLEN의 급여
SELECT sal FROM emp 
WHERE ename = 'ALLEN';
-- STEP 2: 급여가 1,600보다 많은 직원들
SELECT * FROM emp
WHERE sal > 1600;
-- 서브 쿼리
SELECT * FROM emp
WHERE sal > (
    SELECT sal FROM emp WHERE ename = 'ALLEN'
);

-- 전체 사원의 급여 평균보다 더 많은 급여를 받는 직원들
SELECT * FROM emp
WHERE sal > (
    SELECT AVG(sal) FROM emp
);



-- 1. ALLEN보다 적은 급여를 받는 직원들의 사번, 이름, 급여를 출력
SELECT empno, ename, sal
FROM emp
WHERE sal < (
      SELECT sal FROM emp WHERE ename = 'ALLEN'
);

-- 2. ALLEN과 같은 업무를 담당하는 직원들의 사번, 이름, 부서번호, 업무, 급여를 출력
SELECT empno, ename, deptno, job, sal
FROM emp 
WHERE job = (
     SELECT job FROM emp WHERE ename = 'ALLEN'
);

-- 3. SALESMAN의 급여 최댓값보다 더 많은 급여를 받는 직원들의 사번, 이름, 급여, 업무를 출력
SELECT empno, ename, sal, job
FROM emp
WHERE sal > (
     SELECT MAX(sal) FROM emp WHERE job = 'SALESMAN'
);

-- 4. WARD의 연봉보다 더 많은 연봉을 받는 직원들의 이름, 급여, 수당, 연봉을 출력
--   연봉 = sal * 12 + comm. comm이 null인 경우는 0으로 계산
--   연봉 내림차순 정렬
SELECT 
     ename, sal, comm, 
     sal * 12 + NVL(comm, 0) as 연봉
FROM emp
WHERE sal * 12 + NVL(comm, 0) > (
        SELECT sal * 12 + nvl(comm, 0) as 연봉 
        FROM emp 
        WHERE ename = 'WARD' 
)
ORDER BY 연봉 desc;

-- 5. SCOTT과 같은 급여를 받는 직원들의 이름과 급여를 출력. 단, SCOTT은 제외
SELECT ename, sal
FROM emp
WHERE ename != 'SCOTT' and
      sal = (
      SELECT sal FROM emp WHERE ename = 'SCOTT'
);

-- 6. ALLEN보다 늦게 입사한 직원들의 이름, 입사날짜를 최근입사일부터 출력
SELECT ename, hiredate
FROM emp
WHERE hiredate > (
      SELECT hiredate FROM emp WHERE ename = 'ALLEN'
)
ORDER BY hiredate desc;

-- 7. 매니저가 KING인 직원들의 사번, 이름, 매니저 사번을 검색
SELECT empno, ename, mgr
FROM emp
WHERE mgr = (
     SELECT empno FROM emp WHERE ename = 'KING'
);

-- 8. ACCOUNTING 부서에 일하는 직원들의 이름, 급여, 부서번호를 검색
SELECT ename, sal, deptno 
FROM emp
WHERE deptno = (
     SELECT deptno FROM dept WHERE dname = 'ACCOUNTING' 
);
-- ORDER BY sal desc;

-- 9. CHICAGO에서 근무하는 직원들의 이름, 급여, 부서 번호를 검색
SELECT ename, sal, deptno 
FROM emp
WHERE deptno = (
     SELECT deptno FROM dept WHERE loc = 'CHICAGO' 
);


-- 단일 행 서브 쿼리: 서브 쿼리 결과 행의 갯수가 1개인 경우
-- 단일 행 서브 쿼리는 동등비교(=)를 할 수 있음

-- 다중 행 서브 쿼리: 서브 쿼리의 결과 행의 개수가 2개 이상인 경우
-- 다중 행 서브 쿼리는 동등비교(=)를 할 수 없지만, IN 연산자는 사용할 수 있음!
-- SALESMAN들의 급여와 같은 급여를 받는 직원들?
-- STEP 1: SALESMAN의 급여
SELECT sal FROM emp WHERE job = 'SALESMAN';

-- STEP 2: 급여가 1,600이거나 또는 1,250 또는 1,500인 직원
SELECT * FROM emp
WHERE sal = 1600 OR
      sal = 1250 OR
      sal = 1500;
-- 
SELECT * FROM emp
WHERE sal IN (1600, 1250, 1500);

-- 서브 쿼리
SELECT * FROM emp
WHERE sal IN (
     SELECT sal FROM emp WHERE job = 'SALESMAN'
);

-- 매니저인 직원들?
SELECT * FROM emp
WHERE empno IN (
     SELECT DISTINCT mgr FROM emp
);

-- 매니저가 ** 아닌 ** 직원들
SELECT * FROM emp
WHERE empno not IN (
     SELECT mgr FROM emp -- WHERE mgr is not null
);
-- 결과 행이 한 개도 없음!
-- 조건식 empno IN (a, b, c)는 empno = a or empno = b or empno = c와 같은 의미
-- 조건식 empno not IN (a, b, c)는 empno != a and empno != b and empno != c와 같은 의미
-- IN 연산자는 값을 비교할 때 동등비교 연산자(=, !=)를 사용. null과 비교할 때도 동등비교 연산자를 사용
-- empno = null의 결과도, empno != null 결과도 항상 ** FALSE **
SELECT * FROM emp WHERE mgr != null;


-- 다중 행 서브 쿼리와 EXISTS, NOT EXISTS
-- 매니저인 직원들?
SELECT * FROM emp e1
WHERE EXISTS(
     SELECT * FROM emp E2 WHERE e2.mgr = e1.empno
);

-- 매니저가 아닌 직원들?
SELECT * FROM emp e1
WHERE NOT EXISTS(
     SELECT * FROM emp e2 WHERE e2.mgr = e1.empno
);

-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하는 부서들만!
SELECT * FROM dept d
WHERE EXISTS (
      SELECT * FROM emp e WHERE e.deptno = d.deptno
)
ORDER BY deptno;

-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하지 않는 부서들만!
SELECT * FROM dept d
WHERE NOT EXISTS (
      SELECT * FROM emp e WHERE e.deptno = d.deptno
);


-- 다중 행 서브 쿼리에서 ANY vs ALL
SELECT * FROM emp
WHERE sal > any (
     SELECT sal FROM emp WHERE job = 'SALESMAN'
);
--> 영업사원 급여 최솟값보다 급여를 더 많이 받는 직원들

SELECT * FROM emp
WHERE sal > all (
     SELECT sal FROM emp WHERE job = 'SALESMAN'
);
--> 영업사원 급여 최댓값보다 급여를 더 많이 받는 직원들


-- HAVING 절에서 사용되는 서브 쿼리
-- 업무별 급여의 합계 출력. 단, 영업사원들의 급여 합계보다 큰 경우만 출력
SELECT job, SUM(sal)
FROM emp
GROUP BY job
HAVING SUM(sal) > (
     SELECT SUM(sal) FROM emp WHERE job = 'SALESMAN' 
);
--> 서브 쿼리가 단일 행이기 때문에 비교 가능


-- SELECT 절에서 사용되는 서브 쿼리
-- CLERK들의 사번, 이름, 급여, CLERK 급여의 최솟값, 최댓값 출력
SELECT empno, ename, sal,
       (SELECT MIN(sal) FROM emp WHERE job = 'CLERK') "MIN SAL",
       (SELECT MAX(sal) FROM emp WHERE job = 'CLERK') "MAX SAL"
FROM emp
WHERE job = 'CLERK';


-- FROM 절에서 사용되는 서브 쿼리
-- 이름, 급여, 급여 순위 출력
SELECT
     ename, sal,
     RANK() OVER (ORDER BY sal desc) RANKING
FROM emp;

-- 이름, 입사일, 입사일 순서(내림차순) 출력
SELECT
      ename, hiredate, 
      RANK() OVER (ORDER BY hiredate desc nulls last) RANKING
FROM emp;
--> 오름차순(asc)에서는 null이 가장 마지막에 랭크되지만, 내림차순(desc)에서는 null이 가장 먼저 랭크됨
--> 내림차순 정렬에서 null 값을 마지막에 출력하려면 (ORDER BY 컬럼 desc nulls last) 형식으로 작성


-- 이름, 급여, 급여 순위를 출력. 1~5위까지만 출력.
SELECT 
    t.*
FROM (SELECT ename, sal, 
             RANK() OVER (ORDER BY sal desc) 급여순위
      FROM emp
      ) t
WHERE t.급여순위 <= 5;


-- WITH 식별자 as (서브 쿼리) 구문: 주된 SQL 문장을 간단히 작성하기 위해서
WITH t as (SELECT ename, sal, 
             RANK() OVER (ORDER BY sal desc) 급여순위
      FROM emp)
SELECT t.*
FROM t
WHERE t.급여순위 <= 5;


