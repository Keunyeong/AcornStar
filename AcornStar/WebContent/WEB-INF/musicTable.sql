create table music_feed(
	num number primary key,
	writer varchar2(100) not null, --작성자 (로그인된 아이디)
   	title varchar2(100), --제목
   	content CLOB, --글 내용
   	link varchar2(100), -- youtube link
   	upCount NUMBER, -- 조회수
   	tag varchar2(100),
   	regdate date --글 작성일
);

create sequence music_feed_seq;

create table music_comment(
	num number primary key, --댓글의 글번호
   	writer varchar2(100), --댓글 작성자의 아이디
   	content varchar2(500), --댓글 내용
   	target_id varchar2(100), --댓글의 대상자 아이디
   	ref_group number,
   	comment_group number,
   	deleted CHAR(3) DEFAULT 'no',
   	regdate DATE
);

create sequence music_comment_seq;
