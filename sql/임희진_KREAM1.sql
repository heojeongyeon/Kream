---------------------------------------------------------------------------
[ ���������� ]
< ȸ�� ���� >
CREATE OR REPLACE PROCEDURE member_info
(
    pemail  tb_member.m_email%type
)
IS
    vimage  tb_member.m_image%type;
    vname   tb_member.m_name%type;
    vemail  tb_member.m_email%type;
    vpoint  tb_member.m_point%type;
BEGIN
    vemail := RPAD(SUBSTR(pemail, 1, 1), INSTR(pemail, '@') - 2, '*')
        || SUBSTR(pemail, INSTR(pemail, '@') - 1);
    
    SELECT m_image, m_name, m_point INTO vimage, vname, vpoint
    FROM tb_member
    WHERE m_email = pemail;
    
    DBMS_OUTPUT.PUT_LINE('---- ���� ������ ---- ');
    DBMS_OUTPUT.PUT_LINE('[ ȸ�� ���� ]');        
    DBMS_OUTPUT.PUT_LINE(vimage || chr(10) || vname || ', ' || vemail || ', ' || vpoint || 'P');
END;
-- Procedure MEMBER_INFO��(��) �����ϵǾ����ϴ�.
EXEC member_info('hyungjs1234@naver.com');


< ���� �Ǹ� ���� >
1. �ŷ� ���� ���� ���
CREATE OR REPLACE PROCEDURE member_bp
(
    pemail  tb_member.m_email%type
)
IS
    vbpsendreq  tb_amount.am_bpsendreq%type;
    vbpwait     tb_amount.am_bpwait%type;
    vbping      tb_amount.am_bping%type;
    vbpcalcompl tb_amount.am_bpcalcompl%type;
BEGIN
    SELECT am_bpsendreq, am_bpwait, am_bping, am_bpcalcompl
        INTO vbpsendreq, vbpwait, vbping, vbpcalcompl
    FROM tb_amount
    WHERE m_email = pemail;

    DBMS_OUTPUT.PUT_LINE('[ ���� �Ǹ� ���� ]');
    DBMS_OUTPUT.PUT_LINE('�߼ۿ�û : ' || vbpsendreq);
    DBMS_OUTPUT.PUT_LINE('�ǸŴ�� : ' || vbpwait);
    DBMS_OUTPUT.PUT_LINE('�Ǹ��� : ' || vbping);
    DBMS_OUTPUT.PUT_LINE('����Ϸ� : ' || vbpcalcompl);
END;
-- Procedure MEMBER_BP��(��) �����ϵǾ����ϴ�.
EXEC member_bp('hyungjs1234@naver.com');


< ���� ���� >
1. �ŷ� ���� ���� ���
CREATE OR REPLACE PROCEDURE member_gu
(
    pemail  tb_member.m_email%type
)
IS
    vgulog     tb_amount.am_gulog%type;
    vgubid     tb_amount.am_gubid%type;
    vguing     tb_amount.am_guing%type;
    vgucompl   tb_amount.am_gucompl%type;
BEGIN
    SELECT am_gulog, am_gubid, am_guing, am_gucompl
        INTO vgulog, vgubid, vguing, vgucompl
    FROM tb_amount
    WHERE m_email = pemail;
    
    DBMS_OUTPUT.PUT_LINE('[ ���� ���� ]');
    DBMS_OUTPUT.PUT_LINE('��ü : ' || vgulog);
    DBMS_OUTPUT.PUT_LINE('������ : ' || vgubid);
    DBMS_OUTPUT.PUT_LINE('������ : ' || vguing);
    DBMS_OUTPUT.PUT_LINE('���� : ' || vgucompl);
END;
-- Procedure MEMBER_GU��(��) �����ϵǾ����ϴ�.
EXEC member_gu('hyungjs1234@naver.com');


< �Ǹ� ���� >
1. �ŷ� ���� ���� ���
CREATE OR REPLACE PROCEDURE member_pan
(
    pemail  tb_member.m_email%type
)
IS
    vpanlog     tb_amount.am_panlog%type;
    vpanbid     tb_amount.am_panbid%type;
    vpaning     tb_amount.am_paning%type;
    vpancompl   tb_amount.am_pancompl%type;
BEGIN
    SELECT am_panlog, am_panbid, am_paning, am_pancompl
        INTO vpanlog, vpanbid, vpaning, vpancompl
    FROM tb_amount
    WHERE m_email = pemail;
    
    DBMS_OUTPUT.PUT_LINE('[ �Ǹ� ���� ]');
    DBMS_OUTPUT.PUT_LINE('��ü : ' || vpanlog);
    DBMS_OUTPUT.PUT_LINE('������ : ' || vpanbid);
    DBMS_OUTPUT.PUT_LINE('������ : ' || vpaning);
    DBMS_OUTPUT.PUT_LINE('���� : ' || vpancompl);
END;
-- Procedure MEMBER_PAN��(��) �����ϵǾ����ϴ�.
EXEC member_pan('hyungjs1234@naver.com');


< ���� ��ǰ >
1. ���� ��ǰ ��� ���
-- ������ ��� X, ������� ���� ��� O
CREATE OR REPLACE PROCEDURE member_inter
(
    pemail  tb_member.m_email%type
)
IS
    vi_id       tb_item.i_id%type;
    vi_image    tb_item.i_image%type;
    vi_brand    tb_item.i_brand%type;
    vi_name     tb_item.i_name_eng%type;
    vis_gprice  tb_itemsize.is_gprice%type;
    vb_id       tb_branditem.b_id%type;
    vb_image    tb_branditem.b_image%type;
    vb_brand    tb_branditem.b_brand%type;
    vb_name     tb_branditem.b_name_eng%type;
    vb_price    tb_branditem.b_price%type;
    vinter_size tb_interest.inter_size%type;
    visquick    number;
    -- ��ǰ Ŀ��
    CURSOR c_interest IS
                        SELECT i_id, i_image, i_brand, i_name_eng, is_gprice
                                , b_id, b_image, b_brand, b_name_eng, b_price
                                , inter_size
                        FROM (
                            SELECT inter_id, a.i_id, i_image, i_brand, i_name_eng
                                    , a.b_id, b_image, b_brand, b_name_eng, b_price, a.inter_size
                            FROM tb_interest a LEFT JOIN tb_item b ON a.i_id = b.i_id
                                               LEFT JOIN tb_branditem c ON a.b_id = c.b_id
                            WHERE a.m_email = pemail
                        )t1 JOIN (
                            SELECT s_size, is_gprice
                            FROM tb_size a LEFT JOIN tb_itemsize b ON a.s_id = b.s_id
                        )t2 ON t1.inter_size = t2.s_size
                        ORDER BY inter_id DESC;  -- �ֱٵ�ϼ� ����
BEGIN
    SELECT COUNT(*) INTO visquick  -- 0���� ũ�� �������
    FROM (
        SELECT a.i_id, a.inter_size
        FROM tb_interest a LEFT JOIN tb_item b ON a.i_id = b.i_id
        WHERE a.m_email = pemail
    )t1 JOIN (
        SELECT s_size
        FROM tb_size a LEFT JOIN tb_itemsize b
        ON a.s_id = b.s_id
    )t2 ON t1.inter_size = t2.s_size
    JOIN tb_panmaebid a ON t1.i_id = a.i_id
    JOIN tb_bpanitem b ON a.pbid_id = b.pbid_id
    JOIN tb_95item c ON a.pbid_id = c.pbid_id
    WHERE (pbid_keepcheck = 1 and bpi_inspect = 1) or (pbid_95check = 1 and i95_soldout = 0);
    
    DBMS_OUTPUT.PUT_LINE('[ ���� ��ǰ ]');
    
    OPEN c_interest;
    LOOP
        FETCH c_interest INTO vi_id, vi_image, vi_brand, vi_name, vis_gprice
                            , vb_id, vb_image, vb_brand, vb_name, vb_price, vinter_size;
        EXIT WHEN c_interest%NOTFOUND;
        
        IF vb_id IS NULL THEN -- �Ϲ� ��ǰ ���
            IF vis_gprice IS NULL THEN  -- ��ñ��Ű� ���� ���
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name || ', -');
            ELSE
                IF visquick > 0 THEN  -- ��������� ���
                    DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' 
                                        || vi_name || ', �������, ' || vis_gprice);
                ELSE  -- �Ϲݹ���� ���
                    DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' 
                                        || vi_name || ', ' || vis_gprice);
                END IF;
            END IF;
    
        ELSE  -- �귣�� ��ǰ ���
            DBMS_OUTPUT.PUT_LINE(vb_image || ', ' || vb_brand || ', ' || vb_name
                                || ', �귣����, ' || vb_price);
        END IF;
    END LOOP;
    IF c_interest%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�߰��Ͻ� ���� ��ǰ�� �����ϴ�.');
    END IF;
    CLOSE c_interest;
