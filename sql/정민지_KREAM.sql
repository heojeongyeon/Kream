[ȸ������]
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
dbms_output.put_line('�̹̻�������̸����Դϴ�');

EXCEPTION
when no_data_found then
if pm_age_agree = '1' then
insert into tb_member (m_email, m_pw,m_tel, m_size,m_name, m_birth, m_age_agree, m_mail_agree, m_regdate) 
values (pm_email, pm_pw, pm_tel, pm_size, pm_name, pm_birth, pm_age_agree, pm_mail_agree, pm_regdate);
dbms_output.put_line('ȸ�������̿Ϸ�Ǿ����ϴ�'); 
else
dbms_output.put_line('����������ּ���'); 
END IF;
END;

exec up_join('m1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); --����������ּ���
exec up_join('minji1234@naver.com', 'aLYwWVpX', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); --ȸ�������̿Ϸ�Ǿ����ϴ�
exec up_join('hyungjs1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '1', '1', sysdate); --�̹̻�������̸����Դϴ�

ȸ������Ȯ��
select *
from tb_member





[�α���]

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
dbms_output.put_line('�α���');
end if;
EXCEPTION
when no_data_found then
dbms_output.put_line('�̸��ϰ� ��й�ȣ�� Ȯ���� �ּ���');
END;

 
exec up_login('hyungjs1234@naver.com', 'minji!!ya'); --�α��� ����
exec up_login('nsdjfn@naver.com', 'minji!!ya'); --'�̸��ϰ� ��й�ȣ�� Ȯ���� �ּ���'






[�̸��� ã��]
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
dbms_output.put_line('��ġ�ϴ� ����� ������ ã�� �� �����ϴ�');
END;


exec up_findemail('010-1234-5678');   --minji1234@naver.com
exec up_findemail('010-2938-7563');   --��ġ�ϴ� ����� ������ ã�� �� �����ϴ�






[��й�ȣ ã��]
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
dbms_output.put_line('�ӽ� ��й�ȣ�� �����Ͽ����ϴ�. ���� ���� �ӽ� ��й�ȣ�� �α������ּ���.');
end if;

update tb_member 
set m_pw = dbms_random.string('A', 8)
where vm_email = pm_email;

EXCEPTION
when no_data_found then
dbms_output.put_line('��ġ�ϴ� ����� ������ ã�� �� �����ϴ�');
END;


exec up_findpw ('010-1234-5678', 'minji1234@naver.com'); --�ӽ� ��й�ȣ�� �����Ͽ����ϴ�. ���� ���� �ӽ� ��й�ȣ�� �α������ּ���.
exec up_findpw ('010-9876-3746', 'h12345@naver.com'); --��ġ�ϴ� ����� ������ ã�� �� �����ϴ�

select *
from tb_member;  --�ӽ� ��й�ȣ�� �ٲ�� Ȯ��




====================================================================================================================

[Ȩ]

[���Ÿ� ������ ���� ��� ��ǰ]
create or replace procedure up_home
is
begin
dbms_output.put_line('Luxury Items');
dbms_output.put_line('���� ���� �� ���� ���Ÿ�!');
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






[�귣�� ��ǰ ���]
create or replace procedure up_home2
is
begin
dbms_output.put_line('Brand Focus');
dbms_output.put_line('��õ �귣��');
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






[�߸��� ���� ���]
create or replace procedure up_home3
is
begin
dbms_output.put_line('Just Dropped');
dbms_output.put_line('�߸� ��ǰ');
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






[��� ���Ű� ���� ���]
create or replace procedure up_home4
is 
begin
dbms_output.put_line('New Lowest Asks');
dbms_output.put_line('���ο� ��� ���Ű�');
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






[�α� ��ǰ ���]
create or replace procedure up_home5
is
begin
dbms_output.put_line('Most Popular');
dbms_output.put_line('�α� ��ǰ');
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

[��������]

CREATE OR REPLACE PROCEDURE up_gong
is
begin
dbms_output.put_line('��������');
for vrow in ( select nt_title from tb_notice ) 
loop
dbms_output.put_line(vrow.nt_title);
end loop;
end;

exec up_gong;


[�������� - ����]
CREATE OR REPLACE PROCEDURE up_gong2
(
pnt_title tb_notice.nt_title%type
)
is
begin
dbms_output.put_line('��������');
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


exec up_gong2('[����]�¶��� ����� ���� ���� �ȳ�');




[�������� ���]
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
dbms_output.put_line('�̹� �����մϴ�');

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
dbms_output.put_line('���������� ��� �Ǿ����ϴ�');
else
dbms_output.put_line('������ ���̵� Ȯ���� �ּ���');
end if;
end;



exec up_insnotice ('ADMIN01', sysdate, '����', '����', '�ȳ�');   --���������� ��� �Ǿ����ϴ�
exec up_insnotice ('ADMIN02', sysdate, '����', '����', '�ȳ�');   --������ ���̵� Ȯ���� �ּ���


select *
from tb_notice  -��� Ȯ��



[�������� ����]
CREATE OR REPLACE PROCEDURE up_delfaq
(
   pnt_id   tb_notice.nt_id%type
   ,padm_id  tb_admin.adm_id%type
)
IS
BEGIN
   DELETE FROM tb_notice
   WHERE nt_id = pnt_id and padm_id = 'ADMIN01';
   dbms_output.put_line('�����Ǿ����ϴ�');
   
exception
when no_data_found then
dbms_output.put_line('�����Ǿ����ϴ�');
END;


exec up_delfaq(18, 'ADMIN01'); --�����Ǿ����ϴ�


select *
from tb_notice




[���� ���� ����]
create or replace procedure up_gong3
IS
BEGIN
dbms_output.put_line('���� ���� ����');
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




[���� ���� ���� - ����]
create or replace procedure up_gong4
(
pfaq_type tb_faq.faq_type%type
)
is
begin
dbms_output.put_line('���� ���� ����');
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

exec up_gong4('�Ǹ�');





[���� ���� ���� - ����]
create or replace procedure up_gong5
(
pfaq_title tb_faq.faq_title%type
)
is
begin
dbms_output.put_line('���� ���� ����');
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


exec up_gong5('�Ǹ����� ���Ƽ ���� ������ �� �ʿ��Ѱ���?');



[���� ���� ���� ���]
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
dbms_output.put_line('�̹� �����մϴ�');

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
dbms_output.put_line('���ֹ��� ������ ��� �Ǿ����ϴ�');
else
dbms_output.put_line('������ ���̵� Ȯ���� �ּ���');
end if;
end;


exec up_insfaq('ADMIN01', sysdate, '����', '������������', '����������������');   --���ֹ��� ������ ��� �Ǿ����ϴ�

select *
from tb_faq



[�˼�����]
create or replace procedure up_gong6
(
pac_type tb_ac.ac_type%type
)
is
begin
dbms_output.put_line('�˼� ����');
for i in
(
      select ac_update_date, ac_apply_date, ac_content, ac_type
      from tb_ac
      where ac_type = pac_type
 )     
loop
dbms_output.put_line('[������Ʈ]'|| to_char(i.ac_update_date, 'YYYY/MM/DD DY') );
dbms_output.put_line('[�����Ͻ�]' || to_char(i.ac_apply_date, 'YYYY/MM/DD DY HH24:MI') || ' ü�� �� ����');
dbms_output.put_line(i.ac_content);
end loop;
end;


exec up_gong6('�Ƿ�');






=========================================================




================================================================================
[ȸ������] 
exec up_join('minji1234@naver.com', 'dkffkak', '010-1234-5678', 245 , '2000/07/18', '0', '1', sysdate); 
exec ȸ������ (�̸���, ��й�ȣ, ��ȭ��ȣ, �Ź߻�����, �������, ���̵���, ���ڵ���, ���Գ�¥)  

[�α���]
exec up_login('hyungjs1234@naver.com', 'minji!!ya');
exec �α���(�̸���, ��й�ȣ)

[�̸��� ã��]
exec up_findemail('010-1234-5678'); 
exec �̸��� ã��(��ȭ��ȣ)

[��й�ȣ ã��]
exec up_findpw ('010-1234-5678', 'minji1234@naver.com');
exec ��й�ȣã�� (��ȭ��ȣ, �̸���)


[Ȩ ȭ�����]
���Ÿ� ������ ���
exec up_home;

�귣�� ���
exec up_home2;

�߸��� ���� ���
exec up_home3;

��� ���Ű� ���� ���
exec up_home4;
�α� ��ǰ ���� ���
exec up_home5;


[��������]
��������
exec up_gong;

�������� - ���񴩸��� ����
exec up_gong2('[����]�¶��� ����� ���� ���� �ȳ�');
exec ��������2 (����)

�������� ���
exec up_insnotice ('ADMIN01', sysdate, '����', '����', '�ȳ�'); 
exec �������׵��(�����ھ��̵�, �ۼ���, ������������, ����, ����)

�������� ����
exec up_delfaq(18, 'ADMIN01');
exec �������׻���(�������׽ĺ���, ������ ���̵�)

���ֹ��� ���� ���
exec up_gong3;

���ֹ��� ����
exec up_gong4('�Ǹ�');
exec ���ֹ�������(���ֹ������� ����)

���ֹ��� ���� - ����Ŭ�� ����
exec up_gong5('�Ǹ����� ���Ƽ ���� ������ �� �ʿ��Ѱ���?');
exec ���ֹ�������(���ֹ������� ����)

���ֹ��� ���� ���
exec up_insfaq('ADMIN01', sysdate, '����', '������������', '����������������'); 
exec �������(�����ھ��̵�, �ۼ���, ����, ����, ����)

�˼�����
exec up_gong6('�Ƿ�');
exec �˼�����(�˼���������)