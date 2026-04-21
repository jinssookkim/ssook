/*
 * gapminder 파일 다운로드 및 테이블에 데이터 임포트
 * TSV(Tab-Separated Values): 값들이 탭으로 구분된 텍스트 파일. CSV 파일의 일종.
 * 테이블 이름: gapminder
 * 컬럼 이름: country, continent, year, life_exp(기대수명), pop(인구수), gdp_percap(1인당 gdp)
 
 
 * 1. 테이블에는 모두 몇 개의 나라가 있을까요?
 * 2. 테이블에는 모두 몇 개의 대륙이 있을까요?
 * 3. 테이블에는 저장된 데이터는 몇년도부터 몇년도까지 조사한 내용일까요?
 * 4. 기대 수명이 최댓값인 레코드(row)를 찾으세요.
 * 5. 인구가 최댓값인 레코드(row)를 찾으세요.
 * 6. 1인당 GDP가 최댓값인 레코드(row)를 찾으세요.
 * 7. 우리나라의 통계 자료만 출력하세요.
 * 8. 연도별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 9. 대륙별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 10. 연도별, 대륙별 인구수를 출력하세요.
 *     인구수가 가장 많은 연도와 대륙은 어디인가요?
 * 11. 연도별, 대륙별 기대 수명의 평균을 출력하세요.
 *     기대 수명이 가장 긴 연도와 대륙은 어디인가요?
 * 12. 연도별, 대륙별 1인당 GDP의 평균을 출력하세요.
 *     1인당 GDP의 평균이 가장 큰 연도와 대륙은 어디인가요?
 * 13. 10번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 14. 11번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 15. 12번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 */
 
drop table gapminder purge;
 
CREATE TABLE gapminder (
    country     VARCHAR2(50 CHAR),
    continent   VARCHAR2(50 CHAR), -- varchar2는 괄호 안 숫자 지정 필수
    year        NUMBER(4),
    life_exp    NUMBER(5, 3),      -- 타입 number인 경우, 숫자 지정하지 않아도 됨
    pop         NUMBER(20),
    gdp_percap  NUMBER(15, 8)      -- 소수점 자릿수 일정하지 않을 경우, 정수로만 적으면 소수점 자릿수 알아서 max로 잡힘
);


-- 데이터 탐색
select count(*) from gapminder;

-- 각 컬럼에 null이 아닌 데이터들의 개수
SELECT 
    COUNT(country), COUNT(continent), COUNT(year),
    COUNT(life_exp), COUNT(pop), COUNT(gdp_percap)
FROM gapminder;
--> null이 있는 컬럼 없음.

SELECT * FROM gapminder
ORDER BY country, year;


-- * 1. 테이블에는 모두 몇 개의 나라가 있을까요?
SELECT distinct country FROM gapminder ORDER BY country;
SELECT COUNT(distinct country) FROM gapminder;

-- * 2. 테이블에는 모두 몇 개의 대륙이 있을까요?     
SELECT distinct continent FROM gapminder;

-- 기대수명의 기술통계량
SELECT
    round(avg(life_exp), 2) as 평균,
    round(variance(life_exp), 2) as 분산,
    round(stddev(life_exp), 2) as 표준편차,
    MIN(life_exp) as 최솟값,
    MAX(life_exp) as 최댓값,
    MEDIAN(life_exp) as 중위값
FROM gapminder;

-- 인구의 기술통계량
SELECT
    round(avg(pop), 2) as 평균,
    round(variance(pop), 2) as 분산,
    round(stddev(pop), 2) as 표준편차,
    MIN(pop) as 최솟값,
    MAX(pop) as 최댓값,
    MEDIAN(pop) as 중위값
FROM gapminder;

-- 1인당 GDP 기술통계량
SELECT
    round(avg(gdp_percap), 2) as 평균,
    round(variance(gdp_percap), 2) as 분산,
    round(stddev(gdp_percap), 2) as 표준편차,
    MIN(gdp_percap) as 최솟값,
    MAX(gdp_percap) as 최댓값,
    MEDIAN(gdp_percap) as 중위값
FROM gapminder;

-- * 3. 테이블에는 저장된 데이터는 몇년도부터 몇년도까지 조사한 내용일까요?
SELECT MIN(year), MAX(year) FROM gapminder;
SELECT COUNT(distinct year) FROM gapminder;

-- * 4. 기대 수명이 최댓값인 레코드(row)를 찾으세요.
SELECT * FROM gapminder WHERE life_exp = (
            SELECT MAX(life_exp) FROM gapminder);
 
-- * 5. 인구가 최댓값인 레코드(row)를 찾으세요.
SELECT * FROM gapminder WHERE pop = (
        SELECT MAX(pop) FROM gapminder
);

-- * 6. 1인당 GDP가 최댓값인 레코드(row)를 찾으세요.
SELECT * FROM gapminder WHERE gdp_percap = (
        SELECT MAX(gdp_percap) FROM gapminder 
);
 
-- * 7. 우리나라의 통계 자료만 출력하세요.
SELECT distinct country FROM gapminder WHERE lower(country) like '%kor%';
SELECT * FROM gapminder WHERE country = 'Korea, Rep.';

 
-- * 8. 연도별 1인당 GDP의 최댓값인 레코드를 찾으세요.
SELECT year, MAX(gdp_percap) FROM gapminder GROUP BY year ORDER BY year;


SELECT * 
FROM gapminder 
WHERE (year, gdp_percap) in (
        SELECT year, MAX(gdp_percap) FROM gapminder 
        GROUP BY year
)
ORDER BY year;


/* -- RANK() 함수를 이용한 그룹별 최댓값 찾기
SELECT 
    g.*,
    rank() over (PARTITION BY year ORDER BY g.gdp_percap desc) RANKING
FROM gapminder g;
-- 해당 함수를 from에 넣기
*/

