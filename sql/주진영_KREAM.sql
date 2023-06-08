---------------Ʈ����
CREATE OR REPLACE TRIGGER �Ǹ�Ʈ����
after
INSERT ON tb_panmaebid
FOR EACH ROW
DECLARE
    v_i_name_eng    tb_item.i_name_eng%TYPE;
    v_s_id          tb_itemsize.s_id%TYPE;
    v_max_price     tb_gumaebid.gbid_price%TYPE;
BEGIN
    --�����Ǹ�
    IF :NEW.pbid_keepcheck = 1 THEN
        UPDATE tb_amount
        SET am_bpsendreq = am_bpsendreq+1
        WHERE m_email = :NEW.m_email;
    --�Ǹ�����
    ELSE 
        SELECT i_name_eng INTO v_i_name_eng
        FROM tb_item
        WHERE i_id = :NEW.i_id;
        
        SELECT s_id INTO v_s_id
        FROM tb_size
        WHERE s_size = :NEW.pbid_size;
        
            
        IF :NEW.pbid_price IS NOT NULL   THEN
            UPDATE tb_amount
            SET am_panlog = am_panlog+1, am_panbid = am_panbid+1
            WHERE m_email = :NEW.m_email;
            
            --��ñ��Ű� ����
            IF :NEW.pbid_price < ��ñ��Ű�(v_i_name_eng ,:NEW.pbid_size)    THEN
                UPDATE tb_itemsize
                SET is_gprice = :NEW.pbid_price
                WHERE i_id = :NEW.i_id and s_id = v_s_id;
            END IF;
        --����Ǹ�
        ELSIF :NEW.pbid_complete = 1 THEN
            UPDATE tb_amount
            SET am_panlog = am_panlog+1, am_paning = am_paning+1
            WHERE m_email = :NEW.m_email;
        
            --��ñ��Ű� ����(�����������̺� �� ���� ���� ���������)
            SELECT MAX(gbid_price) INTO v_max_price FROM tb_gumaebid 
            WHERE gbid_complete = 0 and gbid_rdate+gbid_deadline < SYSDATE;
            
            UPDATE tb_itemsize
            SET is_gprice = v_max_price
            WHERE i_id = :NEW.i_id and s_id = v_s_id;
        END IF;
    END IF;
END;

CREATE OR REPLACE TRIGGER ����Ʈ����
after
INSERT ON tb_gumaebid
FOR EACH ROW
DECLARE
    v_i_name_eng    tb_item.i_name_eng%TYPE;
    v_s_id          tb_itemsize.s_id%TYPE;
    v_min_price     tb_gumaebid.gbid_price%TYPE;
BEGIN
    SELECT i_name_eng INTO v_i_name_eng
    FROM tb_item
    WHERE i_id = :NEW.i_id;
    
    SELECT s_id INTO v_s_id
    FROM tb_size
    WHERE s_size = :NEW.gbid_size;

    UPDATE tb_amount
    SET am_gubid = am_gubid+1, am_gulog = am_gulog+1
    WHERE m_email = :NEW.m_email;
    --��������
    IF :NEW.gbid_complete = 0 THEN
        
        IF :NEW.gbid_price > ����ǸŰ�(v_i_name_eng ,:NEW.gbid_size)    THEN
            UPDATE tb_itemsize
            SET is_pprice = :NEW.gbid_price
            WHERE i_id = :NEW.i_id and s_id = v_s_id;
        END IF;
    --��ñ���
    ELSIF  :NEW.gbid_complete = 1 THEN
        
        --����ǸŰ� ����(�Ǹ��������̺� �� ���� ���� �Ǹ������)
        SELECT MIN(pbid_price) INTO v_min_price FROM tb_panmaebid 
        WHERE pbid_complete = 0 and pbid_rdate+pbid_deadline < SYSDATE;
            
        UPDATE tb_itemsize
        SET is_pprice = v_min_price
        WHERE i_id = :NEW.i_id and s_id = v_s_id;
    END IF;
END;

CREATE OR REPLACE TRIGGER ü��ŷ�Ʈ����
after
INSERT ON tb_matching
FOR EACH ROW
DECLARE
    v_buy_email tb_member.m_email%TYPE;
    v_sell_email tb_member.m_email%TYPE;
    v_usepoint    tb_gumaebid.gbid_usepoint%TYPE;   
BEGIN
    SELECT m_email, gbid_usepoint INTO v_buy_email, v_usepoint
    FROM tb_gumaebid
    WHERE gbid_id = :NEW.gbid_id;
    
    SELECT m_email INTO v_sell_email
    FROM tb_panmaebid
    WHERE pbid_id = :NEW.pbid_id;

    UPDATE tb_amount
    SET am_gubid = am_gubid-1, am_guing = am_guing+1
    WHERE m_email = v_buy_email;
    
    UPDATE tb_amount
    SET am_panbid = am_panbid-1, am_paning = am_paning+1
    WHERE m_email = v_sell_email;
    
    UPDATE tb_gumaebid 
    SET gbid_complete = '1'
    WHERE gbid_id = :NEW.gbid_id;

    UPDATE tb_panmaebid 
    SET pbid_complete = '1'
    WHERE pbid_id = :NEW.pbid_id;
    
    --����Ʈ ��볻��
    IF v_usepoint != 0 THEN
        INSERT INTO tb_spoint VALUES (����Ʈ��볻��.nextval, :NEW.mat_id
        ,  v_buy_email, v_usepoint, :NEW.mat_date, '���Žû��');
    END IF;
