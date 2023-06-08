[ �������/�Ϲݹ�� �����ϱ� ]

CREATE OR REPLACE PROCEDURE �����Ϲݹ�۱����ϱ�
(
    p_i_name_eng IN tb_item.i_name_eng%TYPE
)
IS
    v_s_size    tb_size.s_size%TYPE;
    v_is_gprice varchar2(100);
    v_quick     varchar2(100);
    v_normal    varchar2(100);
    v_95quick   varchar2(100);
    vcursor     SYS_REFCURSOR;
BEGIN
    --��ǰ�������
    DBMS_OUTPUT.PUT_LINE('---��ǰ����---');
    ��ǰ����(p_i_name_eng);

    DBMS_OUTPUT.PUT_LINE('---������ ����---');
    OPEN vcursor FOR SELECT s_size , NVL(TO_CHAR(is_gprice,'9,999,999,999'),'��������')
                            FROM tb_item i JOIN tb_itemsize it ON i.i_id = it.i_id
                                            JOIN tb_size s ON it.s_id = s.s_id
                            WHERE i_name_eng = p_i_name_eng
                            ORDER BY s_size;
    LOOP
        FETCH vcursor INTO v_s_size, v_is_gprice;
        EXIT WHEN vcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_s_size  || '   ' ||  v_is_gprice);
    END LOOP;
    CLOSE vcursor;
    
    --�ϴ�(�������, �Ϲݹ��, 95����ǰ ���� ���)
    -- ������� ������
    SELECT TO_CHAR(MIN(pbid_price), '9,999,999,999') INTO v_quick
    FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id 
                   JOIN tb_bpanitem b ON p.pbid_id = b.pbid_id
    WHERE i_name_eng = p_i_name_eng 
        and pbid_keepcheck = 1 and pbid_95check = 0 and bpi_inspect = 1;
    
    -- �Ϲݹ�� ������
    SELECT NVL(TO_CHAR(MIN(pbid_price), '9,999,999,999'), '��������') INTO v_normal
    FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id 
    WHERE i_name_eng = p_i_name_eng and pbid_keepcheck = 0;
    
    -- 95�� ��ǰ ������
    SELECT TO_CHAR(MIN(pbid_price), '9,999,999,999') INTO v_95quick
    FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id 
                   JOIN tb_95item g ON p.pbid_id = g.pbid_id
    WHERE i_name_eng = p_i_name_eng and pbid_95check = 1 and i95_soldout = 0;

    -- �������/95�� ����� ��ñ��Ű��� null�̸� ���X, �Ϲݹ���� '��������' ���
    IF v_quick IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('������� : ' || v_quick);
    END IF;
    DBMS_OUTPUT.PUT_LINE('�Ϲݹ�� : ' || v_normal);
    IF v_95quick IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('95�� ������� : ' || v_95quick);
    END IF;
END;
-- Procedure �����Ϲݹ�۱����ϱ���(��) �����ϵǾ����ϴ�.
EXEC �����Ϲݹ�۱����ϱ�('Nike Air Force 1 ''07 Low White');


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

    DBMS_OUTPUT.PUT_LINE(v_i_image || chr(10) || 
     v_i_model || chr(10) || v_i_name_eng || chr(10) || 
     v_i_name_kor || chr(10) || v_fast_delivery);
END;


------------------------------------------------------------------------
[ 95�� ��ǰ ���� ]
CREATE OR REPLACE PROCEDURE select_95
(
    p_i_name_eng    IN tb_item.i_name_eng%TYPE
    , p_size        varchar2
    , p_ex_soldout  number  -- �ǸſϷ� ��ǰ ���� ���� (0�̸� ����, 1�̸� ����)
)
IS
    v_image     tb_item.i_image%TYPE;
    v_price     varchar2(100);
    v_soldout   nvarchar2(10);
    CURSOR c_95 IS
                SELECT i_image, TO_CHAR(i95_price, 'FM999,999,999,999') || '��'
                        , DECODE(i95_soldout, 0, '�Ǹ���', 1, '�ǸſϷ�')
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                               JOIN tb_95item g ON p.pbid_id = g.pbid_id
                WHERE pbid_95check = 1 and i_name_eng = p_i_name_eng
                    and pbid_size = p_size;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 95�� ��ǰ ���� ������ ---');
    DBMS_OUTPUT.PUT_LINE('[ ��ǰ���� ]');
    ��ǰ����(p_i_name_eng);
    DBMS_OUTPUT.PUT_LINE(p_size);
    
    DBMS_OUTPUT.PUT_LINE('[ 95�� ��ǰ ���� ]');
    OPEN c_95;
    LOOP
        FETCH c_95 INTO v_image, v_price, v_soldout;
        EXIT WHEN c_95%NOTFOUND;
        IF p_ex_soldout = 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_image || chr(10) || p_i_name_eng || chr(10) || '�������'
                                || chr(10) || '95�� ���Ű�: ' || v_price || chr(10) || v_soldout);
        ELSE  -- �ǸſϷ� ����
            IF v_soldout = '�Ǹ���' THEN
                DBMS_OUTPUT.PUT_LINE('[ �ǸſϷ� ���� ]');
                DBMS_OUTPUT.PUT_LINE(v_image || chr(10) || p_i_name_eng || chr(10) || '�������'
                                || chr(10) || '95�� ���Ű�: ' || v_price || chr(10) || v_soldout);
            END IF;
        END IF;
    END LOOP;
    CLOSE c_95;
END;
-- Procedure SELECT_95��(��) �����ϵǾ����ϴ�.
EXEC select_95('Nike Air Force 1 ''07 Low White', 250, 0);
EXEC select_95('Nike Air Force 1 ''07 Low White', 250, 1);

-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'shiueo@naver.com', 1, null, 250, 220000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, 1, '����6', 2, '�ǸſϷ�', 2200, '�����ù�', '31456797645');
INSERT INTO tb_95item VALUES (2, 6, 1, 220000, 1, 'https://kream-phinf.pstatic.net/MjAyMjA5MjZfMTIz/M��8930a7e544bc42a1b97e2f615ba4ae28.jpeg?type=l_webp'
            , '����-�ݰ�(���� �ڱ� ��) ��12mm', TO_DATE('2022/10/07', 'YYYY/MM/DD'));

-- �׽�Ʈ ������ ����
DELETE FROM tb_95item
WHERE i95_id = 2;
DELETE FROM tb_panmaebid
WHERE pbid_id = 6;

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_95item;


--------------------------------------------------------------------------
[ �������/�Ϲݹ�� �����ϱ� ]
-- �������/�Ϲݹ�� �����ϱ�(��ǰ��(����))
EXEC �����Ϲݹ�۱����ϱ�('Nike Air Force 1 ''07 Low White');


------------------------------------------------------------------------
[ 95�� ��ǰ ���� ]
-- �׽�Ʈ ������ �߰�
INSERT INTO tb_panmaebid VALUES (6, 'shiueo@naver.com', 1, null, 250, 220000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, 1, '����6', 2, '�ǸſϷ�', 2200, '�����ù�', '31456797645');
INSERT INTO tb_95item VALUES (2, 6, 1, 220000, 1, 'https://kream-phinf.pstatic.net/MjAyMjA5MjZfMTIz/M��8930a7e544bc42a1b97e2f615ba4ae28.jpeg?type=l_webp'
            , '����-�ݰ�(���� �ڱ� ��) ��12mm', TO_DATE('2022/10/07', 'YYYY/MM/DD'));

-- ��ǰ ��� ���(��ǰ��(����), ������, �ǸſϷ��ǰ ���� ����)
-- 0�̸� �ǸſϷ� ��ǰ ����, 1�̸� ����
EXEC select_95('Nike Air Force 1 ''07 Low White', 250, 0);
EXEC select_95('Nike Air Force 1 ''07 Low White', 250, 1);

-- �׽�Ʈ ������ ����
DELETE FROM tb_95item
WHERE i95_id = 2;
DELETE FROM tb_panmaebid
WHERE pbid_id = 6;

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_95item;