WITH t AS (
    SELECT g.*,
        RANK() OVER (PARTITION BY year ORDER BY g.gdp_percap desc) RANKING
    FROM gapminder g)

SELECT *
FROM t
WHERE t.RANKING = 1
ORDER BY year;

-- * 9. 대륙별 1인당 GDP의 최댓값인 레코드를 찾으세요.
SELECT * 
FROM gapminder 
WHERE (continent, gdp_percap) in (
    SELECT continent, MAX(gdp_percap) FROM gapminder GROUP BY continent
)
ORDER BY gdp_percap;
 
-- * 10. 연도별, 대륙별 인구수를 출력하세요.
SELECT year, continent, SUM(pop) 인구합계 FROM gapminder GROUP BY year, continent ORDER BY 인구합계 desc;
-- *     인구수가 가장 많은 연도와 대륙은 어디인가요?
--> 2007년 아시아

WITH t AS (
    SELECT year, continent, SUM(pop) as 인구합계
    FROM gapminder 
    GROUP BY year, continent
)

SELECT t.* FROM t
WHERE t.인구합계 = (
    SELECT MAX(인구합계) FROM t
);

-- * 11. 연도별, 대륙별 기대 수명의 평균을 출력하세요.
SELECT year, continent, 
    ROUND(AVG(life_exp), 2) "기대수명 평균" 
FROM gapminder 
GROUP BY year, continent
ORDER BY "기대수명 평균" desc;
--*     기대 수명이 가장 긴 연도와 대륙은 어디인가요?
--> 2007년, 오세아니아


WITH t AS (
    SELECT year, continent, ROUND(AVG(life_exp)) as "기대수명 평균"
    FROM gapminder 
    GROUP BY year, continent
)

SELECT t.* FROM t
WHERE t."기대수명 평균" = (
    SELECT MAX("기대수명 평균") FROM t
);

-- * 12. 연도별, 대륙별 1인당 GDP의 평균을 출력하세요.
SELECT year, continent, 
    ROUND(AVG(gdp_percap), 2) "1인당 GDP 평균"
FROM gapminder
GROUP BY year, continent
ORDER BY "1인당 GDP 평균" desc
FETCH FIRST 5 ROWS ONLY;
-- *     1인당 GDP의 평균이 가장 큰 연도와 대륙은 어디인가요?
--> 2007년 오세아니아


-- PIVOT() 함수 사용! ! ! ! ! ! ! ! 
-- * 13. 10번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
SELECT year, continent, SUM(pop) 인구합계 FROM gapminder GROUP BY year, continent ORDER BY year, continent;

SELECT * 
FROM (SELECT year, continent, pop FROM gapminder)
PIVOT(SUM(pop) for continent in ('Africa', 'Americas', 'Asia', 'Europe', 'Oceania'))
ORDER BY year; 


WITH t AS (
    SELECT year, continent, pop FROM gapminder
)
SELECT * FROM t
PIVOT(sum(pop) for continent in('Africa' as "AFRICA", 
                                'Americas' as "AMEIRCAS", 
                                'Asia' as "ASIA", 
                                'Europe' as "EUROPE", 
                                'Oceania' as "OCEANIA"))
ORDER BY year;


WITH t AS (
    SELECT year, continent, pop FROM gapminder
)
SELECT * FROM t
PIVOT(sum(pop) for year in(1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, 2002, 2007))
ORDER BY continent;


-- * 14. 11번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
SELECT *
FROM (SELECT year, continent, life_exp FROM gapminder)
PIVOT(AVG(life_exp) for continent in ('Americas', 'Asia', 'Europe', 'Africa', 'Oceania'))
ORDER BY year;

SELECT year, 
       ROUND(AFRICA, 2) AFRICA,
       ROUND(AMERICAS, 2) AMERICAS,
       ROUND(ASIA, 2) ASIA,
       ROUND(EUROPE, 2) EUROPE,
       ROUND(OCEANIA, 2) OCEANIA
FROM (SELECT year, continent, life_exp FROM gapminder)
PIVOT(AVG(life_exp) for continent in ('Africa' as "AFRICA", 
                                        'Americas' as "AMERICAS", 
                                        'Asia' as "ASIA", 
                                        'Europe' as "EUROPE", 
                                        'Oceania' as "OCEANIA"))
ORDER BY year; 



WITH t AS (
    SELECT year, continent, life_exp FROM gapminder
)

SELECT year,
    ROUND(AFRICA, 2) "AFRICA",
    ROUND(AMERICAS, 2) "AMERICAS",
    ROUND(ASIA, 2) "ASIA",
    ROUND(EUROPE, 2) "EUROPE",
    ROUND(OCEANIA, 2) "OCEANIA"
FROM t
PIVOT(AVG(life_exp) for continent in ('Africa' as "AFRICA", 
                                        'Americas' as "AMERICAS", 
                                        'Asia' as "ASIA", 
                                        'Europe' as "EUROPE", 
                                        'Oceania' as "OCEANIA"))
ORDER BY year;



-- * 15. 12번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
SELECT year, 
       ROUND(AFRICA, 2) AFRICA,
       ROUND(AMERICAS, 2) AMERICAS,
       ROUND(ASIA, 2) ASIA,
       ROUND(EUROPE, 2) EUROPE,
       ROUND(OCEANIA, 2) OCEANIA
FROM (SELECT year, continent, gdp_percap FROM gapminder)
PIVOT(AVG(gdp_percap) for continent in ('Africa' as "AFRICA", 
                                        'Americas' as "AMERICAS", 
                                        'Asia' as "ASIA", 
                                        'Europe' as "EUROPE", 
                                        'Oceania' as "OCEANIA"))
ORDER BY year; 









