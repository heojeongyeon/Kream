[회원가입]
create or replace procedure up_join
(
     pm_email  tb_member.m_email%type
    ,pm_pw     tb_member.m_pw%type
    ,pm_tel    tb_member.m_tel%type
    ,pm_size   tb_member.m_size%type
    ,pm_name   tb_member.m_name%type
    ,pm_birth  tb_member.m_birth%type
    ,pm_age_agree  tb_member.m_age_agree%type
    ,pm_mail_agree   tb_member.m_mail_agree%type
    ,pm_regdate  tb_member.m_regdate%type
    
    
)
IS

vm_email tb_member.m_email%type;

BEGIN

select m_email into vm_email
from tb_member 
where m_email = pm_email;
dbms_output.put_line('이미사용중인이메일입니다');

EXCEPTION
when no_data_found then
if pm_age_agree = '1' then
insert into tb_member (m_email, m_pw,m_tel, m_size,m_name, m_birth, m_age_agree, m_mail_agree, m_regdate) 
values (pm_email, pm_pw, pm_tel, pm_size, pm_name, pm_birth, pm_age_agree, pm_mail_agree, pm_regdate);
dbms_output.put_line('회원가입이완료되었습니다'); 
else
dbms_output.put_line('약관동의해주세요'); 
END IF;
END;

