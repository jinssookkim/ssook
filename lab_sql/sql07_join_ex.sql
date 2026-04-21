/*
 * JOIN 연습문제
 */
 
 
-- EX1. 직원 이름, 근무 도시를 검색. 도시 이름으로 정렬. (모든 JOIN비교)
-- 1) JOIN
SELECT ename, loc
FROM emp e
    JOIN dept d ON e.deptno = d.deptno
ORDER BY loc;

-- 2) LEFT
SELECT ename, loc
FROM emp e
    LEFT JOIN dept d ON e.deptno = d.deptno
ORDER BY loc;

-- 3) RIGHT
SELECT ename, loc
FROM emp e
     RIGHT JOIN dept d ON e.deptno = d.deptno
ORDER BY loc;

-- 4) FULL
SELECT ename, loc
FROM emp e
     FULL JOIN dept d ON e.deptno = d.deptno
ORDER BY loc;
-- Oracle 방식
SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno(+)
UNION
SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
ORDER BY loc;


-- EX2. 직원 이름, 매니저 이름, 직원 급여, 직원 급여 등급 검색
-- 정렬 순서: (1) 매니저, (2) 급여 등급 
-- INNER JOIN
SELECT
      e1.ename "직원 이름",
      e2.ename "매니저 이름",
      e1.sal "직원 급여",
      s.grade "직원 급여 등급"
FROM emp e1, emp e2, salgrade s
WHERE e1.mgr = e2.empno and
      e1.sal between s.losal and s.hisal
ORDER BY "매니저 이름", "직원 급여 등급";

/*                        ----------------------- ANSI 표준 문법
SELECT
     e1.*, e2.*, s.*
FROM emp e1
     JOIN emp e2 ON e1.mgr = e2.empno
     JOIN salgrade s ON e1.sal between s.losal and s.hisal;
*/

-- LEFT JOIN
SELECT
      e1.ename "직원 이름",
      e2.ename "매니저 이름",
      e1.sal "직원 급여",
      s.grade "직원 급여 등급"
FROM emp e1, emp e2, salgrade s
WHERE e1.mgr = e2.empno(+) and
      e1.sal between s.losal(+) and s.hisal(+)
ORDER BY "매니저 이름", "직원 급여 등급";

/*                        ----------------------- ANSI 표준 문법
SELECT
      e1.ename "직원 이름",
      e2.ename "매니저 이름",
      e1.sal "직원 급여",
      s.grade "직원 급여 등급"
FROM emp e1
     LEFT JOIN emp e2 ON e1.mgr = e2.empno
     JOIN salgrade s ON e1.sal between s.losal and s.hisal;
--> LEFT를 쓰든 LEFT 생략하고 JOIN만 쓰든 상관 없음
*/

-- RIGHT JOIN --> 누군가의 매니저가 아닌 직원들도 검색됨. e1.mgr = e2.empno 조건 붙였을 때, e2에서 empno가 다 보여야 하니까 붙여지는 e1테이블의 다른 값은 NULL이 됨. --> INNER랑 같은 값을 도출
SELECT
      e1.ename "직원 이름",
      e2.ename "매니저 이름",
      e1.sal "직원 급여",
      s.grade "직원 급여 등급"
FROM emp e1, emp e2, salgrade s
WHERE e1.mgr(+) = e2.empno and
      e1.sal between s.losal and s.hisal
ORDER BY "매니저 이름", "직원 급여 등급";

/*                        ----------------------- ANSI 표준 문법
SELECT
      e1.ename "직원 이름",
      e2.ename "매니저 이름",
      e1.sal "직원 급여",
      s.grade "직원 급여 등급"
FROM emp e1
     RIGHT JOIN emp e2 ON e1.mgr = e2.empno
     RIGHT JOIN salgrade s ON e1.sal between s.losal and s.hisal;
*/

/*
SELECT e1.*, e2.*
FROM emp e1
     JOIN emp e2 ON e1.mgr = e2.;
 */


-- EX3. 직원 이름, 부서 이름, 급여, 급여 등급 검색
-- 정렬 순서: (1) 부서 이름, (2) 급여 등급
SELECT
      ename "직원 이름",
      dname "부서 이름",
      sal "직원 급여",
      grade "급여 등급"
FROM emp e, dept d, salgrade s
WHERE e.deptno = d.deptno and
      e.sal between s.losal and s.hisal
ORDER BY "부서 이름", "급여 등급";


-- EX4. 부서 이름, 부서 위치, 부서의 직원 수 검색. 부서 번호 오름차순
SELECT
     dname, loc, count(e.empno) --> *(all)은 loc에 대한 all이 잡혀서
FROM emp e
     FULL JOIN dept d ON e.deptno = d.deptno
GROUP BY e.deptno, dname, loc
ORDER BY e.deptno;


-- EX5. 부서 번호, 부서 이름, 부서 직원수, 부서의 급여 최솟값/최댓값 검색
-- 부서 번호 오름차순
SELECT 
      E.deptno, dname, COUNT(*), MIN(sal), MAX(sal) 
FROM emp e
     LEFT JOIN dept d ON e.deptno = d.deptno
GROUP BY e.deptno, dname
ORDER BY deptno;


-- EX6. 부서 번호, 부서 이름, 사번, 직원 이름, 매니저 사번, 매니저 이름
-- 직원 급여, 직원 급여 등급 검색 
-- 급여가 2,000 이상인 직원들만 검색
-- 정렬 순서: (1) 부서 번호, (2) 사번
---------------------------------------------------------- Oracle 문법
SELECT
      e1.deptno as "부서 번호",
      d.dname as "부서 이름",
      e1.empno as "사번",
      e1.ename as "직원 이름",
      e1.mgr as "매니저 사번",
      e2.ename as "매니저 이름",
      e1.sal as "직원 급여",
      s.grade as "직원 급여 등급"
FROM emp e1, emp e2, dept d, salgrade s
     -- FULL JOIN emp e2, dept d ON e1.mgr = e2.empno --and e1.deptno = d.deptno 
WHERE e1.sal >= 2000 and
      e1.mgr = e2.empno and
      e1.deptno = d.deptno and
      e1.sal between s.losal and s.hisal
ORDER BY "부서 번호", "사번";

---------------------------------------------------------- ANSI 문법
SELECT
      e1.deptno as "부서 번호",
      d.dname as "부서 이름",
      e1.empno as "사번",
      e1.ename as "직원 이름",
      e1.mgr as "매니저 사번",
      e2.ename as "매니저 이름",
      e1.sal as "직원 급여",
      s.grade as "직원 급여 등급"
FROM emp e1 
     JOIN emp e2 ON e1.mgr = e2.empno
     JOIN dept d ON e1.deptno = d.deptno
     JOIN salgrade s ON e1.sal between s.losal and s.hisal
WHERE e1.sal >= 2000 
ORDER BY "부서 번호", "사번";
