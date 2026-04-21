/*
 * 다중행 함수: 여러개의 행들이 함수의 아규먼트로 전달되고 *하나의 값*이 반환되는 함수. 
 통계 함수들: count, sum, avg, ...
 */
 
-- COUNT(var): var(컬럼)에서 null이 아닌 행의 개수를 반환. null은 세지 않음
 SELECT COUNT(empno) FROM emp;
 SELECT COUNT(mgr) FROM emp;
 
-- COUNT(*): 테이블의 전체 행의 개수를 반환
SELECT COUNT(*) FROM emp;
 
-- 통계(집계) 함수: null을 제외하고 계산
-- SUM(): 합계
SELECT SUM(sal) FROM emp;
SELECT SUM(comm) FROM emp;

-- avg() 함수: 평균~
SELECT AVG(sal) FROM emp;
SELECT ROUND(AVG(sal), 2) FROM emp;

SELECT AVG(comm) FROM emp;
-- SELECT 2200 / 4 FROM dual;

-- VARIANCE(): 분산
-- STDDEV(): 표준편차
-- MAX(): 최댓값
-- MIN(): 최솟값

-- 급여 개수, 합계, 평균, 분산, 표준편차, 최댓값, 최솟값
SELECT
    COUNT(sal) as 개수,
    SUM(sal) as 합계,
    ROUND(AVG(sal), 2) as 평균,
    ROUND(VARIANCE(sal), 2) as 분산,
    ROUND(STDDEV(sal), 2) as 표준편차,
    MAX(sal) as 최댓값,
    MIN(sal) as 최솟값
FROM emp;

-- 다중행 함수는 단일행 함수와 함께 사용될 수 없음! --> 행렬 곱셈 성립 조건: 앞 행렬의 열과 뒤 행렬의 행이 같아야 함
SELECT COUNT(comm), nvl(comm, 0) FROM emp;

/*
 * 그룹별 쿼리
 (예) 부서별 직원수, 부서별 급여 평균, ...
 (문법)
 SELECT 컬럼, 그룹함수, ...
 FROM 테이블, ...
 WHERE 조건식(1)
 GROUP BY 컬럼(그룹을 묶기 위한 필드), ...
 HAVING 조건식(2)
 ORDER BY 컬럼(정렬 기준이 되는 필드), ...;

 WHERE 조건식(1): 그룹을 묶기 전에, 조건을 만족하는 행들만 선택하기 위한 조건식
 HAVING 조건식(2): 그룹을 묶은 다음에, 조건에 맞는 그룹들만 선택하기 위한 조건식
 */

-- GROUP BY에서 사용한 그룹을 묶기 위한 컬럼 이름은 SELECT에서 사용할 수 있음
-- GROUP BY에서 설정되지 않은 컬럼은 SELECT할 수 없음
-- 부서별 인원수
SELECT deptno, COUNT(*) 
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 부서별 급여 평균(소수점 둘째자리까지) 계산
SELECT deptno, 
       ROUND(AVG(sal), 2) as "avg_sal"
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 사장님을 제외하고, 업무별 직원 수, 급여 평균, 최댓값, 최솟값 출력
SELECT 
    job as 업무, 
    COUNT(*) as "직원 수", 
    ROUND(AVG(sal), 2) as "급여 평균", 
    MAX(sal) as 최댓값, 
    MIN(sal) as 최솟값
FROM emp
WHERE job != 'PRESIDENT'
GROUP BY job
ORDER BY "급여 평균" desc;

-- 매니저가 있는(null이 아닌) 직원들 중에서 업무별 직원수, 급여 평균 출력
SELECT 
    job as 업무, 
    COUNT(*) as "직원 수", 
    ROUND(AVG(sal), 2) as "급여 평균"
FROM emp
WHERE mgr is not null
GROUP BY job
ORDER BY "급여 평균" desc;

-- 업무별 급여 평균이 2000 이상인 그룹들 출력
SELECT job, 
       ROUND(AVG(sal), 2) as "급여 평균"
FROM emp
GROUP BY job
HAVING avg(sal) >= 2000
ORDER BY "급여 평균" desc;

-- 매니저가 있는 직원들 중에서 업무별 급여 평균이 2000이상인 그룹 출력
SELECT job, 
       ROUND(AVG(sal), 2) as "급여 평균"
FROM emp
WHERE mgr is not null
GROUP BY job
HAVING avg(sal) >= 2000
ORDER BY "급여 평균" desc;

-- 부서별 업무별 직원 수, 급여 평균/최솟값/최댓값을 출력
SELECT deptno, job, COUNT(job), AVG(sal), MIN(sal), MAX(sal)
FROM emp
GROUP BY deptno, job
ORDER BY deptno;

-- 매니저가 있는 직원들 중에서
-- 부서별 업무별 급여 평균이 1000 이상인 그룹들만
-- 부서별 업무별 직원수, 급여 평균/최솟값/최댓값을 출력
SELECT deptno, job, COUNT(job), AVG(sal), MIN(sal), MAX(sal)
FROM emp
WHERE mgr is not null
GROUP BY deptno, job
HAVING AVG(sal) >= 1000
ORDER BY deptno;

-- 입사연도별 직원수를 입사연도 오름차순으로 출력
SELECT TO_CHAR(hiredate, 'YYYY') as 입사연도,
       COUNT(*) as 직원수
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY 입사연도;

-- 입사연도별 부서별 직원수 출력
SELECT TO_CHAR(hiredate, 'YYYY') as 입사연도, 
       deptno as "부서 번호", 
       COUNT(*) as 직원수
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY'), deptno
ORDER BY 입사연도;