/*
 *오라클 함수(function)
 1. 단일 행 함수:
    - 행(row)이 하나씩 함수의 아규먼트로 전달되고, 행마다 결과값이 반환되는 함수
    - 예: to_number, to_date(문자열-->날짜형식), to_char(문자열이 아닌 것을 --> 문자열), lower, upper, ... 
 2. 다중 행 함수: 
    - 테이블에서 여러개의 행들이 함수의 아규먼트('()')로 전달되고, 하나의 결과값이 반환되는 함수
    - 통계 관련 함수. 예: count, sum, avg, ...
 */
 
 
 -- 단일 행 함수
 -- to_char(컬럼, '포맷'): 컬럼의 값들을 '포맷' 형식의 문자열로 변환
 -- 컬럼은 문자열이 아닌 컬럼이 해당. (예) 날짜형식이 가장 많이 사용됨
 SELECT 
    ename, 
    to_char(hiredate, 'YYYY-MM-DD') as 입사형식1,
    to_char(hiredate, 'MM/DD/YYYY') as 입사형식2
 FROM emp;
 
 -- 직원이름과 입사연도를 출력
 SELECT ename, to_char(hiredate, 'YYYY') as 입사연도
 FROM emp;

-- lower(문자열 타입 컬럼): 소문자로 변환
-- upper(문자열 타입 컬럼): 대문자로 변환
-- initcap(문자열 타입 컬럼): 첫글자를 대문자로 변환
SELECT ename, lower(ename), upper(ename), initcap(ename) 
FROM emp;

-- 이름 중에 대/소문자 구분 없이 'a'가 포함된 직원들의 레코드
SELECT * FROM emp
WHERE lower(ename) LIKE '%a%';


-- replace(문자열 컬럼, 변환전 문자, 변환할 문자)
SELECT replace('smith', 'i', '*') FROM dual;
SELECT replace('allen', 'l', '*') FROM dual;
SELECT ename, replace(ename, 'A', '-') FROM emp;

-- substr(문자열[컬럼], 자르기 시작 인덱스, 자를 문자 개수) --> 자를 개수에 띄어쓰기 포함
SELECT substr('hello sql', 3, 3) FROM dual;
SELECT ename, substr(ename, 2, 5) FROM emp;

-- substr(문자열[컬럼], 자르기 시작 인덱스): 시작 인덱스부터 문자열 끝까지 자름
SELECT substr('hello sql', 5) FROM dual;
SELECT ename, substr(ename, 3) FROM emp;

-- length(문자열[컬럼]): 글자수 반환
-- lengthb(문자열[컬럼]): 문자 byte개수 반환
--> 영문자, 숫자, 특수기호 1byte, 한글 대개 한글자당 3byte
SELECT length('hello') FROM dual;
SELECT lengthb('김진숙천재') FROM dual;
SELECT * FROM emp
WHERE length(ename) >= 6;

SELECT substr(ename, 1, 1) || '*' || substr(ename, length(ename), 1)
FROM emp;

SELECT substr('김진숙', 1, 1) || '*' || substr('김진숙', length('김진숙'), 1) as 이름
FROM dual;


-- nvl(var, value): var가 null이면 value를 반환하고, null이 아니면 var를 그대로 반환
SELECT comm, nvl(comm, '-1') as comm1 
FROM emp;

-- nvl2(var, value, value): var가 null이 아니면 value1, null이면 value2를 반환)
SELECT comm, nvl2(comm, '유', '무') as 수당
FROM emp;

SELECT comm, nvl2(comm, comm, -1) as 수당
FROM emp;

-- 직원 이름, 급여, 수당, 연봉(=sum(급여 * 12, 수당)을 출력
SELECT ename, sal, comm, sal * 12 + nvl(comm, 0) as "annual salary"
FROM emp;

-- 연봉이 30,000이상인 직원들의 이름, 급여, 수당, 연봉을 출력. 연봉 내림차순 출력
SELECT 
    ename, sal, comm, 
    sal * 12 + nvl(comm, 0) as 연봉
FROM emp
WHERE sal * 12 + nvl(comm, 0) >= 30000
ORDER BY sal * 12 + nvl(comm, 0) desc;


-- 연봉이 10,000 이상 30,000 이하인 직원들의 이름, 급여, 수당, 연봉을 연봉 내림차순으로 출력
SELECT 
    ename, sal,
    nvl2(comm, comm, 0) as comm, 
    sal * 12 + nvl(comm, 0) as 연봉
FROM emp
WHERE sal * 12 + nvl(comm, 0) between 10000 and 30000
ORDER BY sal * 12 + nvl(comm, 0) desc;

--> SELECT 절에서 설정한 별명(alias)은 FROM, WHERE 등의 절에서는 사용할 수 없음
--> ORDER BY 절에서만 사용할 수 있음

-- round(식, 소수점 이하 자리) 함수: 반올림
SELECT 
    10 / 3,
    round(10 / 3),  
    round(10 / 3, 2)
FROM dual;

SELECT round(153, -1), round(153, -2) FROM dual;  --음수: 반올림하는 정수 자리 위치(끝에서부터 1)

-- trunc(argument, 소수점 이하 자리) 함수: 잘라냄. 버림 --> 소수점 이하 자리 정수만 되는 듯.
SELECT trunc(3.141592, 2), trunc(3.141592, 3) FROM dual;

-- decode(var, value, return1, return2)
-- var의 값이 value와 같으면 return1을 반환하고, 그렇지 않으면 return2를 반환함

-- 부서번호가 10번인 직원은 보너스가 100, 부서번호 10 아니면 200
SELECT ename, deptno,
    decode(deptno, 10, 100, 200) as 보너스
FROM emp;

-- 부서번호가 10이면 보너스는 50, 부서번호 20이면 보너스 100, 그렇지 않으면 보너스 0
-- decode(var, value1, return1, value2, return2, return3)
-- var의 값이 value1이면 return1, var가 value2이면 return2, var가 아무것도 아니면 return3를 반환
SELECT ename, deptno,
    decode(deptno, 10, 50, 20, 100, 0) as 보너스
FROM emp;

-- case-when 구문: decode() 함수를 대신할 수 있는 구문
SELECT
    ename, deptno,
    case when deptno = 10 then 50
         when deptno = 20 then 100
         else 0
    end as 보너스
FROM emp;

-- 급여가 3,000 이상이면 보너스는 100만원, 2,000 이상이면 보너스는 150, 1,000이상이면 170, 그렇지 않으면 200
SELECT     
    ename, sal,
    case 
        when sal >= 3000 then 100
        when sal >= 2000 then 150 --> 2,000이상 3,000미만   -- when 조건절의 순서 중요! 코드 진행 순서~~있음!
        when sal >= 1000 then 170 --> 1,000이상 2,000미만
        else 200
    end as 보너스
FROM emp;


