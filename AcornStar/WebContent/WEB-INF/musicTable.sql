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