CREATE TABLE users(
	id VARCHAR2(100) PRIMARY KEY,
	pwd VARCHAR2(100) NOT NULL,
	email VARCHAR2(100),
	profile VARCHAR2(100), -- 프로필 이미지 경로를 저장할 칼럼
	regdate DATE -- 가입일
);

create table feed(
   num NUMBER PRIMARY KEY, --글번호
   writer VARCHAR2(100) NOT NULL, --작성자 (로그인된 아이디)
   tag VARCHAR2(100), --태그
   content CLOB, --글 내용
   upCount NUMBER, -- 조회수
   regdate DATE --글 작성일
);

CREATE SEQUENCE feed_seq; 

create table main_feed(
   num NUMBER PRIMARY KEY, --글번호
   writer VARCHAR2(100) NOT NULL, --작성자 (로그인된 아이디)
   tag VARCHAR2(100), --태그
   image CLOB, --이미지
   content CLOB, --글 내용
   upCount NUMBER, -- 조회수
   regdate DATE --글 작성일
);

CREATE SEQUENCE main_feed_seq; 