/* 
 * 연습문제 - scott 계정을 사용
 */

-- 1) ROWNUM: Oracle에서 제공되는 가상(Pseudo) 컬럼.
SELECT ROWNUM, e.* from emp e ORDER BY empno; --> 정렬이 제일 마지막 순서로 실행되기 때문에 15번으로 rownum된 오쌤이 첫 번째 순서로 옴.

SELECT ROWNUM, t.*
FROM (SELECT * FROM emp ORDER BY empno
     ) t
WHERE ROWNUM between 6 and 10; -- 정상적으로 동작하지 않음. ROWNUM이 가상 컬럼이기 때문에.
--------------> 해결 방법
SELECT t2.*
FROM (SELECT ROWNUM RN,
             t1.* 
      FROM(SELECT * FROM emp ORDER BY empno
      ) t1   
)t2
WHERE t2.RN between 6 and 10;

WITH t2 AS (SELECT 
            ROWNUM RN, t1.* 
            FROM(SELECT * FROM emp ORDER BY empno
            ) t1
)      
SELECT t2.*
FROM t2
WHERE t2.RN between 11 and 15; 

-- 2) ROW_NUMBER() 윈도우 함수 사용:
SELECT 
    e.*,
    ROW_NUMBER() OVER (ORDER BY empno) as RN
FROM emp e;

WITH t as (
    SELECT
        emp.*,
        ROW_NUMBER() OVER (ORDER BY empno) 사번순서
    FROM emp
)
SELECT t.*
FROM t
WHERE t.사번순서 between 11 and 15;

-- 3) Top-N 쿼리: 위에 있는 N개의 값을 가져오는 쿼리
SELECT *
FROM emp
ORDER BY empno
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
--> TOP-N 쿼리 위쪽에는 정렬까지 끝난 완전한 문장이 있어야 함.
--> OFFSET x ROWS: 첫 x개의 행을 건너 뛰고,
--> FETCH NEXT y ROWS ONLY: y개의 행들만 출력해라.


--SELECT * FROM emp ORDER BY empno;

-- 페이징(paging) 처리
-- 1. 직원 테이블을 사번 오름차순으로 정렬했을 때 1 ~ 5번 행까지 출력
SELECT *
FROM emp
ORDER BY empno FETCH FIRST 5 ROWS ONLY;

-- 2. 직원 테이블을 사번 오름차순으로 정렬했을 때 6 ~ 10번 행까지 출력
SELECT *
FROM emp
ORDER BY empno OFFSET 5 ROWS
FETCH FIRST 5 ROWS ONLY;

-- 3. 직원 테이블을 사번 오름차순으로 정렬했을 때 11 ~ 15번 행까지 출력
SELECT *
FROM emp
ORDER BY empno OFFSET 10 ROWS
FETCH FIRST 5 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------


/*
 * 연습문제 - hr 계정을 사용
 * - hr.sql 스크립트를 실행
 * - hr 계정의 테이블 내용을 파악
 * - 연습문제들에서 직원의 이름은 이름(first_name)과 성(last_name)을 붙여서 하나의 컬럼으로 출력.
 *   (예) Steven King
 */

-- 1. 직원의 이름과 부서 이름을 출력. (inner join)
SELECT 
      e.first_name || ' ' || last_name as 직원이름, 
      d.department_name as 부서이름
FROM employees e
     JOIN departments d ON e.department_id = d.department_id;

-- 2. 직원의 이름과 부서 이름을 출력. 부서 번호가 없는 직원도 출력.
SELECT 
      e.first_name || ' ' || last_name as 직원이름, 
      d.department_name as 부서이름
FROM employees e
     LEFT JOIN departments d ON e.department_id = d.department_id;

-- 3. 직원의 이름과 직무 이름(job title)을 출력.
SELECT 
      e.first_name || ' ' || last_name as 직원이름,
      j.job_title as 직무이름
FROM employees e
     JOIN jobs j ON e.job_id = j.job_id;
          
-- NULL값 찾아야 하는 경우, COUNT쓸 때, * 를 사용. 왜냐하면, COUNT함수 자체는 NULL값이 아닌 것만 세기 때문.
--SELECT COUNT(*) FROM employees WHERE department_id is null;