exec up_join('m1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); --약관동의해주세요
exec up_join('minji1234@naver.com', 'aLYwWVpX', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); --회원가입이완료되었습니다
exec up_join('hyungjs1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '1', '1', sysdate); --이미사용중인이메일입니다

회원정보확인
select *
from tb_member





[로그인]

create or replace procedure up_login
(
     pm_email  tb_member.m_email%type
    ,pm_pw     tb_member.m_pw%type
)
IS

vm_email tb_member.m_email%type := pm_email;

BEGIN

select m_email into vm_email
from tb_member 
where m_email = vm_email and m_pw = pm_pw;

if vm_email = pm_email then
dbms_output.put_line('로그인');
end if;
EXCEPTION
when no_data_found then
dbms_output.put_line('이메일과 비밀번호를 확인해 주세요');
END;

 
exec up_login('hyungjs1234@naver.com', 'minji!!ya'); --로그인 성공
exec up_login('nsdjfn@naver.com', 'minji!!ya'); --'이메일과 비밀번호를 확인해 주세요'






[이메일 찾기]
create or replace procedure up_findemail
(
     pm_tel    tb_member.m_tel%type
)
IS

vm_tel tb_member.m_tel%type := pm_tel;
vm_email tb_member.m_email%type;

BEGIN

SELECT m_email into vm_email
FROM tb_member
WHERE m_tel = pm_tel;
   
if vm_tel = pm_tel then
dbms_output.put_line(rpad(substr(vm_email, 1, 1), instr(vm_email, '@')-2, '*')||substr(vm_email, instr(vm_email,'@')-1));
end if;

EXCEPTION
when no_data_found then
dbms_output.put_line('일치하는 사용자 정보를 찾을 수 없습니다');
END;


exec up_findemail('010-1234-5678');   --minji1234@naver.com
exec up_findemail('010-2938-7563');   --일치하는 사용자 정보를 찾을 수 없습니다






[비밀번호 찾기]
create or replace procedure up_findpw
(
     pm_tel    tb_member.m_tel%type
     ,pm_email    tb_member.m_email%type
)
IS

vm_tel tb_member.m_tel%type := pm_tel;
vm_email tb_member.m_email%type := pm_email;

BEGIN

if vm_email = pm_email then
SELECT m_email into vm_email
FROM tb_member
WHERE m_email = vm_email and m_tel = pm_tel;
dbms_output.put_line('임시 비밀번호를 전송하였습니다. 전송 받은 임시 비밀번호로 로그인해주세요.');
end if;

update tb_member 
set m_pw = dbms_random.string('A', 8)
where vm_email = pm_email;

EXCEPTION
when no_data_found then
dbms_output.put_line('일치하는 사용자 정보를 찾을 수 없습니다');
END;


exec up_findpw ('010-1234-5678', 'minji1234@naver.com'); --임시 비밀번호를 전송하였습니다. 전송 받은 임시 비밀번호로 로그인해주세요.
exec up_findpw ('010-9876-3746', 'h12345@naver.com'); --일치하는 사용자 정보를 찾을 수 없습니다

select *
from tb_member;  --임시 비밀번호로 바뀐거 확인




====================================================================================================================

[홈]

[럭셔리 아이템 기준 출력 제품]
create or replace procedure up_home
is
begin
dbms_output.put_line('Luxury Items');
dbms_output.put_line('쉽게 만날 수 없던 럭셔리!');
for vrow in 
(
select t.*
from (
      select i_image, i_brand, i_name_eng, i_realeasep , col_name
      from tb_item right join tb_collection on tb_item.i_id = tb_collection.i_id 
      where col_name = 'Luxury'
      )t
where rownum <= 4
 ORDER BY DBMS_RANDOM.RANDOM()
)
loop
dbms_output.put_line(vrow.i_image ||' ,' || vrow.i_brand ||' ,' || vrow.i_name_eng || ', '|| vrow.i_realeasep);
end loop;
end;

exec up_home;






[브랜드 상품 출력]
create or replace procedure up_home2
is
begin
dbms_output.put_line('Brand Focus');
dbms_output.put_line('추천 브랜드');
for i in 1..3
loop
for vrow in(
select i_image, i_brand
from (
        select i_image, i_brand 
        from tb_item
      )t
where rownum <= 5
ORDER BY DBMS_RANDOM.RANDOM()
)
loop
dbms_output.put_line(vrow.i_image || '  '|| vrow.i_brand);
end loop;
dbms_output.put_line('  ');
end loop;
end;

exec up_home2;






[발매일 기준 출력]
create or replace procedure up_home3
is
begin
dbms_output.put_line('Just Dropped');
dbms_output.put_line('발매 상품');
for vrow in(
select t.*
from (
      select i_image, i_brand, i_name_eng,is_gprice
      from tb_item left join tb_itemsize on tb_item.i_id = tb_itemsize.i_id 
      where i_rdate is not null
      order by i_rdate desc
      )t
where rownum <= 4
)
loop
dbms_output.put_line(vrow.i_image || '  '||vrow.i_brand ||'  '|| vrow.i_name_eng ||'  '||vrow.is_gprice);
end loop;
end;

exec up_home3;






[즉시 구매가 기준 출력]
create or replace procedure up_home4
is 
begin
dbms_output.put_line('New Lowest Asks');
dbms_output.put_line('새로운 즉시 구매가');
for vrow in (
select t.*
from (
      select i_image, i_brand, i_name_eng, is_gprice
      from tb_item right join tb_itemsize on tb_item.i_id = tb_itemsize.i_id 
      order by is_gprice
      )t
where rownum <= 4
)
loop
dbms_output.put_line(vrow.i_image || '  '||vrow.i_brand ||'  '|| vrow.i_name_eng ||'  '||vrow.is_gprice);
end loop;
end;

exec up_home4;






[인기 상품 출력]
create or replace procedure up_home5
is
begin
dbms_output.put_line('Most Popular');
dbms_output.put_line('인기 상품');
for vrow in(
select t.*
from (
      select i_image, i_brand, i_name_eng, is_gprice
      from tb_item left join tb_itemsize on tb_item.i_id = tb_itemsize.i_id 
      order by i_interest_cnt desc
      )t
where rownum <= 4
)
loop
dbms_output.put_line(vrow.i_image || '  '||vrow.i_brand ||'  '|| vrow.i_name_eng ||'  '||vrow.is_gprice);
end loop;
end;

exec up_home5;




==========================================================================================================

[공지사항]

CREATE OR REPLACE PROCEDURE up_gong
is
begin
dbms_output.put_line('공지사항');
for vrow in ( select nt_title from tb_notice ) 
loop
dbms_output.put_line(vrow.nt_title);
end loop;
end;

exec up_gong;


[공지사항 - 내용]
CREATE OR REPLACE PROCEDURE up_gong2
(
pnt_title tb_notice.nt_title%type
)
is
begin
dbms_output.put_line('공지사항');
for i in
(
select nt_write_date, nt_title, nt_content
from tb_notice
where nt_title = pnt_title
)
loop
dbms_output.put_line(i.nt_write_date);
dbms_output.put_line(i.nt_title);
dbms_output.put_line(i.nt_content);
end loop;
end;


exec up_gong2('[공지]온라인 사업자 세무 관련 안내');




[공지사항 등록]
CREATE SEQUENCE seq_notice;

 create or replace procedure up_insnotice
(
     padm_id          tb_admin.adm_id%type
    ,pnt_write_date   tb_notice.nt_write_date%type
    ,pnt_type         tb_notice.nt_type%type
    ,pnt_title        tb_notice.nt_title%type 
    ,pnt_content      tb_notice.nt_content%type
)
IS

vnt_title        tb_notice.nt_title%type ;

BEGIN

select nt_title into vnt_title
from tb_notice
where nt_title = pnt_title;
dbms_output.put_line('이미 존재합니다');

EXCEPTION
when no_data_found then
if padm_id = 'ADMIN01' then
insert into tb_notice (nt_id, adm_id, nt_write_date, nt_type, nt_title, nt_content)
values (seq_notice.nextval 
        , (select adm_id from tb_admin where adm_id = padm_id)
        , pnt_write_date
        , pnt_type
        , pnt_title
        , pnt_content
        );
dbms_output.put_line('공지사항이 등록 되었습니다');
else
dbms_output.put_line('관리자 아이디를 확인해 주세요');
end if;
end;



exec up_insnotice ('ADMIN01', sysdate, '공지', '오예', '냠냠');   --공지사항이 등록 되었습니다
exec up_insnotice ('ADMIN02', sysdate, '공지', '오예', '냠냠');   --관리자 아이디를 확인해 주세요


select *
from tb_notice  -등록 확인



[공지사항 삭제]
CREATE OR REPLACE PROCEDURE up_delfaq
(
   pnt_id   tb_notice.nt_id%type
   ,padm_id  tb_admin.adm_id%type
)
IS
BEGIN
   DELETE FROM tb_notice
   WHERE nt_id = pnt_id and padm_id = 'ADMIN01';
   dbms_output.put_line('삭제되었습니다');
   
exception
when no_data_found then
dbms_output.put_line('삭제되었습니다');
END;


exec up_delfaq(18, 'ADMIN01'); --삭제되었습니다


select *
from tb_notice




[자주 묻는 질문]
create or replace procedure up_gong3
IS
BEGIN
dbms_output.put_line('자주 묻는 질문');
for vrow in
(
select faq_type, faq_title
from tb_faq
)
loop
dbms_output.put_line(vrow.faq_type ||'  '|| vrow.faq_title);
end loop;
end;

exec up_gong3;




[자주 묻는 질문 - 세부]
create or replace procedure up_gong4
(
pfaq_type tb_faq.faq_type%type
)
is
begin
dbms_output.put_line('자주 묻는 질문');
for i in
(
      select faq_type, faq_title
      from tb_faq
      where faq_type = pfaq_type
 )     
loop
dbms_output.put_line( i.faq_type ||'  '|| i.faq_title);
end loop;
end;

exec up_gong4('판매');





[자주 묻는 질문 - 세부]
create or replace procedure up_gong5
(
pfaq_title tb_faq.faq_title%type
)
is
begin
dbms_output.put_line('자주 묻는 질문');
for i in
(
      select faq_type, faq_title, faq_content, faq_update_date
      from tb_faq
      where faq_title = pfaq_title
 )     
loop
dbms_output.put_line(i.faq_type ||'  '|| i.faq_title);
dbms_output.put_line(i.faq_update_date);
dbms_output.put_line(i.faq_content);
end loop;
end;


exec up_gong5('판매자의 페널티 결제 정보는 왜 필요한가요?');



[자주 묻는 질문 등록]
CREATE SEQUENCE seq_faq;

 create or replace procedure up_insfaq
(
     padm_id            tb_admin.adm_id%type
    ,pfaq_write_date    tb_faq.faq_write_date%type
    ,pfaq_type          tb_faq.faq_type%type
    ,pfaq_title         tb_faq.faq_title%type
    ,pfaq_content       tb_faq.faq_content%type 
)
IS

vfaq_title        tb_faq.faq_title%type ;

BEGIN

select faq_title into vfaq_title
from tb_faq
where faq_title = pfaq_title;
dbms_output.put_line('이미 존재합니다');

EXCEPTION
when no_data_found then
if padm_id = 'ADMIN01' then
insert into tb_faq (faq_id, adm_id, faq_write_date, faq_type, faq_title, faq_content )
values (seq_faq.nextval 
        , (select adm_id from tb_admin where adm_id = padm_id)
        , pfaq_write_date
        , pfaq_type
        , pfaq_title
        , pfaq_content
        );
dbms_output.put_line('자주묻는 질문이 등록 되었습니다');
else
dbms_output.put_line('관리자 아이디를 확인해 주세요');
end if;
end;


exec up_insfaq('ADMIN01', sysdate, '구매', '자주자주자주', '묻는질문묻는질문');   --자주묻는 질문이 등록 되었습니다

select *
from tb_faq



[검수기준]
create or replace procedure up_gong6
(
pac_type tb_ac.ac_type%type
)
is
begin
dbms_output.put_line('검수 기준');
for i in
(
      select ac_update_date, ac_apply_date, ac_content, ac_type
      from tb_ac
      where ac_type = pac_type
 )     
loop
dbms_output.put_line('[업데이트]'|| to_char(i.ac_update_date, 'YYYY/MM/DD DY') );
dbms_output.put_line('[적용일시]' || to_char(i.ac_apply_date, 'YYYY/MM/DD DY HH24:MI') || ' 체결 건 부터');
dbms_output.put_line(i.ac_content);
end loop;
end;


exec up_gong6('의류');






=========================================================




================================================================================
[회원가입] 
exec up_join('minji1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); 
exec 회원가입 (이메일, 비밀번호, 전화번호, 신발사이즈, 생년월일, 나이동의, 문자동의, 가입날짜)  

[로그인]
exec up_login('hyungjs1234@naver.com', 'minji!!ya');
exec 로그인(이메일, 비밀번호)

[이메일 찾기]
exec up_findemail('010-1234-5678'); 
exec 이메일 찾기(전화번호)

[비밀번호 찾기]
exec up_findpw ('010-1234-5678', 'minji1234@naver.com');
exec 비밀번호찾기 (전화번호, 이메일)


[홈 화면출력]
럭셔리 아이템 출력
exec up_home;

브랜드 출력
exec up_home2;

발매일 기준 출력
exec up_home3;

즉시 구매가 기준 출력
exec up_home4;
인기 상품 기준 출력
exec up_home5;


[공지사항]
공지사항
exec up_gong;

공지사항 - 제목누르면 내용
exec up_gong2('[공지]온라인 사업자 세무 관련 안내');
exec 공지사항2 (제목)

공지사항 등록
exec up_insnotice ('ADMIN01', sysdate, '공지', '오예', '냠냠'); 
exec 공지사항등록(관리자아이디, 작성일, 공지사항종류, 제목, 내용)

공지사항 삭제
exec up_delfaq(18, 'ADMIN01');
exec 공지사항삭제(공지사항식별자, 관리자 아이디)

자주묻는 질문 출력
exec up_gong3;

자주묻는 질문
exec up_gong4('판매');
exec 자주묻는질문(자주묻는질문 종류)

자주묻는 질문 - 제목클릭 내용
exec up_gong5('판매자의 페널티 결제 정보는 왜 필요한가요?');
exec 자주묻는질문(자주묻는질문 제목)

자주묻는 질문 등록
exec up_insfaq('ADMIN01', sysdate, '구매', '자주자주자주', '묻는질문묻는질문'); 
exec 질문등록(관리자아이디, 작성일, 종류, 제목, 내용)

검수기준
exec up_gong6('의류');
exec 검수기준(검수기준종류)