END;


------------------������
CREATE SEQUENCE ������ǰ�ڵ�
INCREMENT BY 1
START WITH 10
MINVALUE 10
MAXVALUE 1000000
NOCYCLE
NOCACHE
NOORDER;

CREATE SEQUENCE �Ǹ������ڵ�
INCREMENT BY 1
START WITH 10
MINVALUE 10
MAXVALUE 1000000
NOCYCLE
NOCACHE
NOORDER;

CREATE SEQUENCE ���������ڵ�
INCREMENT BY 1
START WITH 10
MINVALUE 10
MAXVALUE 1000000
NOCYCLE
NOCACHE
NOORDER;

CREATE SEQUENCE ü��ŷ��ֹ���ȣ
INCREMENT BY 1
START WITH 10
MINVALUE 10
MAXVALUE 1000000
NOCYCLE
NOCACHE
NOORDER;

CREATE SEQUENCE ����Ʈ��볻��
INCREMENT BY 1
START WITH 10
MINVALUE 10
MAXVALUE 1000000
NOCYCLE
NOCACHE
NOORDER;


----------��� ����
CREATE OR REPLACE PROCEDURE ��ǰ���� 
( 
    p_i_name_eng IN tb_item.i_name_eng%TYPE
)
IS
    v_i_image       tb_item.i_image%TYPE;
    v_i_model       tb_item.i_model%TYPE;
    v_i_name_eng    tb_item.i_name_eng%TYPE;
    v_i_name_kor    tb_item.i_name_kor%TYPE;
    v_fast_delivery nvarchar2(4);
BEGIN
    SELECT i_image, i_model, i_name_eng, i_name_kor, 
    CASE
        WHEN (SELECT count(pbid_itemstate) 
        FROM tb_panmaebid 
        WHERE i_name_eng = p_i_name_eng
        and pbid_itemstate = '������') > 0 THEN
            '�������'
        ELSE ''
    END 
    INTO v_i_image, v_i_model, v_i_name_eng
                        , v_i_name_kor, v_fast_delivery 
    FROM tb_item i
    WHERE i_name_eng = p_i_name_eng;

    DBMS_OUTPUT.PUT_LINE(v_i_image || chr(10) 
    || v_i_model || chr(10) || v_i_name_eng || chr(10) 
    || v_i_name_kor || chr(10) || v_fast_delivery);
END;

CREATE OR REPLACE PROCEDURE �Ϲݻ�ǰ���� 
( 
    p_i_name_eng IN tb_item.i_name_eng%TYPE
)
IS
    v_i_image       tb_item.i_image%TYPE;
    v_i_model       tb_item.i_model%TYPE;
    v_i_name_eng    tb_item.i_name_eng%TYPE;
    v_i_name_kor    tb_item.i_name_kor%TYPE;
BEGIN
    SELECT i_image, i_model, i_name_eng, i_name_kor 
    INTO v_i_image, v_i_model, v_i_name_eng
                        , v_i_name_kor
    FROM tb_item 
    WHERE i_name_eng = p_i_name_eng;

    DBMS_OUTPUT.PUT_LINE(v_i_image || chr(10) 
    || v_i_model || chr(10) || v_i_name_eng || chr(10) 
    || v_i_name_kor);
END;

CREATE OR REPLACE PROCEDURE �ݼ�ȸ���ּ�
(
    p_m_email   tb_member.m_email%TYPE
)
IS
    v_d_name        tb_delivery.d_name%TYPE;
    v_d_tel         tb_delivery.d_tel%TYPE;
    v_d_addetail    nvarchar2(40);
BEGIN
    SELECT RPAD(SUBSTR(d_name,1,1),LENGTH(d_name)+1,'*')
, SUBSTR(d_tel,1,5)|| '***-*' || SUBSTR(d_tel,-3), d_ads || d_detail 
    INTO v_d_name, v_d_tel, v_d_addetail
    FROM tb_delivery
    WHERE d_basic = 1 and m_email = p_m_email;
    
    DBMS_OUTPUT.PUT_LINE(v_d_name || CHR(10) || v_d_tel || CHR(10) ||v_d_addetail);
END;

CREATE OR REPLACE PROCEDURE ����հŷ���
(
    p_i_name_eng    tb_item.i_name_eng%TYPE
)
IS
    v_mon_avgprice NUMBER(10);
BEGIN
    SELECT AVG(mat_price) INTO v_mon_avgprice
    FROM tb_item i JOIN tb_matching m ON i.i_id = m.i_id 
    WHERE i_name_eng = p_i_name_eng
    and EXTRACT(MONTh FROM mat_date) = EXTRACT(MONTH FROM SYSDATE);
    
    DBMS_OUTPUT.PUT_LINE(v_mon_avgprice);