END;
-- Procedure MEMBER_INTER��(��) �����ϵǾ����ϴ�.
EXEC member_inter('shiueo@naver.com');


< �ŷ� ���� ���� ���� >
1. ���� �Ϸ�(�ŷ� ����)
CREATE OR REPLACE PROCEDURE complete_cal
(
    ppbid_id        tb_panmaebid.pbid_id%type  -- �Ǹ� ���� �ڵ�
    , ppbid_state   tb_panmaebid.pbid_itemstate%type  -- ������ ��ǰ ����
    , pgbid_id      tb_gumaebid.gbid_id%type  -- ���� ���� �ڵ�
    , pgbid_state   tb_gumaebid.gbid_itemstate%type  -- ������ ��ǰ ����
)
IS
BEGIN
    IF ppbid_id IS NOT NULL THEN  -- �Ǹ� ��ǰ�� ��ǰ ���� ����
        UPDATE tb_panmaebid
        SET pbid_itemstate = ppbid_state, pbid_complete = 2
        WHERE pbid_id = ppbid_id;
    END IF;
    
    IF pgbid_id IS NOT NULL THEN  -- ���� ��ǰ�� ��ǰ ���� ����
        UPDATE tb_gumaebid
        SET gbid_itemstate = pgbid_state, gbid_complete = 2
        WHERE gbid_id = pgbid_id;
    END IF;
END;
-- Procedure COMPLETE_CAL��(��) �����ϵǾ����ϴ�.


2. �Ǹ� ���� ���� ����(�Ϲ� �Ǹ�/���� �Ǹ�)
CREATE OR REPLACE PROCEDURE upd_amount_pan
(
    ppbid_id    tb_panmaebid.pbid_id%type
)
IS 
    vpanbid     number;
    vpaning     number;
    vpancompl   number;
    vpanlog     number;
    vbpsendreq  number;
    vbpwait     number;
    vbping      number;
    vbpcalcompl number;
    vemail      tb_member.m_email%type;
    vkeepcheck  tb_panmaebid.pbid_keepcheck%type;
BEGIN
    SELECT m_email, pbid_keepcheck INTO vemail, vkeepcheck
    FROM tb_panmaebid
    WHERE pbid_id = ppbid_id;
    
    IF vkeepcheck = 0 THEN  -- �Ϲ� �Ǹ� ��ǰ
        SELECT * INTO vpanbid, vpaning, vpancompl
        FROM (SELECT pbid_complete FROM tb_panmaebid WHERE m_email = vemail)
        PIVOT (COUNT(pbid_complete) FOR pbid_complete IN (0, 1, 2));
        
        vpanlog := vpanbid + vpaning + vpancompl;
        
        UPDATE tb_amount 
        SET am_panlog = vpanlog, am_panbid = vpanbid, am_paning = vpaning, am_pancompl = vpancompl
        WHERE m_email = vemail;
        
    ELSE  -- ���� �Ǹ� ��ǰ
        SELECT * INTO vbpsendreq, vbpwait, vbping, vbpcalcompl
        FROM (SELECT pbid_itemstate FROM tb_panmaebid WHERE m_email = vemail)
        PIVOT (COUNT(pbid_itemstate) FOR pbid_itemstate IN ('�߼ۿ�û', '�ǸŴ��', '�Ǹ���', '����Ϸ�'));
        
        UPDATE tb_amount 
        SET am_bpsendreq = vbpsendreq, am_bpwait = vbpwait, am_bping = vbping, am_bpcalcompl = vbpcalcompl
        WHERE m_email = vemail;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� �ڵ带 �߸� �Է��Ͽ����ϴ�.');
END;
-- Procedure UPD_AMOUNT_PAN��(��) �����ϵǾ����ϴ�.


3. ���� ���� ���� ����
CREATE OR REPLACE PROCEDURE upd_amount_gu
(
    pgbid_id  tb_gumaebid.gbid_id%type
)
IS 
    vgubid    number;
    vguing    number;
    vgucompl  number;
    vgulog    number;
    vemail    tb_member.m_email%type;
BEGIN
    SELECT m_email INTO vemail
    FROM tb_gumaebid
    WHERE gbid_id = pgbid_id;
    
    SELECT * INTO vgubid, vguing, vgucompl
    FROM (SELECT gbid_complete FROM tb_gumaebid WHERE m_email = vemail)
    PIVOT (COUNT(gbid_complete) FOR gbid_complete IN (0, 1, 2));
    
    vgulog := vgubid + vguing + vgucompl;
        
    UPDATE tb_amount 
    SET am_gulog = vgulog, am_gubid = vgubid, am_guing = vguing, am_gucompl = vgucompl
    WHERE m_email = vemail;
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� �ڵ带 �߸� �Է��Ͽ����ϴ�.');
END;
-- Procedure UPD_AMOUNT_GU��(��) �����ϵǾ����ϴ�.

-- 1) �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES(4, 'shiueo@naver.com', 1, 250, 260000
            , TO_DATE('22/09/21', 'YY/MM/DD'), 30, 0, '�������', '����', 0, 1, '�����', 7800, 5000);

-- 2) ���ν��� ����
EXEC complete_cal(2, '����Ϸ�', 4, '��ۿϷ�');  -- �ŷ� ����, ��ǰ ���� ����
EXEC upd_amount_pan(2);  -- �Ǹ� ���� ���� ����
EXEC upd_amount_gu(4);  -- ���� ���� ���� ����

-- 3) Ȯ��
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_amount;
ROLLBACK;

-- 4) �׽�Ʈ ������ �ѹ�
DELETE FROM tb_gumaebid WHERE gbid_id = 4;
UPDATE tb_panmaebid
SET pbid_itemstate = '�Ǹ���', pbid_complete = 1
WHERE pbid_id = 2;
COMMIT;


