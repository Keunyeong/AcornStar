CREATE TABLE users(
	id VARCHAR2(100) PRIMARY KEY,
	name VARCHAR2(100),
	pwd VARCHAR2(100) NOT NULL,
	email VARCHAR2(100),
	profile clob, -- 프로필 이미지 경로를 저장할 칼럼
	friends clob,
	uplist clob,
	intro clob,
	autority CHAR(3) DEFAULT 'no',
	regdate DATE -- 가입일
);

create table main_feed(
   num NUMBER PRIMARY KEY, --글번호
   writer VARCHAR2(100) NOT NULL, --작성자 (로그인된 아이디)
   tag VARCHAR2(100), --태그
   image CLOB, --이미지
   content CLOB, --글 내용
   upCount NUMBER, -- 조회수
   upMember CLOB,--좋아요아이디
   regdate DATE --글 작성일
);

CREATE SEQUENCE main_feed_seq; 

CREATE TABLE feed_comment(
	num NUMBER PRIMARY KEY, --댓글의 글번호
	writer VARCHAR2(100), --댓글 작성자의 아이디
	content VARCHAR2(500), --댓글 내용
	target_id VARCHAR2(100), --댓글의 대상자 아이디
	ref_group NUMBER,
	comment_group NUMBER,
	deleted CHAR(3) DEFAULT 'no',
	regdate DATE
);

CREATE SEQUENCE feed_comment_seq;