-- 4. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력.
SELECT 
     e.first_name || ' ' || last_name as 직원이름,
     l.city as 도시이름
FROM employees e
     JOIN departments d ON e.department_id = d.department_id
     JOIN locations l ON d.location_id = l.location_id;

-- 5. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력. 근무 도시를 알 수 없는 직원도 출력.
SELECT 
     e.first_name || ' ' || last_name as 직원이름,
     l.city as 도시이름
FROM employees e
     LEFT JOIN departments d ON e.department_id = d.department_id
     LEFT JOIN locations l ON d.location_id = l.location_id;
     
-- 6. 2008년에 입사한 직원들의 이름을 출력.
-- 6-1. 입사일을 DATE 타입의 크기 비교를 사용
SELECT first_name || ' ' || last_name as 직원이름
FROM employees
WHERE hire_date between TO_DATE('2008/01/01', 'YYYY/MM/DD') and TO_DATE('2008/12/31', 'YYYY/MM/DD'); 
--
SELECT first_name || ' ' || last_name as 직원이름
FROM employees
WHERE hire_date between '08/01/01' and '08/12/31';
--> '2008-01-01' 문자열을 암묵적으로 DATE 타입으로 변환한 다음에 크기 비교.
-- 6-2. 입사일(DATE)을 문자열로 변환해서 문자열 비교 
SELECT 
     first_name || ' ' || last_name as 직원이름
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '2008';

-- 7. 2008년에 입사한 직원들의 부서 이름과 부서별 인원수 출력.
SELECT 
      d.department_name "부서 이름",
      count(*) "부서별 인원수"
FROM employees e
     JOIN departments d ON e.department_id = d.department_id
WHERE TO_CHAR(hire_date, 'YYYY') = '2008'
GROUP BY d.department_name;
-- (참고) 부서별 인원수. 부서번호가 없는 직원 포함.
SELECT 
     d.department_name, count(*)
FROM employees e
     LEFT JOIN departments d ON e.department_id = d.department_id
GROUP BY ROLLUP(d.department_name); 
-- ** rollup: GROUP BY에서만 사용할 수 있는, 변수 합계나 평균, 최댓값 등등을 보여주는 함수. 지정되지 않은 경우, SUM으로 작동. SELECT에서 사용 불가.

-- 8. 2008년에 입사한 직원들의 부서 이름과 부서별 인원수 출력. 
--    단, 부서별 인원수가 5명 이상인 경우만 출력.
SELECT 
      d.department_name 부서이름,
      count(*) as "부서별 인원수"
FROM employees e
     JOIN departments d ON e.department_id = d.department_id
WHERE TO_CHAR(hire_date, 'YYYY') = '2008'
GROUP BY d.department_name
HAVING count(*) >= 5;

-- 9. 부서번호, 부서별 급여 평균을 검색. 소숫점 한자리까지 반올림 출력.
SELECT department_id 부서번호,
       ROUND(AVG(salary), 1) 급여평균
FROM employees
-- WHERE department_id is not null
GROUP BY department_id;
-- ORDER BY department_id;

-- 10. 부서별 급여 평균이 최대인 부서의 부서번호, 급여 평균을 출력.
-- (1) having 절과 서브쿼리 사용
SELECT department_id 부서번호,
       ROUND(AVG(salary), 1) 급여평균
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
            SELECT MAX(AVG(salary)) FROM employees GROUP BY department_id
            );

-- (2) from 절에서의 서브쿼리 사용
SELECT t.*
FROM (SELECT
         department_id as 부서번호, 
         ROUND(AVG(salary)) as 급여평균
       FROM employees
       GROUP BY department_id
       HAVING ROUND(AVG(salary)) = (SELECT MAX(ROUND(AVG(salary)))  
                                    FROM employees 
                                    GROUP BY department_id
                                    )           
      ) t
;

-- 선생님 답. max는 통계함수. 통계함수 select할 때에는 t.department_id << 사용할 수 없음.
SELECT MAX("급여 평균")
FROM (SELECT
         department_id as "부서 번호", 
         ROUND(AVG(salary)) as "급여 평균"
       FROM employees
       GROUP BY department_id
       ) t;
--> from절에서의 서브 쿼리는 select되는 값이 최대값 항목만이 나올 수 밖엔 없음