END;

CREATE OR REPLACE PROCEDURE �������
(
    p_m_email   tb_member.m_email%TYPE
)
IS
    v_c_bank    tb_card.c_bank%TYPE;
    v_c_id  CHAR(19);
BEGIN
    SELECT c_bank,'****-****-****-' || SUBSTR(c_id,13,3) ||'*'
    INTO v_c_bank, v_c_id
    FROM tb_card
    WHERE m_email = p_m_email
    and c_pay = 1;
    
    DBMS_OUTPUT.PUT_LINE(v_c_bank || CHR(10) || v_c_id);
END;

CREATE OR REPLACE PROCEDURE ������������
(
    --p_pbid_id   out tb_panmaebid.pbid_id%TYPE ���̺� ������ ����
    p_pbid_id   OUT VARCHAR2
)
IS
    v_var   VARCHAR2(20);
    v_count    NUMBER :=0;
    v_max   NUMBER;
    vcursor SYS_REFCURSOR;
    --v_pbid_id   tb_panmaebid.pbid_id%TYPE; ���߿� ���̺� ������ �ٲ� ��
    v_pbid_id   VARCHAR(20);
    v_idcheck   CHAR(1) := '0';
BEGIN
    LOOP
        v_count := 0;
        v_var := '';
        v_max := FLOOR(DBMS_RANDOM.VALUE(7,21));
        WHILE(v_count<v_max)
        LOOP
            v_var := v_var 
            || CASE
                WHEN FLOOR(DBMS_RANDOM.VALUE(0,2)) = 1 THEN
                    DBMS_RANDOM.STRING('A',1)
                ELSE 
                    TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1,10)),'FM9')
            END;
            v_count := v_count+1;
        END LOOP;
    OPEN vcursor FOR SELECT pbid_id FROM tb_panmaebid;
    LOOP
        FETCH vcursor INTO v_pbid_id;
        EXIT WHEN vcursor%NOTFOUND;
        IF v_pbid_id = v_var THEN
            v_idcheck := '1';
        END IF;
    END LOOP;
    EXIT WHEN  v_idcheck = '0';
    END LOOP;
    
    p_pbid_id := v_var;
END;

CREATE OR REPLACE FUNCTION ����ǸŰ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE
)
RETURN NUMBER 
IS
    v_is_pprice tb_itemsize.is_pprice%TYPE;
BEGIN
    SELECT is_pprice INTO v_is_pprice
    FROM tb_itemsize i JOIN tb_size s ON i.s_id = s.s_id
                        JOIN tb_item ti ON ti.i_id = i.i_id
    WHERE i.s_id = (select s_id FROM tb_size WHERE s_size = p_size) 
    and i.i_id = (SELECT i_id FROM tb_item WHERE i_name_eng = p_i_name_eng);
    RETURN v_is_pprice;
END;

CREATE OR REPLACE FUNCTION ��ñ��Ű�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE  
)
RETURN NUMBER 
IS
    v_is_gprice tb_itemsize.is_gprice%TYPE;
BEGIN
    SELECT is_gprice INTO v_is_gprice
    FROM tb_itemsize i JOIN tb_size s ON i.s_id = s.s_id
                        JOIN tb_item ti ON ti.i_id = i.i_id
    WHERE i.s_id = (select s_id FROM tb_size WHERE s_size = p_size) 
    and i.i_id = (SELECT i_id FROM tb_item WHERE i_name_eng = p_i_name_eng);
    RETURN v_is_gprice;
END;

CREATE OR REPLACE FUNCTION �ݼ��ּ�
(
    p_m_email tb_member.m_email%TYPE
)
RETURN VARCHAR2 
IS
    v_pbid_adrs tb_panmaebid.pbid_adrs%TYPE;
BEGIN
    SELECT d_ads || d_detail INTO v_pbid_adrs
    FROM tb_delivery
    WHERE m_email = p_m_email;
    RETURN v_pbid_adrs;
END;

CREATE OR REPLACE FUNCTION ��ǰ�ڵ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE
)
RETURN VARCHAR2 
IS
    v_i_id tb_item.i_id%TYPE;
BEGIN
    SELECT i_id INTO v_i_id
    FROM tb_item
    WHERE i_name_eng = p_i_name_eng;
    RETURN v_i_id;
END;

CREATE OR REPLACE PROCEDURE ���ݿ��������
(
    p_m_email   tb_member.m_email%TYPE
)
IS
    v_r_type        tb_receipt.r_type%TYPE;
    v_r_tel         tb_receipt.r_tel%TYPE;
    v_r_cardnum     tb_receipt.r_cardnum%TYPE;
BEGIN
    SELECT r_type, r_tel, r_cardnum INTO v_r_type, v_r_tel, v_r_cardnum
    FROM tb_receipt
    WHERE m_email = p_m_email;
    
    DBMS_OUTPUT.PUT_LINE('���� = ' || v_r_type);
    IF v_r_type = '�̽�û'   THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� �ŷ� �� �����ῡ ���� �Ǻ��� ���ݿ������� �߱��մϴ�.');
    ELSIF   v_r_type = '���μҵ����(�޴���)'  THEN
        DBMS_OUTPUT.PUT_LINE('�޴��� ��ȣ = ' || v_r_tel);
    ELSE
        DBMS_OUTPUT.PUT_LINE('ī�� ��ȣ = ' || v_r_cardnum);
    END IF;
