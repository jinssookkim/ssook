/*
 * 제약조건(CONSTRAINT): 데이터의 무결성을 유지하기 위한 조건들
 1. primary key(PK, 고유키)
    - 테이블에서 유일한 1개의 행(row)을 선택할 수 있는 컬럼(들).
    - PK인 컬럼(들)은 null이 될 수 없고, 중복된 값을 가질 수 없음.
 2. not null(NN)
    - 반드시 값을 가져야만 하는 컬럼. null이 될 수 없는 컬럼.
 3. unique
    - 중복된 값을 가질 수 없는 컬럼. null은 여러 개 있을 수 있음.
 4. check
    - 컬럼에 삽입되는 값들이 어떤 특정 조건을 만족해야 하는 경우.
    - 2번 not null 제약 조건은 check의 특별한 경우. = check (column is not null)
 5. foreign key(FK, 외래키)
    - 다른 테이블의 고유 키(PK)를 참조하는 컬럼
    - (예) dept 테이블 PK인 deptno를 참조하는 emp 테이블의 컬럼(emp.deptno)
 */
 
 
-- 테이블 생성 시 제약조건 만들기 1: 제약조건의 이름을 설정하지 않는 경우
-- 오라클에서 제약조건 이름을 자동으로 만들어 줌. (예) SYS_C001234
CREATE table ex_tbl1 (
    eno     number(4) primary key,
    ename   varchar2(10) not null,
    email   varchar2(20) unique,
    salary  number(9) check (salary >= 0),
    memo    varchar2(100)
);

INSERT into ex_tbl1 
values (1004, '오쌤', 'jake', 1000000, '안녕하세요.');
COMMIT;

SELECT * FROM ex_tbl1;

-- 위 29라인에 INSERT 문장을 다시 실행시키면 primary key 위배로 에러가 발생

-- INSERT INTO ex_tbl1 (ename) values ('홍길동');
--> PK 컬럼인 eno는 null이 될 수 없기 때문에 에러가 발생

INSERT INTO ex_tbl1 (eno, ename) values (1005, null);
--> ename이 not null이라는 제약조건 위배

INSERT INTO ex_tbl1 (eno, ename) values (2001, '홍길동');
COMMIT;

SELECT * FROM ex_tbl1;

INSERT INTO ex_tbl1 (eno, ename, email) values (2002, '홍길동', 'jake');
--> email이 unique라는 제약조건 위배

INSERT INTO ex_tbl1 (eno, ename, salary) values (3000, '김길동', -100);

-- 데이터 무결성: 테이블에 데이터를 삽입(insert)할 때 결점이 없는 데이터들만 입력될 수 있도록 유지 하는 것.


-- 테이블 생성 시 제약조건 만들기 2: 제약조건의 이름을 직접 설정.
-- (1) 컬럼을 선언하는 줄에서 제약조건 이름을 설정
CREATE table ex_tbl2 (
    /*컬럼 선언과 함께 제약조건 이름/내용을 설정*/
    id      number(4) 
            CONSTRAINT tbl2_pk_id primary key,
    name    varchar2(10) 
            CONSTRAINT tbl2_nn_name not null,
    email   varchar2(20) 
            CONSTRAINT tbl2_uq_email unique,
    salary  number(9) 
            CONSTRAINT tbl2_ck_salary check (salary >= 0),
    memo    varchar2(100)
);



-- (2) 컬럼 선언 따로, 제약조건 선언 따로.
CREATE table ex_tbl3 (
    /* 컬럼 선언부 */
    id      number(4),
    name    varchar2(10),
    email   varchar2(20),
    salary  number(9),
    memo    varchar2(100), -- << 쉼표 꼭 들어가야 함!
    
    /* 제약조건 선언부 */
    CONSTRAINT tbl3_pk_id primary key (id),
    CONSTRAINT tbl3_nn_name check (name is not null),
    CONSTRAINT tbl3_uq_email unique (email),
    CONSTRAINT tbl3_ck_salary check (salary >= 0)
);


-- foriegn key: (다른/같은) 테이블의 PK를 참조(reference)하는 제약조건.
-- 데이터를 삽입할 때 PK에 없는 값은 삽입되지 않도록 하기 위해서
-- (1) PK를 갖는 테이블을 먼저 생성, 그 PK를 참조하는 FK를 찾는 테이블을 나중에 생성.
--     예: dept 테이블을 먼저 생성, emp 테이블 나중에 생성
-- (2) PK/FK 제약조건 설정 없이 테이블(들)을 먼저 생성하고, 그 후에 제약조건을 추가(ALTER). --> 상호참조하는 테이블들이 있는 경우 사용.

-- PK를 갖는 테이블. 다른 테이블에서 참조하게 될 테이블.
CREATE table ex_dept (
    /* 컬럼 선언 */
    id      number(2),
    name    varchar2(10),
    
    /* 제약 조건 */
    CONSTRAINT ex_dept_pk_id primary key (id)
);


