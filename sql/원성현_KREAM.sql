<������ ���� â>
--���������� ��� ���ν���
CREATE OR REPLACE PROCEDURE �������������
(
pemail tb_member.m_email%type
)
is
begin
FOR  vrow IN (  SELECT  *    FROM tb_member where m_email= pemail ) 
   LOOP
     DBMS_OUTPUT.PUT_LINE( '������ ����' );
     DBMS_OUTPUT.PUT_LINE( vrow.m_name );
     DBMS_OUTPUT.PUT_LINE( NVL(vrow.m_image, '�̹��� ����')|| '[�̹��� ����]' || '[����]' );
     DBMS_OUTPUT.PUT_LINE( '�α��� ����' );
     DBMS_OUTPUT.PUT_LINE( '�̸��� : ' ||SUBSTR(vrow.m_email,0,1) 
     ||lpad('*', length(substr(vrow.m_email,INSTR(vrow.m_email, '@')))-1, '*')|| substr(vrow.m_email,INSTR(vrow.m_email, '@')-1 )  
     || '[����]'); 
     DBMS_OUTPUT.PUT_LINE( '��й�ȣ : ' || lpad('*', length(vrow.m_pw),'*') || '[����]' );
     DBMS_OUTPUT.PUT_LINE( '��������' );
     DBMS_OUTPUT.PUT_LINE( '�̸� : '  || vrow.m_name || '[����]' );
     DBMS_OUTPUT.PUT_LINE( '�޴��� ��ȣ : '  || vrow.m_tel || '[����]' );
     DBMS_OUTPUT.PUT_LINE( '�Ź� ������ : ' || vrow.m_size || '[����]' );
     DBMS_OUTPUT.PUT_LINE( '���� ���� ����' );
     DBMS_OUTPUT.PUT_LINE( '���� �޽��� ' || vrow.m_email_agree);
     DBMS_OUTPUT.PUT_LINE( '�̸��� ' || vrow.m_mail_agree);
     DBMS_OUTPUT.PUT_LINE( '[ȸ�� Ż��]');
   END LOOP; 
end;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- ������ ���� ���� ���ν��� (�����ּ�, �̸��� ������ ���� ����)
CREATE OR REPLACE PROCEDURE �����ʻ�������
(  
    pimage tb_member.m_image%type
)
IS
vemail tb_member.m_email%type;
BEGIN 
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
     update tb_member
     set m_image = pimage
     where m_email = vemail;
END;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- ������ ���� ���� ���ν��� (�̸��� ������ ���� ����)
CREATE OR REPLACE PROCEDURE �����ʻ�������

IS
vm_email tb_member.m_email%type;
BEGIN
    select m_email into vm_email
    from tb_member
    where m_email='shiueo@naver.com';

        update tb_member
        set m_image = null
        where m_email = vm_email;
END;