END;



------------------- ���������
-------------------[�Ǹ��ϱ�]
CREATE OR REPLACE PROCEDURE �Ǹ��ϱ� 
( 
    p_i_name_eng IN tb_item.i_name_eng%TYPE
)
IS
    v_s_size    tb_size.s_size%TYPE;
    v_is_pprice varchar2(100);
    vcursor     SYS_REFCURSOR;
BEGIN
    --��ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��ǰ ����---');
    ��ǰ����(p_i_name_eng);
    
    DBMS_OUTPUT.PUT_LINE('---������ ����---');
    OPEN vcursor FOR SELECT s_size , NVL(TO_CHAR(is_pprice,'9,999,999,999'),'�Ǹ�����')
                            FROM tb_item i JOIN tb_itemsize it ON i.i_id = it.i_id
                                            JOIN tb_size s ON it.s_id = s.s_id
                            WHERE i_name_eng = p_i_name_eng
                            ORDER BY s_size;  
    LOOP
        FETCH vcursor INTO v_s_size, v_is_pprice;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_s_size || '   ' || v_is_pprice);
    END LOOP;
    CLOSE vcursor;
END;

---------------------------------------------------------------------
------------------[���� ��û]
CREATE OR REPLACE PROCEDURE ������û
(
    p_i_name_eng IN tb_item.i_name_eng%TYPE
)
IS
    v_s_size    tb_size.s_size%TYPE;
    vcursor     SYS_REFCURSOR;
BEGIN
    --��ǰ����
    DBMS_OUTPUT.PUT_LINE('---��ǰ ����---');
    ��ǰ����(p_i_name_eng);
    
    DBMS_OUTPUT.PUT_LINE('---������ ����---');
    OPEN vcursor FOR SELECT s_size
                            FROM tb_item i JOIN tb_itemsize it ON i.i_id = it.i_id
                                            JOIN tb_size s ON it.s_id = s.s_id
                            WHERE i_name_eng = p_i_name_eng
                            ORDER BY s_size;  
    LOOP
        FETCH vcursor INTO v_s_size;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_s_size);
    END LOOP;
    CLOSE vcursor;
END;

----------------------------------------------------------------------
-----------------[��û ����]
CREATE OR REPLACE PROCEDURE ��û����
(
    p_i_name_eng IN tb_item.i_name_eng%TYPE,
    p_m_email IN tb_member.m_email%TYPE,
    p_pbid_size tb_panmaebid.pbid_size%TYPE,
    p_select_count IN NUMBER := 1
)
IS
    v_s_size    tb_size.s_size%TYPE;
    v_select_count  NUMBER;
    vcursor     SYS_REFCURSOR;
BEGIN
    --��ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��û ��ǰ---');
    ��ǰ����(p_i_name_eng);
    
    --������ ���
    DBMS_OUTPUT.PUT_LINE('��'|| p_select_count || '��' || '  ' || p_pbid_size);
    
    --�ݼ�ȸ���ּ� ���
    DBMS_OUTPUT.PUT_LINE('---�ݼ�/ȸ�� �ּ�---');
    �ݼ�ȸ���ּ�(p_m_email);
    
    --�ǸŴ� �߼� ��� �ù��� ����
    DBMS_OUTPUT.PUT_LINE('---�߼� ���---');
    DBMS_OUTPUT.PUT_LINE('�ù��� ����');
    
    --�г�Ƽ�ݾ� ���
    DBMS_OUTPUT.PUT_LINE('---�г�Ƽ ���� �ݾ�---');
    ����հŷ���(p_i_name_eng);
    
    --���� ��û ����
    DBMS_OUTPUT.PUT_LINE('---���� ��û ����---');
    SELECT p_select_count INTO v_select_count
    FROM dual;
    DBMS_OUTPUT.PUT_LINE('������ = ' || v_select_count * 3000 || CHR(10) 
    || '��û���� = ' || v_select_count);
    
    --�������
    DBMS_OUTPUT.PUT_LINE('---���� ���---');
    �������(p_m_email);
END;

--�����ǸŰ����ϱ�
CREATE OR REPLACE PROCEDURE �����ǸŰ���
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email   tb_panmaebid.m_email%TYPE,
    p_pbid_size tb_panmaebid.pbid_size%TYPE,
    p_select_count NUMBER := 1
)
IS
    V_pbid_id   tb_panmaebid.pbid_id%TYPE;
BEGIN
    V_pbid_id := �Ǹ������ڵ�.nextval;
    --�Ǹ����� ���̺� ������ INSERT
    INSERT INTO tb_panmaebid(pbid_id, m_email, i_id, pbid_size, pbid_rdate
    , pbid_keepcheck, pbid_adrs, pbid_itemstate, pbid_fee) 
    VALUES(V_pbid_id, p_m_email, ��ǰ�ڵ�(p_i_name_eng), p_pbid_size, SYSDATE, 1, �ݼ��ּ�(p_m_email), '�߼ۿ�û', 0);
    
    INSERT INTO tb_bpanitem(bpi_id, pbid_id, i_id, bpi_inspect, bpi_deposit) 
    VALUES (������ǰ�ڵ�.nextval, v_pbid_id, ��ǰ�ڵ�(p_i_name_eng), 0, 3000*p_select_count);
