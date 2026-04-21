/*
 * 조건 검색 - where 구문
 조건 검색이란? 조건을 만족하는 행(row)들을 선택하는 방법.
 (문법) SELECT 컬럼, ... FROM 테이블 WHERE 조건식 [ORDER BY 컬럼, ...] <<<<순서 주의!
 
 조건식에서 사용되는 연산자:
 (1) 비교 연산자: =, !=, >, <, >=, <=, is null, is not null, ...
 (2) 논리 연산자: and, or, not
 
 (주의) 키워드(식별자: 예약어, 테이블 이름, 컬럼 이름)를 제외한 문자열은 작은따옴표 사용해야 함
 (주의) 키워드(식별자)와 다르게 *****조건식에서 사용되는 비교 문자열은 대소문자 구분함*****
 */
 
 
-- 10번 부서에서 근무하는 직원들의 사번, 이름, 부서번호를 출력
SELECT empno, ename, deptno
FROM emp 
WHERE deptno = 10; 
 
-- 10번 부서가 아닌 직원들의 사번, 이름, 부서번호를 출력
SELECT empno, ename, deptno
FROM emp
WHERE deptno != 10 ORDER BY deptno;

-- 수당이 null이 아닌 직원들의 모든 정보를 출력
SELECT  * FROM emp
WHERE comm is not null ORDER BY comm;

-- (주의) null인지 아닌지를 비교할 때는 =, != 연산자를 사용하면 안 됨

-- 수당이 null이 아닌 직원들의 부서번호, 사번, 이름, 급여, 수당을 검색
-- 정렬 순서: (1) 부서번호 오름차순, (2) 사번 오름차순
SELECT deptno, empno, ename, sal, comm 
FROM emp
WHERE comm is not null 
ORDER BY deptno, empno;

-- 급여가 2000 이상인 직원들의 이름, 업무, 급여를 출력
-- 정렬 순서: (1) 급여 내림차순, (2) 이름 오름차순
SELECT ename, job, sal
FROM emp 
WHERE sal >= 2000
ORDER BY sal desc, ename;

-- 급여가 2000 이상이고 3000 이하인 직원들의 이름, 업무, 급여를 출력
-- 정렬 순서: 급여 내림차순
SELECT ename, job, sal
FROM emp
WHERE sal >= 2000 and sal <= 3000 
ORDER BY sal desc;

SELECT ename, job, sal
FROM emp
WHERE sal between 2000 and 3000
ORDER BY sal desc;

-- 비교: 급여가 2000 이하이거나 3000 이상인 직원들
SELECT ename, job, sal
FROM emp
WHERE sal <= 2000 or sal >= 3000 
ORDER BY sal desc;

-- 수당은 null이 아니고, 급여는 1500 미만인 직원들
SELECT * FROM emp
WHERE sal < 1500 and comm is not null 
ORDER BY comm;

-- 10번 또는 20번 부서에서 근무하는 직원들의 부서번호, 이름, 급여를 출력
-- 정렬: (1) 부서번호 오름차순, (2) 급여 내림차순
SELECT deptno, ename, sal
FROM emp
WHERE deptno = 10 or deptno = 20
ORDER BY deptno, sal desc;

SELECT deptno, ename, sal
FROM emp
WHERE deptno in (10, 20)
ORDER BY deptno, sal desc;

-- 업무가 'CLERK'인 직원들의 이름, 업무, 급여를 출력. 이름순으로 출력
SELECT ename, job, sal
FROM emp
WHERE job = 'CLERK' ORDER BY ename;

-- 업무가 'CLERK' 또는 'MANAGER'인 직원들의 이름, 업무, 급여를 출력
-- 정렬: (1) 업무, (2) 급여
SELECT ename, job, sal
FROM emp
WHERE job = 'CLERK' or job = 'MANAGER'
ORDER BY job, sal;

SELECT ename, job, sal
FROM emp
WHERE job in ('CLERK', 'MANAGER')
ORDER BY job, sal;

-- 업무가 영업사원, 관리자, 분석가인 직원들 검색
SELECT *
FROM emp
WHERE job in ('SALESMAN', 'MANAGER', 'ANALYST')
ORDER BY job, sal;

-- 20번 부서에서 근무하는 'CLERK'의 모든 레코드(모든 컬럼)를 출력
SELECT * FROM emp
WHERE deptno = 20 and job = 'CLERK';

