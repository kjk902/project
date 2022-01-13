--게시판 테이블 생성
create table tbl_board(
bno number(10,0) constraint pk_board primary key,
title varchar2(200) not null,
writer varchar2(50) not null,
content varchar2(3500) not null,
regdate date default sysdate,
updatedate date default sysdate,
replycnt number(10,0) default 0);

select * from tbl_board;

select * from tab;


--댓글수 데이터 수정
update tbl_board
set replycnt = (
                select count(rno) from tbl_reply
                where tbl_reply.bno = tbl_board.bno);
    
commit;




--게시판 글번호 시퀀스 생성
--1부터 1,000,000,000번까지 생성가능
create sequence seq_board
increment by 1
start with 1
maxvalue 1000000000
minvalue 1
nocycle
nocache;




--더미 데이터 입력
--시퀀스가 2부터 시작되면 시퀀스 삭제 및 테이블 데이터 삭제후 다시 시도
truncate table tbl_board;
drop sequence seq_board;

insert into tbl_board (bno, title, writer, content)
values (seq_board.nextval, '제목', '작성자', '내용');

--재귀 복사
insert into tbl_board (bno, title, content, writer)
(select seq_board.nextval, title, content, writer from tbl_board);




--댓글 테이블 생성
--tbl_board의 bno칼럼을 외래키로 참조(on delete cascade로 게시물 삭제시 댓글도 삭제)
create table tbl_reply(
rno number(10,0) constraint pk_reply primary key,
bno number(10,0) constraint fk_reply_board references tbl_board(bno) on delete cascade,
reply varchar2(1000) not null,
replyer varchar2(50) not null,
replydate date default sysdate,
updatedate date default sysdate);

select * from tbl_reply;

select to_char( replydate, 'yyyy/MM/dd hh24:mi:ss' ) from tbl_reply;

--외래키 지정
alter table tbl_reply add constraint fk_reply_board foreign key (bno) references tbl_board(bno) on delete cascade;
--외래키 삭제
alter table tbl_reply drop constraint fk_reply_board;




--게시판 글번호 시퀀스 생성
--1부터 1,000,000,000번까지 생성가능
create sequence seq_reply
increment by 1
start with 1
maxvalue 1000000000
minvalue 1
nocycle
nocache;




--댓글 페이징 처리를 위한 인덱스 생성
create index idx_reply on tbl_reply (bno desc, rno asc); --복합 인덱스




--더미 데이터 입력
--시퀀스가 2부터 시작되면 시퀀스 삭제 및 테이블 데이터 삭제후 다시 시도
truncate table tbl_reply;
drop sequence seq_reply;

insert into tbl_reply (rno, bno, reply, replyer)
values (seq_reply.nextval, 498, '댓글내용', '작성자');

commit;




--회원 테이블 생성
create table tbl_member(
memberid varchar2(50) constraint pk_member primary key,
pw varchar2(100) not null,
membername varchar2(45) not null,
phone char(12) unique,  --핸드폰 번호 중복 불가
joindate date default sysdate,
enabled number(1) default 1); --회원이 이용가능하면 1, 불가능이면 0

select * from tbl_member;
desc tbl_member;
alter table tbl_member modify enabled number(1) default 1;
delete from tbl_member where memberid != 'admin';

--관리자 계정
insert into tbl_member (memberid, pw, membername) values ('admin', 'admin', '운영자');
update tbl_member set joindate = null where memberid = 'admin';


update tbl_member set phone = '00000000000' where memberid = 'admin';

--회원 권한 테이블 생성
create table tbl_auth(
authname varchar2(15) default 'ROLE_MEMBER' not null,
memberid varchar(50) constraint fk_member_auth references tbl_member(memberid) primary key
);

alter table tbl_auth modify memberid primary key;


select * from tbl_auth;
delete from tbl_auth where memberid != 'admin';

--회원 아이디와 회원 권한 외래키 지정(on delete cascade로 회원 탈퇴시 tbl_auth 테이블 데이터도 삭제)
alter table tbl_auth add constraint fk_member_auth foreign key (memberid) references tbl_member(memberid) on delete cascade;

--외래키 삭제
alter table tbl_auth drop constraint fk_member_auth;

--관리자 권한
insert into tbl_auth (authname, memberid) values ('ROLE_ADMIN', 'admin');




--데이터베이스 이용 자동 로그인
create table persistent_logins(
username varchar(64) not null,
series varchar(64) primary key,
token varchar(64) not null,
last_used timestamp not null);

select * from persistent_logins;

--외래키 검색
select CONSTRAINT_NAME, TABLE_NAME, R_CONSTRAINT_NAME
from user_constraints
where CONSTRAINT_NAME = 'JK.FK_REPLY_BOARD';

--pk 검색
select CONSTRAINT_NAME, TABLE_NAME, R_CONSTRAINT_NAME, constraint_type
from user_constraints
where constraint_type = 'P';


--첨부파일 등록
create table tbl_attach (
uuid varchar2(100) constraint pk_attach primary key,
uploadPath varchar2(200) not null,
fileName varchar2(100) not null,
filetype char(1) default '1',
bno number(10,0) constraint fk_board_attach references tbl_board(bno) on delete cascade
);

select * from tbl_attach;

--uuid를 primary key로 지정
alter table tbl_attach add constraint pk_attach primary key(uuid);

--bno 칼럼을 tbl_board의 bno를 참조하는 외래키로 지정
alter table tbl_attach add constraint fk_board_attach foreign key (bno) references tbl_board(bno) on delete cascade;

--외래키 삭제
alter table tbl_attach drop constraint fk_board_attach;




--테이블 전체 데이터 삭제
truncate table tbl_board;
truncate table tbl_reply;
truncate table tbl_member;
truncate table tbl_auth;
truncate table tbl_attach;

commit;
rollback;








update tbl_member set enabled = 0 where memberid = 'tester1';














