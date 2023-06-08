--1. 판매자가 회원가입 후 마이페이지 프로필 정보 수정
--      -> 판매입찰 및 주문까지 
--      -> 구매자가 회원가입 후 즉시구매&결제&거래 체결 
--      -> 배송 완료 후 정산(거래 종료) 
--      -> 판매자 판매내역확인, 구매자 구매내역확인

--[판매자 회원가입 후 로그인]
EXEC UP_JOIN('panmaeja@naver.com', '12345678A!', '01012345678', 245 , 'panmaeja', '1911/11/11', '1', '0', SYSDATE); 
commit;
SELECT * FROM tb_member;
INSERT INTO tb_amount VALUES('panmaeja@naver.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

EXEC UP_LOGIN('panmaeja@naver.com', '12345678A!');


--[ 홈 화면 출력 ]
exec up_home;
exec up_home2;
exec up_home3;
exec up_home4;
exec up_home5;

--[ 마이페이지 ]
EXEC 주소추가('panmaeja@naver.com', 'panmaeja', '01012345678', 33, '집주소', '집상세주소', 1);
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_delivery;
COMMIT;

EXEC 카드추가('panmaeja@naver.com', 1234432112344321, '26/07/01', '11/11/11', 1234, '국민', 1);
SELECT * FROM TB_CARD;
COMMIT;

EXEC 판매정산계좌등록('panmaeja@naver.com', '우리은행', 87659155784321, 'panmaeja');
SELECT * FROM tb_account;

EXEC 현금영수증등록('panmaeja@naver.com', '미신청');
EXEC 현금영수증('panmaeja@naver.com', '개인소득공제(휴대폰)', '01012345678' );
SELECT * FROM tb_receipt;


--[ SHOP 페이지 출력 ]
--  SHOP 페이지 카테고리 목록 출력
EXEC up_shop_maincategory;

--  선택에 따른 SHOP상품 목록 출력(배송 종류, 카테고리)
--  전체 상품 ( 너무 많아서 OVERFLOW )
EXEC up_shop_list;

--[ 빠른배송/일반배송 상품 상세정보 ]
--  i_id로 제일 처음 화면 출력(시세는 12개월, 체결거래)
EXEC UP_ITEM_INFO(1);

EXEC 판매하기('Nike Air Force 1 ''07 Low White');
EXEC 판매입찰하기('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '250', 105000, 30);
commit;
SELECT * from tb_panmaebid;

--임의 DLM문
UPDATE TB_PANMAEBID SET PBID_ADRS = '집앞6' WHERE M_EMAIL = 'panmaeja@naver.com';
COMMIT;
--진영님 파일이랑 성현님 파일 현금영수증 프로시저 명이 겹침 수정해야함
EXEC 주문정산('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '250', 158000, 30);

--[구매자 회원가입]
EXEC UP_JOIN('gumaeja@naver.com', '12345678A!', '01012345678', 270 , 'gumaeja', '1922/12/12', '1', '0', SYSDATE); 
commit;
SELECT * FROM tb_member;
INSERT INTO tb_amount VALUES('gumaeja@naver.com', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

EXEC UP_LOGIN('gumaeja@naver.com', '12345678A!');

--[ 마이페이지 ]
EXEC 주소추가('gumaeja@naver.com', 'gumaeja', '01098765432', 43, '집주소2', '집상세주소2', 1);
SELECT * FROM tb_delivery;
COMMIT;

EXEC 카드추가('gumaeja@naver.com', 7890098778900987, '25/05/01', '12/12/12', 4321, '신한', 1);
SELECT * FROM TB_CARD;
COMMIT;

EXEC 판매정산계좌등록('gumaeja@naver.com', '신한은행', 77659155784321, 'gumaeja');
SELECT * FROM tb_account;

EXEC 현금영수증등록('gumaeja@naver.com', '미신청');
EXEC 현금영수증('gumaeja@naver.com', '개인소득공제(휴대폰)', '01098765432' );
SELECT * FROM tb_receipt;

--[구매하기 페이지]
EXEC 빠른일반배송구매하기('Nike Air Force 1 ''07 Low White');

--[구매자가 즉시구매]
EXEC 즉시구매하기('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '250', '일반배송', 0);
SELECT * FROM TB_ITEMSIZE;
SELECT * FROM TB_MATCHING;

--[ 배송 완료 ]
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_GUMAEBID;
EXEC complete_cal(17, '정산완료', 20, '배송완료');

--[ 판매, 구매 내역 확인]
EXEC upd_amount_pan(17);  -- 판매 내역 수량 변경
EXEC upd_amount_gu(20); -- 구매 내역 수량 변경
SELECT * FROM tb_amount;

--2. 구매자가 구매입찰 후 결제 
--    -> 판매자가 즉시판매&거래 체결 
--    -> 배송 완료 후 정산 
--    -> 판매자 판매내역 확인, 구매자가 구매내역 확인

--[구매자 구매입찰하기]
EXEC 구매입찰하기('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '260', '일반배송', 0, 150000, 30);
EXEC 구매입찰하기('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '235', '일반배송', 0, 160000, 60);
EXEC 구매입찰하기('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '245', '일반배송', 0, 165000, 30);
EXEC 구매입찰하기('Nike Air Force 1 ''07 Low White', 'gumaeja@naver.com', '265', '일반배송', 0, 140000, 60);

select * from tb_gumaebid;

--[판매하기 페이지]
EXEC 판매하기('Nike Air Force 1 ''07 Low White');

--[판매자가 즉시판매]
EXEC 바로판매하기('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '260');
EXEC 바로판매하기('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '245');
EXEC 바로판매하기('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '265');
SELECT * FROM TB_ITEMSIZE;
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_MATCHING;

--[정산]
SELECT * FROM TB_PANMAEBID;
SELECT * FROM TB_GUMAEBID;
EXEC complete_cal(18, '정산완료', 21, '배송완료');

--[ 판매, 구매 내역 확인]
EXEC upd_amount_pan(18);  -- 판매 내역 수량 변경
EXEC upd_amount_gu(21); -- 구매 내역 수량 변경
SELECT * FROM tb_amount;

--3. 판매자가 보관 판매 신청 -> 보관 판매 내역 확인
--[보관판매 신청]
EXEC 보관신청('Nike Air Force 1 ''07 Low White');

--[보관판매 결제]
EXEC 보관판매결제('Nike Air Force 1 ''07 Low White', 'panmaeja@naver.com', '240', 1);
select * from tb_panmaebid;

--[보관 판매 내역 확인]
SELECT * FROM TB_PANMAEBID;
EXEC upd_amount_pan(20);  -- 판매 내역 수량 변경
SELECT * FROM tb_amount;

--4. 구매자가 관심상품 등록 -> 관심상품 확인
EXEC up_item_interest_print(1); -- i_id가 1인 상품의 유효 사이즈 출력
EXEC up_item_interest('gumaeja@naver.com', 1, '&put_size'); -- 사이즈를 선택하여 i_id가 1인 상품을 관심 목록에 추가
SELECT * FROM tb_interest; -- 추가되었는지 확인
-- 마이페이지 - 관심상품
EXEC interest('gumaeja@naver.com');

EXEC up_bitem_interest_print(1); -- b_id가 1인 상품의 유효 사이즈 출력
EXEC up_bitem_interest('gumaeja@naver.com', 1, '&put_size'); -- 사이즈를 선택하여 b_id가 1인 상품을 관심 목록에 추가
SELECT * FROM tb_interest; -- 추가되었는지 확인
-- 마이페이지 - 관심상품
EXEC interest('gumaeja@naver.com');
Commit;

--5. 마이페이지 쇼핑정보
--[구매 내역 입찰중]
EXEC gbid_default('gumaeja@naver.com');
    -- 기간별 조회(이메일, 시작일, 종료일)
    EXEC gbid_date('gumaeja@naver.com', '2022-05-23', '2022-06-28');
    EXEC gbid_date('gumaeja@naver.com', '2022-08-23', '2022-10-28');

    -- 구매희망가순 정렬(이메일, 정렬방식)
    -- 0이면 오름차순, 1이면 내림차순(이하 전부 동일)
    EXEC gbid_price_order('gumaeja@naver.com', 0);
    EXEC gbid_price_order('gumaeja@naver.com', 1);
    
    -- 만료일순 정렬(이메일, 정렬방식)
    EXEC gbid_exdate_order('gumaeja@naver.com', 0);
    EXEC gbid_exdate_order('gumaeja@naver.com', 1);

--[구매 내역 진행중]
    -- 상태순 정렬(이메일, 정렬방식)
    EXEC ging_state_order('gumaeja@naver.com', 0);
    EXEC ging_state_order('gumaeja@naver.com', 1);
    
--[구매 내역 종료]
EXEC gend_matdate_order('gumaeja@naver.com', 0);

--6. 관리자가 공지사항, 자주 묻는 질문 작성
SELECT * FROM TB_ADMIN;
SELECT * FROM TB_NOTICE;
-- 시퀀스 새로 생성하면 번호 미뤄야함
SELECT seq_notice.NEXTVAL FROM DUAL;
SELECT seq_faq.NEXTVAL FROM DUAL;
SELECT seq_notice.NEXTVAL FROM DUAL;
seq_faq
--[공지사항 작성]
exec up_insnotice ('ADMIN01', sysdate, '공지', '[공지]오예1', '냠냠1');
COMMIT;
select * from tb_notice;

--[자주 묻는 질문 작성]
exec up_insfaq('ADMIN01', sysdate, '구매', '자주자주자주', '묻는질문묻는질문'); 
commit;
select * from tb_faq;