END;

------------------------------------------------------------------------
--------------[�Ǹ� �����ϱ� / ��� �Ǹ��ϱ�]
CREATE OR REPLACE PROCEDURE �Ǹ�����
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE,
    p_pbid_price    tb_panmaebid.pbid_price%TYPE,
    p_date          NUMBER
)
IS
BEGIN
    --�Ϲݻ�ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��û ��ǰ---');
    �Ϲݻ�ǰ����(p_i_name_eng);
    DBMS_OUTPUT.PUT_LINE(p_size);
    
    --��� ���Ű�/��� �ǸŰ�
    DBMS_OUTPUT.PUT_LINE('��� ���Ű� : ' || ��ñ��Ű�(p_i_name_eng, p_size));
    DBMS_OUTPUT.PUT_LINE('��� �ǸŰ� : ' || ����ǸŰ�(p_i_name_eng, p_size));
    
    
    DBMS_OUTPUT.PUT_LINE('������ : ' || FLOOR(p_pbid_price/10000)*100);
    DBMS_OUTPUT.PUT_LINE(p_date || '��(' || TO_CHAR(sysdate + p_date, 'yyyy/mm/dd') ||'����)');
    DBMS_OUTPUT.PUT_LINE('����ݾ� : ' || (p_pbid_price - (FLOOR(p_pbid_price/10000)*100)));
END;

CREATE OR REPLACE PROCEDURE ����Ǹ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE
)
IS
    v_is_pprice     tb_itemsize.is_pprice%TYPE;
BEGIN
    --�Ϲݻ�ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��û ��ǰ---');
    �Ϲݻ�ǰ����(p_i_name_eng);
    DBMS_OUTPUT.PUT_LINE(p_size);
    
    --��� ���Ű�/��� �ǸŰ�
    v_is_pprice := ����ǸŰ�(p_i_name_eng, p_size);
    DBMS_OUTPUT.PUT_LINE('��� ���Ű� : ' || ��ñ��Ű�(p_i_name_eng, p_size));
    DBMS_OUTPUT.PUT_LINE('��� �ǸŰ� : ' || v_is_pprice);
    
    DBMS_OUTPUT.PUT_LINE('������ : ' || FLOOR(v_is_pprice/10000)*100);
    DBMS_OUTPUT.PUT_LINE('����ݾ� : ' || (v_is_pprice - (FLOOR(v_is_pprice/10000)*100)));
END;

CREATE OR REPLACE PROCEDURE �Ǹ���������Ǹ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE,
    p_pbid_price    tb_panmaebid.pbid_price%TYPE := null,
    p_date          NUMBER := null
)
IS
BEGIN
    IF p_pbid_price IS NULL or p_pbid_price < ����ǸŰ�(p_i_name_eng, p_size) THEN
        ����Ǹ�(p_i_name_eng, p_size);
    ELSE
        �Ǹ�����(p_i_name_eng, p_size, p_pbid_price, p_date);
    END IF;
END;

--------------[�ֹ�/����]
CREATE OR REPLACE PROCEDURE �ֹ�����
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_pbid_size     tb_panmaebid.pbid_size%TYPE,         
    p_pbid_price    tb_panmaebid.pbid_price%TYPE := null,
    p_date          tb_panmaebid.pbid_deadline%TYPE := null          
)
IS
    v_is_pprice     tb_itemsize.is_pprice%TYPE;
BEGIN
    --�Ϲݻ�ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��û ��ǰ---');
    �Ϲݻ�ǰ����(p_i_name_eng);
    DBMS_OUTPUT.PUT_LINE(p_pbid_size);
    
    --�ݼ� �ּ�
    DBMS_OUTPUT.PUT_LINE('---�ݼ� �ּ�---');
    �ݼ�ȸ���ּ�(p_m_email);
    
    --�ǸŴ� �߼� ��� �ù��� ����
    DBMS_OUTPUT.PUT_LINE('---�߼� ���---');
    DBMS_OUTPUT.PUT_LINE('�ù��� ����');
    
    --���� �ֹ� ����
    DBMS_OUTPUT.PUT_LINE('---���� �ֹ� ����---');
    IF p_pbid_price IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('����ݾ�' || (p_pbid_price - (FLOOR(p_pbid_price/10000)*100)) || CHR(10) 
        || '�Ǹ� ����� : ' || p_pbid_price || CHR(10) 
        || '������ : ' || FLOOR(p_pbid_price/10000)*100 || CHR(10) 
        || '���� ���� ���� : ' || p_date || '��(' || TO_CHAR(sysdate + p_date, 'yyyy/mm/dd') ||'����)');
    ELSE
        v_is_pprice := ����ǸŰ�(p_i_name_eng, p_pbid_size);
        DBMS_OUTPUT.PUT_LINE('����ݾ�' || (v_is_pprice - (FLOOR(v_is_pprice/10000)*100)) || CHR(10) 
        || '��� �ǸŰ� : ' || v_is_pprice || CHR(10) 
        || '������ : ' || FLOOR(v_is_pprice/10000)*100);
    END IF;
    
    --���ݿ����� ����
    DBMS_OUTPUT.PUT_LINE('---���ݿ����� ����---');
    ���ݿ��������(p_m_email);
    
    --�г�Ƽ ���� ���
    DBMS_OUTPUT.PUT_LINE('---���� ���---');
    �������(p_m_email);