----------------------------------------------------------------------------------------------------------------------------
--��й�ȣ ���� ���ν���
CREATE OR REPLACE PROCEDURE ��й�ȣ����
(   
    pm_pw tb_member.m_pw%type -- ���� ���
    ,pupdatepw tb_member.m_pw%type --.���� �� ���
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
   IF pm_pw = pupdatepw THEN DBMS_OUTPUT.PUT_LINE( '���� ��й�ȣ�� �����մϴ�.' );
   ELSE  update tb_member set m_pw = pupdatepw where m_email=vemail;
   DBMS_OUTPUT.PUT_LINE( '��й�ȣ ���������� ����Ǿ����ϴ�.' );
   END IF;
END;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- �̸� �����ϱ�
CREATE OR REPLACE PROCEDURE �̸����� 
(  
 pname tb_member.m_name%type
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
     update tb_member
     set m_name = pname
     where m_email = vemail;
     DBMS_OUTPUT.PUT_LINE('ȸ�� �̸��� ' || pname || '���� ���� �Ǿ���.');
     
END;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- �޴��� ��ȣ ���� �ϱ�
CREATE OR REPLACE PROCEDURE �޴�����ȣ���� -- ȸ�� �̸��� ������ ���� �̸����� ����
(  
 ptel tb_member.m_name%type
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
     update tb_member
     set m_tel = ptel
     where m_email = vemail;
     
     DBMS_OUTPUT.PUT_LINE('ȸ�� ��ȣ�� ' || ptel || '���� ���� �Ǿ���.');
END;

----------------------------------------------------------------------------------------------------------------------------
-- �Ź� ������ ���û��� ���
CREATE OR REPLACE PROCEDURE  �Ź߻�����û���
IS
BEGIN
    dbms_output.put_line('�������');
  FOR vrow  IN ( SELECT * FROM TB_SIZE WHERE S_ID BETWEEN 2 AND 18)
  LOOP    
    DBMS_OUTPUT.PUT_LINE( vrow.S_SIZE );    
  END LOOP; 
END;
-- ������ ���� ���ν���    
CREATE OR REPLACE PROCEDURE �Ź߻������
(
psize tb_member.m_size%type
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
    IF PSIZE IN(220, 225, 230, 235 ,240, 245 ,250, 255, 260, 265, 270, 275 ,280 ,285, 290, 295, 300)  THEN
    update tb_member 
    set m_size = psize
    where m_email = vemail;
    DBMS_OUTPUT.PUT_LINE( '����� ���������� ����Ǿ����ϴ�.' ); 
    ELSE DBMS_OUTPUT.PUT_LINE( '���û��׿� �ִ� ����� �������ּ���.' ); 
    END IF;
END;
----------------------------------------------------------------------------------------------------------------------------
-- ���� ���� ���� ����
-- 1�̸� ���� ���� 
-- 0�̸� ���� �ź�
CREATE OR REPLACE PROCEDURE �����������ź���
(
Pemagree tb_member.m_email_agree%type
,pmagree tb_member.m_mail_agree%type
)
IS
vm_email tb_member.m_email%type;
BEGIN
    select m_email into vm_email
    from tb_member
    where m_email='shiueo@naver.com';
    
    update tb_member set m_email_agree = Pemagree , m_mail_agree = pmagree where m_email = vm_email;
END;

----------------------------------------------------------------------------------------------------------------------------
--ȸ�� Ż�� ��� ����
create or replace procedure ȸ��Ż�����������
is
begin
    DBMS_OUTPUT.PUT_LINE('(���� (1) ����(0) )KREAM�� Ż���ϸ� ȸ�� ���� �� ���� �̿� ����� �����˴ϴ�.
�� ������, �ŷ�����(����/�Ǹ�), ���ɻ�ǰ, ������ǰ, STYLE �Խù�(�Խù�/���), �̻�� ���� ����Ʈ �� ������� ��� ������ ������� �簡�� �ϴ��� ������ �Ұ����մϴ�.
Ż�� 14�� �̳� �簡���� �� ������, Ż�� �� ���� �̸��Ϸ� �簡���� �� �����ϴ�');
DBMS_OUTPUT.PUT_LINE('(���� (1) ����(0) ) �� ���� �̸��Ϸ� �簡���� �� �����ϴ�
���� ���� �� ���� ���ؿ� ���� ���� �����ϴ� ��쿡�� �Ϻ� ������ ������ �� �ֽ��ϴ�.
1. ���ڻ�ŷ� �� �Һ��� ��ȣ�� ���� ����
��� �Ǵ� û��öȸ � ���� ���: 5�� ����
��ݰ��� �� ��ȭ ���� ���޿� ���� ���: 5�� ����
�Һ����� �Ҹ� �Ǵ� ����ó���� ���� ���: 3�� ����');
    DBMS_OUTPUT.PUT_LINE('(���� (1) ����(0) )KREAM Ż�� ���ѵ� ��쿡�� �Ʒ� ������ �����Ͻñ� �ٶ��ϴ�.
���� ���� �ŷ�(�Ǹ�/����)�� ���� ���: �ش� �ŷ� ���� �� Ż�� ����
���� ���� ����(�Ǹ�/����)�� ���� ���: �ش� ���� ���� �� Ż�� ����');
    DBMS_OUTPUT.PUT_LINE('(���� (1) ����(0) )ȸ��Ż�� �ȳ��� ��� Ȯ���Ͽ����� Ż�� �����մϴ�.');
end;


-- ��� 1 üũ�ϸ� ȸ�� ����
create or replace procedure ȸ��Ż��
(
p1 number
,p2 number
,p3 number
,p4 number
)
is
vm_email tb_member.m_email%type;
begin
        select m_email into vm_email
        from tb_member
        where m_email= 'shiueo@naver.com';
        
        if p1 = 1 and p2 =1 and p3 =1 and p4=1 then DBMS_OUTPUT.PUT_LINE( ' shiueo@naver.com ȸ��Ż��.' );
        DELETE TB_MEMBER WHERE M_EMAIL = vm_email;
        -- tb_member�� ������ ��� ���̺� �����غ���..
        else DBMS_OUTPUT.PUT_LINE( ' shiueo@naver.com ȸ������.' ); 
        end if;
end;

----------------------------------------------------------------------------------------------------------------------------
-- �ּҷ� ������ ���
CREATE OR REPLACE PROCEDURE �ּҷ����������
(
pemail tb_member.m_email%type
)
is
begin

FOR  vrow IN (  SELECT  *    FROM tb_delivery where m_email= pemail order by d_basic desc , d_id asc) --  Ŀ�� ����
   LOOP
    if vrow.d_basic=1 then
     DBMS_OUTPUT.PUT_LINE( '�ּҷ�' );
     DBMS_OUTPUT.PUT_LINE( '[+ �� ����� �߰�]' );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_name, 0,1) || lpad('*', length(vrow.d_name)-1,'*')  || ' �⺻�����');
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_tel,0,3)||'-'||substr(vrow.d_tel,5,1)||'***-*'||substr(vrow.d_tel,11) );
     DBMS_OUTPUT.PUT_LINE( '('||vrow.d_zip||')' || vrow.d_ads ||' '|| vrow.d_detail || '[����]  [����]');
     DBMS_OUTPUT.PUT_LINE( '===============================================================================' );
     elsif vrow.d_basic=0 then
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_name, 0,1) || lpad('*', length(vrow.d_name)-1,'*') );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_tel,0,3)||'-'||substr(vrow.d_tel,5,1)||'***-*'||substr(vrow.d_tel,11) );
     DBMS_OUTPUT.PUT_LINE( '('||vrow.d_zip||')' || vrow.d_ads ||' '|| vrow.d_detail || '[�⺻ �����]  [����]  [����]');
     DBMS_OUTPUT.PUT_LINE( '===============================================================================' );
     end if;
   END LOOP; 
