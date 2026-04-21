/*
 * OECD 국가 연평균 근로 시간
    연평균_근로시간_OECD.xlsx 파일의 테이블을 데이터베이스에 저장 및 분석.
 (1) CREATE TABLE
 (2) DATA IMPORT
 (3) SELECT
 */ 

-- 엑셀 파일의 내용을 저장할 수 있는 테이블을 생성
-- 테이블 이름: work_times
-- 컬럼 이름: 1) country(60byte), 2) y2014 ~ y2018(4,0)

CREATE TABLE work_times (
    country     VARCHAR2(60),
    y2014       NUMBER(4),
    y2015       NUMBER(4),
    y2016       NUMBER(4),
    y2017       NUMBER(4),
    y2018       NUMBER(4)
);

-- [접속 패널] -> work_times 테이블 오른쪽 클릭 -> 데이터 임포트 선택

-- 우리나라(한국)의 연평균 근로시간(모든 연도)를 출력
SELECT * FROM work_times WHERE country = '한국';
--> 결과 행이 1개도 없음. 국가 이름 앞에 공백이 포함되어 있기 때문에.

SELECT * FROM work_times WHERE country LIKE '%한국%';

-- country 컬럼의 국가 이름들에서 공백들을 모두 제거하고 업데이트
SELECT TRIM('  hello sql   ') FROM dual;
--> TRIM(): 문자열의 시작과 끝에 있는 모든 공백들을 제거. 
SELECT TRIM(country) FROM work_times;
--> 엑셀에서 임포트한 공백들이 잘리지 않음.

-- 내 응답
UPDATE work_times
SET country = SUBSTR(country, 4);
-- 선생님 답(SUBSTR 사용)
UPDATE work_times
SET country = SUBSTR(country, length('　　　') +1);
-- 선생님 답2(REPLACE 사용)
UPDATE work_times
SET country = REPLACE(country, '　',  '');
-- 선생님 답3(REGEXP_REPLACE)
UPDATE work_times
SET country = REGEXP_REPLACE(country, '[[:space:]]', '');

-- 정규표현식(regular expression) 문자열 대체
SELECT REGEXP_REPLACE(country, '[[:space:]]', '') FROM work_times;
--> 모든 종류의 빈칸을 찾는 식--> REGEXP_REPLACE(column_name, '[[:space:]]', 새로운 변수)

ROLLBACK;
select * from work_times;


COMMIT;

-- 2018년 한국의 평균 근로 시간보다 더 긴 국가들
SELECT country, y2018 FROM work_times
WHERE y2018 > (SELECT y2018 FROM work_times WHERE country = '한국');

SELECT * FROM work_times
WHERE y2014 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2015 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2016 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2017 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2018 > (SELECT y2018 FROM work_times WHERE country = '한국')
;

-- 2018년의 평균 근로시간 상위 5개 국가들.
SELECT country, y2018, RANK() OVER (ORDER BY y2018 desc) RANK FROM work_times
FETCH FIRST 5 ROWS ONLY;

SELECT * FROM work_times
ORDER BY y2018 desc
FETCH FIRST 5 ROWS ONLY;

SELECT * FROM work_times
ORDER BY y2018 desc
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;

WITH t AS (SELECT w.*, RANK() OVER (ORDER BY y2018 desc) RANK FROM work_times w)
SELECT t.*
FROM t
WHERE t.RANK <= 5;

--> ** ROW_NUMBER() OVER() **와 RANK() OVER()의 차이점 --> 동점자를 동순위로 처리하지 않고, 임의로 차례대로 순위 매김
WITH t AS (
        SELECT w.*, ROW_NUMBER() OVER(ORDER BY y2018 desc) RANK
        FROM work_times w
)
SELECT *
FROM t
WHERE t.RANK <= 5;

-- 각각의 연도에서 평균 근로시간이 가장 많은 나라는?
SELECT *
FROM work_times
WHERE y2018 = (SELECT MAX(y2018) FROM work_times) or
      y2017 = (SELECT MAX(y2017) FROM work_times) or
      y2016 = (SELECT MAX(y2016) FROM work_times) or
      y2015 = (SELECT MAX(y2015) FROM work_times) or
      y2014 = (SELECT MAX(y2014) FROM work_times)
;

-- UNPIVOT(): 컬럼의 내용들을 행으로 바꿔주는 함수. 가로 데이터를 세로 데이터로!!!!!!!!
-- UNPIVOT(values들이 들어갈 컬럼 이름 for 컬럼들이 들어갈 컬럼 이름 IN (col1, col2, ...) 
SELECT * FROM work_times
UNPIVOT(work_time for year in (y2014, y2015, y2016, y2017, y2018));

CREATE VIEW vw_work_times_long AS
        SELECT *
        FROM work_times
        UNPIVOT (work_time for year in (y2014, y2015, y2016, y2017, y2018));

SELECT * FROM vw_work_times_long
WHERE country = '한국' and lower(year) = 'y2018';

-- 2018년 한국 평균 근로시간보다 더 많은 근로시간을 갖는 나라와 연도?
SELECT * FROM vw_work_times_long
WHERE work_time > (
        SELECT work_time FROM vw_work_times_long
        WHERE country = '한국' and year = 'Y2018'
);
-- cf) unpivot 쓰지 않았을 때와 비교
SELECT * FROM work_times
WHERE y2014 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2015 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2016 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2017 > (SELECT y2018 FROM work_times WHERE country = '한국') or
      y2018 > (SELECT y2018 FROM work_times WHERE country = '한국')
;


-- 각각의 연도에서 평균 근로시간 최댓값. 
SELECT year, MAX(work_time)
FROM vw_work_times_long
GROUP BY year;

SELECT *
FROM vw_work_times_long
WHERE (year, work_time) in (               -- multi-row & multi-column 서브 쿼리
        SELECT year, MAX(work_time)
        FROM vw_work_times_long
        GROUP BY year;
);

-- 각각의 연도에서 평균 근로시간 최솟값.
SELECT year, MIN(work_time)
FROM vw_work_times_long
GROUP BY year;

SELECT *
FROM vw_work_times_long
WHERE (year, work_time) in (
        SELECT year, MIN(work_time) FROM vw_work_times_long GROUP BY year
);

SELECT * FROM vw_work_times_long ORDER BY work_time;