END;

CREATE OR REPLACE  PROCEDURE �Ǹ������ϱ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_pbid_size     tb_panmaebid.pbid_size%TYPE,         
    p_pbid_price    tb_panmaebid.pbid_price%TYPE,
    p_date          tb_panmaebid.pbid_deadline%TYPE 
)
IS
BEGIN
    INSERT INTO tb_panmaebid(pbid_id, m_email, i_id, pbid_size, pbid_price
    , pbid_rdate, pbid_deadline, pbid_adrs, pbid_itemstate, pbid_fee) 
    VALUES(�Ǹ������ڵ�.nextval, p_m_email,��ǰ�ڵ�(p_i_name_eng), p_pbid_size, p_pbid_price, SYSDATE
    , p_date, �ݼ��ּ�(p_m_email), '������', FLOOR(p_pbid_price/10000)*100);
END;

CREATE OR REPLACE PROCEDURE �ٷ��Ǹ��ϱ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_pbid_size     tb_panmaebid.pbid_size%TYPE          
)
IS
    v_pbid_id   tb_panmaebid.pbid_id%TYPE;
    v_gbid_id   tb_gumaebid.gbid_id%TYPE;
    v_i_id      tb_item.i_id%TYPE;
    v_gbid_delivtype    tb_gumaebid.gbid_delivtype%TYPE;
    v_mat_fast_deliv    tb_matching.mat_fast_deliv%TYPE;
    v_is_pprice     tb_itemsize.is_pprice%TYPE;
BEGIN
    v_i_id    := ��ǰ�ڵ�(p_i_name_eng);
    v_pbid_id := �Ǹ������ڵ�.nextval;
    v_is_pprice := ����ǸŰ�(p_i_name_eng, p_pbid_size);
    SELECT gbid_id,gbid_delivtype INTO v_gbid_id,v_gbid_delivtype
    FROM tb_gumaebid
    WHERE i_id = v_i_id and gbid_size = p_pbid_size 
    and gbid_price = v_is_pprice and gbid_complete = '0';
    
    IF v_gbid_delivtype = '�Ϲݹ��'    THEN
        v_mat_fast_deliv := '0';
    ELSIF v_gbid_delivtype = '�������' THEN
        v_mat_fast_deliv := '1';
    END IF;
    

    INSERT INTO tb_panmaebid(pbid_id, m_email, i_id, pbid_size
    , pbid_rdate, pbid_adrs, pbid_itemstate, pbid_fee) 
    VALUES(v_pbid_id, p_m_email, v_i_id, p_pbid_size, SYSDATE
    , �ݼ��ּ�(p_m_email), '�߼ۿ�û', FLOOR(v_is_pprice/10000)*100);
    
    INSERT INTO tb_matching(mat_id, i_id, pbid_id, gbid_id, mat_fast_deliv
    , mat_size, mat_price, mat_date) VALUES (ü��ŷ��ֹ���ȣ.nextval
    , v_i_id, v_pbid_id, v_gbid_id, v_mat_fast_deliv, p_pbid_size, v_is_pprice, SYSDATE);
END;

--------------[�������/�Ϲݹ�� �����ϱ�]

--------------[95�� ��ǰ ����]

--------------[95�� ��ǰ ������]

--------------[���� �����ϱ�/��ñ����ϱ�]
CREATE OR REPLACE PROCEDURE ����������ñ���
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_size          tb_size.s_size%TYPE,
    p_gbid_price    tb_gumaebid.gbid_price%TYPE := null,
    p_date          NUMBER := null
)
IS
    v_price     NUMBER;
BEGIN
    --�Ϲݻ�ǰ���� ���
    DBMS_OUTPUT.PUT_LINE('---��û ��ǰ---');
    �Ϲݻ�ǰ����(p_i_name_eng);
    DBMS_OUTPUT.PUT_LINE(p_size);
    
    --��� ���Ű�/��� �ǸŰ�
    v_price := ��ñ��Ű�(p_i_name_eng, p_size);
    DBMS_OUTPUT.PUT_LINE('��� ���Ű� : ' || v_price);
    DBMS_OUTPUT.PUT_LINE('��� �ǸŰ� : ' || ����ǸŰ�(p_i_name_eng, p_size));
    
    
    
    IF p_gbid_price IS NULL or p_gbid_price > v_price THEN
        DBMS_OUTPUT.PUT_LINE('��� ���Ű� : ' || v_price);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('���� ����� : ' || p_gbid_price);
        DBMS_OUTPUT.PUT_LINE(p_date || '��(' || TO_CHAR(sysdate + p_date, 'yyyy/mm/dd') ||'����)');    
    END IF;
