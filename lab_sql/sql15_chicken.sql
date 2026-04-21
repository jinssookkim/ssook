/*
 * call_chicken.csv 데이터 분석
 * 1. github에 있는 CSV 파일을 다운로드.
 * 2. CSV 파일 내용을 저장할 수 있는 테이블 생성
 *    테이블 이름(call_chicken), 컬럼 이름(call_date, call_day, gu, ages, gender, calls)
 * 3. CSV 파일 데이터를 테이블로 임포트(import)
 * 4. 분석:
 *    (1) 통화 건수의 최댓값, 최솟값
 *    (2) 통화 건수가 최댓값이거나 최솟값인 레코드 출력
 *    (3) 통화 요일별 통화 건수의 평균
 *    (4) 연령대별 통화 건수의 평균
 *    (5) 통화 요일별 연령대별 통화 건수의 평균
 *    (6) 구별 성별 통화 건수의 평균
 *    (7) 요일별 구별 연령대별 통화 건수의 평균
 */


-- CSV(Comma-Separated Values) 파일:
-- 값들을 쉼표(,)로 구분해서 테이블 모양의 데이터를 텍스트로 작성한 파일
 
drop table call_chicken purge;
  
CREATE TABLE call_chicken (
    call_date   DATE,
    call_day    VARCHAR2(10),           -- char(1 char): 고정길이 문자열(일정한 길이의 데이터인 경우)
    gu          VARCHAR2(20),           -- varchar2(5 char): 가변길이 문자열
    ages        VARCHAR2(20),           -- varchar2(5 char)
    gender      VARCHAR2(10),           -- char(1 char)
    calls       NUMBER(5)               -- number(4)
);

SELECT count(*) FROM call_chicken;
--> 행(row) 개수

SELECT distinct call_date FROM call_chicken ORDER BY call_date;

SELECT distinct gu FROM call_chicken;


--    (1) 통화 건수의 최댓값, 최솟값
SELECT MAX(calls) "통화 건수 최댓값", MIN(calls) "통화 건수 최솟값" FROM call_chicken;

--    (2) 통화 건수가 최댓값이거나 최솟값인 레코드 출력
SELECT * FROM call_chicken
WHERE calls in (
            (SELECT MAX(calls) FROM call_chicken), (SELECT MIN(calls) FROM call_chicken)
)
ORDER BY calls;

--    (3) 통화 요일별 통화 건수의 평균
SELECT call_day, ROUND(AVG(calls)) "통화 건수 평균" FROM call_chicken GROUP BY call_day ORDER BY "통화 건수 평균" desc; 

--    (4) 연령대별 통화 건수의 평균
SELECT ages, ROUND(AVG(calls)) "통화 건수 평균" FROM call_chicken GROUP BY ages ORDER BY "통화 건수 평균" desc;

--    (5) 통화 요일별 연령대별 통화 건수의 평균
SELECT call_day, ages, ROUND(AVG(calls)) "통화 건수 평균" FROM call_chicken GROUP BY call_day, ages ORDER BY "통화 건수 평균" desc FETCH FIRST 10 ROWS ONLY;

--    (6) 구별 성별 통화 건수의 평균
SELECT gu, gender, ROUND(AVG(calls)) "통화 건수 평균" FROM call_chicken GROUP BY gu, gender ORDER BY "통화 건수 평균" desc;

--    (7) 요일별 구별 연령대별 통화 건수의 평균
SELECT call_day, gu, ages, ROUND(AVG(calls)) "통화 건수 평균" FROM call_chicken GROUP BY call_day, gu, ages ORDER BY "통화 건수 평균" desc;
    



