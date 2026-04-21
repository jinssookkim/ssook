/* 
 * 교재 연습 Sheet
 */
 
SELECT SUBSTR('SMITH', 2, 1) FROM dual;

SELECT INSTR('SMITH', 'T') FROM dual; --> 특정 철자 위치 출력 위해


--메일 앞 아이디만 추출하고 싶을 때
-- ID: ria87133@naver.com
SELECT INSTR('ria87133@naver.com', '@') FROM dual;
SELECT SUBSTR('ria87133@naver.com', 1, 8) FROM dual;
--> 결합
SELECT SUBSTR('ria87133@naver.com', INSTR('ria87133@nave.com', 'r'), INSTR('ria87133@naver.com', '@')-1) as ID 
FROM dual;
 

CREATE TABLE TEST_ENAME
(ENAME  VARCHAR2(10));

INSERT INTO TEST_ENAME VALUES('김인호');
INSERT INTO TEST_ENAME VALUES('안상수');
INSERT INTO TEST_ENAME VALUES('최영희');
INSERT INTO TEST_ENAME VALUES('김진숙');
COMMIT;

-- 가운데 이름만 블러 처리
SELECT ename FROM test_ename;
SELECT REPLACE(ename, SUBSTR(ename, 2, 1), '*') FROM test_ename;
-- 성 제외 이름 블러 처리
SELECT REPLACE(ename, SUBSTR(ename, 2), '**') FROM test_ename;


SELECT ename, sal, lpad('■', ROUND(sal/100), '■') as salary
FROM emp
ORDER BY sal desc; -- salary로도 정렬 되긴 하는데, 조금 부정확함


-- MOD: 나머지
-- 사원번호가 홀수면 1, 짝수면 0
SELECT empno, MOD(empno, 2) FROM emp;

-- FLOOR: 몫
SELECT FLOOR(10/3) FROM dual;

-- MONTHS_BETWEEN(최신 날짜, 예전 날짜): 날짜와 날짜 사이의 개월 수 계산
SELECT sysdate FROM dual;
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate) FROM emp;



-- RANK() OVER (partition by ... order by ...): 순위/랭킹
-- DENSE_RANK() OVER (partition by ... order by ...): 중복된 값을 같은 순위로 포함해 순위/랭킹을 차례대로 상세히 보여주는 함수
-- CUME_DIST() OVER (partition by ... order by ...): 순위를 백분율로 계산

-- LISTAGG: 데이터 가로로 출력하기. 가로 출력 위해서는 GROUP BY절 사용 필수!
SELECT deptno, LISTAGG(ename, ', ') within group (order by ename) as EMPLOYEE
FROM emp
GROUP BY deptno;