-- (3) with 식별자 as (서브쿼리) 사용
WITH t as (SELECT department_id as 부서번호,
                  ROUND(AVG(salary)) as 급여평균
            FROM employees 
            GROUP BY department_id
            HAVING ROUND(AVG(salary)) = (SELECT MAX(ROUND(AVG(salary)))  
                                        FROM employees 
                                        GROUP BY department_id
                                        )       
            )
SELECT t.*
FROM t;

-- 선생님 답.
WITH t as (SELECT department_id as "부서 번호",
                  ROUND(AVG(salary)) as "급여 평균"
            FROM employees 
            GROUP BY department_id
            )
SELECT *
FROM t
WHERE t."급여 평균" = (SELECT MAX(t."급여 평균") 
                      FROM t
                      )
;

-- (4) offset-fetch 사용
SELECT *
FROM (SELECT department_id, ROUND(AVG(salary)) as 급여평균 
     FROM employees 
     GROUP BY department_id 
     ORDER BY 급여평균 desc) t
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY;

-- 선생님 답
SELECT department_id, ROUND(AVG(salary)) as 급여평균
FROM employees
GROUP BY department_id
ORDER BY 급여평균 desc
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

-- 11. 사번, 직원 이름, 국가 이름, 급여 출력.
SELECT employee_id as 사번, 
       first_name || ' ' || last_name as 직원이름,
       country_name 국가이름,
       salary 급여
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id;
       
-- Oracle 문법
SELECT employee_id as 사번, 
        first_name || ' ' || last_name as 직원이름,
        country_name 국가이름,
        salary 급여
FROM employees e, departments d, locations l, countries c
WHERE e.department_id = d.department_id and
      d.location_id = l.location_id and
      l.country_id = c.country_id;

       
-- 12. 국가이름, 국가별 급여 합계 출력.
SELECT 
       country_name "국가 이름",
       SUM(salary) "급여 합계"
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
GROUP BY country_name;
-- ORDER BY "급여 합계" desc;

-- 13. 사번, 직원이름, 직무 이름, 급여를 출력.
SELECT
      e.employee_id as 사번,
      e.first_name || ' ' || e.last_name as 직원이름,
      j.job_title as 직무이름,
      e.salary as 급여
FROM employees e
     JOIN jobs j ON e.job_id = j.job_id;

-- 14. 직무 이름, 직무별 급여 평균, 최솟값, 최댓값을 출력.
SELECT 
      job_title as 직무이름,
      AVG(salary) as "급여 평균",
      MIN(salary) as "급여 최솟값",
      MAX(salary) as "급여 최댓값"
FROM employees e
     JOIN jobs j ON e.job_id = j.job_id
GROUP BY job_title  
ORDER BY 직무이름;

-- 15. 국가 이름, 직무 이름, 국가별 직무별 급여 평균을 출력.
SELECT 
       country_name "국가 이름",
       job_title "직무 이름",
       ROUND(AVG(salary)) "급여 평균"
FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
GROUP BY ROLLUP (country_name, job_title)
ORDER BY "국가 이름", "직무 이름";

-- 16. 국가 이름, 직무 이름, 국가별 직무별 급여 합계을 출력.
--     미국에서, 국가별 직무별 급여 합계가 50,000 이상인 레코드만 출력.
SELECT 
       country_name "국가 이름",
       job_title "직무 이름",
       SUM(salary) "급여 합계"
FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
GROUP BY ROLLUP(country_name, job_title)
HAVING country_name = 'United States of America' and
       SUM(salary) >= 50000;
-- ORDER BY sal;


SELECT 
       country_name "국가 이름",
       job_title "직무 이름",
       SUM(salary) "급여 합계"
FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
WHERE c.country_id = 'US'
GROUP BY country_name, job_title
HAVING SUM(e.salary) >= 50000;





-- 17. 부서번호, 부서이름, 부서매니저 사번, 부서매니저 이름, 부서매니저 직무, 부서매니저 급여
SELECT 
     d.department_id,
     d.department_name,
     d.manager_id,
     e.first_name || ' ' || e.last_name,
     j.job_title,
     e.salary
FROM departments d
    JOIN employees e ON d.manager_id = e.employee_id
    JOIN jobs j ON j.job_id = e.job_id
ORDER BY d.department_id;

