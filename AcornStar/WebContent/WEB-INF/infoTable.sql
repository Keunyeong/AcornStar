-- info 게시판 게시글을 저장 할 테이블
CREATE TABLE info(
   num NUMBER PRIMARY KEY, -- 게시글의 글 번호
   writer VARCHAR2(100) NOT NULL, -- 글 작성자의 아이디
   title VARCHAR2(100) NOT NULL, -- 글 제목
   content CLOB, -- 글 내용
   upcount NUMBER, -- 조회수
   regdate DATE -- 등록일
);

CREATE SEQUENCE info_seq;


-- info 게시판 댓글을 저장 할 테이블
CREATE TABLE info_comment(
   num NUMBER PRIMARY KEY, --댓글의 글번호
   writer VARCHAR2(100), --댓글 작성자의 아이디
   content VARCHAR2(500) NOT NULL, --댓글 내용
   target_id VARCHAR2(100), --댓글의 대상자 아이디
   ref_group NUMBER,
   comment_group NUMBER,
   deleted CHAR(3) DEFAULT 'no',
   regdate DATE
);

CREATE SEQUENCE info_comment_seq;