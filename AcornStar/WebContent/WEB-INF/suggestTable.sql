-- 게시글을 저장할 테이블 
CREATE TABLE suggest(
	num NUMBER PRIMARY KEY, --글번호
	writer VARCHAR2(100) NOT NULL, --작성자 (로그인된 아이디)
	title VARCHAR2(100) NOT NULL, --제목
	content CLOB, --글 내용
	viewCount NUMBER, -- 조회수
	regdate DATE --글 작성일
);
-- 게시글의 번호를 얻어낼 시퀀스
CREATE SEQUENCE suggest_seq; 

CREATE TABLE suggest_comment(
	num NUMBER PRIMARY KEY,
	writer VARCHAR2(100),
	content VARCHAR2(500),
	target_id VARCHAR2(100),
	ref_group NUMBER,
	comment_group NUMBER,
	deleted CHAR(3) DEFAULT 'no',
	regdate DATE
);

CREATE SEQUENCE suggest_comment_seq;