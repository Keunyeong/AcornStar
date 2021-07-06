create table feed(
   num NUMBER PRIMARY KEY, --글번호
   writer VARCHAR2(100) NOT NULL, --작성자 (로그인된 아이디)
   tag VARCHAR2(100), --제목
   content CLOB, --글 내용
   upCount NUMBER, -- 조회수
   regdate DATE --글 작성일
);

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