end;

--�ּ��߰� ���ν���
CREATE OR REPLACE PROCEDURE �ּ��߰�
(
PNAME tb_delivery.d_name%type
,PTEL tb_delivery.d_tel%type
,PZIP tb_delivery.d_zip%type
,PADS tb_delivery.d_ads%type
,PDETAIL tb_delivery.d_detail%type
, pCheck number
) 
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email= 'hyungjs1234@naver.com';
        if pcheck =1 then 
        update tb_delivery set d_basic=0 where m_email= 'hyungjs1234@naver.com'; 
        end if;
    insert into tb_delivery (d_id, m_email, d_name, d_tel, d_zip, d_ads, d_detail, d_basic)
  values ( delivery_id.NEXTVAL, vemail, PNAME,PTEL, pzip, pads, PDETAIL,pCheck);
END;


----------------------------------------------------------------------------------------------------------------------------
-- ���� ����
CREATE OR REPLACE PROCEDURE ��������â���
(
pemail tb_member.m_email%type
)
is
begin

FOR  vrow IN (  SELECT  *    FROM tb_card where m_email= pemail ORDER BY C_PAY DESC) --  Ŀ�� ����
   LOOP
     IF vrow.c_pay=1 then
     DBMS_OUTPUT.PUT_LINE( '[���� ����]         '  ||  '     [+�� ī�� �߰��ϱ�]' );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.c_bank,0,2) || lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'|| substr(vrow.c_id, -4,3)||'*' || ' �⺻ ���� ' || ' [����] ');
     DBMS_OUTPUT.PUT_LINE( '===================================================' );
     ELSIF vrow.c_pay=0 THEN 
     DBMS_OUTPUT.PUT_LINE( substr(vrow.c_bank,0,2) || lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'|| substr(vrow.c_id, -4,3)||'*'
     || '[�⺻ ����]     [����] ');
     END IF;
   END LOOP; 
end;