---------------------------------------------------------------------------
[ ���� ���� ]
< �������� >
-- ���ſ��� 0
1. ��ü ��ȸ
CREATE OR REPLACE PROCEDURE gbid_default
(
    pemail   tb_member.m_email%type
)
IS
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_gumaebid.gbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- ������
    CURSOR c_gbid IS
                SELECT i_image, i_name_eng, gbid_size
                         , TO_CHAR(gbid_price, 'FM999,999,999,999') || '��' gbid_price
                         , TO_CHAR(gbid_rdate + gbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                WHERE gbid_complete = 0 and m_email = pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE; 
                    -- �Ⱓ �⺻��: �ֱ� 2����
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� ���� ]');
    
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('���������: ' || vprice || ', ������: ' || vexdate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GBID_DEFAULT��(��) �����ϵǾ����ϴ�.
EXEC gbid_default('shiueo@naver.com');
EXEC gbid_default('lklk9803@gmail.com');


2. �Ⱓ�� ��ȸ
-- �������� �Է��� �����ϰ� ������ ������ ������� ��ȸ
CREATE OR REPLACE PROCEDURE gbid_date
(
    pemail    tb_member.m_email%type
    , psdate  varchar2  -- �Է� ������
    , pedate  varchar2  -- �Է� ������
)
IS
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    varchar2(20);
    vexdate   varchar2(10);  -- ������
    CURSOR c_gbid IS
                SELECT i_image, i_name_eng, gbid_size
                         , TO_CHAR(gbid_price, 'FM999,999,999,999') || '��' gbid_price
                         , TO_CHAR(gbid_rdate + gbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                WHERE gbid_complete = 0 and m_email = pemail
                    and gbid_rdate BETWEEN TO_DATE(psdate, 'YYYY-MM-DD') AND TO_DATE(pedate, 'YYYY-MM-DD'); 
BEGIN
    DBMS_OUTPUT.PUT_LINE('[ �Ⱓ�� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('�Ⱓ: ' || psdate || ' ~ ' || pedate);
    
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('���������: ' || vprice || ', ������: ' || vexdate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GBID_DATE��(��) �����ϵǾ����ϴ�.
EXEC gbid_date('shiueo@naver.com', '2022-05-23', '2022-06-28');
EXEC gbid_date('shiueo@naver.com', '2022-08-23', '2022-10-28');


3. ����������� ����
CREATE OR REPLACE PROCEDURE gbid_price_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql      varchar2(1000);
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    number(12);
    vexdate   date;  -- ������
    vcur      SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, gbid_price, gbid_rdate + gbid_deadline ';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id ';
    vsql := vsql || ' WHERE gbid_complete = 0 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ��������� �������� ���� ]');
        vsql := vsql || ' ORDER BY gbid_price ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ��������� �������� ���� ]');
        vsql := vsql || ' ORDER BY gbid_price DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('���������: ' || TO_CHAR(vprice, 'FM999,999,999,999')
        || '��, ������: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GBID_PRICE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC gbid_price_order('shiueo@naver.com', 0);
EXEC gbid_price_order('shiueo@naver.com', 1);
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 0, '������', 4950, 3000);


4. �����ϼ� ����
CREATE OR REPLACE PROCEDURE gbid_exdate_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql      varchar2(1000);
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    number(12);
    vexdate   date;  -- ������
    vcur      SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, gbid_price, gbid_rdate + gbid_deadline AS exdate';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id ';
    vsql := vsql || ' WHERE gbid_complete = 0 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY exdate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY exdate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('���������: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '��, ������: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GBID_EXDATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC gbid_exdate_order('shiueo@naver.com', 0);
EXEC gbid_exdate_order('shiueo@naver.com', 1);
-- �׽�Ʈ ������ ����
DELETE FROM tb_gumaebid WHERE gbid_id = 4;


5. ������ ��ǰ ������
5-1. ��ǰ ����
CREATE OR REPLACE PROCEDURE gbid_info1
(
    pemail      tb_member.m_email%type
    , pgumaeid  tb_gumaebid.gbid_id%type
)
IS
    vimage    tb_item.i_image%type;
    vmodel    tb_item.i_model%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vgprice   tb_itemsize.is_gprice%type;
    vpprice   tb_itemsize.is_pprice%type;
BEGIN
    SELECT i_image, i_model, i_name_eng, gbid_size, is_gprice, is_pprice
        INTO vimage, vmodel, vname, vsize, vgprice, vpprice
    FROM (
        SELECT i_image, i_model, i_name_eng, gbid_size
        FROM tb_gumaebid g LEFT JOIN tb_item i ON g.i_id = i.i_id
        WHERE gbid_complete = 0 and m_email = pemail and gbid_id = pgumaeid
    ) t1 JOIN (
        SELECT s_size, is_gprice, is_pprice
        FROM tb_size a LEFT JOIN tb_itemsize b ON a.s_id = b.s_id
    )t2 ON t1.gbid_size = t2.s_size;
    
    DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
    DBMS_OUTPUT.PUT_LINE('[ ��ǰ ���� ]');
    DBMS_OUTPUT.PUT_LINE('�ֹ���ȣ: ' || pgumaeid);
    DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vsize);
    DBMS_OUTPUT.PUT_LINE('��ñ��Ű�: ' || TO_CHAR(vgprice, 'FM999,999,999,999') || '��, ����ǸŰ�: ' 
                        || TO_CHAR(vpprice, 'FM999,999,999,999') || '��');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
END;
-- Procedure GBID_INFO1��(��) �����ϵǾ����ϴ�.
EXEC gbid_info1('shiueo@naver.com', 2);


5-2. ���� ���� ����
CREATE OR REPLACE PROCEDURE gbid_info2
(
    pemail      tb_member.m_email%type
    , pgumaeid  tb_gumaebid.gbid_id%type
)
IS
    vprice      tb_gumaebid.gbid_price%type;
    vfee        tb_gumaebid.gbid_fee%type;
    vdelivfee   tb_gumaebid.gbid_deliv_fee%type;
    vrdate      tb_gumaebid.gbid_rdate%type;
    vdeadline   tb_gumaebid.gbid_deadline%type;