END;

--------------[���/����]

CREATE OR REPLACE PROCEDURE ������۰���
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_size          tb_size.s_size%TYPE,
    p_buymethod     nVARCHAR2 := '�Ϲݹ��',
    p_point         tb_gumaebid.gbid_usepoint%TYPE := 0,
    p_gbid_price    tb_gumaebid.gbid_price%TYPE := null,
    p_date          NUMBER := null
)
IS
--    v_pbid_95check  tb_panmaebid.pbid_95check%TYPE;
    v_m_point       tb_member.m_point%TYPE;
    v_price         NUMBER(10);
    v_gbid_fee      tb_gumaebid.gbid_fee%TYPE;
    v_del_fee       VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('---��ǰ����---');
    IF p_buymethod = '�Ϲݹ��' THEN
        �Ϲݻ�ǰ����(p_i_name_eng);
        v_del_fee := '3000';
        DBMS_OUTPUT.PUT_LINE(p_size);
    ELSIF p_buymethod = '�������' THEN
        ��ǰ����(p_i_name_eng);
        v_del_fee := '5000';
        DBMS_OUTPUT.PUT_LINE(p_size);
    ELSE
        ��ǰ����(p_i_name_eng);
        v_del_fee := '����';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('---��� �ּ�---');
    �ݼ�ȸ���ּ�(p_m_email);
    
    DBMS_OUTPUT.PUT_LINE('---��� ���---');
    DBMS_OUTPUT.PUT_LINE(p_buymethod || CHR(10) || 'â����');
    
    DBMS_OUTPUT.PUT_LINE('---����Ʈ---');
    SELECT m_point INTO v_m_point
    FROM tb_member
    WHERE m_email = p_m_email;
    DBMS_OUTPUT.PUT_LINE(v_m_point);
    
    DBMS_OUTPUT.PUT_LINE('---���� �ֹ� ����---');
    IF p_gbid_price IS NULL THEN
        v_price := ��ñ��Ű�(p_i_name_eng, p_size);
        v_gbid_fee := FLOOR(v_price/10000)*100;
        DBMS_OUTPUT.PUT_LINE('�� �����ݾ� : ' || (v_price + v_gbid_fee + v_del_fee - p_point));
        DBMS_OUTPUT.PUT_LINE('��ñ��Ű� : ' || v_price);    
    ELSE
        v_price := p_gbid_price;
        v_gbid_fee := FLOOR(v_price/10000)*100;
        DBMS_OUTPUT.PUT_LINE('�� �����ݾ� : ' || (v_price + v_gbid_fee + v_del_fee - p_point));
        DBMS_OUTPUT.PUT_LINE('��������� : ' || v_price);    
    END IF;
    
    IF p_point = 0 THEN
        DBMS_OUTPUT.PUT_LINE('����Ʈ : -');
    ELSE
        DBMS_OUTPUT.PUT_LINE('����Ʈ : ' || p_point);
    END IF;
    DBMS_OUTPUT.PUT_LINE('�˼��� : ����');
    DBMS_OUTPUT.PUT_LINE('������ : ' || v_gbid_fee);
    DBMS_OUTPUT.PUT_LINE('��ۺ� : ' || v_del_fee);
    
    IF p_gbid_price IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ���� : ' || p_date || '��-' 
        || TO_CHAR(sysdate + p_date, 'yyyy/mm/dd') ||'����');
    END IF;
    
    
    DBMS_OUTPUT.PUT_LINE('---���� ���---');
    �������(p_m_email);
END;

CREATE OR REPLACE PROCEDURE ���������ϱ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_gbid_size    tb_gumaebid.gbid_size%TYPE,     
    p_buymethod     nVARCHAR2 := '�Ϲݹ��',
    p_point         tb_gumaebid.gbid_usepoint%TYPE,
    p_gbid_price    tb_gumaebid.gbid_price%TYPE,
    p_date          tb_gumaebid.gbid_deadline%TYPE
)
IS
     v_del_fee       VARCHAR2(10);
BEGIN
    IF p_buymethod = '�Ϲݹ��' THEN
        v_del_fee := '3000';
    ELSIF p_buymethod = '�������' THEN
        v_del_fee := '5000';
    ELSE
        v_del_fee := '����';
    END IF;
    
    INSERT INTO tb_gumaebid(gbid_id, m_email, i_id, gbid_size, gbid_price
    , gbid_rdate, gbid_deadline, gbid_delivtype, gbid_adrs
    , gbid_usepoint, gbid_itemstate, gbid_fee, gbid_deliv_fee) 
    VALUES(���������ڵ�.nextval, p_m_email,��ǰ�ڵ�(p_i_name_eng), p_gbid_size
    , p_gbid_price, SYSDATE, p_date, p_buymethod, �ݼ��ּ�(p_m_email)
    , p_point, '������', FLOOR(p_gbid_price/10000)*100, v_del_fee);
END;

