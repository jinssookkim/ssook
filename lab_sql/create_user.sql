/*
 * 사용자 계정 생성, 권한 부여
 */
 
-- 오라클 12c 버전부터는 사용자 계정 이름에 "C##" 접두사를 붙여야만 하도록 변경
-- 사용자 계정 이름을 "C##"으로 시작하고 싶지 않을 때 세션 정보를 변경하면 됨
ALTER SESSION SET "_ORACLE_SCRIPT" = true;

-- 계정 이름 hr, 비밀번호 hr인 계정을 생성.
CREATE user hr IDENTIFIED BY hr;

-- hr 계정에 어드민(관리자) 권한을 부여
GRANT dba to hr;

-- 계정 삭제
-- drop user hr;