BEGIN
    SELECT gbid_price, gbid_fee, gbid_deliv_fee, gbid_rdate, gbid_deadline
        INTO vprice, vfee, vdelivfee, vrdate, vdeadline
    FROM tb_gumaebid
    WHERE gbid_complete = 0 and m_email = pemail and gbid_id = pgumaeid;
    
    DBMS_OUTPUT.PUT_LINE('[ ���� ���� ���� ]');
    DBMS_OUTPUT.PUT_LINE('���� �����: ' || TO_CHAR(vprice, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('�˼���: ����');
    DBMS_OUTPUT.PUT_LINE('������: ' || TO_CHAR(vfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('��ۺ�: ' || TO_CHAR(vdelivfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('�� �����ݾ�: ' || TO_CHAR(vprice + vfee + vdelivfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('������: ' || vrdate);
    DBMS_OUTPUT.PUT_LINE('������������: ' || vdeadline || '�� - ' || TO_CHAR(vrdate + vdeadline, 'YY/MM/DD') || '����');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('[ ���� ���� ���� ]');
        DBMS_OUTPUT.PUT_LINE('���� ���� ������ �����ϴ�.');
END;
-- Procedure GBID_INFO2��(��) �����ϵǾ����ϴ�.
EXEC gbid_info2('shiueo@naver.com', 2);


5-3. ��� �ּ� �� ���� ����
CREATE OR REPLACE PROCEDURE gbid_info3
(
    pemail  tb_member.m_email%type
)
IS
    vname     tb_delivery.d_name%type;
    vtel      tb_delivery.d_tel%type;
    vzip      tb_delivery.d_zip%type;
    vads      tb_delivery.d_ads%type;
    vdetail   tb_delivery.d_detail%type;
    vbank     tb_card.c_bank%type;
    vcid      tb_card.c_id%type;
BEGIN
    SELECT d_name, d_tel, d_zip, d_ads, d_detail
        INTO vname, vtel, vzip, vads, vdetail
    FROM tb_delivery
    WHERE m_email = pemail and d_basic = 1;  -- �⺻ �����
    
    SELECT c_bank, c_id INTO vbank, vcid
    FROM tb_card
    WHERE m_email = pemail and c_pay = 1; -- �⺻ ���� ī��
    
    DBMS_OUTPUT.PUT_LINE('[ ��� �ּ� ]');
    DBMS_OUTPUT.PUT_LINE('�޴� ���: ' || REPLACE(vname, SUBSTR(vname, 2), '**'));
    DBMS_OUTPUT.PUT_LINE('�޴��� ��ȣ: ' || REPLACE(vtel, SUBSTR(vtel, 6, 5), '***-*'));
    DBMS_OUTPUT.PUT_LINE('�ּ�: (' || vzip || ') ' || vads || ' ' || vdetail);
    DBMS_OUTPUT.PUT_LINE('[ ���� ���� ]');
    DBMS_OUTPUT.PUT_LINE(vbank || ' ****-****-****-' || SUBSTR(vcid, 13, 3) || '*');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
        DBMS_OUTPUT.PUT_LINE('��� �ּ� �� ���� ������ �����ϴ�.');
END;
-- Procedure GBID_INFO3��(��) �����ϵǾ����ϴ�.
EXEC gbid_info3('shiueo@naver.com');

-- ��ü ���
EXEC gbid_info1('shiueo@naver.com', 2);
EXEC gbid_info2('shiueo@naver.com', 2);
EXEC gbid_info3('shiueo@naver.com');


6. ���� ���� �����ϱ�
CREATE OR REPLACE PROCEDURE del_gbid
(
    pgumaeid  tb_gumaebid.gbid_id%type
)
IS
BEGIN
    DELETE FROM tb_gumaebid
    WHERE gbid_id = pgumaeid;
    DBMS_OUTPUT.PUT_LINE('���� ������ �����Ǿ����ϴ�.');
END;
-- Procedure GBID_INFO1��(��) �����ϵǾ����ϴ�.
EXEC del_gbid(3);
ROLLBACK;
SELECT * FROM tb_gumaebid;



< ������ >
-- ���ſ��� 1
1. ���º� ��ȸ
CREATE OR REPLACE PROCEDURE ging_state
(
    pemail       tb_member.m_email%type
    , pitemstate tb_gumaebid.gbid_itemstate%type
)
IS
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_gumaebid.gbid_size%type;
    vstate  tb_gumaebid.gbid_itemstate%type;
    CURSOR c_gbid IS
                SELECT i_image, i_name_eng, gbid_size, gbid_itemstate
                FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                WHERE gbid_complete = 1 and m_email = pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE
                    and gbid_itemstate = pitemstate;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� �� ]');
    DBMS_OUTPUT.PUT_LINE('[ ���º� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('������ ����: ' || pitemstate);
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vstate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('����: ' || vstate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GING_STATE��(��) �����ϵǾ����ϴ�.
EXEC ging_state('shiueo@naver.com', '�԰���');
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�԰���', 4950, 3000);
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 190000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '��� ��', 5700, 3000);


2. ���¼� ����
CREATE OR REPLACE PROCEDURE ging_state_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql     varchar2(1000);
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_gumaebid.gbid_size%type;
    vstate   tb_gumaebid.gbid_itemstate%type;
    vcur     SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, gbid_itemstate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id ';
    vsql := vsql || ' WHERE gbid_complete = 1 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ���� �������� ���� ]');
        vsql := vsql || ' ORDER BY gbid_itemstate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ���� �������� ���� ]');
        vsql := vsql || ' ORDER BY gbid_itemstate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('����: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GING_STATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC ging_state_order('shiueo@naver.com', 0);
EXEC ging_state_order('shiueo@naver.com', 1);
-- �׽�Ʈ ������ ����
DELETE FROM tb_gumaebid WHERE gbid_id IN (4, 5);


3. ������ ��ǰ ������
3-1. ��ǰ ����
CREATE OR REPLACE PROCEDURE ging_info1
(
    pemail    tb_member.m_email%type
    , pmatid  tb_matching.mat_id%type
)
IS
    vimage      tb_item.i_image%type;
    vmodel      tb_item.i_model%type;
    vname       tb_item.i_name_eng%type;
    vsize       tb_gumaebid.gbid_size%type;
    vitemstate  tb_gumaebid.gbid_itemstate%type;
BEGIN
    SELECT i_image, i_model, i_name_eng, gbid_size, gbid_itemstate
        INTO vimage, vmodel, vname, vsize, vitemstate
    FROM tb_gumaebid g LEFT JOIN tb_item i ON g.i_id = i.i_id
                       JOIN tb_matching m ON g.gbid_id = m.gbid_id
    WHERE gbid_complete = 1 and g.gbid_id = m.gbid_id and mat_id = pmatid;
    
    DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
    DBMS_OUTPUT.PUT_LINE('[ ��ǰ ���� ]');
    DBMS_OUTPUT.PUT_LINE('�ֹ���ȣ: ' || pmatid);
    DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vsize);
    DBMS_OUTPUT.PUT_LINE('�����Ȳ: ' || vitemstate);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
        DBMS_OUTPUT.PUT_LINE('���� ���� �� ��ǰ�� �����ϴ�.');
END;
-- Procedure GBID_INFO1��(��) �����ϵǾ����ϴ�.
EXEC ging_info1('hyungjs1234@naver.com', 2);
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�԰���', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'hyungjs1234@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�԰���', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�߼ۿ�û', 1600, '��ü���ù�', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'hyungjs1234@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�����', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

ROLLBACK;

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;
  
  
3-2. ���� ����
CREATE OR REPLACE PROCEDURE ging_info2
(
    pemail    tb_member.m_email%type
    , pmatid  tb_matching.mat_id%type
)
IS
    vprice      tb_matching.mat_price%type;
    vfee        tb_gumaebid.gbid_fee%type;
    vdelivfee   tb_gumaebid.gbid_deliv_fee%type;
    vmatdate    tb_matching.mat_date%type;
BEGIN
    SELECT mat_price, gbid_fee, gbid_deliv_fee, mat_date
        INTO vprice, vfee, vdelivfee, vmatdate
    FROM tb_matching m JOIN tb_gumaebid g ON m.gbid_id = g.gbid_id
    WHERE gbid_complete = 1 and g.gbid_id = m.gbid_id and mat_id = pmatid;
    
    DBMS_OUTPUT.PUT_LINE('�� �����ݾ�: ' || TO_CHAR(vprice + vfee + vdelivfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('�˼���: ����');
    DBMS_OUTPUT.PUT_LINE('������: ' || TO_CHAR(vfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('��ۺ�: ' || TO_CHAR(vdelivfee, 'FM999,999,999,999') || '��');
    DBMS_OUTPUT.PUT_LINE('�ŷ��Ͻ�: ' || TO_CHAR(vmatdate, 'YY/MM/DD HH24:MI'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- ���� ���� �� ---');
        DBMS_OUTPUT.PUT_LINE('���� ���� �� ��ǰ�� �����ϴ�.');
END;
-- Procedure GING_INFO2��(��) �����ϵǾ����ϴ�.
EXEC ging_info2('hyungjs1234@naver.com', 2);


< ���� >
-- ���ſ��� 2
1. �����ϼ�(�ŷ��ϼ�) ����
CREATE OR REPLACE PROCEDURE gend_matdate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql        varchar2(1000);
    viamge      tb_item.i_image%type;
    vname       tb_item.i_name_eng%type;
    vsize       tb_gumaebid.gbid_size%type;
    vmatdate    tb_matching.mat_date%type;
    vstate      tb_gumaebid.gbid_itemstate%type;
    vcur        SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, mat_date, gbid_itemstate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                                     JOIN tb_matching m ON g.gbid_id = m.gbid_id ';
    vsql := vsql || ' WHERE gbid_complete = 2 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    DBMS_OUTPUT.PUT_LINE('--- ���� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� ]');
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY mat_date ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY mat_date DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vmatdate, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('������: ' || vmatdate || ', ����: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GEND_MATDATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC gend_matdate_order('shiueo@naver.com', 0);
EXEC gend_matdate_order('shiueo@naver.com', 1);

-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

ROLLBACK;


2. ���� ��ǰ ������
-- ������ ��ǰ �������� ����



---------------------------------------------------------------------------
[ �Ǹ� ���� ]
< �Ǹ����� >
-- �����Ǹ� ���� 0, �Ǹſ��� 0
1. ��ü ��ȸ
CREATE OR REPLACE PROCEDURE pbid_default
(
    pemail  tb_member.m_email%type
)
IS
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_panmaebid.pbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- ������
    CURSOR c_pbid IS
                SELECT i_image, i_name_eng, pbid_size
                         , TO_CHAR(pbid_price, 'FM999,999,999,999') || '��' gbid_price
                         , TO_CHAR(pbid_rdate + pbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE;  
                    -- �Ⱓ �⺻��: �ֱ� 2����
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- �Ǹ� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ �Ǹ� ���� ]');
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('�Ǹ������: ' || vprice || ', ������: ' || vexdate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ������ �����ϴ�.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PBID_DEFAULT��(��) �����ϵǾ����ϴ�.
EXEC pbid_default('lklk9803@gmail.com');


2. �Ⱓ�� ��ȸ
CREATE OR REPLACE PROCEDURE pbid_date
(
    pemail    tb_member.m_email%type
    , psdate  varchar2  -- �Է� ������
    , pedate  varchar2  -- �Է� ������
)
IS  
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_panmaebid.pbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- ������
    CURSOR c_pbid IS
                SELECT i_image, i_name_eng, pbid_size
                         , TO_CHAR(pbid_price, 'FM999,999,999,999') || '��' pbid_price
                         , TO_CHAR(pbid_rdate + pbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = pemail
                    and pbid_rdate BETWEEN TO_DATE(psdate, 'YYYY-MM-DD') AND TO_DATE(pedate, 'YYYY-MM-DD'); 
BEGIN
    DBMS_OUTPUT.PUT_LINE('[ �Ⱓ�� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('�Ⱓ: ' || psdate || ' ~ ' || pedate);
    
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('�Ǹ������: ' || vprice || ', ������: ' || vexdate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ������ �����ϴ�.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PBID_DATE��(��) �����ϵǾ����ϴ�.
EXEC pbid_date('lklk9803@gmail.com', '2022-05-23', '2022-06-28');
EXEC pbid_date('lklk9803@gmail.com', '2022-08-23', '2022-10-28');
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'lklk9803@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 0, '������', 1550, null, null);
          
SELECT * FROM tb_panmaebid;


3. �Ǹ�������� ����
CREATE OR REPLACE PROCEDURE pbid_price_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql    varchar2(1000);
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vprice  number(12);
    vexdate date;  -- ������
    vcur    SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, pbid_price, pbid_rdate + pbid_deadline ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ �Ǹ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY pbid_price ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ �Ǹ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY pbid_price DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('�Ǹ������: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '��, ������: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PBID_PRICE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC pbid_price_order('lklk9803@gmail.com', 0);
EXEC pbid_price_order('lklk9803@gmail.com', 1);


4. �����ϼ� ����
CREATE OR REPLACE PROCEDURE pbid_exdate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql    varchar2(1000);
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vprice  number(12);
    vexdate date;  -- ������
    vcur    SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, pbid_price, pbid_rdate + pbid_deadline AS exdate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY exdate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY exdate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('�Ǹ������: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '��, ������: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PBID_EXDATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC pbid_exdate_order('lklk9803@gmail.com', 0);
EXEC pbid_exdate_order('lklk9803@gmail.com', 1);
-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid WHERE pbid_id = 6;


5. ������ ��ǰ ������
-- ��ǰ ����, ���� ������ ���� ������ ����
-- ���Ƽ ���� ������ ���� ������ ī�� ������ ����
-- �ݼ� �ּҴ� ���� ������ ��� �ּҿ� ����
5-1. �Ǹ� ���� ����
CREATE OR REPLACE PROCEDURE pbid_account
(
    pemail  tb_account.m_email%type
)
IS
    vbank   tb_account.ac_bank%type;
    vnum    tb_account.ac_num%type;
BEGIN
    SELECT ac_bank, ac_num INTO vbank, vnum
    FROM tb_account
    WHERE m_email = pemail;
    
    DBMS_OUTPUT.PUT_LINE('[ �Ǹ� ���� ���� ]');
    DBMS_OUTPUT.PUT_LINE(vbank || RPAD(' ', LENGTH(vnum), '*'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ���°� �����ϴ�.');
END;
-- Procedure PBID_ACCOUNT��(��) �����ϵǾ����ϴ�.
EXEC pbid_account('lklk9803@gmail.com');


< ���� �� >
-- �����Ǹ� ���� 0, �Ǹſ��� 1
1. ���º� ��ȸ
CREATE OR REPLACE PROCEDURE ping_state
(
    pemail       tb_member.m_email%type
    , pitemstate tb_panmaebid.pbid_itemstate%type
)
IS
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vstate  tb_panmaebid.pbid_itemstate%type;
    CURSOR c_pbid IS
                SELECT i_image, i_name_eng, pbid_size, pbid_itemstate
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                WHERE pbid_keepcheck = 0 and pbid_complete = 1 and m_email = pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE
                    and pbid_itemstate = pitemstate;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- �Ǹ� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� �� ]');
    DBMS_OUTPUT.PUT_LINE('[ ���º� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('������ ����: ' || pitemstate);
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vstate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('����: ' || vstate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PING_STATE��(��) �����ϵǾ����ϴ�.
EXEC ping_state('sdjsd@naver.com', '�߼ۿ�û');


2. ���¼� ����
CREATE OR REPLACE PROCEDURE ping_state_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql    varchar2(1000);
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vstate  tb_panmaebid.pbid_itemstate%type;
    vcur    SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, pbid_itemstate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 1 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ���� �������� ���� ]');
        vsql := vsql || ' ORDER BY pbid_itemstate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ���� �������� ���� ]');
        vsql := vsql || ' ORDER BY pbid_itemstate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('����: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PING_STATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC ping_state_order('sdjsd@naver.com', 0);
EXEC ping_state_order('sdjsd@naver.com', 1);
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'sdjsd@naver.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�԰�Ϸ�', 1550, null, null);

ROLLBACK;


3. ������ ��ǰ ������
-- �߼� ���� �̿ܿ� ��� ���� ����
3-1. �߼� ���� ���
CREATE OR REPLACE PROCEDURE ping_shipping
(
    pemail      tb_account.m_email%type
    , ppbid_id  tb_panmaebid.pbid_id%type
)
IS
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
BEGIN
    SELECT pbid_courier, pbid_trackingnum INTO vcourier, vtrackingnum
    FROM tb_panmaebid
    WHERE m_email = pemail;
    DBMS_OUTPUT.PUT_LINE('[ �߼� ���� ]');
    DBMS_OUTPUT.PUT_LINE(vcourier || ' ' || vtrackingnum);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('�߼� ������ �����ϴ�.');
END;
-- Procedure PING_SHIPPING��(��) �����ϵǾ����ϴ�.
EXEC ping_shipping('hyungjs1234@naver.com', 2);


3-2. �߼� ���� ����
EXEC upd_shipping(2, '��ü���ù�', '736132678451');

SELECT * FROM tb_panmaebid;
ROLLBACK;


< ���� >
-- �����Ǹ� ���� 0, �Ǹſ��� 2
1. �����ϼ� ����
CREATE OR REPLACE PROCEDURE pend_caldate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0�̸� ��������, 1�̸� ��������
)
IS
    vsql        varchar2(1000);
    viamge      tb_item.i_image%type;
    vname       tb_item.i_name_eng%type;
    vsize       tb_panmaebid.pbid_size%type;
    vcaldate    tb_matching.mat_caldate%type;
    vstate      tb_panmaebid.pbid_itemstate%type;
    vcur        SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, mat_caldate, pbid_itemstate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                                     JOIN tb_matching m ON p.pbid_id = m.pbid_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 2 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    DBMS_OUTPUT.PUT_LINE('--- �Ǹ� ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� ]');
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY mat_caldate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ ������ �������� ���� ]');
        vsql := vsql || ' ORDER BY mat_caldate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vcaldate, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('������: ' || vcaldate || ', ����: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ŷ� ������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PEND_CALDATE_ORDER��(��) �����ϵǾ����ϴ�.
EXEC pend_caldate_order('jeifh@gmail.com', 0);
EXEC pend_caldate_order('jeifh@gmail.com', 1);

-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1600, '��ü���ù�', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;


2. ���� ��ǰ ������
-- ������ �̿ܿ� ��� ���� ����
2-1. ������ ���
CREATE OR REPLACE PROCEDURE pend_caldate
(
    pmat_id   tb_matching.mat_id%type  -- �ֹ���ȣ
)
IS
    vcaldate  tb_matching.mat_caldate%type;
BEGIN
    SELECT mat_caldate INTO vcaldate
    FROM tb_panmaebid p JOIN tb_matching m ON p.pbid_id = m.pbid_id
    WHERE pbid_keepcheck = 0 and pbid_complete = 2 and mat_id = pmat_id;
    DBMS_OUTPUT.PUT_LINE('������: ' || TO_CHAR(vcaldate, 'YY/MM/DD'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('�Ǹ� ���� ��ǰ ������ �����ϴ�.');
END;
-- Procedure PEND_CALDATE��(��) �����ϵǾ����ϴ�.
EXEC pend_caldate(2);
-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid WHERE pbid_id >= 6;
DELETE FROM tb_gumaebid WHERE gbid_id >= 4;
DELETE FROM tb_matching WHERE mat_id >= 2;


---------------------------------------------------------------------------
[ ���� �Ǹ� ]
-- ��ü ��ȸ �Ұ�. ���º��θ� ��ȸ ����.
< ���� ��ǰ ���� >
CREATE OR REPLACE PROCEDURE bpan_itemlist
IS
    vimage      tb_item.i_image%type;
    vmodel      tb_item.i_model%type;
    vname_eng   tb_item.i_name_eng%type;
    vname_kor   tb_item.i_name_kor%type;
    CURSOR c_bpan IS
                SELECT i_image, i_model, i_name_eng, i_name_kor
                FROM tb_item i 
                WHERE i_bpcheck = 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� ��ǰ ���� ---');
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname_eng, vname_kor;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || chr(10) || vmodel || chr(10)
                            || vname_eng || chr(10) || vname_kor);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    END LOOP;
    CLOSE c_bpan;
END;
-- Procedure BPAN_ITEMLIST��(��) �����ϵǾ����ϴ�.
EXEC bpan_itemlist;


< ��û >
-- �����Ǹ� ���� 1, �Ǹſ��� 0
1. ���º� ��ȸ (default�� �߼ۿ�û)
CREATE OR REPLACE PROCEDURE bpan_app
(
    pemail      tb_member.m_email%type
    , pstate    tb_panmaebid.pbid_itemstate%type
)
IS
    vimage       tb_item.i_image%type;
    vmodel       tb_item.i_model%type;
    vname        tb_item.i_name_eng%type;
    vsize        tb_gumaebid.gbid_size%type;
    vbpi_id      tb_bpanitem.bpi_id%type;
    vdeposit     tb_bpanitem.bpi_deposit%type;
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
    CURSOR c_bpan IS
                SELECT i_image, i_model, i_name_eng, pbid_size, bpi_id
                        , bpi_deposit, pbid_courier, pbid_trackingnum
                FROM tb_panmaebid p LEFT JOIN tb_item i ON p.i_id = i.i_id
                                    LEFT JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id
                WHERE pbid_keepcheck = 1 and pbid_complete = 0 and m_email = pemail;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� �Ǹ� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ��û ]');
    DBMS_OUTPUT.PUT_LINE('[ ���º� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('������ ����: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('������: ' || vsize || ', ������: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('�ù��: ' || vcourier || ', ����� ��ȣ: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('������ �����ϴ�.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_APP��(��) �����ϵǾ����ϴ�.
EXEC bpan_app('shiueo@naver.com', '�߼ۿ�û');
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '����8', 0, '�߼ۿ�û', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);


2. �ù��, ������ȣ �Է�
CREATE OR REPLACE PROCEDURE upd_shipping 
(
    ppbid_id        tb_panmaebid.pbid_id%type  -- �Ǹ����� �ڵ�
    , pcourier      tb_panmaebid.pbid_courier%type
    , ptrackingnum  tb_panmaebid.pbid_trackingnum%type
)
IS
BEGIN
    UPDATE tb_panmaebid
    SET pbid_courier = pcourier, pbid_trackingnum = ptrackingnum
    WHERE pbid_id = ppbid_id;
END;
-- Procedure UPD_SHIPPING��(��) �����ϵǾ����ϴ�.
EXEC upd_shipping(8, '��ü���ù�', '516873151354');

EXEC bpan_app('shiueo@naver.com', '�߼ۿ�û');

-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid
WHERE pbid_id = 8;
DELETE FROM tb_bpanitem
WHERE bpi_id = 4;
COMMIT;


3. ��û ���
CREATE OR REPLACE PROCEDURE del_bpan 
(
    pbpi_id   tb_bpanitem.bpi_id%type  -- ���� ��ǰ �ڵ�
)
IS
    vpbid_id  tb_panmaebid.pbid_id%type;
BEGIN
    SELECT a.pbid_id INTO vpbid_id
    FROM tb_bpanitem a JOIN tb_panmaebid b ON a.pbid_id = b.pbid_id
    WHERE bpi_id = pbpi_id;
    
    -- ���� �Ǹ� ��ǰ ���̺��� ����
    DELETE FROM tb_bpanitem
    WHERE bpi_id = pbpi_id;
    
    -- �Ǹ� ���� ���̺��� ����
    DELETE FROM tb_panmaebid
    WHERE pbid_id = vpbid_id;
    
    DBMS_OUTPUT.PUT_LINE('���� �Ǹ� ��û�� ��ҵǾ����ϴ�.');
END;
--Procedure DEL_BPAN��(��) �����ϵǾ����ϴ�.
EXEC del_bpan(4);
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '����8', 0, '�߼ۿ�û', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

SELECT * FROM tb_bpanitem;
SELECT * FROM tb_panmaebid;



< ������ >
-- �����Ǹ� ���� 1, �Ǹſ��� 1
1. ���º� ��ȸ (default�� �ǸŴ��)
CREATE OR REPLACE PROCEDURE bpan_ing
(
    pemail      tb_member.m_email%type
    , pstate    tb_panmaebid.pbid_itemstate%type
)
IS
    vimage       tb_item.i_image%type;
    vmodel       tb_item.i_model%type;
    vname        tb_item.i_name_eng%type;
    vsize        tb_gumaebid.gbid_size%type;
    vbpi_id      tb_bpanitem.bpi_id%type;
    vdeposit     tb_bpanitem.bpi_deposit%type;
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
    CURSOR c_bpan IS
                SELECT i_image, i_model, i_name_eng, pbid_size, bpi_id
                        , bpi_deposit, pbid_courier, pbid_trackingnum
                FROM tb_panmaebid p LEFT JOIN tb_item i ON p.i_id = i.i_id
                                    LEFT JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id
                WHERE pbid_keepcheck = 1 and pbid_complete = 1 and m_email = pemail;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� �Ǹ� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� �� ]');
    DBMS_OUTPUT.PUT_LINE('[ ���º� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('������ ����: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('������: ' || vsize || ', ������: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('�ù��: ' || vcourier || ', ����� ��ȣ: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('������ �����ϴ�.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_ING��(��) �����ϵǾ����ϴ�.
EXEC bpan_ing('hyungjs1234@naver.com', '�Ǹ���');


2. �հ�/95�� �հݺ� ��ȸ
CREATE OR REPLACE PROCEDURE bpan_ing_pass
(
    pemail  tb_member.m_email%type
    , pis95 number  -- 0�̸� �հ� ��ǰ, 1�̸� 95�� ��ǰ
)
IS
    vsql         varchar2(1000);
    vimage       tb_item.i_image%type;
    vmodel       tb_item.i_model%type;
    vname        tb_item.i_name_eng%type;
    vsize        tb_gumaebid.gbid_size%type;
    vbpi_id      tb_bpanitem.bpi_id%type;
    vdeposit     tb_bpanitem.bpi_deposit%type;
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
    vcur         SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_model, i_name_eng, pbid_size, bpi_id
                        , bpi_deposit, pbid_courier, pbid_trackingnum ';
    vsql := vsql || ' FROM tb_panmaebid p LEFT JOIN tb_item i ON p.i_id = i.i_id
                                          LEFT JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 1 and pbid_complete = 1 
                            and bpi_inspect = 1 and m_email = :pemail ';
    
    IF pis95 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ �հ� ]');
        vsql := vsql || ' and pbid_95check = 0 ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 95�� �հ� ]');
        vsql := vsql || ' and pbid_95check = 1 ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('������: ' || vsize || ', ������: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('�ù��: ' || vcourier || ', ����� ��ȣ: ' || vtrackingnum);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('������ �����ϴ�.');
    END IF;
    CLOSE vcur;
END;
-- Procedure BPAN_ING_PASS��(��) �����ϵǾ����ϴ�.
EXEC bpan_ing_pass('hyungjs1234@naver.com', 0);
EXEC bpan_ing_pass('hyungjs1234@naver.com', 1);


< ���� >
-- �����Ǹ� ���� 1, �Ǹſ��� 2
1. ���º� ��ȸ (default�� ����Ϸ�)
CREATE OR REPLACE PROCEDURE bpan_end
(
    pemail      tb_member.m_email%type
    , pstate    tb_panmaebid.pbid_itemstate%type
)
IS
    vimage       tb_item.i_image%type;
    vmodel       tb_item.i_model%type;
    vname        tb_item.i_name_eng%type;
    vsize        tb_gumaebid.gbid_size%type;
    vbpi_id      tb_bpanitem.bpi_id%type;
    vdeposit     tb_bpanitem.bpi_deposit%type;
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
    CURSOR c_bpan IS
                SELECT i_image, i_model, i_name_eng, pbid_size, bpi_id
                        , bpi_deposit, pbid_courier, pbid_trackingnum
                FROM tb_panmaebid p LEFT JOIN tb_item i ON p.i_id = i.i_id
                                    LEFT JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id
                WHERE pbid_keepcheck = 1 and pbid_complete = 2 and m_email = pemail;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� �Ǹ� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ���� ]');
    DBMS_OUTPUT.PUT_LINE('[ ���º� ��ȸ ]');
    DBMS_OUTPUT.PUT_LINE('������ ����: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('������: ' || vsize || ', ������: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('�ù��: ' || vcourier || ', ����� ��ȣ: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('������ �����ϴ�.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_END��(��) �����ϵǾ����ϴ�.
EXEC bpan_end('jeifh@gmail.com', '����Ϸ�');



< �˻� >
-- ��û: pbid_keepcheck = 1 and pbid_complete = 0
-- ���� ��: pbid_keepcheck = 1 and pbid_complete = 1
-- ����: pbid_keepcheck = 1 and pbid_complete = 2
CREATE OR REPLACE PROCEDURE bpan_search
(   
    pemail      tb_member.m_email%type
    , pnum      number   -- 1�̸� �귣���, 2�� ��ǰ��(����), 3�̸� �𵨸����� �˻�
    , pkeyword  varchar2
)
IS
    vsql         varchar2(1000);
    vimage       tb_item.i_image%type;
    vmodel       tb_item.i_model%type;
    vname        tb_item.i_name_eng%type;
    vsize        tb_gumaebid.gbid_size%type;
    vbpi_id      tb_bpanitem.bpi_id%type;
    vdeposit     tb_bpanitem.bpi_deposit%type;
    vcourier     tb_panmaebid.pbid_courier%type;
    vtrackingnum tb_panmaebid.pbid_trackingnum%type;
    CURSOR c_bpan IS
                    SELECT i_image, i_model, i_name_eng, pbid_size, bpi_id
                            , bpi_deposit, pbid_courier, pbid_trackingnum 
                    FROM tb_panmaebid p JOIN tb_item i ON p.i_id = i.i_id
                                        JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id 
                    WHERE pbid_keepcheck = 1 and pbid_complete = 1 and m_email = pemail 
                        and ( (pnum = 1 and i_brand LIKE '%' || pkeyword || '%')
                        or (pnum = 2 and i_name_eng LIKE '%' || pkeyword || '%')
                        or (pnum = 3 and i_model LIKE '%' || pkeyword || '%') );
BEGIN
    DBMS_OUTPUT.PUT_LINE('[ ���� �Ǹ� �˻� ]');
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('������: ' || vsize || ', ������: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('�ù��: ' || vcourier || ', ����� ��ȣ: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('������ �����ϴ�.');
    END IF;
    CLOSE c_bpan;     
END;   
-- Procedure BPAN_SEARCH��(��) �����ϵǾ����ϴ�.
-- �ùٸ� ��)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'NIK');  -- NIKE
EXEC bpan_search('hyungjs1234@naver.com', 2, 'Air Force');  -- Nike Air Force 1 '07 Low White
EXEC bpan_search('hyungjs1234@naver.com', 3, 'CW2288');  -- 315122-111/CW2288-111
-- �߸��� ��)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'Air Force');  -- ������ �����ϴ�.
EXEC bpan_search('hyungjs1234@naver.com', 2, 'CW2288');  -- ������ �����ϴ�.



---------------------------------------------------------------------------
[ ���� ��ǰ ]
< ���� ��ǰ ��� >
-- ������ ��� O, ������� ���� ��� X
1. ���
CREATE OR REPLACE PROCEDURE interest
(
    pemail  tb_member.m_email%type
)
IS
    vi_id       tb_item.i_id%type;
    vi_image    tb_item.i_image%type;
    vi_brand    tb_item.i_brand%type;
    vi_name     tb_item.i_name_eng%type;
    vis_gprice  tb_itemsize.is_gprice%type;
    vb_id       tb_branditem.b_id%type;
    vb_image    tb_branditem.b_image%type;
    vb_brand    tb_branditem.b_brand%type;
    vb_name     tb_branditem.b_name_eng%type;
    vb_price    tb_branditem.b_price%type;
    vinter_size tb_interest.inter_size%type;
    -- ��ǰ Ŀ��
    CURSOR c_interest IS
                        SELECT i_id, i_image, i_brand, i_name_eng, is_gprice
                                , b_id, b_image, b_brand, b_name_eng, b_price
                                , inter_size
                        FROM (
                            SELECT inter_id, a.i_id, i_image, i_brand, i_name_eng
                                    , a.b_id, b_image, b_brand, b_name_eng, b_price, a.inter_size
                            FROM tb_interest a LEFT JOIN tb_item b ON a.i_id = b.i_id
                                               LEFT JOIN tb_branditem c ON a.b_id = c.b_id
                            WHERE a.m_email = pemail
                        )t1 JOIN (
                            SELECT s_size, is_gprice
                            FROM tb_size a LEFT JOIN tb_itemsize b ON a.s_id = b.s_id
                        )t2 ON t1.inter_size = t2.s_size
                        ORDER BY inter_id DESC;  -- �ֱٵ�ϼ� ����
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ���� ��ǰ ������ ---');
    OPEN c_interest;
    LOOP
        FETCH c_interest INTO vi_id, vi_image, vi_brand, vi_name, vis_gprice
                                , vb_id, vb_image, vb_brand, vb_name, vb_price, vinter_size;
        EXIT WHEN c_interest%NOTFOUND;
        IF vb_id IS NULL THEN -- �Ϲ� ��ǰ ���
            IF vis_gprice IS NULL THEN  -- ��ñ��Ű� ���� ���
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name 
                                    || ', ' || vinter_size || ', -');
            ELSE
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name 
                                    || ', ' || vinter_size || ', ' || vis_gprice);
            END IF;
            
        ELSE  -- �귣�� ��ǰ ���
            DBMS_OUTPUT.PUT_LINE(vb_image || ', ' || vb_brand || '(�귣�� ���), ' 
                                || vb_name || ', ' || vinter_size || ', ' || vb_price);
        END IF;
    END LOOP;
    IF c_interest%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�߰��Ͻ� ���� ��ǰ�� �����ϴ�.');
    END IF;
    CLOSE c_interest;
END;
-- Procedure INTEREST��(��) �����ϵǾ����ϴ�.
EXEC interest('shiueo@naver.com');


2. ���� ��ǰ ����
CREATE OR REPLACE PROCEDURE del_inter 
(
    pinter_id   tb_interest.inter_id%type  -- ���ɻ�ǰ �ڵ�
)
IS
BEGIN
    DELETE FROM tb_interest
    WHERE inter_id = pinter_id;
    DBMS_OUTPUT.PUT_LINE('���� ��ǰ�� �����Ǿ����ϴ�.');
END;
-- Procedure DEL_INTER��(��) �����ϵǾ����ϴ�.
EXEC del_inter(11);

SELECT * FROM tb_interest;
ROLLBACK;


----------------------------------------------------------------------
[ ���������� ]
< ȭ�� ��� >
-- ȸ�� ���� (�̸���)
EXEC member_info('hyungjs1234@naver.com');

-- ���� �Ǹ� �ŷ� ���� ���� (�̸���)
EXEC member_bp('hyungjs1234@naver.com');

-- ���� �ŷ� ���� ���� (�̸���)
EXEC member_gu('hyungjs1234@naver.com');

-- �Ǹ� �ŷ� ���� ���� (�̸���)
EXEC member_pan('hyungjs1234@naver.com');

-- ���� ��ǰ ��� (�̸���)
EXEC member_inter('shiueo@naver.com');


< ���� �Ϸ�(�ŷ� ����) �� �ŷ� ���� ���� ���� >
1) �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES(4, 'shiueo@naver.com', 1, 250, 260000
            , TO_DATE('22/09/21', 'YY/MM/DD'), 30, 0, '�������', '����', 0, 1, '�����', 7800, 5000);

2) ���ν��� ����
-- ���� �Ϸ�(�Ǹ����� �ڵ�, ������ �Ǹ� ��ǰ ����, �������� �ڵ�, ������ ���� ��ǰ ����)
EXEC end_deal(2, '����Ϸ�', 4, '��ۿϷ�');

-- �Ǹ� ���� ���� ����(�Ǹ����� �ڵ�)
EXEC upd_amount_pan(2);

-- ���� ���� ���� ����(�������� �ڵ�)  
EXEC upd_amount_gu(4);

3) Ȯ��
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_amount;
ROLLBACK;

4) �׽�Ʈ ������ �ѹ�
DELETE FROM tb_gumaebid WHERE gbid_id = 4;
UPDATE tb_panmaebid
SET pbid_itemstate = '�Ǹ���', pbid_complete = 1
WHERE pbid_id = 2;
COMMIT;


---------------------------------------------------------------------------
[ ���� ���� ������ ]
1. ���� ����  -- ���ſ��� 0
< ��ȸ >
-- ��ü ��ȸ(�̸���)
EXEC gbid_default('shiueo@naver.com');

-- �Ⱓ�� ��ȸ(�̸���, ������, ������)
EXEC gbid_date('shiueo@naver.com', '2022-05-23', '2022-06-28');
EXEC gbid_date('shiueo@naver.com', '2022-08-23', '2022-10-28');


< ���� >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 0, '������', 4950, 3000);

-- ����������� ����(�̸���, ���Ĺ��)
-- 0�̸� ��������, 1�̸� ��������(���� ���� ����)
EXEC gbid_price_order('shiueo@naver.com', 0);
EXEC gbid_price_order('shiueo@naver.com', 1);

-- �����ϼ� ����(�̸���, ���Ĺ��)
EXEC gbid_exdate_order('shiueo@naver.com', 0);
EXEC gbid_exdate_order('shiueo@naver.com', 1);

-- �׽�Ʈ ������ ����
DELETE FROM tb_gumaebid WHERE gbid_id = 4;


< ������ ��ǰ ������ ��� >
-- ��ǰ����(�̸���, �������� �ڵ�)
EXEC gbid_info1('shiueo@naver.com', 2);

-- ���� ���� ����(�̸���, �������� �ڵ�)
EXEC gbid_info2('shiueo@naver.com', 2);

-- ��� �ּ� �� ���� ����(�̸���)
EXEC gbid_info3('shiueo@naver.com');


< ���� ���� ���� >
-- ���� ���� ����(�������� �ڵ�) 
EXEC del_gbid(3);

-- Ȯ�� �� �ѹ�
ROLLBACK;
SELECT * FROM tb_gumaebid;


2. ������  -- ���ſ��� 1
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�԰���', 4950, 3000);
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 190000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '��� ��', 5700, 3000);


< ��ȸ >
-- ���º� ��ȸ(�̸���, ��ǰ ����)
EXEC ging_state('shiueo@naver.com', '�԰���');


< ���� >
-- ���¼� ����(�̸���, ���Ĺ��)
EXEC ging_state_order('shiueo@naver.com', 0);
EXEC ging_state_order('shiueo@naver.com', 1);

-- �׽�Ʈ ������ ����
DELETE FROM tb_gumaebid WHERE gbid_id IN (4, 5);


< ������ ��ǰ ������ >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�԰���', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'hyungjs1234@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�԰���', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�߼ۿ�û', 1600, '��ü���ù�', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'hyungjs1234@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 1, '�����', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

-- Ȯ�� �� �ѹ�
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;
ROLLBACK;
  
-- ��ǰ ����(�̸���, �ֹ���ȣ)
EXEC ging_info1('hyungjs1234@naver.com', 2);

-- ���� ����(�̸���, �ֹ���ȣ)
EXEC ging_info2('hyungjs1234@naver.com', 2);


3. ����  -- ���ſ��� 2
< ���� >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

-- �����ϼ�(�ŷ��ϼ�) ����(�̸���, ���Ĺ��)
EXEC gend_matdate_order('shiueo@naver.com', 0);
EXEC gend_matdate_order('shiueo@naver.com', 1);

-- �ѹ�
ROLLBACK;


< ���� ��ǰ ������ >
-- ������ ��ǰ �������� ����


---------------------------------------------------------------------------
[ �Ǹ� ���� ]
1. �Ǹ� ����  -- �����Ǹ� ���� 0, �Ǹſ��� 0
< ��ȸ >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'lklk9803@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 0, '������', 1550, null, null);
          
SELECT * FROM tb_panmaebid;

-- ��ü ��ȸ(�̸���)
EXEC pbid_default('lklk9803@gmail.com');

-- �Ⱓ�� ��ȸ(�̸���, ������, ������)
EXEC pbid_date('lklk9803@gmail.com', '2022-05-23', '2022-06-28');
EXEC pbid_date('lklk9803@gmail.com', '2022-08-23', '2022-10-28');


< ����>
-- �Ǹ�������� ����(�̸���, ���Ĺ��)
EXEC pbid_price_order('lklk9803@gmail.com', 0);
EXEC pbid_price_order('lklk9803@gmail.com', 1);

-- �����ϼ� ����(�̸���, ���Ĺ��)
EXEC pbid_exdate_order('lklk9803@gmail.com', 0);
EXEC pbid_exdate_order('lklk9803@gmail.com', 1);

-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid WHERE pbid_id = 6;


< ������ ��ǰ ������ >
-- ��ǰ ����, ���� ������ ���� ������ ����
-- ���Ƽ ���� ������ ���� ������ ī�� ������ ����
-- �ݼ� �ּҴ� ���� ������ ��� �ּҿ� ����

-- �Ǹ� ���� ����(�̸���)
EXEC pbid_account('lklk9803@gmail.com');


2. ������  -- �����Ǹ� ���� 0, �Ǹſ��� 1
< ��ȸ >
-- ���º� ��ȸ(�̸���, ��ǰ ����)
EXEC ping_state('sdjsd@naver.com', '�߼ۿ�û');


< ���� >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'sdjsd@naver.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 1, '�԰�Ϸ�', 1550, null, null);

-- ���¼� ����(�̸���, ���Ĺ��)
EXEC ping_state_order('sdjsd@naver.com', 0);
EXEC ping_state_order('sdjsd@naver.com', 1);

-- �ѹ�
ROLLBACK;


< ������ ��ǰ ������ >
-- �߼� ���� �̿ܿ� ��� ���� ����

-- �߼� ���� ���(�̸���, �Ǹ����� �ڵ�)
EXEC ping_shipping('hyungjs1234@naver.com', 2);

-- �߼� ���� ����(�Ǹ����� �ڵ�, �ù��, ������ȣ)
EXEC upd_shipping(2, '��ü���ù�', '736132678451');

-- Ȯ�� �� �ѹ�
SELECT * FROM tb_panmaebid;
ROLLBACK;


3. ����  -- �����Ǹ� ���� 0, �Ǹſ��� 2
< ���� >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1550, '�����ù�', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '����6', 2, '����Ϸ�', 1600, '��ü���ù�', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '�Ϲݹ��', '����', 0, 2, '��ۿϷ�', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

-- �����ϼ� ����(�̸���, ���Ĺ��)
EXEC pend_caldate_order('jeifh@gmail.com', 0);
EXEC pend_caldate_order('jeifh@gmail.com', 1);


< ���� ��ǰ ������ >
-- ������ �̿ܿ� ��� ���� ����

-- ������ ���(�ֹ���ȣ)
EXEC pend_caldate(2);

-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid WHERE pbid_id >= 6;
DELETE FROM tb_gumaebid WHERE gbid_id >= 4;
DELETE FROM tb_matching WHERE mat_id >= 2;


---------------------------------------------------------------------------
[ ���� �Ǹ� ]
-- ��ü ��ȸ �Ұ�. ���º��θ� ��ȸ ����.
< ���� ��ǰ ���� >
EXEC bpan_itemlist;

1. ��û  -- �����Ǹ� ���� 1, �Ǹſ��� 0
< ��ȸ >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '����8', 0, '�߼ۿ�û', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

-- ���º� ��ȸ(�̸���, ��ǰ ����)
EXEC bpan_app('shiueo@naver.com', '�߼ۿ�û');


< �߼� ���� �Է� >
-- �߼� ���� �Է�(�Ǹ������ڵ�, �ù��, ������ȣ)
EXEC upd_shipping(8, '��ü���ù�', '516873151354');

-- �׽�Ʈ ������ ����
DELETE FROM tb_panmaebid
WHERE pbid_id = 8;
DELETE FROM tb_bpanitem
WHERE bpi_id = 4;
COMMIT;


< ��û ��� >
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '����8', 0, '�߼ۿ�û', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

-- ��û ���(���� ��ǰ �ڵ�)
EXEC del_bpan(4);

-- Ȯ��
SELECT * FROM tb_bpanitem;
SELECT * FROM tb_panmaebid;


2. ������  -- �����Ǹ� ���� 1, �Ǹſ��� 1
< ��ȸ >
-- ���º� ��ȸ(�̸���, ��ǰ ����)
EXEC bpan_ing('hyungjs1234@naver.com', '�Ǹ���');

-- �հ�/95�� �հݺ� ��ȸ(�̸���, 95���հݿ���)
-- 0�̸� �հ� ��ǰ, 1�̸� 95�� �հ� ��ǰ
EXEC bpan_ing_pass('hyungjs1234@naver.com', 0);
EXEC bpan_ing_pass('hyungjs1234@naver.com', 1);


3. ����  -- �����Ǹ� ���� 1, �Ǹſ��� 2
< ��ȸ >
-- ���º� ��ȸ(�̸���, ��ǰ ����)
EXEC bpan_end('jeifh@gmail.com', '����Ϸ�');


4. �˻�(�̸���, �˻�����, Ű����)
-- �˻������� 1�̸� �귣���, 2�� ��ǰ��(����), 3�̸� �𵨸����� �˻�
-- �ùٸ� ��)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'NIK');  -- NIKE
EXEC bpan_search('hyungjs1234@naver.com', 2, 'Air Force');  -- Nike Air Force 1 '07 Low White
EXEC bpan_search('hyungjs1234@naver.com', 3, 'CW2288');  -- 315122-111/CW2288-111

-- �߸��� ��)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'Air Force');  -- ������ �����ϴ�.
EXEC bpan_search('hyungjs1234@naver.com', 2, 'CW2288');  -- ������ �����ϴ�.


---------------------------------------------------------------------------
[ ���� ��ǰ ]
< ���� ��ǰ ��� ��� >
-- ���(�̸���)
EXEC interest('shiueo@naver.com');

< ���� ��ǰ ����>
-- ����(���� ��ǰ �ڵ�)
EXEC del_inter(11);

-- Ȯ�� �� �ѹ�
SELECT * FROM tb_interest;
ROLLBACK;

