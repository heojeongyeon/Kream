---------------------------------------------------------------------------
[ 마이페이지 ]
< 회원 정보 >
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
    
    DBMS_OUTPUT.PUT_LINE('---- 마이 페이지 ---- ');
    DBMS_OUTPUT.PUT_LINE('[ 회원 정보 ]');        
    DBMS_OUTPUT.PUT_LINE(vimage || chr(10) || vname || ', ' || vemail || ', ' || vpoint || 'P');
END;
-- Procedure MEMBER_INFO이(가) 컴파일되었습니다.
EXEC member_info('hyungjs1234@naver.com');


< 보관 판매 내역 >
1. 거래 내역 수량 출력
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

    DBMS_OUTPUT.PUT_LINE('[ 보관 판매 내역 ]');
    DBMS_OUTPUT.PUT_LINE('발송요청 : ' || vbpsendreq);
    DBMS_OUTPUT.PUT_LINE('판매대기 : ' || vbpwait);
    DBMS_OUTPUT.PUT_LINE('판매중 : ' || vbping);
    DBMS_OUTPUT.PUT_LINE('정산완료 : ' || vbpcalcompl);
END;
-- Procedure MEMBER_BP이(가) 컴파일되었습니다.
EXEC member_bp('hyungjs1234@naver.com');


< 구매 내역 >
1. 거래 내역 수량 출력
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
    
    DBMS_OUTPUT.PUT_LINE('[ 구매 내역 ]');
    DBMS_OUTPUT.PUT_LINE('전체 : ' || vgulog);
    DBMS_OUTPUT.PUT_LINE('입찰중 : ' || vgubid);
    DBMS_OUTPUT.PUT_LINE('진행중 : ' || vguing);
    DBMS_OUTPUT.PUT_LINE('종료 : ' || vgucompl);
END;
-- Procedure MEMBER_GU이(가) 컴파일되었습니다.
EXEC member_gu('hyungjs1234@naver.com');


< 판매 내역 >
1. 거래 내역 수량 출력
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
    
    DBMS_OUTPUT.PUT_LINE('[ 판매 내역 ]');
    DBMS_OUTPUT.PUT_LINE('전체 : ' || vpanlog);
    DBMS_OUTPUT.PUT_LINE('입찰중 : ' || vpanbid);
    DBMS_OUTPUT.PUT_LINE('진행중 : ' || vpaning);
    DBMS_OUTPUT.PUT_LINE('종료 : ' || vpancompl);
END;
-- Procedure MEMBER_PAN이(가) 컴파일되었습니다.
EXEC member_pan('hyungjs1234@naver.com');


< 관심 상품 >
1. 관심 상품 목록 출력
-- 사이즈 출력 X, 빠른배송 여부 출력 O
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
    -- 상품 커서
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
                        ORDER BY inter_id DESC;  -- 최근등록순 정렬
BEGIN
    SELECT COUNT(*) INTO visquick  -- 0보다 크면 빠른배송
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
    
    DBMS_OUTPUT.PUT_LINE('[ 관심 상품 ]');
    
    OPEN c_interest;
    LOOP
        FETCH c_interest INTO vi_id, vi_image, vi_brand, vi_name, vis_gprice
                            , vb_id, vb_image, vb_brand, vb_name, vb_price, vinter_size;
        EXIT WHEN c_interest%NOTFOUND;
        
        IF vb_id IS NULL THEN -- 일반 상품 출력
            IF vis_gprice IS NULL THEN  -- 즉시구매가 없는 경우
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name || ', -');
            ELSE
                IF visquick > 0 THEN  -- 빠른배송인 경우
                    DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' 
                                        || vi_name || ', 빠른배송, ' || vis_gprice);
                ELSE  -- 일반배송인 경우
                    DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' 
                                        || vi_name || ', ' || vis_gprice);
                END IF;
            END IF;
    
        ELSE  -- 브랜드 상품 출력
            DBMS_OUTPUT.PUT_LINE(vb_image || ', ' || vb_brand || ', ' || vb_name
                                || ', 브랜드배송, ' || vb_price);
        END IF;
    END LOOP;
    IF c_interest%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('추가하신 관심 상품이 없습니다.');
    END IF;
    CLOSE c_interest;
END;
-- Procedure MEMBER_INTER이(가) 컴파일되었습니다.
EXEC member_inter('shiueo@naver.com');


< 거래 내역 수량 변경 >
1. 정산 완료(거래 종료)
CREATE OR REPLACE PROCEDURE complete_cal
(
    ppbid_id        tb_panmaebid.pbid_id%type  -- 판매 입찰 코드
    , ppbid_state   tb_panmaebid.pbid_itemstate%type  -- 변경할 제품 상태
    , pgbid_id      tb_gumaebid.gbid_id%type  -- 구매 입찰 코드
    , pgbid_state   tb_gumaebid.gbid_itemstate%type  -- 변경할 제품 상태
)
IS
BEGIN
    IF ppbid_id IS NOT NULL THEN  -- 판매 상품의 제품 상태 변경
        UPDATE tb_panmaebid
        SET pbid_itemstate = ppbid_state, pbid_complete = 2
        WHERE pbid_id = ppbid_id;
    END IF;
    
    IF pgbid_id IS NOT NULL THEN  -- 구매 상품의 제품 상태 변경
        UPDATE tb_gumaebid
        SET gbid_itemstate = pgbid_state, gbid_complete = 2
        WHERE gbid_id = pgbid_id;
    END IF;
END;
-- Procedure COMPLETE_CAL이(가) 컴파일되었습니다.


2. 판매 내역 수량 변경(일반 판매/보관 판매)
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
    
    IF vkeepcheck = 0 THEN  -- 일반 판매 상품
        SELECT * INTO vpanbid, vpaning, vpancompl
        FROM (SELECT pbid_complete FROM tb_panmaebid WHERE m_email = vemail)
        PIVOT (COUNT(pbid_complete) FOR pbid_complete IN (0, 1, 2));
        
        vpanlog := vpanbid + vpaning + vpancompl;
        
        UPDATE tb_amount 
        SET am_panlog = vpanlog, am_panbid = vpanbid, am_paning = vpaning, am_pancompl = vpancompl
        WHERE m_email = vemail;
        
    ELSE  -- 보관 판매 상품
        SELECT * INTO vbpsendreq, vbpwait, vbping, vbpcalcompl
        FROM (SELECT pbid_itemstate FROM tb_panmaebid WHERE m_email = vemail)
        PIVOT (COUNT(pbid_itemstate) FOR pbid_itemstate IN ('발송요청', '판매대기', '판매중', '정산완료'));
        
        UPDATE tb_amount 
        SET am_bpsendreq = vbpsendreq, am_bpwait = vbpwait, am_bping = vbping, am_bpcalcompl = vbpcalcompl
        WHERE m_email = vemail;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('판매 입찰 코드를 잘못 입력하였습니다.');
