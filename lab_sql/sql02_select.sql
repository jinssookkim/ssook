/*
 기본 질의(Query) 문법: 테이블에서 데이터를 검색하는 방법:
 (문법) SELECT 컬럼이름, , , ...  FROM 테이블이름;
 테이블의 모든 컬럼을 검색: SELECT * FROM 테이블이름;
 * meaning: all
 */
 
 -- 직원 테이블(emp)에서 사번(empno)과 직원 이름(ename)을 검색:
 SELECT empno, ename FROM emp;
 
 -- 직원 테이블의 모든 컬럼을 검색:
 SELECT * FROM emp;
 
 -- 직원들의 정보를 '부서번호, 사번, 이름, 업무, 급여, 수당, 입사일, 매니저 사번' 순서로 출력:
SELECT deptno, empno, ename, job, sal, comm, hiredate, mgr 
FROM emp;



-- 컬럼 이름에 별명(alias) 주기: 컬럼이름 as "별명"
-- as는 생략
-- 별명에 공백이 없는 경우, 큰 따옴표 생략 가능
-- 별명 이름에서는 작은 따옴표 사용 불가
SELECT
    empno as 사번,
    ename "직원 이름",
    sal 급여
FROM emp;

-- 부서 테이블(dept)에서 부서 번호, 부서 이름, 위치를 검색
-- 실제 column 이름 대신 한글로 별명을 사용해서 출력
SELECT
    deptno "부서 번호",
    dname "부서 이름",
    loc 위치
FROM dept;



-- 연결 연산자(||): 2개 이상의 column 값들을 합쳐서 하나의 문자열로 만들어줌
-- 'SMITH의 급여는 800입니다.' 형식으로 검색 결과를 출력
SELECT
    ename || '의 급여는 ' || sal || '입니다.' as "이름-급여"
FROM emp;

-- 부서 테이블에서 부서 번호와 이름을 '10-accounting'과 같은 형식으로 출력
SELECT 
    '''' || deptno || '-' || dname || '''' as "'부서 번호-부서명'"
FROM dept;



-- 검색 결과를 정렬해서 출력하기:
-- (문법) SELECT ... FROM 테이블 ORDER BY 정렬기준컬럼 [asc/desc], ... ;
-- asc: 오름차순(ascending order), desc: 내림차순(descending order) // 정렬의 기본값은 오름차순 --> 생략 가능

-- 사번, 이름 검색. 사번 오름차순으로 출력
SELECT empno, ename 
FROM emp
ORDER BY empno; 

SELECT empno, ename
FROM emp
ORDER BY empno desc;

-- 부서번호, 이름, 급여를 검색
-- 정렬 순서: (1) 부서번호의 오름차순, (2) 급여 내림차순
SELECT deptno, ename, sal
FROM emp
ORDER BY deptno, sal desc;

-- 직원 이름 오름차순 정렬
SELECT ename
FROM emp
ORDER BY ename;

-- 부서번호, 이름, 입사일을 검색
-- 정렬 순서: (1) 부서번호 오름차순, (2) 입사일 오름차순
SELECT deptno, ename, hiredate
FROM emp
ORDER BY deptno, hiredate;

-- 사번, 이름, 업무, 급여를 검색
-- 정렬 순서: (1) 업무 오름차순, (2) 급여 오름차순
SELECT empno, ename, job, sal
FROM emp
ORDER BY job, sal;



-- 중복되는 데이터는 제거하고 출력
-- (문법) SELECT DISTINCT 열 FROM 데이터;
SELECT DISTINCT deptno FROM emp ORDER BY deptno;

-- SELECT과 SELECT DISTINCT 문장 비교
SELECT deptno, job FROM emp ORDER BY deptno, job;
SELECT DISTINCT deptno, job FROM emp ORDER BY deptno, job;

-- (주의) DISTINCT 키워드는 한 번만 사용! 한 구문에 여러 번 사용하지 못 함 