CREATE OR REPLACE PROCEDURE ��ñ����ϱ�
(
    p_i_name_eng    tb_item.i_name_eng%TYPE,
    p_m_email       tb_member.m_email%TYPE,
    p_gbid_size     tb_gumaebid.gbid_size%TYPE,
    p_fast_deliv    nVARCHAR2 := '�Ϲݹ��',
    p_point         tb_gumaebid.gbid_usepoint%TYPE
    
)
IS
    v_pbid_id   tb_panmaebid.pbid_id%TYPE;
    v_gbid_id   tb_gumaebid.gbid_id%TYPE;
    v_i_id      tb_item.i_id%TYPE;
    v_gbid_deliv_fee   tb_gumaebid.gbid_deliv_fee%TYPE;
    v_mat_fast_deliv    tb_matching.mat_fast_deliv%TYPE;
    v_is_gprice     tb_itemsize.is_gprice%TYPE;
BEGIN
    v_i_id    := ��ǰ�ڵ�(p_i_name_eng);
    v_gbid_id := ���������ڵ�.nextval;
    v_is_gprice := ��ñ��Ű�(p_i_name_eng, p_gbid_size);
    SELECT pbid_id INTO v_pbid_id
    FROM tb_panmaebid 
    WHERE i_id = v_i_id and pbid_size = p_gbid_size 
    and pbid_price = v_is_gprice and pbid_complete = '0';
    
    IF p_fast_deliv = '�Ϲݹ��'    THEN
        v_mat_fast_deliv := '0';
        v_gbid_deliv_fee := 3000;
    ELSIF p_fast_deliv = '�������' THEN
        v_mat_fast_deliv := '1';
        v_gbid_deliv_fee := 5000;
    END IF;
    

    INSERT INTO tb_gumaebid(gbid_id, m_email, i_id, gbid_size
    , gbid_rdate, gbid_delivtype, gbid_adrs
    , gbid_usepoint, gbid_itemstate, gbid_fee, gbid_deliv_fee) 
    VALUES(v_gbid_id, p_m_email,��ǰ�ڵ�(p_i_name_eng), p_gbid_size
    , SYSDATE, p_fast_deliv, �ݼ��ּ�(p_m_email)
    , p_point, '�����', FLOOR(v_is_gprice/10000)*100, v_gbid_deliv_fee);
    
    INSERT INTO tb_matching(mat_id, i_id, pbid_id, gbid_id, mat_fast_deliv
    , mat_size, mat_price, mat_date) VALUES (ü��ŷ��ֹ���ȣ.nextval
    , v_i_id, v_pbid_id, v_gbid_id, v_mat_fast_deliv, p_gbid_size
    , v_is_gprice, SYSDATE);
END;


--[ȭ�����]
--EXEC �Ǹ��ϱ�(��ǰ��)
EXEC �Ǹ��ϱ�('Nike Air Force 1 ''07 Low White');
--EXEC ������û(��ǰ��)
EXEC ������û('Nike Air Force 1 ''07 Low White');
--EXEC ��û����(��ǰ��, ����, ������, ����)
EXEC ��û����('Nike Air Force 1 ''07 Low White', 'shiueo@naver.com', '250', 1);
--EXEC �Ǹ���������Ǹ�(��ǰ��, ������, �Ǹ�������(����), ���ᳯ¥(����)) -> ���� �� ����Ǹ�
EXEC �Ǹ���������Ǹ�('Nike Air Force 1 ''07 Low White', '250', 125000, 30);
--EXEC �ֹ�����(��ǰ��, ����, ������, �Ǹ�������(����), ���ᳯ¥(����))
EXEC �ֹ�����('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '250', 1511000, 30);
--EXEC ����������ñ���(��ǰ��, ������, ����������(����), ���ᳯ¥(����))
EXEC ����������ñ���('Nike Air Force 1 ''07 Low White', '250', 140000, 30);
--EXEC ������۰���(��ǰ��, ����, ������, ��۹��, ����Ʈ(����), ���������(����), ���ᳯ¥(����))
EXEC ������۰���('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '250', '�������', 100);

--[�����ϱ�]
--EXEC �����ǸŰ���(��ǰ��, ����, ������, ����)
EXEC �����ǸŰ���('Nike Air Force 1 ''07 Low White', 'shiueo@naver.com', '250', 1);
--EXEC �Ǹ������ϱ�(��ǰ��, ����, ������, �Ǹ�������, ���ᳯ¥)
EXEC �Ǹ������ϱ�('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '250', 1511000, 30);
--EXEC �ٷ��Ǹ��ϱ�(��ǰ��, ����, ������)
EXEC �ٷ��Ǹ��ϱ�('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '250');
--EXEC ���������ϱ�(��ǰ��, ����, ������, ��۹��, ����Ʈ, ����������, ���ᳯ¥)
EXEC ���������ϱ�('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '250', '�Ϲݹ��', 0, 130000, 30);
--EXEC ��ñ����ϱ�(��ǰ��, ����, ������, ��۹��, ����Ʈ)
EXEC ��ñ����ϱ�('Nike Air Force 1 ''07 Low White', 'hyungjs1234@naver.com', '260', '�Ϲݹ��', 0);