END;
-- Procedure UPD_AMOUNT_PAN이(가) 컴파일되었습니다.


3. 구매 내역 수량 변경
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
        DBMS_OUTPUT.PUT_LINE('구매 입찰 코드를 잘못 입력하였습니다.');
END;
-- Procedure UPD_AMOUNT_GU이(가) 컴파일되었습니다.

-- 1) 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES(4, 'shiueo@naver.com', 1, 250, 260000
            , TO_DATE('22/09/21', 'YY/MM/DD'), 30, 0, '빠른배송', '서울', 0, 1, '배송중', 7800, 5000);

-- 2) 프로시저 실행
EXEC complete_cal(2, '정산완료', 4, '배송완료');  -- 거래 종료, 제품 상태 변경
EXEC upd_amount_pan(2);  -- 판매 내역 수량 변경
EXEC upd_amount_gu(4);  -- 구매 내역 수량 변경

-- 3) 확인
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_amount;
ROLLBACK;

-- 4) 테스트 데이터 롤백
DELETE FROM tb_gumaebid WHERE gbid_id = 4;
UPDATE tb_panmaebid
SET pbid_itemstate = '판매중', pbid_complete = 1
WHERE pbid_id = 2;
COMMIT;


---------------------------------------------------------------------------
[ 구매 내역 ]
< 구매입찰 >
-- 구매여부 0
1. 전체 조회
CREATE OR REPLACE PROCEDURE gbid_default
(
    pemail   tb_member.m_email%type
)
IS
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_gumaebid.gbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- 만료일
    CURSOR c_gbid IS
                SELECT i_image, i_name_eng, gbid_size
                         , TO_CHAR(gbid_price, 'FM999,999,999,999') || '원' gbid_price
                         , TO_CHAR(gbid_rdate + gbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                WHERE gbid_complete = 0 and m_email = pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE; 
                    -- 기간 기본값: 최근 2개월
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 구매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 구매 입찰 ]');
    
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('구매희망가: ' || vprice || ', 만료일: ' || vexdate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GBID_DEFAULT이(가) 컴파일되었습니다.
EXEC gbid_default('shiueo@naver.com');
EXEC gbid_default('lklk9803@gmail.com');


2. 기간별 조회
-- 입찰일이 입력한 시작일과 종료일 사이인 입찰목록 조회
CREATE OR REPLACE PROCEDURE gbid_date
(
    pemail    tb_member.m_email%type
    , psdate  varchar2  -- 입력 시작일
    , pedate  varchar2  -- 입력 종료일
)
IS
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    varchar2(20);
    vexdate   varchar2(10);  -- 만료일
    CURSOR c_gbid IS
                SELECT i_image, i_name_eng, gbid_size
                         , TO_CHAR(gbid_price, 'FM999,999,999,999') || '원' gbid_price
                         , TO_CHAR(gbid_rdate + gbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id
                WHERE gbid_complete = 0 and m_email = pemail
                    and gbid_rdate BETWEEN TO_DATE(psdate, 'YYYY-MM-DD') AND TO_DATE(pedate, 'YYYY-MM-DD'); 
BEGIN
    DBMS_OUTPUT.PUT_LINE('[ 기간별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('기간: ' || psdate || ' ~ ' || pedate);
    
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('구매희망가: ' || vprice || ', 만료일: ' || vexdate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GBID_DATE이(가) 컴파일되었습니다.
EXEC gbid_date('shiueo@naver.com', '2022-05-23', '2022-06-28');
EXEC gbid_date('shiueo@naver.com', '2022-08-23', '2022-10-28');


3. 구매희망가순 정렬
CREATE OR REPLACE PROCEDURE gbid_price_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0이면 오름차순, 1이면 내림차순
)
IS
    vsql      varchar2(1000);
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    number(12);
    vexdate   date;  -- 만료일
    vcur      SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, gbid_price, gbid_rdate + gbid_deadline ';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id ';
    vsql := vsql || ' WHERE gbid_complete = 0 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 구매희망가 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY gbid_price ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 구매희망가 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY gbid_price DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('구매희망가: ' || TO_CHAR(vprice, 'FM999,999,999,999')
        || '원, 만료일: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GBID_PRICE_ORDER이(가) 컴파일되었습니다.
EXEC gbid_price_order('shiueo@naver.com', 0);
EXEC gbid_price_order('shiueo@naver.com', 1);
-- 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 0, '입찰중', 4950, 3000);


4. 만료일순 정렬
CREATE OR REPLACE PROCEDURE gbid_exdate_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0이면 오름차순, 1이면 내림차순
)
IS
    vsql      varchar2(1000);
    viamge    tb_item.i_image%type;
    vname     tb_item.i_name_eng%type;
    vsize     tb_gumaebid.gbid_size%type;
    vprice    number(12);
    vexdate   date;  -- 만료일
    vcur      SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, gbid_size, gbid_price, gbid_rdate + gbid_deadline AS exdate';
    vsql := vsql || ' FROM tb_item i JOIN tb_gumaebid g ON i.i_id = g.i_id ';
    vsql := vsql || ' WHERE gbid_complete = 0 and m_email = :pemail
                    and gbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 만료일 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY exdate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 만료일 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY exdate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('구매희망가: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '원, 만료일: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GBID_EXDATE_ORDER이(가) 컴파일되었습니다.
EXEC gbid_exdate_order('shiueo@naver.com', 0);
EXEC gbid_exdate_order('shiueo@naver.com', 1);
-- 테스트 데이터 삭제
DELETE FROM tb_gumaebid WHERE gbid_id = 4;


5. 입찰중 상품 상세정보
5-1. 상품 정보
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
    
    DBMS_OUTPUT.PUT_LINE('--- 구매 입찰 중 ---');
    DBMS_OUTPUT.PUT_LINE('[ 상품 정보 ]');
    DBMS_OUTPUT.PUT_LINE('주문번호: ' || pgumaeid);
    DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vsize);
    DBMS_OUTPUT.PUT_LINE('즉시구매가: ' || TO_CHAR(vgprice, 'FM999,999,999,999') || '원, 즉시판매가: ' 
                        || TO_CHAR(vpprice, 'FM999,999,999,999') || '원');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- 구매 입찰 중 ---');
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
END;
-- Procedure GBID_INFO1이(가) 컴파일되었습니다.
EXEC gbid_info1('shiueo@naver.com', 2);


5-2. 구매 입찰 내역
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
    
    DBMS_OUTPUT.PUT_LINE('[ 구매 입찰 내역 ]');
    DBMS_OUTPUT.PUT_LINE('구매 희망가: ' || TO_CHAR(vprice, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('검수비: 무료');
    DBMS_OUTPUT.PUT_LINE('수수료: ' || TO_CHAR(vfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('배송비: ' || TO_CHAR(vdelivfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('총 결제금액: ' || TO_CHAR(vprice + vfee + vdelivfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('입찰일: ' || vrdate);
    DBMS_OUTPUT.PUT_LINE('입찰마감기한: ' || vdeadline || '일 - ' || TO_CHAR(vrdate + vdeadline, 'YY/MM/DD') || '까지');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('[ 구매 입찰 내역 ]');
        DBMS_OUTPUT.PUT_LINE('구매 입찰 내역이 없습니다.');
END;
-- Procedure GBID_INFO2이(가) 컴파일되었습니다.
EXEC gbid_info2('shiueo@naver.com', 2);


5-3. 배송 주소 및 결제 정보
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
    WHERE m_email = pemail and d_basic = 1;  -- 기본 배송지
    
    SELECT c_bank, c_id INTO vbank, vcid
    FROM tb_card
    WHERE m_email = pemail and c_pay = 1; -- 기본 결제 카드
    
    DBMS_OUTPUT.PUT_LINE('[ 배송 주소 ]');
    DBMS_OUTPUT.PUT_LINE('받는 사람: ' || REPLACE(vname, SUBSTR(vname, 2), '**'));
    DBMS_OUTPUT.PUT_LINE('휴대폰 번호: ' || REPLACE(vtel, SUBSTR(vtel, 6, 5), '***-*'));
    DBMS_OUTPUT.PUT_LINE('주소: (' || vzip || ') ' || vads || ' ' || vdetail);
    DBMS_OUTPUT.PUT_LINE('[ 결제 정보 ]');
    DBMS_OUTPUT.PUT_LINE(vbank || ' ****-****-****-' || SUBSTR(vcid, 13, 3) || '*');
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- 구매 입찰 중 ---');
        DBMS_OUTPUT.PUT_LINE('배송 주소 및 결제 정보가 없습니다.');
END;
-- Procedure GBID_INFO3이(가) 컴파일되었습니다.
EXEC gbid_info3('shiueo@naver.com');

-- 전체 출력
EXEC gbid_info1('shiueo@naver.com', 2);
EXEC gbid_info2('shiueo@naver.com', 2);
EXEC gbid_info3('shiueo@naver.com');


6. 입찰 내역 삭제하기
CREATE OR REPLACE PROCEDURE del_gbid
(
    pgumaeid  tb_gumaebid.gbid_id%type
)
IS
BEGIN
    DELETE FROM tb_gumaebid
    WHERE gbid_id = pgumaeid;
    DBMS_OUTPUT.PUT_LINE('입찰 내역이 삭제되었습니다.');
END;
-- Procedure GBID_INFO1이(가) 컴파일되었습니다.
EXEC del_gbid(3);
ROLLBACK;
SELECT * FROM tb_gumaebid;



< 진행중 >
-- 구매여부 1
1. 상태별 조회
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
    DBMS_OUTPUT.PUT_LINE('--- 구매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 진행 중 ]');
    DBMS_OUTPUT.PUT_LINE('[ 상태별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('선택한 상태: ' || pitemstate);
    OPEN c_gbid;
    LOOP
        FETCH c_gbid INTO viamge, vname, vsize, vstate;
        EXIT WHEN c_gbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vstate);
    END LOOP;
    IF c_gbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE c_gbid;
END;
-- Procedure GING_STATE이(가) 컴파일되었습니다.
EXEC ging_state('shiueo@naver.com', '입고대기');
-- 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '입고대기', 4950, 3000);
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 190000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '배송 중', 5700, 3000);


2. 상태순 정렬
CREATE OR REPLACE PROCEDURE ging_state_order
(
    pemail   tb_member.m_email%type
    , pnum   number  -- 0이면 오름차순, 1이면 내림차순
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
        DBMS_OUTPUT.PUT_LINE('[ 상태 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY gbid_itemstate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 상태 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY gbid_itemstate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GING_STATE_ORDER이(가) 컴파일되었습니다.
EXEC ging_state_order('shiueo@naver.com', 0);
EXEC ging_state_order('shiueo@naver.com', 1);
-- 테스트 데이터 삭제
DELETE FROM tb_gumaebid WHERE gbid_id IN (4, 5);


3. 진행중 상품 상세정보
3-1. 상품 정보
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
    
    DBMS_OUTPUT.PUT_LINE('--- 구매 진행 중 ---');
    DBMS_OUTPUT.PUT_LINE('[ 상품 정보 ]');
    DBMS_OUTPUT.PUT_LINE('주문번호: ' || pmatid);
    DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vsize);
    DBMS_OUTPUT.PUT_LINE('진행상황: ' || vitemstate);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- 구매 진행 중 ---');
        DBMS_OUTPUT.PUT_LINE('구매 진행 중 상품이 없습니다.');
END;
-- Procedure GBID_INFO1이(가) 컴파일되었습니다.
EXEC ging_info1('hyungjs1234@naver.com', 2);
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '입고대기', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'hyungjs1234@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '입고대기', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '발송요청', 1600, '우체국택배', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'hyungjs1234@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '대기중', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

ROLLBACK;

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;
  
  
3-2. 결제 정보
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
    
    DBMS_OUTPUT.PUT_LINE('총 결제금액: ' || TO_CHAR(vprice + vfee + vdelivfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('검수비: 무료');
    DBMS_OUTPUT.PUT_LINE('수수료: ' || TO_CHAR(vfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('배송비: ' || TO_CHAR(vdelivfee, 'FM999,999,999,999') || '원');
    DBMS_OUTPUT.PUT_LINE('거래일시: ' || TO_CHAR(vmatdate, 'YY/MM/DD HH24:MI'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('--- 구매 진행 중 ---');
        DBMS_OUTPUT.PUT_LINE('구매 진행 중 상품이 없습니다.');
END;
-- Procedure GING_INFO2이(가) 컴파일되었습니다.
EXEC ging_info2('hyungjs1234@naver.com', 2);


< 종료 >
-- 구매여부 2
1. 구매일순(거래일순) 정렬
CREATE OR REPLACE PROCEDURE gend_matdate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0이면 오름차순, 1이면 내림차순
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
    
    DBMS_OUTPUT.PUT_LINE('--- 구매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 종료 ]');
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 구매일 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY mat_date ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 구매일 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY mat_date DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vmatdate, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('구매일: ' || vmatdate || ', 상태: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure GEND_MATDATE_ORDER이(가) 컴파일되었습니다.
EXEC gend_matdate_order('shiueo@naver.com', 0);
EXEC gend_matdate_order('shiueo@naver.com', 1);

-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

ROLLBACK;


2. 종료 상품 상세정보
-- 진행중 상품 상세정보와 동일



---------------------------------------------------------------------------
[ 판매 내역 ]
< 판매입찰 >
-- 보관판매 여부 0, 판매여부 0
1. 전체 조회
CREATE OR REPLACE PROCEDURE pbid_default
(
    pemail  tb_member.m_email%type
)
IS
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_panmaebid.pbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- 만료일
    CURSOR c_pbid IS
                SELECT i_image, i_name_eng, pbid_size
                         , TO_CHAR(pbid_price, 'FM999,999,999,999') || '원' gbid_price
                         , TO_CHAR(pbid_rdate + pbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE;  
                    -- 기간 기본값: 최근 2개월
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 판매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 판매 입찰 ]');
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('판매희망가: ' || vprice || ', 만료일: ' || vexdate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판매 입찰 내역이 없습니다.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PBID_DEFAULT이(가) 컴파일되었습니다.
EXEC pbid_default('lklk9803@gmail.com');


2. 기간별 조회
CREATE OR REPLACE PROCEDURE pbid_date
(
    pemail    tb_member.m_email%type
    , psdate  varchar2  -- 입력 시작일
    , pedate  varchar2  -- 입력 종료일
)
IS  
    viamge   tb_item.i_image%type;
    vname    tb_item.i_name_eng%type;
    vsize    tb_panmaebid.pbid_size%type;
    vprice   varchar2(20);
    vexdate  varchar2(10);  -- 만료일
    CURSOR c_pbid IS
                SELECT i_image, i_name_eng, pbid_size
                         , TO_CHAR(pbid_price, 'FM999,999,999,999') || '원' pbid_price
                         , TO_CHAR(pbid_rdate + pbid_deadline, 'YYYY/MM/DD') exdate
                FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id
                WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = pemail
                    and pbid_rdate BETWEEN TO_DATE(psdate, 'YYYY-MM-DD') AND TO_DATE(pedate, 'YYYY-MM-DD'); 
BEGIN
    DBMS_OUTPUT.PUT_LINE('[ 기간별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('기간: ' || psdate || ' ~ ' || pedate);
    
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('판매희망가: ' || vprice || ', 만료일: ' || vexdate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판매 입찰 내역이 없습니다.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PBID_DATE이(가) 컴파일되었습니다.
EXEC pbid_date('lklk9803@gmail.com', '2022-05-23', '2022-06-28');
EXEC pbid_date('lklk9803@gmail.com', '2022-08-23', '2022-10-28');
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'lklk9803@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 0, '입찰중', 1550, null, null);
          
SELECT * FROM tb_panmaebid;


3. 판매희망가순 정렬
CREATE OR REPLACE PROCEDURE pbid_price_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0이면 오름차순, 1이면 내림차순
)
IS
    vsql    varchar2(1000);
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vprice  number(12);
    vexdate date;  -- 만료일
    vcur    SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, pbid_price, pbid_rdate + pbid_deadline ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 판매희망가 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY pbid_price ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 판매희망가 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY pbid_price DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('판매희망가: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '원, 만료일: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판매 입찰 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PBID_PRICE_ORDER이(가) 컴파일되었습니다.
EXEC pbid_price_order('lklk9803@gmail.com', 0);
EXEC pbid_price_order('lklk9803@gmail.com', 1);


4. 만료일순 정렬
CREATE OR REPLACE PROCEDURE pbid_exdate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0이면 오름차순, 1이면 내림차순
)
IS
    vsql    varchar2(1000);
    viamge  tb_item.i_image%type;
    vname   tb_item.i_name_eng%type;
    vsize   tb_panmaebid.pbid_size%type;
    vprice  number(12);
    vexdate date;  -- 만료일
    vcur    SYS_REFCURSOR;
BEGIN
    vsql := ' SELECT i_image, i_name_eng, pbid_size, pbid_price, pbid_rdate + pbid_deadline AS exdate ';
    vsql := vsql || ' FROM tb_item i JOIN tb_panmaebid p ON i.i_id = p.i_id ';
    vsql := vsql || ' WHERE pbid_keepcheck = 0 and pbid_complete = 0 and m_email = :pemail
                    and pbid_rdate BETWEEN ADD_MONTHS(SYSDATE, -2) AND SYSDATE ';
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 만료일 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY exdate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 만료일 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY exdate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vprice, vexdate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('판매희망가: ' || TO_CHAR(vprice, 'FM999,999,999,999')
                            || '원, 만료일: ' || TO_CHAR(vexdate, 'YYYY/MM/DD'));
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판매 입찰 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PBID_EXDATE_ORDER이(가) 컴파일되었습니다.
EXEC pbid_exdate_order('lklk9803@gmail.com', 0);
EXEC pbid_exdate_order('lklk9803@gmail.com', 1);
-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid WHERE pbid_id = 6;


5. 입찰중 상품 상세정보
-- 상품 정보, 입찰 내역은 구매 내역과 동일
-- 페널티 결제 정보는 구매 내역의 카드 정보와 동일
-- 반송 주소는 구매 내역의 배송 주소와 동일
5-1. 판매 정산 계좌
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
    
    DBMS_OUTPUT.PUT_LINE('[ 판매 정산 계좌 ]');
    DBMS_OUTPUT.PUT_LINE(vbank || RPAD(' ', LENGTH(vnum), '*'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('판매 정산 계좌가 없습니다.');
END;
-- Procedure PBID_ACCOUNT이(가) 컴파일되었습니다.
EXEC pbid_account('lklk9803@gmail.com');


< 진행 중 >
-- 보관판매 여부 0, 판매여부 1
1. 상태별 조회
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
    DBMS_OUTPUT.PUT_LINE('--- 판매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 진행 중 ]');
    DBMS_OUTPUT.PUT_LINE('[ 상태별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('선택한 상태: ' || pitemstate);
    OPEN c_pbid;
    LOOP
        FETCH c_pbid INTO viamge, vname, vsize, vstate;
        EXIT WHEN c_pbid%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vstate);
    END LOOP;
    IF c_pbid%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE c_pbid;
END;
-- Procedure PING_STATE이(가) 컴파일되었습니다.
EXEC ping_state('sdjsd@naver.com', '발송요청');


2. 상태순 정렬
CREATE OR REPLACE PROCEDURE ping_state_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0이면 오름차순, 1이면 내림차순
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
        DBMS_OUTPUT.PUT_LINE('[ 상태 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY pbid_itemstate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 상태 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY pbid_itemstate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PING_STATE_ORDER이(가) 컴파일되었습니다.
EXEC ping_state_order('sdjsd@naver.com', 0);
EXEC ping_state_order('sdjsd@naver.com', 1);
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'sdjsd@naver.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '입고완료', 1550, null, null);

ROLLBACK;


3. 진행중 상품 상세정보
-- 발송 정보 이외에 모두 위와 동일
3-1. 발송 정보 출력
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
    DBMS_OUTPUT.PUT_LINE('[ 발송 정보 ]');
    DBMS_OUTPUT.PUT_LINE(vcourier || ' ' || vtrackingnum);
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('발송 정보가 없습니다.');
END;
-- Procedure PING_SHIPPING이(가) 컴파일되었습니다.
EXEC ping_shipping('hyungjs1234@naver.com', 2);


3-2. 발송 정보 변경
EXEC upd_shipping(2, '우체국택배', '736132678451');

SELECT * FROM tb_panmaebid;
ROLLBACK;


< 종료 >
-- 보관판매 여부 0, 판매여부 2
1. 정산일순 정렬
CREATE OR REPLACE PROCEDURE pend_caldate_order
(
    pemail  tb_member.m_email%type
    , pnum  number  -- 0이면 오름차순, 1이면 내림차순
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
    
    DBMS_OUTPUT.PUT_LINE('--- 판매 내역 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 종료 ]');
    
    IF pnum = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ 정산일 오름차순 정렬 ]');
        vsql := vsql || ' ORDER BY mat_caldate ASC ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 정산일 내림차순 정렬 ]');
        vsql := vsql || ' ORDER BY mat_caldate DESC ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO viamge, vname, vsize, vcaldate, vstate;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(viamge || ', ' || vname || ', ' || vsize);
        DBMS_OUTPUT.PUT_LINE('정산일: ' || vcaldate || ', 상태: ' || vstate);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('거래 내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure PEND_CALDATE_ORDER이(가) 컴파일되었습니다.
EXEC pend_caldate_order('jeifh@gmail.com', 0);
EXEC pend_caldate_order('jeifh@gmail.com', 1);

-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1600, '우체국택배', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;


2. 종료 상품 상세정보
-- 정산일 이외에 모두 위와 동일
2-1. 정산일 출력
CREATE OR REPLACE PROCEDURE pend_caldate
(
    pmat_id   tb_matching.mat_id%type  -- 주문번호
)
IS
    vcaldate  tb_matching.mat_caldate%type;
BEGIN
    SELECT mat_caldate INTO vcaldate
    FROM tb_panmaebid p JOIN tb_matching m ON p.pbid_id = m.pbid_id
    WHERE pbid_keepcheck = 0 and pbid_complete = 2 and mat_id = pmat_id;
    DBMS_OUTPUT.PUT_LINE('정산일: ' || TO_CHAR(vcaldate, 'YY/MM/DD'));
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('판매 종료 상품 정보가 없습니다.');
END;
-- Procedure PEND_CALDATE이(가) 컴파일되었습니다.
EXEC pend_caldate(2);
-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid WHERE pbid_id >= 6;
DELETE FROM tb_gumaebid WHERE gbid_id >= 4;
DELETE FROM tb_matching WHERE mat_id >= 2;


---------------------------------------------------------------------------
[ 보관 판매 ]
-- 전체 조회 불가. 상태별로만 조회 가능.
< 보관 상품 선택 >
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
    DBMS_OUTPUT.PUT_LINE('--- 보관 상품 선택 ---');
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
-- Procedure BPAN_ITEMLIST이(가) 컴파일되었습니다.
EXEC bpan_itemlist;


< 신청 >
-- 보관판매 여부 1, 판매여부 0
1. 상태별 조회 (default는 발송요청)
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
    DBMS_OUTPUT.PUT_LINE('--- 보관 판매 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 신청 ]');
    DBMS_OUTPUT.PUT_LINE('[ 상태별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('선택한 상태: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('사이즈: ' || vsize || ', 보증금: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('택배사: ' || vcourier || ', 운송장 번호: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('내역이 없습니다.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_APP이(가) 컴파일되었습니다.
EXEC bpan_app('shiueo@naver.com', '발송요청');
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '집앞8', 0, '발송요청', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);


2. 택배사, 운송장번호 입력
CREATE OR REPLACE PROCEDURE upd_shipping 
(
    ppbid_id        tb_panmaebid.pbid_id%type  -- 판매입찰 코드
    , pcourier      tb_panmaebid.pbid_courier%type
    , ptrackingnum  tb_panmaebid.pbid_trackingnum%type
)
IS
BEGIN
    UPDATE tb_panmaebid
    SET pbid_courier = pcourier, pbid_trackingnum = ptrackingnum
    WHERE pbid_id = ppbid_id;
END;
-- Procedure UPD_SHIPPING이(가) 컴파일되었습니다.
EXEC upd_shipping(8, '우체국택배', '516873151354');

EXEC bpan_app('shiueo@naver.com', '발송요청');

-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid
WHERE pbid_id = 8;
DELETE FROM tb_bpanitem
WHERE bpi_id = 4;
COMMIT;


3. 신청 취소
CREATE OR REPLACE PROCEDURE del_bpan 
(
    pbpi_id   tb_bpanitem.bpi_id%type  -- 보관 상품 코드
)
IS
    vpbid_id  tb_panmaebid.pbid_id%type;
BEGIN
    SELECT a.pbid_id INTO vpbid_id
    FROM tb_bpanitem a JOIN tb_panmaebid b ON a.pbid_id = b.pbid_id
    WHERE bpi_id = pbpi_id;
    
    -- 보관 판매 상품 테이블에서 삭제
    DELETE FROM tb_bpanitem
    WHERE bpi_id = pbpi_id;
    
    -- 판매 입찰 테이블에서 삭제
    DELETE FROM tb_panmaebid
    WHERE pbid_id = vpbid_id;
    
    DBMS_OUTPUT.PUT_LINE('보관 판매 신청이 취소되었습니다.');
END;
--Procedure DEL_BPAN이(가) 컴파일되었습니다.
EXEC del_bpan(4);
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '집앞8', 0, '발송요청', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

SELECT * FROM tb_bpanitem;
SELECT * FROM tb_panmaebid;



< 보관중 >
-- 보관판매 여부 1, 판매여부 1
1. 상태별 조회 (default는 판매대기)
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
    DBMS_OUTPUT.PUT_LINE('--- 보관 판매 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 보관 중 ]');
    DBMS_OUTPUT.PUT_LINE('[ 상태별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('선택한 상태: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('사이즈: ' || vsize || ', 보증금: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('택배사: ' || vcourier || ', 운송장 번호: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('내역이 없습니다.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_ING이(가) 컴파일되었습니다.
EXEC bpan_ing('hyungjs1234@naver.com', '판매중');


2. 합격/95점 합격별 조회
CREATE OR REPLACE PROCEDURE bpan_ing_pass
(
    pemail  tb_member.m_email%type
    , pis95 number  -- 0이면 합격 상품, 1이면 95점 상품
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
        DBMS_OUTPUT.PUT_LINE('[ 합격 ]');
        vsql := vsql || ' and pbid_95check = 0 ';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ 95점 합격 ]');
        vsql := vsql || ' and pbid_95check = 1 ';
    END IF;
    
    OPEN vcur FOR vsql USING pemail;
    LOOP
        FETCH vcur INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('사이즈: ' || vsize || ', 보증금: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('택배사: ' || vcourier || ', 운송장 번호: ' || vtrackingnum);
    END LOOP;
    IF vcur%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('내역이 없습니다.');
    END IF;
    CLOSE vcur;
END;
-- Procedure BPAN_ING_PASS이(가) 컴파일되었습니다.
EXEC bpan_ing_pass('hyungjs1234@naver.com', 0);
EXEC bpan_ing_pass('hyungjs1234@naver.com', 1);


< 종료 >
-- 보관판매 여부 1, 판매여부 2
1. 상태별 조회 (default는 정산완료)
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
    DBMS_OUTPUT.PUT_LINE('--- 보관 판매 페이지 ---');
    DBMS_OUTPUT.PUT_LINE('[ 종료 ]');
    DBMS_OUTPUT.PUT_LINE('[ 상태별 조회 ]');
    DBMS_OUTPUT.PUT_LINE('선택한 상태: ' || pstate);
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('사이즈: ' || vsize || ', 보증금: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('택배사: ' || vcourier || ', 운송장 번호: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('내역이 없습니다.');
    END IF;
    CLOSE c_bpan;
END;
-- Procedure BPAN_END이(가) 컴파일되었습니다.
EXEC bpan_end('jeifh@gmail.com', '정산완료');



< 검색 >
-- 신청: pbid_keepcheck = 1 and pbid_complete = 0
-- 보관 중: pbid_keepcheck = 1 and pbid_complete = 1
-- 종료: pbid_keepcheck = 1 and pbid_complete = 2
CREATE OR REPLACE PROCEDURE bpan_search
(   
    pemail      tb_member.m_email%type
    , pnum      number   -- 1이면 브랜드명, 2면 상품명(영어), 3이면 모델명으로 검색
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
    DBMS_OUTPUT.PUT_LINE('[ 보관 판매 검색 ]');
    OPEN c_bpan;
    LOOP
        FETCH c_bpan INTO vimage, vmodel, vname, vsize, vbpi_id, vdeposit, vcourier, vtrackingnum;
        EXIT WHEN c_bpan%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vimage || ', ' || vmodel || ', ' || vname || ', ' || vbpi_id);
        DBMS_OUTPUT.PUT_LINE('사이즈: ' || vsize || ', 보증금: ' || vdeposit);
        DBMS_OUTPUT.PUT_LINE('택배사: ' || vcourier || ', 운송장 번호: ' || vtrackingnum);
    END LOOP;
    IF c_bpan%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('내역이 없습니다.');
    END IF;
    CLOSE c_bpan;     
END;   
-- Procedure BPAN_SEARCH이(가) 컴파일되었습니다.
-- 올바른 예)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'NIK');  -- NIKE
EXEC bpan_search('hyungjs1234@naver.com', 2, 'Air Force');  -- Nike Air Force 1 '07 Low White
EXEC bpan_search('hyungjs1234@naver.com', 3, 'CW2288');  -- 315122-111/CW2288-111
-- 잘못된 예)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'Air Force');  -- 내역이 없습니다.
EXEC bpan_search('hyungjs1234@naver.com', 2, 'CW2288');  -- 내역이 없습니다.



---------------------------------------------------------------------------
[ 관심 상품 ]
< 관심 상품 목록 >
-- 사이즈 출력 O, 빠른배송 여부 출력 X
1. 출력
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
    -- 상품 커서
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
                        ORDER BY inter_id DESC;  -- 최근등록순 정렬
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 관심 상품 페이지 ---');
    OPEN c_interest;
    LOOP
        FETCH c_interest INTO vi_id, vi_image, vi_brand, vi_name, vis_gprice
                                , vb_id, vb_image, vb_brand, vb_name, vb_price, vinter_size;
        EXIT WHEN c_interest%NOTFOUND;
        IF vb_id IS NULL THEN -- 일반 상품 출력
            IF vis_gprice IS NULL THEN  -- 즉시구매가 없는 경우
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name 
                                    || ', ' || vinter_size || ', -');
            ELSE
                DBMS_OUTPUT.PUT_LINE(vi_image || ', ' || vi_brand || ', ' || vi_name 
                                    || ', ' || vinter_size || ', ' || vis_gprice);
            END IF;
            
        ELSE  -- 브랜드 상품 출력
            DBMS_OUTPUT.PUT_LINE(vb_image || ', ' || vb_brand || '(브랜드 배송), ' 
                                || vb_name || ', ' || vinter_size || ', ' || vb_price);
        END IF;
    END LOOP;
    IF c_interest%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('추가하신 관심 상품이 없습니다.');
    END IF;
    CLOSE c_interest;
END;
-- Procedure INTEREST이(가) 컴파일되었습니다.
EXEC interest('shiueo@naver.com');


2. 관심 상품 삭제
CREATE OR REPLACE PROCEDURE del_inter 
(
    pinter_id   tb_interest.inter_id%type  -- 관심상품 코드
)
IS
BEGIN
    DELETE FROM tb_interest
    WHERE inter_id = pinter_id;
    DBMS_OUTPUT.PUT_LINE('관심 상품이 삭제되었습니다.');
END;
-- Procedure DEL_INTER이(가) 컴파일되었습니다.
EXEC del_inter(11);

SELECT * FROM tb_interest;
ROLLBACK;


----------------------------------------------------------------------
[ 마이페이지 ]
< 화면 출력 >
-- 회원 정보 (이메일)
EXEC member_info('hyungjs1234@naver.com');

-- 보관 판매 거래 내역 수량 (이메일)
EXEC member_bp('hyungjs1234@naver.com');

-- 구매 거래 내역 수량 (이메일)
EXEC member_gu('hyungjs1234@naver.com');

-- 판매 거래 내역 수량 (이메일)
EXEC member_pan('hyungjs1234@naver.com');

-- 관심 상품 목록 (이메일)
EXEC member_inter('shiueo@naver.com');


< 정산 완료(거래 종료) 및 거래 내역 수량 갱신 >
1) 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES(4, 'shiueo@naver.com', 1, 250, 260000
            , TO_DATE('22/09/21', 'YY/MM/DD'), 30, 0, '빠른배송', '서울', 0, 1, '배송중', 7800, 5000);

2) 프로시저 실행
-- 정산 완료(판매입찰 코드, 변경할 판매 상품 상태, 구매입찰 코드, 변경할 구매 상품 상태)
EXEC end_deal(2, '정산완료', 4, '배송완료');

-- 판매 내역 수량 갱신(판매입찰 코드)
EXEC upd_amount_pan(2);

-- 구매 내역 수량 갱신(구매입찰 코드)  
EXEC upd_amount_gu(4);

3) 확인
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_amount;
ROLLBACK;

4) 테스트 데이터 롤백
DELETE FROM tb_gumaebid WHERE gbid_id = 4;
UPDATE tb_panmaebid
SET pbid_itemstate = '판매중', pbid_complete = 1
WHERE pbid_id = 2;
COMMIT;


---------------------------------------------------------------------------
[ 구매 내역 페이지 ]
1. 구매 입찰  -- 구매여부 0
< 조회 >
-- 전체 조회(이메일)
EXEC gbid_default('shiueo@naver.com');

-- 기간별 조회(이메일, 시작일, 종료일)
EXEC gbid_date('shiueo@naver.com', '2022-05-23', '2022-06-28');
EXEC gbid_date('shiueo@naver.com', '2022-08-23', '2022-10-28');


< 정렬 >
-- 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 0, '입찰중', 4950, 3000);

-- 구매희망가순 정렬(이메일, 정렬방식)
-- 0이면 오름차순, 1이면 내림차순(이하 전부 동일)
EXEC gbid_price_order('shiueo@naver.com', 0);
EXEC gbid_price_order('shiueo@naver.com', 1);

-- 만료일순 정렬(이메일, 정렬방식)
EXEC gbid_exdate_order('shiueo@naver.com', 0);
EXEC gbid_exdate_order('shiueo@naver.com', 1);

-- 테스트 데이터 삭제
DELETE FROM tb_gumaebid WHERE gbid_id = 4;


< 입찰중 상품 상세정보 출력 >
-- 상품정보(이메일, 구매입찰 코드)
EXEC gbid_info1('shiueo@naver.com', 2);

-- 구매 입찰 내역(이메일, 구매입찰 코드)
EXEC gbid_info2('shiueo@naver.com', 2);

-- 배송 주소 및 결제 정보(이메일)
EXEC gbid_info3('shiueo@naver.com');


< 입찰 내역 삭제 >
-- 입찰 내역 삭제(구매입찰 코드) 
EXEC del_gbid(3);

-- 확인 및 롤백
ROLLBACK;
SELECT * FROM tb_gumaebid;


2. 진행중  -- 구매여부 1
-- 테스트 데이터 추가
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 230, 165000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '입고대기', 4950, 3000);
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 190000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '배송 중', 5700, 3000);


< 조회 >
-- 상태별 조회(이메일, 제품 상태)
EXEC ging_state('shiueo@naver.com', '입고대기');


< 정렬 >
-- 상태순 정렬(이메일, 정렬방식)
EXEC ging_state_order('shiueo@naver.com', 0);
EXEC ging_state_order('shiueo@naver.com', 1);

-- 테스트 데이터 삭제
DELETE FROM tb_gumaebid WHERE gbid_id IN (4, 5);


< 진행중 상품 상세정보 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '입고대기', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'hyungjs1234@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '입고대기', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '발송요청', 1600, '우체국택배', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'hyungjs1234@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 1, '대기중', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

-- 확인 및 롤백
SELECT * FROM tb_panmaebid;
SELECT * FROM tb_gumaebid;
SELECT * FROM tb_matching;
ROLLBACK;
  
-- 상품 정보(이메일, 주문번호)
EXEC ging_info1('hyungjs1234@naver.com', 2);

-- 결제 정보(이메일, 주문번호)
EXEC ging_info2('hyungjs1234@naver.com', 2);


3. 종료  -- 구매여부 2
< 정렬 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

-- 구매일순(거래일순) 정렬(이메일, 정렬방식)
EXEC gend_matdate_order('shiueo@naver.com', 0);
EXEC gend_matdate_order('shiueo@naver.com', 1);

-- 롤백
ROLLBACK;


< 종료 상품 상세정보 >
-- 진행중 상품 상세정보와 동일


---------------------------------------------------------------------------
[ 판매 내역 ]
1. 판매 입찰  -- 보관판매 여부 0, 판매여부 0
< 조회 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'lklk9803@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 0, '입찰중', 1550, null, null);
          
SELECT * FROM tb_panmaebid;

-- 전체 조회(이메일)
EXEC pbid_default('lklk9803@gmail.com');

-- 기간별 조회(이메일, 시작일, 종료일)
EXEC pbid_date('lklk9803@gmail.com', '2022-05-23', '2022-06-28');
EXEC pbid_date('lklk9803@gmail.com', '2022-08-23', '2022-10-28');


< 정렬>
-- 판매희망가순 정렬(이메일, 정렬방식)
EXEC pbid_price_order('lklk9803@gmail.com', 0);
EXEC pbid_price_order('lklk9803@gmail.com', 1);

-- 만료일순 정렬(이메일, 정렬방식)
EXEC pbid_exdate_order('lklk9803@gmail.com', 0);
EXEC pbid_exdate_order('lklk9803@gmail.com', 1);

-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid WHERE pbid_id = 6;


< 입찰중 상품 상세정보 >
-- 상품 정보, 입찰 내역은 구매 내역과 동일
-- 페널티 결제 정보는 구매 내역의 카드 정보와 동일
-- 반송 주소는 구매 내역의 배송 주소와 동일

-- 판매 정산 계좌(이메일)
EXEC pbid_account('lklk9803@gmail.com');


2. 진행중  -- 보관판매 여부 0, 판매여부 1
< 조회 >
-- 상태별 조회(이메일, 제품 상태)
EXEC ping_state('sdjsd@naver.com', '발송요청');


< 정렬 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'sdjsd@naver.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 1, '입고완료', 1550, null, null);

-- 상태순 정렬(이메일, 정렬방식)
EXEC ping_state_order('sdjsd@naver.com', 0);
EXEC ping_state_order('sdjsd@naver.com', 1);

-- 롤백
ROLLBACK;


< 진행중 상품 상세정보 >
-- 발송 정보 이외에 모두 위와 동일

-- 발송 정보 출력(이메일, 판매입찰 코드)
EXEC ping_shipping('hyungjs1234@naver.com', 2);

-- 발송 정보 변경(판매입찰 코드, 택배사, 운송장번호)
EXEC upd_shipping(2, '우체국택배', '736132678451');

-- 확인 및 롤백
SELECT * FROM tb_panmaebid;
ROLLBACK;


3. 종료  -- 보관판매 여부 0, 판매여부 2
< 정렬 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (6, 'jeifh@gmail.com', 1, null, 240, 155000
            , TO_DATE('2022/10/20', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1550, '한진택배', '31456797645');
INSERT INTO tb_gumaebid VALUES (4, 'shiueo@naver.com', 1, 240, 155000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4650, 3000);
INSERT INTO tb_matching VALUES (2, 1, 6, 4, 0, 240, 155000, TO_DATE('2022/10/20', 'YYYY/MM/DD'), TO_DATE('2022/10/24', 'YYYY/MM/DD'));

INSERT INTO tb_panmaebid VALUES (7, 'jeifh@gmail.com', 1, null, 270, 160000
            , TO_DATE('2022/10/18', 'YYYY/MM/DD'), 30, 0, 0, '집앞6', 2, '정산완료', 1600, '우체국택배', '7543135431');
INSERT INTO tb_gumaebid VALUES (5, 'shiueo@naver.com', 1, 270, 160000
            , TO_DATE('2022/10/10', 'YYYY/MM/DD'), 30, 1, '일반배송', '서울', 0, 2, '배송완료', 4800, 3000);
INSERT INTO tb_matching VALUES (3, 1, 7, 5, 0, 270, 160000, TO_DATE('2022/10/18', 'YYYY/MM/DD'), TO_DATE('2022/10/22', 'YYYY/MM/DD'));

-- 정산일순 정렬(이메일, 정렬방식)
EXEC pend_caldate_order('jeifh@gmail.com', 0);
EXEC pend_caldate_order('jeifh@gmail.com', 1);


< 종료 상품 상세정보 >
-- 정산일 이외에 모두 위와 동일

-- 정산일 출력(주문번호)
EXEC pend_caldate(2);

-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid WHERE pbid_id >= 6;
DELETE FROM tb_gumaebid WHERE gbid_id >= 4;
DELETE FROM tb_matching WHERE mat_id >= 2;


---------------------------------------------------------------------------
[ 보관 판매 ]
-- 전체 조회 불가. 상태별로만 조회 가능.
< 보관 상품 선택 >
EXEC bpan_itemlist;

1. 신청  -- 보관판매 여부 1, 판매여부 0
< 조회 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '집앞8', 0, '발송요청', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

-- 상태별 조회(이메일, 제품 상태)
EXEC bpan_app('shiueo@naver.com', '발송요청');


< 발송 정보 입력 >
-- 발송 정보 입력(판매입찰코드, 택배사, 운송장번호)
EXEC upd_shipping(8, '우체국택배', '516873151354');

-- 테스트 데이터 삭제
DELETE FROM tb_panmaebid
WHERE pbid_id = 8;
DELETE FROM tb_bpanitem
WHERE bpi_id = 4;
COMMIT;


< 신청 취소 >
-- 테스트 데이터 추가
INSERT INTO tb_panmaebid VALUES (8, 'shiueo@naver.com', 1, null, 280, 180000
            , TO_DATE('22/10/01', 'YY/MM/DD'), 30, 0, 1, '집앞8', 0, '발송요청', 1800, null, null); 
INSERT INTO tb_bpanitem VALUES (4, 8, 1, 0, 3000);

-- 신청 취소(보관 상품 코드)
EXEC del_bpan(4);

-- 확인
SELECT * FROM tb_bpanitem;
SELECT * FROM tb_panmaebid;


2. 보관중  -- 보관판매 여부 1, 판매여부 1
< 조회 >
-- 상태별 조회(이메일, 제품 상태)
EXEC bpan_ing('hyungjs1234@naver.com', '판매중');

-- 합격/95점 합격별 조회(이메일, 95점합격여부)
-- 0이면 합격 상품, 1이면 95점 합격 상품
EXEC bpan_ing_pass('hyungjs1234@naver.com', 0);
EXEC bpan_ing_pass('hyungjs1234@naver.com', 1);


3. 종료  -- 보관판매 여부 1, 판매여부 2
< 조회 >
-- 상태별 조회(이메일, 제품 상태)
EXEC bpan_end('jeifh@gmail.com', '정산완료');


4. 검색(이메일, 검색조건, 키워드)
-- 검색조건이 1이면 브랜드명, 2면 상품명(영어), 3이면 모델명으로 검색
-- 올바른 예)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'NIK');  -- NIKE
EXEC bpan_search('hyungjs1234@naver.com', 2, 'Air Force');  -- Nike Air Force 1 '07 Low White
EXEC bpan_search('hyungjs1234@naver.com', 3, 'CW2288');  -- 315122-111/CW2288-111

-- 잘못된 예)
EXEC bpan_search('hyungjs1234@naver.com', 1, 'Air Force');  -- 내역이 없습니다.
EXEC bpan_search('hyungjs1234@naver.com', 2, 'CW2288');  -- 내역이 없습니다.


---------------------------------------------------------------------------
[ 관심 상품 ]
< 관심 상품 목록 출력 >
-- 출력(이메일)
EXEC interest('shiueo@naver.com');

< 관심 상품 삭제>
-- 삭제(관심 상품 코드)
EXEC del_inter(11);

-- 확인 및 롤백
SELECT * FROM tb_interest;
ROLLBACK;