--ī�� �߰��ϱ�
CREATE OR REPLACE PROCEDURE ī���߰�
(
    PID TB_CARD.C_ID%TYPE 
    ,PDATE  TB_CARD.C_DATE%TYPE 
    ,PBIRTH TB_CARD.C_BIRTH%TYPE 
    ,PPSW TB_CARD.C_PSW%TYPE 
    ,PBANK TB_CARD.C_BANK%TYPE
    ,pCheck number
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email= 'hyungjs1234@naver.com';
        if pcheck =1 then 
        update tb_card set c_pay=0 where m_email= 'hyungjs1234@naver.com'; 
        end if;
    INSERT INTO TB_CARD(C_ID, M_EMAIL, C_DATE, C_BIRTH, C_PSW, C_BANK, C_PAY)
    VALUES (PID, vemail, PDATE,PBIRTH,PPSW, PBANK,pCheck);
END;
--����

----------------------------------------------------------------------------------------------------------------------------
--�Ǹ��������
CREATE OR REPLACE PROCEDURE �Ǹ��������
(
pbank tb_account.ac_bank%type
,pnum tb_account.ac_num%type  
,pname tb_account.ac_name%type
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email= 'hyungjs1234@naver.com';

    update tb_account set ac_bank =pbank , ac_num = pnum, ac_name=pname
    where m_email = vemail;
    
    DBMS_OUTPUT.PUT_LINE( '[���� ���� ����]' );
    DBMS_OUTPUT.PUT_LINE( '��ϵ� ���� ���� : ' || pbank ||' '|| substr(pnum, 0,4 ) || lpad('*', length(pnum)-4, '*')
    ||'/'
    ||substr(pname,0,1)|| lpad('*',length(pname)-1,'*'));
    
    DBMS_OUTPUT.PUT_LINE( '[����� : ]' );
    DBMS_OUTPUT.PUT_LINE( '[���¹�ȣ] (-���� �Է��ϼ���) : ' );
    DBMS_OUTPUT.PUT_LINE( '[������] : ' );
END;

----------------------------------------------------------------------------------------------------------------------------
--���� ������ ���� ���� �� ���
CREATE OR REPLACE PROCEDURE ���ݿ�����
(
ptype tb_receipt.r_type%type
,ptel tb_receipt.r_tel%type :=NULL
,pcardnum tb_receipt.r_cardnum%type :=NULL
,pcheck varchar2 :=NULL
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_receipt where m_email= 'hyungjs1234@naver.com'; -- ȸ�� ���̵�
    
    DBMS_OUTPUT.PUT_LINE( '���ݿ����� ����' );
    DBMS_OUTPUT.PUT_LINE( '���� : ' );
    IF ptype='�̽�û' THEN 
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = NULL, R_CARDNUM =NULL WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( '[�����ϱ�]' );
    ELSIF ptype='���μҵ����(�޴���)' THEN
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = ptel, R_CARDNUM =NULL WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( '�޴�����ȣ : '|| ptel );
    DBMS_OUTPUT.PUT_LINE( '���ݿ����� ��û ������ �����Ͽ� �ڵ����� �߱޵Ǵ� �Ϳ� �����մϴ�.' ||pcheck );
    ELSIF ptype='���μҵ����(���ݿ�����ī��)' THEN
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = NULL, R_CARDNUM =pcardnum WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( 'ī���ȣ : '|| pcardnum );
    DBMS_OUTPUT.PUT_LINE( '���ݿ����� ��û ������ �����Ͽ� �ڵ����� �߱޵Ǵ� �Ϳ� �����մϴ�.' ||pcheck );
    END IF;
END;

-----------------------------------------------------------------------------------------
--����Ʈ 
-- 
-- ���� ����Ʈ ���� Ʈ���� : TB_GPOINT�� ����Ʈ INSERT �� TB_MEMBER ���̺��� m_point�� �߰��ϴ� ���
CREATE OR REPLACE TRIGGER ��������Ʈ_����Ʈ����
AFTER
INSERT ON TB_GPOINT
FOR EACH ROW  
BEGIN
     UPDATE TB_MEMBER SET m_point = m_point + :NEW.gp_point WHERE M_EMAIL= :NEW.M_EMAIL;
END;
--���� ����Ʈ ��� Ʈ���� : TB_SPOINT�� �������Ʈ INSERT�� TB_MEMBER ���̺��� M_POINT ����
CREATE OR REPLACE TRIGGER ��������Ʈ_���Ʈ����
AFTER
INSERT ON TB_SPOINT
FOR EACH ROW  
BEGIN
     UPDATE TB_MEMBER SET m_point = m_point - :NEW.sp_point WHERE M_EMAIL= :NEW.M_EMAIL;
END;
--��밡�� ����Ʈ ��� ���ν���
CREATE OR REPLACE PROCEDURE ��밡������Ʈ
(
Pemail tb_member.m_email%type
)
IS
    vpoint tb_member.m_point%type;
BEGIN 
     select  M_POINT into VPOINT
     from tb_member where m_email= Pemail;
    DBMS_OUTPUT.PUT_LINE('��� ������ ����Ʈ ' || VPOINT ||'P');
END;
---------------------------------
--�Ҹ꿹�� ����Ʈ ��� ���ν���
CREATE OR REPLACE PROCEDURE �Ҹ꿹������Ʈ
(
Pemail tb_member.m_email%type
)
IS 
vpoint_extinct tb_gpoint.gp_point%type;
BEGIN
   SELECT GP_POINT INTO vpoint_extinct 
    FROM TB_GPOINT WHERE m_email= Pemail AND (TO_CHAR(GP_DATE+ (INTERVAL '1' YEAR), 'YY/MM')) =  (TO_CHAR(SYSDATE, 'YY/MM'));
    DBMS_OUTPUT.PUT_LINE('�̹��� �Ҹ꿹�� ����Ʈ ' || vpoint_extinct ||'P'  || '  [+����Ʈ �����ϱ�]');                
  
END;

------------------------------------
CREATE OR REPLACE PROCEDURE ����Ʈ����  -- ����Ʈ �Ⱓ ������ �����ϴ� ���ν���.
IS
 PDATE TB_GPOINT.gp_date%TYPE; 
 CURSOR C IS (
                SELECT GP_DATE 
                FROM TB_GPOINT
                WHERE (  TO_DATE(SYSDATE,'YYYY/MM/DD' ) - TO_DATE(GP_DATE,'YYYY/MM/DD')  ) >365
                      );
BEGIN
    OPEN C;
        LOOP
        FETCH C INTO PDATE;
             DELETE TB_GPOINT WHERE GP_DATE IN PDATE;
            EXIT WHEN C%NOTFOUND;
        END LOOP;
    CLOSE C;
END;



--����Ʈ ���� Ʈ����(���ν����� �Ⱓ ���� ����Ʈ ��������Ʈ���� ����)
CREATE OR REPLACE TRIGGER ��������Ʈ_����Ʈ���� 
AFTER
DELETE ON TB_GPOINT
FOR EACH ROW  
DECLARE
BEGIN
     UPDATE TB_MEMBER SET m_point = m_point - :OLD.gp_point WHERE M_EMAIL= :OLD.m_email;
END;

-------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
EXEC �������������('ȸ�� �̸���')  
EXEC �����ʻ�������('������ �̹���'); 
EXEC �����ʻ�������; 
EXEC ��й�ȣ����('���� ��й�ȣ', '������ ��й�ȣ ') 
EXEC �̸�����('�ٲٰ��� �ϴ� �̸���' ) 
EXEC �޴�����ȣ����('�޴�����ȣ �Է�' )
EXEC �Ź߻�����û���;
EXEC �Ź߻������('������') �ٲٰ��� �ϴ� ������� �Է�
EXEC �����������ź���(�̸��ϼ��ŵ��ǿ���,���ڵ��ǿ���); 1: ���� 0 ����
EXEC ȸ��Ż�����������;
EXEC ȸ��Ż��(1,1,1,1)  1:���� 0:���� // ��� 1�̸� ȸ��Ż��// �ϳ��� 0�̸� ȸ������
EXEC �ּҷ����������('ȸ�� �̸���') 
EXEC �ּ��߰�('�̸�', '��ȭ��ȣ', �����ȣ, '�ּ�', '���ּ�', �⺻�����);  // �⺻����� (1) // �ƴϸ� 0
EXEC ��������â���('ȸ�� �̸���') 
EXEC ī���߰�(ī���ȣ,'��ȿ�Ⱓ','�������',��й�ȣ,'�����',�⺻���� ����);  // �⺻����(1) // �ƴϸ� 0
EXEC �Ǹ��������('�����', '���¹�ȣ', '������')
EXEC ���ݿ�����('���ݿ���������', '�޴�����ȣ/���ݿ�����ī���ȣ/ NULL' ) '���ݿ���������' = '���μҵ����(�޴���)' / '���μҵ����(���ݿ�����ī��)' / '�̽�û'
EXEC ��밡������Ʈ('ȸ���̸���');
EXEC �Ҹ꿹������Ʈ('ȸ���̸���');
EXEC ����Ʈ����; ���� �� ��ȿ�Ⱓ ���� ����Ʈ ����

