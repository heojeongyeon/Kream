--1. �Ǹ��ڰ� ȸ������ �� ���������� ������ ���� ����
--      -> �Ǹ����� �� �ֹ����� 
--      -> �����ڰ� ȸ������ �� ��ñ���&����&�ŷ� ü�� 
--      -> ��� �Ϸ� �� ����(�ŷ� ����) 
--      -> �Ǹ��� �Ǹų���Ȯ��, ������ ���ų���Ȯ��

--[�Ǹ��� ȸ������ �� �α���]
EXEC UP_JOIN('panmaeja@naver.com', '12345678A!', '01012345678', 245 , 'panmaeja', '1911/11/11', '1', '0', SYSDATE); 
commit;
SELECT * FROM tb_member;
INSERT INTO tb_amount VALUES('panmaeja@naver.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

EXEC UP_LOGIN('panmaeja@naver.com', '12345678A!');


--[ Ȩ ȭ�� ��� ]
exec up_home;
exec up_home2;
exec up_home3;
exec up_home4;
exec up_home5;

--[ ���������� ]
EXEC �ּ��߰�('panmaeja@naver.com', 'panmaeja', '01012345678', 33, '���ּ�', '�����ּ�', 1);
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_delivery;
COMMIT;

EXEC ī���߰�('panmaeja@naver.com', 1234432112344321, '26/07/01', '11/11/11', 1234, '����', 1);
SELECT * FROM TB_CARD;
COMMIT;

EXEC �Ǹ�������µ��('panmaeja@naver.com', '�츮����', 87659155784321, 'panmaeja');
SELECT * FROM tb_account;

EXEC ���ݿ��������('panmaeja@naver.com', '�̽�û');
EXEC ���ݿ�����('panmaeja@naver.com', '���μҵ����(�޴���)', '01012345678' );
SELECT * FROM tb_receipt;


--[ SHOP ������ ��� ]
--  SHOP ������ ī�װ� ��� ���
EXEC up_shop_maincategory;

--  ���ÿ� ���� SHOP��ǰ ��� ���(��� ����, ī�װ�)
--  ��ü ��ǰ ( �ʹ� ���Ƽ� OVERFLOW )
EXEC up_shop_list;

--[ �������/�Ϲݹ�� ��ǰ ������ ]
--  i_id�� ���� ó�� ȭ�� ���(�ü��� 12����, ü��ŷ�)
EXEC UP_ITEM_INFO(1);

EXEC �Ǹ��ϱ�('Nike Air Force 1 ''07 Low White');
EXEC �Ǹ������ϱ�('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '250', 105000, 30);
commit;
SELECT * from tb_panmaebid;

--���� DLM��
UPDATE TB_PANMAEBID SET PBID_ADRS = '����6' WHERE M_EMAIL = 'panmaeja@naver.com';
COMMIT;
--������ �����̶� ������ ���� ���ݿ����� ���ν��� ���� ��ħ �����ؾ���
EXEC �ֹ�����('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '250', 158000, 30);

--[������ ȸ������]
EXEC UP_JOIN('gumaeja@naver.com', '12345678A!', '01012345678', 270 , 'gumaeja', '1922/12/12', '1', '0', SYSDATE); 
commit;
SELECT * FROM tb_member;
INSERT INTO tb_amount VALUES('gumaeja@naver.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

EXEC UP_LOGIN('gumaeja@naver.com', '12345678A!');

--[ ���������� ]
EXEC �ּ��߰�('gumaeja@naver.com', 'gumaeja', '01098765432', 43, '���ּ�2', '�����ּ�2', 1);
SELECT * FROM tb_delivery;
COMMIT;

EXEC ī���߰�('gumaeja@naver.com', 7890098778900987, '25/05/01', '12/12/12', 4321, '����', 1);
SELECT * FROM TB_CARD;
COMMIT;

EXEC �Ǹ�������µ��('gumaeja@naver.com', '��������', 77659155784321, 'gumaeja');
SELECT * FROM tb_account;

EXEC ���ݿ��������('gumaeja@naver.com', '�̽�û');
EXEC ���ݿ�����('gumaeja@naver.com', '���μҵ����(�޴���)', '01098765432' );
SELECT * FROM tb_receipt;

--[�����ϱ� ������]
EXEC �����Ϲݹ�۱����ϱ�('Nike Air Force 1 ''07 Low White');

--[�����ڰ� ��ñ���]
EXEC ��ñ����ϱ�('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '250', '�Ϲݹ��', 0);
SELECT * FROM TB_ITEMSIZE;
SELECT * FROM TB_MATCHING;

--[ ��� �Ϸ� ]
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_GUMAEBID;
EXEC complete_cal(17, '����Ϸ�', 20, '��ۿϷ�');

--[ �Ǹ�, ���� ���� Ȯ��]
EXEC upd_amount_pan(17);  -- �Ǹ� ���� ���� ����
EXEC upd_amount_gu(20); -- ���� ���� ���� ����
SELECT * FROM tb_amount;

--2. �����ڰ� �������� �� ���� 
--    -> �Ǹ��ڰ� ����Ǹ�&�ŷ� ü�� 
--    -> ��� �Ϸ� �� ���� 
--    -> �Ǹ��� �Ǹų��� Ȯ��, �����ڰ� ���ų��� Ȯ��

--[������ ���������ϱ�]
EXEC ���������ϱ�('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '260', '�Ϲݹ��', 0, 150000, 30);
EXEC ���������ϱ�('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '235', '�Ϲݹ��', 0, 160000, 60);
EXEC ���������ϱ�('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '245', '�Ϲݹ��', 0, 165000, 30);
EXEC ���������ϱ�('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '265', '�Ϲݹ��', 0, 140000, 60);

select * from tb_gumaebid;

--[�Ǹ��ϱ� ������]
EXEC �Ǹ��ϱ�('Nike Air Force 1 ''07 Low White');

--[�Ǹ��ڰ� ����Ǹ�]
EXEC �ٷ��Ǹ��ϱ�('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '260');
EXEC �ٷ��Ǹ��ϱ�('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '245');
EXEC �ٷ��Ǹ��ϱ�('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '265');
SELECT * FROM TB_ITEMSIZE;
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_MATCHING;

--[����]
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_GUMAEBID;
EXEC complete_cal(18, '����Ϸ�', 21, '��ۿϷ�');

--[ �Ǹ�, ���� ���� Ȯ��]
EXEC upd_amount_pan(18);  -- �Ǹ� ���� ���� ����
EXEC upd_amount_gu(21); -- ���� ���� ���� ����
SELECT * FROM tb_amount;

--3. �Ǹ��ڰ� ���� �Ǹ� ��û -> ���� �Ǹ� ���� Ȯ��
--[�����Ǹ� ��û]
EXEC ������û('Nike Air Force 1 ''07 Low White');

--[�����Ǹ� ����]
EXEC �����ǸŰ���('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '240', 1);
select * from tb_panmaebid;

--[���� �Ǹ� ���� Ȯ��]
SELECT * FROM TB_PANMAEBID;
EXEC upd_amount_pan(20);  -- �Ǹ� ���� ���� ����
SELECT * FROM tb_amount;

--4. �����ڰ� ���ɻ�ǰ ��� -> ���ɻ�ǰ Ȯ��
EXEC up_item_interest_print(1); -- i_id�� 1�� ��ǰ�� ��ȿ ������ ���
EXEC up_item_interest('gumaeja@naver.com', 1, '&put_size'); -- ����� �����Ͽ� i_id�� 1�� ��ǰ�� ���� ��Ͽ� �߰�
SELECT * FROM tb_interest; -- �߰��Ǿ����� Ȯ��
-- ���������� - ���ɻ�ǰ
EXEC interest('gumaeja@naver.com');

EXEC up_bitem_interest_print(1); -- b_id�� 1�� ��ǰ�� ��ȿ ������ ���
EXEC up_bitem_interest('gumaeja@naver.com', 1, '&put_size'); -- ����� �����Ͽ� b_id�� 1�� ��ǰ�� ���� ��Ͽ� �߰�
SELECT * FROM tb_interest; -- �߰��Ǿ����� Ȯ��
-- ���������� - ���ɻ�ǰ
EXEC interest('gumaeja@naver.com');
Commit;

--5. ���������� ��������
--[���� ���� ������]
EXEC gbid_default('gumaeja@naver.com');
    -- �Ⱓ�� ��ȸ(�̸���, ������, ������)
    EXEC gbid_date('gumaeja@naver.com', '2022-05-23', '2022-06-28');
    EXEC gbid_date('gumaeja@naver.com', '2022-08-23', '2022-10-28');

    -- ����������� ����(�̸���, ���Ĺ��)
    -- 0�̸� ��������, 1�̸� ��������(���� ���� ����)
    EXEC gbid_price_order('gumaeja@naver.com', 0);
    EXEC gbid_price_order('gumaeja@naver.com', 1);
    
    -- �����ϼ� ����(�̸���, ���Ĺ��)
    EXEC gbid_exdate_order('gumaeja@naver.com', 0);
    EXEC gbid_exdate_order('gumaeja@naver.com', 1);

--[���� ���� ������]
    -- ���¼� ����(�̸���, ���Ĺ��)
    EXEC ging_state_order('gumaeja@naver.com', 0);
    EXEC ging_state_order('gumaeja@naver.com', 1);
    
--[���� ���� ����]
EXEC gend_matdate_order('gumaeja@naver.com', 0);

--6. �����ڰ� ��������, ���� ���� ���� �ۼ�
SELECT * FROM TB_ADMIN;
SELECT * FROM TB_NOTICE;
-- ������ ���� �����ϸ� ��ȣ �̷����
SELECT seq_notice.NEXTVAL FROM DUAL;
SELECT seq_faq.NEXTVAL FROM DUAL;
SELECT seq_notice.NEXTVAL FROM DUAL;
seq_faq
--[�������� �ۼ�]
exec up_insnotice ('ADMIN01', sysdate, '����', '[����]����1', '�ȳ�1');
COMMIT;
select * from tb_notice;

--[���� ���� ���� �ۼ�]
exec up_insfaq('ADMIN01', sysdate, '����', '������������', '����������������'); 
commit;
select * from tb_faq;