INSERT INTO ex_dept values (10, 'HR');
INSERT INTO ex_dept values (20, 'IT');
COMMIT;

-- FK를 갖는 테이블. ex_dept 테이블의 id 컬럼을 참조하는 테이블.
-- (1) 제약조건 이름 없이 컬럼 선언과 함께 FK 제약조건을 설정
CREATE table ex_emp2 (
    id      number(4) primary key,
    name    varchar2(10),
    dept_id number(2) REFERENCES ex_dept (id)
);


INSERT INTO ex_emp2 values (1004, '오쌤', 20);
COMMIT;

-- INSERT INTO ex_emp2 values (1005, '마루', 40);
-- ex_dept 테이블의 id 컬럼에 값 40이 없기 때문에 오류 발생


-- (2) 컬럼 선언과 함께 제약조건 이름과 내용 설정
CREATE table ex_emp3 (
    id      number(4)
            CONSTRAINT ex_emp3_pk_id primary key,
    name    varchar2(10),
    dept_id number(2)
            CONSTRAINT ex_emp3_fk_dept_id references ex_dept (id)
);


-- (3) 컬럼 선언 따로, FK 제약조건 따로 설정. ** foriegn key ** 라는 예약어 사용하는 유일한 방법.
CREATE table ex_emp4 (
    id      number(4),
    name    varchar2(10),
    dept_id number(2),
    
    CONSTRAINT ex_emp4_pk_id primary key (id),
    CONSTRAINT ex_emp4_fk_dept_id foreign key (dept_id) REFERENCES ex_dept (id)
);



CREATE table ex_test (
    id          number(6)
                CONSTRAINT test_pk_id primary key,
    content     varchar2(1000) not null, 
    view_cnt    number(6)
                default 0 -- 선언하는 곳에서 무조건 써야함. 제약조건처럼 따로 뺄 수 없음.
                CONSTRAINT test_ck_view_cnt check(view_cnt >= 0), 
    created_time date default sysdate
);



INSERT INTO ex_test (id, content) values (1, '안녕하세요.');

INSERT INTO ex_test values (2, '오늘은 금요일입니다.', 100, '2025/12/01');

COMMIT;

SELECT * FROM ex_test;



/*
 * 연습문제 1.
 * 테이블 이름: customers(고객)
 * 컬럼:
 * (1) cust_id: 고객 아이디. 8 ~ 20 byte의 문자열. primary key.
 * (2) cust_pw: 고객 비밀번호. 8 ~ 20 byte의 문자열. not null.
 * (3) cust_email: 고객 이메일. 100 byte 가변 길이 문자열.
 * (4) cust_gender: 고객 성별. 1자리 정수. 기본값 0. (0, 1, 2) 중 1개 값만 가능.
 * (5) cust_age: 고객 나이. 3자리 정수. 기본값 0. 0 이상 200 이하의 정수만 가능.
 */


CREATE table customers (
    cust_id     varchar2(20)
                CONSTRAINT cust_id_pk primary key
                CONSTRAINT cust_id_ck check (LENGTHB(cust_id) >= 8),
    cust_pw     varchar2(20) not null -- not null은 이름 잘 안 줌
                CONSTRAINT cust_pw_ck check (LENGTHB(cust_pw) >= 8),
    cust_email  varchar2(100),
    cust_gender number(1) default 0
                CONSTRAINT cust_gender_ck check (cust_gender in (0, 1, 2)),
    cust_age    number(3) default 0
                CONSTRAINT cust_age_ck check (cust_age between 0 and 200)
);


/*
 * 연습문제 2.
 * 테이블 이름: orders(주문)
 * 컬럼:
 * (1) order_id: 주문번호. 10자리 정수. primary key.
 * (2) order_date: 주문 날짜. 기본값은 현재 시간.
 * (3) order_method: 주문 방법. 8 byte 문자열. ('online', 'offline') 중 1개 값만 가능.
 * (4) cust_id: 주문 고객 아이디. 20 byte 문자열. not null. customers(cust_id)를 참조.
 */
 
 
CREATE table orders (
    order_id        number(10) primary key,
    order_date      date 
                    default sysdate,
    order_method    varchar2(8) check (order_method in ('online', 'offline'),
    cust_id         varchar2(20) not null and REFERENCES customers (cust_id)
);

 
 
CREATE table orders (
    order_id        number(10),
    order_date      date default sysdate,
    order_method    varchar2(8),
    cust_id         varchar2(20) not null,
    
    CONSTRAINT order_id_pk primary key (order_id),
    CONSTRAINT order_method_ck check (order_method in ('online', 'offline')),
    CONSTRAINT cust_id_rf foreign key (cust_id) REFERENCES customers (cust_id)  
);