-- CLERK, ANALYST, MANAGER가 아닌 직원들의 사번, 이름, 업무, 급여를 사번순 출력
SELECT empno, ename, job, sal
FROM emp
WHERE job != 'CLERK' and job != 'ANALYST' and job != 'MANAGER'
ORDER BY empno;

SELECT empno, ename, job, sal
FROM emp
WHERE job not in ('CLERK', 'ANALYST', 'MANAGER')
ORDER BY empno;



-- LIKE 검색: 특정 문자열이 포함된 값들을 찾는 검색 방법
-- LIKE 검색에서 사용되는 WILDCARD:
-- (1) %: 글자 수 상관없이 어떤 문자열이어도 상관 없음
-- (2) _: 밑줄(underscore)이 있는 자리에 한 글자가 어떤 문자이더라도 상관 없음

SELECT * FROM emp WHERE job LIKE 'C%';
--> 업무가 'C'로 시작하는 모든 단어들

SELECT * FROM emp WHERE job LIKE '%R';
--> 업무가 'R'로 끝나는 모든 단어들

SELECT * FROM emp WHERE job LIKE '%A%';
--> 업무에 'A'가 포함된 모든 단어들 (A로 시작되든, 중간에 있든, 끝나든 상관 무)

SELECT * FROM emp WHERE job LIKE 'C_';
SELECT * FROM emp WHERE job LIKE '_LERK';
SELECT * FROM emp WHERE job LIKE '__ERK';

-- 이름에 'A'가 포함된 직원들의 정보
SELECT * FROM emp WHERE ename LIKE '%A%';

-- 업무에 'MAN'이 포함된 직원들의 정보
SELECT * FROM emp WHERE job LIKE '%MAN%';



-- 사번(empno)가 숫자 7369와 같은 레코드를 찾아주세요
SELECT * FROM emp WHERE empno = 7369;

-- 암묵적 타입 변환
SELECT * FROM emp WHERE empno = '7369';
--> 사번(empno)가 문자열 7369와 같은 레코드
--> 입력받을 때 문자열로 입력 받음
--> 오라클은 문자열 값을 숫자로 변환한 후에 empno 컬럼의 값들과 비교

-- 명시적인 타입 변환: 함수를 사용함
SELECT * FROM emp WHERE empno = to_number('7369');

-- 날짜 타입의 크기 비교: 과거('24년) < 현재('25년) < 미래('26년)
-- 입사일이 1982/01/01 이후에 입사한 직원들
SELECT * FROM emp WHERE hiredate > '1982-01-01';
--> 오라클은 문자열 '1982/01/01'을 날짜 타입(DATE)으로 암묵적으로 변환한 후,
-- hiredate 컬럼의 값들과 크기를 비교해서 조건에 맞는 레코드를 검색


SELECT * FROM emp WHERE hiredate > '82/01/01';
--> 위 SQL 문장의 실행 결과는,
-- 도구 -> 환경설정 -> 데이터베이스 -> NLS -> 날짜/시간 형식 설정에 따라 다른 결과를 보여줌
-- 날짜 형식의 문자열을 DATE 타입으로 암묵적 변환이 일어날 경우에는, 환경 설정에 따라서 다른 결과가 나옴
--> 날짜 형식의 문자열은 '명시적인 타입 변환'을 하는 것을 권장
-- to_date('날짜 형식으로 작성된 문자열', '날짜 포맷') 함수 사용방법
SELECT to_date('2025-11-20', 'YYYY-MM-DD') FROM dual;
SELECT to_date('01/05/2025', 'MM/DD/YYYY') FROM dual; -- 아래 형식이랑 똑같은데, 의미가 다르니까 알려줘야지
SELECT to_date('01/05/2025', 'DD/MM/YYYY') FROM dual;

-- 2자리 연도 표기:
-- (1) YY(현재 세기): 현재 세기의 끝 두 자리 <<세기라는 단어보다 연도 앞 두자리...? 라고 생각하는게 맞는듯
-- (2) RR(반올림 세기): 반올림해서 현재 세기가 될 수 있는 연도들
--     2000-50=1950 ~ 2000+49=2049 --> 20
SELECT to_date('99/11/20', 'YY/MM/DD') FROM dual;
SELECT to_date('99/11/20', 'RR/MM/DD') FROM dual;

-- 1949년 --> 같은 경우에는 그냥 YYYY로 입력하셈 ㅋㅋ


-- *조건절에서* 날짜 크기 비교하기 !!! 명시적 변환(특히, RR) 이용해서 안전하게 검색
SELECT * FROM emp WHERE hiredate > to_date('82/01/01', 'RR/MM/DD');


