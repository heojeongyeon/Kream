
--버퍼 메모리 사이즈 증가 명령문
exec dbms_output.enable('500000000');

-- KREAM 프로젝트 --
--------------------------------------------------------------------------------------------------
-- 예외) 강사님이 한번에 처리하려면 동적 쿼리를 사용해야한다고 말씀주셨다. 꼭 한번 해보기
CREATE OR REPLACE PROCEDURE up_shop_category_test
IS
    vc_main       tb_category.c_main%type;
    vc_sub        tb_category.c_sub%type;
    
    CURSOR cs_selc1 IS 
        SELECT c_main
        FROM tb_category
        GROUP BY c_main
        ORDER BY c_main
    ;
    
    CURSOR cs_selc2 IS 
        SELECT c_sub
        FROM tb_category
        WHERE c_main = '????' -- 여기에 메인 카테고리가 들어가야함
    ;
BEGIN
    OPEN cs_selc1;
    OPEN cs_selc2;
    
    LOOP
        FETCH cs_selc1 INTO vc_main;
        EXIT WHEN cs_selc1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vc_main );
        
        -- 동적쿼리 실행 open for문~ 사용해야함
        LOOP
            FETCH cs_selc2 INTO vc_sub;
            EXIT WHEN cs_selc2%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE( vc_sub );
        END LOOP;
    END LOOP;
    
    CLOSE cs_selc1;
    CLOSE cs_selc2;
--EXCEPTION
END;

-- SHOP 페이지 --
--1. 카테고리 출력
--  1) 서브 카테고리
CREATE OR REPLACE PROCEDURE up_shop_subcategory
(
   pc_main  tb_category.c_main%type
)
IS
    vc_sub        tb_category.c_sub%type;
    
    CURSOR cs_selc1 IS
        SELECT c_sub
        FROM tb_category
        WHERE c_main =  pc_main;
BEGIN
    OPEN cs_selc1;
    
    LOOP
        FETCH cs_selc1 INTO vc_sub;
        EXIT WHEN cs_selc1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( '    ㄴ ' ||  vc_sub );
    END LOOP;
    
    CLOSE cs_selc1;
--EXCEPTION
END;

--  2) 메인 카테고리
CREATE OR REPLACE PROCEDURE up_shop_maincategory
IS
    vc_main       tb_category.c_main%type;
    
    CURSOR cs_selc1 IS
        SELECT c_main
        FROM tb_category
        GROUP BY c_main
        ORDER BY MIN(c_id);
BEGIN
    OPEN cs_selc1;
    
    LOOP
        FETCH cs_selc1 INTO vc_main;
        EXIT WHEN cs_selc1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( vc_main );
        
        up_shop_subcategory( vc_main );
        
    END LOOP;
    
    CLOSE cs_selc1;
--EXCEPTION
END;

--카테고리 목록 출력
EXEC up_shop_maincategory;

--2. 상품 목록 출력(일반 상품 + 브랜드 상품)
--  1) 일반 상품
CREATE OR REPLACE PROCEDURE up_shop_item
(
    pdelivtype    IN NVARCHAR2 DEFAULT null
    , pcategory   IN NVARCHAR2 DEFAULT null
)
IS
    vi_id           tb_item.i_id%type;
    vi_image        tb_item.i_image%type;
    vi_brand        tb_item.i_brand%type;
    vi_name_eng     tb_item.i_name_eng%type;
    vi_name_kor     tb_item.i_name_kor%type;
    vis_gprice      tb_itemsize.is_gprice%type;
    vc_id           tb_category.c_id%type;
    vc_main         tb_category.c_main%type;
    vc_sub          tb_category.c_sub%type;
    vbp_check       NUMBER;
    vmatching_cnt   NUMBER;
    
    CURSOR cs_item IS
        SELECT i_id, i_image, i_brand, i_name_eng, i_name_kor
        FROM tb_item;
BEGIN
    OPEN cs_item;
    
    LOOP
        FETCH cs_item INTO vi_id, vi_image, vi_brand, vi_name_eng, vi_name_kor;
        EXIT WHEN cs_item%NOTFOUND;
        
        SELECT MIN(is_gprice) INTO vis_gprice FROM tb_itemsize a JOIN tb_item b ON a.i_id = vi_id;
        SELECT COUNT(mat_id) INTO vmatching_cnt FROM tb_matching WHERE i_id = vi_id;
        SELECT c_id INTO vc_id FROM tb_item WHERE i_id = vi_id; 
        SELECT c_main INTO vc_main FROM tb_category WHERE c_id = vc_id;
        SELECT c_sub INTO vc_sub FROM tb_category WHERE c_id = vc_id;
        -- 빠른 배송 체크
        SELECT COUNT(*) INTO vbp_check
        FROM tb_bpanitem WHERE i_id = vi_id;
        
        IF pdelivtype = '빠른 배송' AND vbp_check = 0 THEN CONTINUE; END IF;
        IF pcategory IS NOT NULL AND (pcategory != vc_main AND pcategory != vc_sub) THEN CONTINUE; END IF;
        DBMS_OUTPUT.PUT_LINE( '이미지 대체 텍스트, 거래수 : ' || vmatching_cnt );
        DBMS_OUTPUT.PUT_LINE( vi_brand );
        DBMS_OUTPUT.PUT_LINE( vi_name_eng );
        DBMS_OUTPUT.PUT_LINE( vi_name_kor );
--        DBMS_OUTPUT.PUT_LINE( vc_main || ', ' || vc_sub );
        
        IF NOT vbp_check = 0 THEN DBMS_OUTPUT.PUT_LINE( '빠른 배송' );
        END IF;
        
        IF vis_gprice IS NULL THEN DBMS_OUTPUT.PUT_LINE( '즉시구매가 : -' );
        ELSE DBMS_OUTPUT.PUT_LINE( '즉시구매가 : ' || vis_gprice || '원' );
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    CLOSE cs_item;
END;

EXEC up_shop_item; -- 전체 상품
EXEC up_shop_item('빠른 배송', null); -- 빠른 배송 상품
EXEC up_shop_item(null, '신발'); -- 대분류 카테고리 해당 상품
EXEC up_shop_item(null, '스니커즈'); -- 소분류 카테고리 해당 상품
EXEC up_shop_item('빠른 배송', '신발'); -- 빠른 배송이면서 신발인 상품

-- 2) 브랜드 상품
CREATE OR REPLACE PROCEDURE up_shop_branditem
(
    pcategory   IN NVARCHAR2 DEFAULT null
)
IS
    vb_id           tb_branditem.b_id%type;
    vb_image        tb_branditem.b_image%type;
    vb_brand        tb_branditem.b_brand%type;
    vb_name_eng     tb_branditem.b_name_eng%type;
    vb_name_kor     tb_branditem.b_name_kor%type;
    vb_price        tb_branditem.b_price%type;
    vc_id           tb_category.c_id%type;
    vc_main         tb_category.c_main%type;
    vc_sub          tb_category.c_sub%type;
    
    CURSOR cs_bitem IS
        SELECT b_id, b_image, b_brand, b_name_eng, b_name_kor, b_price
        FROM tb_branditem;
BEGIN
    OPEN cs_bitem;
    
    LOOP
        FETCH cs_bitem INTO vb_id, vb_image, vb_brand, vb_name_eng, vb_name_kor, vb_price;
        EXIT WHEN cs_bitem%NOTFOUND;
        
        SELECT c_id INTO vc_id FROM tb_branditem WHERE b_id = vb_id; 
        SELECT c_main INTO vc_main FROM tb_category WHERE c_id = vc_id;
        SELECT c_sub INTO vc_sub FROM tb_category WHERE c_id = vc_id;
        
        IF pcategory IS NOT NULL AND (pcategory != vc_main AND pcategory != vc_sub) THEN CONTINUE; END IF;
        DBMS_OUTPUT.PUT_LINE( '이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE( vb_brand );
        DBMS_OUTPUT.PUT_LINE( vb_name_eng );
        DBMS_OUTPUT.PUT_LINE( vb_name_kor );
        DBMS_OUTPUT.PUT_LINE( '브랜드 배송' );
        
        IF vb_price IS NULL THEN DBMS_OUTPUT.PUT_LINE( '구매가 : -' );
        ELSE DBMS_OUTPUT.PUT_LINE( '구매가 : ' || vb_price || '원' );
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    CLOSE cs_bitem;
END;

EXEC up_shop_branditem;
EXEC up_shop_branditem('의류'); -- 대분류 카테고리 별 브랜드 상품
EXEC up_shop_branditem('자켓'); -- 소분류 카테고리 별 브랜드 상품

-- 3) ****샵 전체 출력(선택에 따라 다른 출력)****
CREATE OR REPLACE PROCEDURE up_shop_list
(
    pdelivtype     NVARCHAR2 DEFAULT null
    , pcategory    NVARCHAR2 DEFAULT null
)
IS
BEGIN
    IF pdelivtype = '브랜드 배송' THEN up_shop_branditem(pcategory);
    ELSIF pdelivtype = '빠른 배송' THEN up_shop_item(pdelivtype, pcategory);
    ELSE
    up_shop_item(pdelivtype, pcategory);
    up_shop_branditem(pcategory);
    END IF;
END;

EXEC up_shop_list;
EXEC up_shop_list(null, '자켓'); -- 상품+브랜드상품 중 자켓 카테고리에 속한 상품 출력

--3. 관심 상품 등록
--xxxx관심 상품 등록 시 해당 상품의 총 관심수 증가하는 트리거 생성... 하려했으나 잘 안돼서 포기... 나중에 다시 해보자
CREATE OR REPLACE TRIGGER ut_inter
BEFORE
INSERT ON tb_interest
FOR EACH ROW
DECLARE
    vi_interest_cnt     tb_item.i_interest_cnt%type;
BEGIN
    SELECT i_interest_cnt+1 INTO vi_interest_cnt FROM tb_item;
    INSERT INTO tb_item (i_interest_cnt) VALUES(vi_interest_cnt);
END;
DROP TRIGGER ut_inter;
--xxxxxxxxx
------------------------
-- 시퀀스 생성
CREATE SEQUENCE us_inter
INCREMENT BY 1
START WITH 12;

--  1) 상품 관심 등록
CREATE OR REPLACE PROCEDURE up_item_interest_print
(
    pi_id       tb_item.i_id%type
)
IS
    vs_size     tb_size.s_size%type;
    
    CURSOR cs_size IS
        SELECT s_size 
        FROM tb_size a 
        WHERE a.s_id IN (SELECT b.s_id FROM tb_itemsize b WHERE i_id = pi_id);
BEGIN
    DBMS_OUTPUT.PUT_LINE('해당 상품의 유효 사이즈 : ');
    OPEN cs_size;
    LOOP
        FETCH cs_size INTO vs_size;
        EXIT WHEN cs_size%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_size);
    END LOOP;
    CLOSE cs_size;
END;

CREATE OR REPLACE PROCEDURE up_item_interest
(
    pm_email      tb_member.m_email%type
    , pi_id       tb_item.i_id%type
    , pput_size   VARCHAR2
)
IS
BEGIN
    INSERT  INTO tb_interest(inter_id, m_email, i_id, inter_size) 
            VALUES(us_inter.nextval, pm_email, pi_id, pput_size );
            
    UPDATE tb_item
    SET i_interest_cnt = i_interest_cnt +1
    WHERE i_id = pi_id;
END;

EXEC up_item_interest_print(1); -- 해당 상품의 유효 사이즈 출력
EXEC up_item_interest('lklk9803@gmail.com', 1, '&put_size'); -- 사이즈를 선택하여 상품 관심 추가
SELECT * FROM tb_interest;
SELECT i_interest_cnt FROM tb_item WHERE i_id = 1;

--  2) 브랜드 상품 관심 등록
CREATE OR REPLACE PROCEDURE up_bitem_interest_print
(
    pb_id       tb_branditem.b_id%type
)
IS
    vs_size     tb_size.s_size%type;
    
    CURSOR cs_bsize IS
        SELECT s_size 
        FROM tb_size a 
        WHERE a.s_id IN (SELECT b.s_id FROM tb_brandsize b WHERE b_id = pb_id);
BEGIN
    DBMS_OUTPUT.PUT_LINE('해당 상품의 유효 사이즈 : ');
    OPEN cs_bsize;
    LOOP
        FETCH cs_bsize INTO vs_size;
        EXIT WHEN cs_bsize%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_size);
    END LOOP;
    CLOSE cs_bsize;
END;
CREATE OR REPLACE PROCEDURE up_bitem_interest
(
    pm_email      tb_member.m_email%type
    , pb_id       tb_branditem.b_id%type
    , pput_size   VARCHAR2
)
IS
BEGIN
    INSERT  INTO tb_interest(inter_id, m_email, b_id, inter_size) 
            VALUES(us_inter.nextval, pm_email, pb_id, pput_size );
            
    UPDATE tb_branditem
    SET b_interest_cnt = b_interest_cnt +1
    WHERE b_id = pb_id;
END;

EXEC up_bitem_interest_print(1); -- 해당 상품의 유효 사이즈 출력
EXEC up_bitem_interest('lklk9803@gmail.com', 1, '&put_size'); -- 사이즈를 선택하여 상품 관심 추가
SELECT * FROM tb_interest;
SELECT b_interest_cnt FROM tb_branditem WHERE b_id = 1;

--4. 빠른배송/일반배송 상품 상세정보
--  1) 시세
CREATE OR REPLACE PROCEDURE up_item_info_mc
(
    pi_id       tb_item.i_id%type
    , pmonth    NUMBER
)
IS
    vmat_id         tb_matching.mat_id%type;
    vmat_price      tb_matching.mat_price%type;
    vmat_date       tb_matching.mat_date%type;        
BEGIN
    DBMS_OUTPUT.PUT_LINE('시세 조회 기간 : ' || pmonth || '개월');
        
    --날짜 별 제일 마지막 데이터
    FOR i IN 1..pmonth*30
    LOOP    
        SELECT mat_id, mat_price, mat_date INTO vmat_id, vmat_price, vmat_date
        FROM(
            SELECT mat_id, mat_price, mat_date, DENSE_RANK() OVER(ORDER BY mat_id DESC) rnk2
            FROM (
                SELECT mat_id, mat_price, mat_date, DENSE_RANK() OVER (ORDER BY mat_date DESC) rnk
                FROM tb_matching
                WHERE i_id = pi_id
            )
            WHERE rnk = i
        )
        WHERE rnk2 = 1;
        
        IF vmat_id IS NULL THEN CONTINUE; END IF;
        DBMS_OUTPUT.PUT_LINE( TO_CHAR(vmat_date, 'YYYY/MM/DD') || ' - ' || vmat_price || '원');
    
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN vmat_id := null;
END;
EXEC up_item_info_mc(1, 3); -- 아이템 번호, 개월 수

--  2) 체결거래/판매입찰/구매입찰
CREATE OR REPLACE PROCEDURE up_item_info_mc2
(
    pi_id       tb_item.i_id%type
    , pn        NUMBER
)
IS
--    vmat_id         tb_matching.mat_id%type;
    vpbid_id        tb_matching.pbid_id%type;
    vgbid_id        tb_matching.gbid_id%type;
    vmat_fast_deliv tb_matching.mat_fast_deliv%type;
    vmat_size       tb_matching.mat_size%type;
    vmat_price      tb_matching.mat_price%type;
    vmat_date       tb_matching.mat_date%type;
    vpbid_size      tb_panmaebid.pbid_size%type;
    vpbid_price     tb_panmaebid.pbid_price%type;
    vpbid_keepcheck tb_panmaebid.pbid_keepcheck%type;
    vpbid_count     NUMBER;
    vgbid_size      tb_gumaebid.gbid_size%type;
    vgbid_price     tb_gumaebid.gbid_price%type;
    vgbid_count     NUMBER;
    
    CURSOR cs_item_mc1 IS
        SELECT mat_fast_deliv, mat_size, mat_price, TO_CHAR(mat_date, 'YY/MM/DD')
        FROM tb_matching
        WHERE i_id = pi_id
        ORDER BY mat_date DESC;
        
    CURSOR cs_item_mc2 IS
        SELECT pbid_size, pbid_price, pbid_keepcheck, COUNT(pbid_id)
        FROM (
            SELECT pbid_id, i_id, pbid_size, pbid_price, pbid_keepcheck
            FROM tb_panmaebid
            ORDER BY pbid_rdate DESC
        )
        WHERE i_id = pi_id
        GROUP BY pbid_size, pbid_price, pbid_keepcheck;
        
    CURSOR cs_item_mc3 IS
        SELECT gbid_size, gbid_price, COUNT(gbid_id)
        FROM (
            SELECT gbid_id, i_id, gbid_size, gbid_price
            FROM tb_gumaebid
            ORDER BY gbid_rdate DESC
        )
        WHERE i_id = pi_id
        GROUP BY gbid_size, gbid_price;
BEGIN
    CASE    WHEN pn = 1 THEN 
                DBMS_OUTPUT.PUT_LINE( '체결 거래' || CHR(10) || '사이즈' || CHR(9) || '거래가' || CHR(9) || CHR(9) || '거래일' );
            WHEN pn = 2 THEN
                DBMS_OUTPUT.PUT_LINE( '판매 입찰' || CHR(10) || '사이즈' || CHR(9) || '판매 희망가' || CHR(9) || '수량' );
            WHEN pn = 3 THEN 
                DBMS_OUTPUT.PUT_LINE( '구매 입찰' || CHR(10) || '사이즈' || CHR(9) || '구매 희망가' || CHR(9) || '수량' );
    END CASE;
    
    IF pn = 1 THEN
        OPEN cs_item_mc1;
        LOOP
            FETCH cs_item_mc1 INTO vmat_fast_deliv, vmat_size, vmat_price, vmat_date;
            EXIT WHEN cs_item_mc1%NOTFOUND;
            
            DBMS_OUTPUT.PUT( vmat_size || CHR(9) || CHR(9) || vmat_price );
            IF vmat_fast_deliv = 1 THEN DBMS_OUTPUT.PUT('(O)'); 
            ELSE DBMS_OUTPUT.PUT( CHR(9) );
            END IF;
            DBMS_OUTPUT.PUT_LINE( CHR(9) || vmat_date );
        END LOOP;
        CLOSE cs_item_mc1;
    ELSIF pn = 2 THEN
        OPEN cs_item_mc2;
        LOOP
            FETCH cs_item_mc2 INTO vpbid_size, vpbid_price, vpbid_keepcheck, vpbid_count;
            EXIT WHEN cs_item_mc2%NOTFOUND;
            
            DBMS_OUTPUT.PUT( vpbid_size || CHR(9) || CHR(9) || vpbid_price );
            IF vpbid_keepcheck = 1 THEN DBMS_OUTPUT.PUT('(O)'); 
            ELSE DBMS_OUTPUT.PUT( CHR(9) );
            END IF;
            DBMS_OUTPUT.PUT_LINE( CHR(9) || vpbid_count );
        END LOOP;
        CLOSE cs_item_mc2;
    ELSIF pn = 3 THEN
        OPEN cs_item_mc3;
        LOOP
            FETCH cs_item_mc3 INTO vgbid_size, vgbid_price, vgbid_count;
            EXIT WHEN cs_item_mc3%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE( vgbid_size || CHR(9) || CHR(9) || vgbid_price || CHR(9) || CHR(9) || vgbid_count);
        END LOOP;
        CLOSE cs_item_mc3;
    ELSE DBMS_OUTPUT.PUT_LINE('파라미터 값이 잘못되었습니다.');
    END IF;
END;
EXEC up_item_info_mc2(1, 1); -- 체결거래
EXEC up_item_info_mc2(1, 2); -- 판매 입찰
EXEC up_item_info_mc2(1, 3); -- 구매 입찰

--  3) 95점 추천 상품
CREATE OR REPLACE PROCEDURE up_95item_recom
(
    pi_id       tb_item.i_id%type
)
IS
    vi95_image  tb_95item.i95_image%type;
    vpbid_size  tb_panmaebid.pbid_size%type;
    vi_name_eng tb_item.i_name_eng%type;
    vi95_price  tb_95item.i95_price%type;
    vcount      NUMBER;
    
    CURSOR cs_95i_r IS
        SELECT i95_image, pbid_size, i_name_eng, i95_price
        FROM tb_95item a JOIN tb_panmaebid b ON a.i_id = b.i_id AND a.pbid_id = b.pbid_id
                         JOIN tb_item c ON a.i_id = c.i_id
        WHERE a.i_id = pi_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE( '---95점 추천 상품---' );
    vcount := 0;
    
    OPEN cs_95i_r;
    LOOP
        FETCH cs_95i_r INTO vi95_image, vpbid_size, vi_name_eng, vi95_price;
        EXIT WHEN cs_95i_r%NOTFOUND OR vcount>=5;
        
        DBMS_OUTPUT.PUT_LINE('95점 상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vpbid_size);
        DBMS_OUTPUT.PUT_LINE(vi_name_eng);
        DBMS_OUTPUT.PUT_LINE('빠른 배송');
        DBMS_OUTPUT.PUT_LINE(vi95_price||'원');
        DBMS_OUTPUT.PUT_LINE('95점 구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_95i_r;
END;

EXEC up_95item_recom(1);

--  4) 빠른배송 추천 상품
CREATE OR REPLACE PROCEDURE up_deliv_recom
IS
    vi_image    tb_item.i_image%type;
    vi_brand    tb_item.i_brand%type;
    vi_name_eng tb_item.i_name_eng%type;    
    vis_gprice  tb_itemsize.is_gprice%type;
    vcount      NUMBER;
    
    CURSOR cs_deliv_r IS
        SELECT i_image, i_brand, i_name_eng, is_gprice
        FROM (
            SELECT i_image, i_brand, i_name_eng, is_gprice, DENSE_RANK() OVER(ORDER BY is_gprice) rnk
            FROM tb_item a JOIN tb_itemsize b ON a.i_id = b.i_id
            WHERE i_bpcheck = 1 AND is_gprice IS NOT NULL
        )
        WHERE rnk = 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE( '---빠른배송 추천 상품---' );
    vcount := 0;
    
    OPEN cs_deliv_r;
    LOOP
        FETCH cs_deliv_r INTO vi_image, vi_brand, vi_name_eng, vis_gprice;
        EXIT WHEN cs_deliv_r%NOTFOUND OR vcount>=5;
        
        DBMS_OUTPUT.PUT_LINE('빠른배송 상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vi_brand);
        DBMS_OUTPUT.PUT_LINE(vi_name_eng);
        DBMS_OUTPUT.PUT_LINE('빠른 배송');
        DBMS_OUTPUT.PUT_LINE(vis_gprice || '원');
        DBMS_OUTPUT.PUT_LINE('즉시 구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_deliv_r;
END;
EXEC up_deliv_recom;

--  5) 같은 브랜드의 다른 상품
CREATE OR REPLACE PROCEDURE up_brand_recom
(
    pi_id       tb_item.i_id%type
)
IS
    vi_id       tb_item.i_id%type;
    vi_image    tb_item.i_image%type;
    vi_brand    tb_item.i_brand%type;
    vi_name_eng tb_item.i_name_eng%type;
    vi_bpcheck  tb_item.i_bpcheck%type;
    vis_gprice  tb_itemsize.is_gprice%type;
    vcount      NUMBER;
    
    CURSOR cs_b_r IS
        SELECT i_id, i_image, i_brand, i_name_eng, i_bpcheck
        FROM tb_item
        WHERE i_brand = ( SELECT i_brand
                          FROM tb_item
                          WHERE i_id = pi_id );
BEGIN
    SELECT i_brand INTO vi_brand
    FROM tb_item
    WHERE i_id = pi_id;
    
    DBMS_OUTPUT.PUT_LINE( '---' || vi_brand || '의 다른 상품---' );
    
    vcount := 0;
    
    OPEN cs_b_r;
    LOOP
        FETCH cs_b_r INTO vi_id, vi_image, vi_brand, vi_name_eng, vi_bpcheck;
        EXIT WHEN cs_b_r%NOTFOUND OR vcount>=5;
        
        BEGIN
            SELECT is_gprice INTO vis_gprice
            FROM (
                SELECT is_id, is_gprice, DENSE_RANK() OVER(ORDER BY is_gprice) rnk
                FROM tb_itemsize
                WHERE i_id = vi_id
            )
            WHERE rnk = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN vis_gprice := null;
        END;
        
        DBMS_OUTPUT.PUT_LINE('상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vi_brand);
        DBMS_OUTPUT.PUT_LINE(vi_name_eng);
        IF vi_bpcheck = 1 THEN DBMS_OUTPUT.PUT_LINE('빠른 배송'); END IF;
        IF vis_gprice IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE(vis_gprice || '원');
        ELSE DBMS_OUTPUT.PUT_LINE('-'); END IF;
        DBMS_OUTPUT.PUT_LINE('즉시 구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_b_r;
END;

EXEC up_brand_recom(1);

--  6) 상품 상세 전체 출력
CREATE OR REPLACE PROCEDURE up_item_info
(
    pi_id   tb_item.i_id%type
)
IS
    vi_image        tb_item.i_image%type;
    vi_brand        tb_item.i_brand%type;
    vi_name_eng     tb_item.i_name_eng%type;
    vi_name_kor     tb_item.i_name_kor%type;
    vmat_price      tb_matching.mat_price%type;
    vis_gprice      tb_itemsize.is_gprice%type;
    vis_pprice      tb_itemsize.is_pprice%type;
    vi_model        tb_item.i_model%type;
    vi_rdate        tb_item.i_rdate%type;
    vi_color        tb_item.i_color%type;
    vi_realeasep    tb_item.i_realeasep%type;
    vi_bpcheck      tb_item.i_bpcheck%type;
    vinterest_cnt   NUMBER;
BEGIN
    SELECT i_image, i_brand, i_name_eng, i_name_kor, i_model, TO_CHAR(i_rdate, 'YY/MM/DD'), i_color, i_realeasep
    INTO vi_image, vi_brand, vi_name_eng, vi_name_kor, vi_model, vi_rdate, vi_color, vi_realeasep
    FROM tb_item
    WHERE i_id = pi_id;
    
    --즉시 구매가
    SELECT MIN(is_gprice) INTO vis_gprice FROM tb_itemsize a JOIN tb_item b ON a.i_id = pi_id;
    --즉시 판매가
    SELECT MIN(is_pprice) INTO vis_pprice FROM tb_itemsize a JOIN tb_item b ON a.i_id = pi_id;
    --관심 수
    SELECT COUNT(inter_id) INTO vinterest_cnt FROM tb_interest WHERE i_id = pi_id;
    --제일 최근 거래가
    SELECT mat_price INTO vmat_price 
    FROM (
        SELECT mat_price
                , DENSE_RANK() OVER(ORDER BY mat_date DESC) AS rnk 
        FROM tb_matching 
        WHERE i_id = pi_id
    )
    WHERE rnk = 1;
        
    DBMS_OUTPUT.PUT_LINE( '이미지 대체 텍스트' );
    DBMS_OUTPUT.PUT_LINE( vi_brand );
    DBMS_OUTPUT.PUT_LINE( vi_name_eng );
    DBMS_OUTPUT.PUT_LINE( vi_name_kor );
    DBMS_OUTPUT.PUT_LINE( '최근 거래가 : '|| vmat_price ||'원' );
    DBMS_OUTPUT.PUT_LINE( '즉시 구매가 : '|| vis_gprice ||'원' );
    DBMS_OUTPUT.PUT_LINE( '즉시 판매가 : '|| vis_pprice ||'원' );
    DBMS_OUTPUT.PUT_LINE( '관심 상품 수 : '|| vinterest_cnt );
    DBMS_OUTPUT.PUT_LINE( '-------상품 정보-------');
    DBMS_OUTPUT.PUT_LINE( '모델 번호 : ' || vi_model );
    DBMS_OUTPUT.PUT_LINE( '출시일 : ' || vi_rdate );
    DBMS_OUTPUT.PUT_LINE( '컬러 : ' || vi_color );
    DBMS_OUTPUT.PUT_LINE( '발매가 : ' || vi_realeasep );
    DBMS_OUTPUT.PUT_LINE( '배송 정보 : ');
    IF vi_bpcheck = 1 THEN DBMS_OUTPUT.PUT_LINE( '    빠른 배송 5000원' ); END IF;
    DBMS_OUTPUT.PUT_LINE( '    일반 배송 3000원' );
    DBMS_OUTPUT.PUT_LINE( '    창고보관 첫 30일 무료' );
    DBMS_OUTPUT.PUT_LINE( '-----------------------' );
    DBMS_OUTPUT.PUT_LINE('');
    up_item_info_mc(pi_id, 12);
    DBMS_OUTPUT.PUT_LINE('');
    up_item_info_mc2(pi_id, 1);
    DBMS_OUTPUT.PUT_LINE('');
    up_95item_recom(pi_id);
    up_deliv_recom;
    up_brand_recom(pi_id);
END;

EXEC UP_ITEM_INFO(1);

--5. 브랜드 상품 상세정보
--  1) 브랜드배송 추천 상품
CREATE OR REPLACE PROCEDURE up_bdeliv_recom
IS
    vb_image    tb_branditem.b_image%type;
    vb_brand    tb_branditem.b_brand%type;
    vb_name_eng tb_branditem.b_name_eng%type;    
    vb_price    tb_branditem.b_price%type;
    vcount      NUMBER;
    
    CURSOR cs_bdeliv_r IS
        SELECT b_image, b_brand, b_name_eng, b_price
        FROM tb_branditem;
BEGIN
    DBMS_OUTPUT.PUT_LINE( '---브랜드배송 추천 상품---' );
    vcount := 0;
    
    OPEN cs_bdeliv_r;
    LOOP
        FETCH cs_bdeliv_r INTO vb_image, vb_brand, vb_name_eng, vb_price;
        EXIT WHEN cs_bdeliv_r%NOTFOUND OR vcount>=5;
        
        DBMS_OUTPUT.PUT_LINE('브랜드배송 상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vb_brand);
        DBMS_OUTPUT.PUT_LINE(vb_name_eng);
        DBMS_OUTPUT.PUT_LINE('브랜드배송');
        DBMS_OUTPUT.PUT_LINE(vb_price || '원');
        DBMS_OUTPUT.PUT_LINE('구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_bdeliv_r;
END;

--  2) 같은 브랜드의 다른 상품 추천
CREATE OR REPLACE PROCEDURE up_brand_recom2
(
    pb_id       tb_branditem.b_id%type
)
IS
    vb_image    tb_branditem.b_image%type;
    vb_brand    tb_branditem.b_brand%type;
    vb_name_eng tb_branditem.b_name_eng%type;
    vb_price    tb_branditem.b_price%type;
    vcount      NUMBER;
    
    CURSOR cs_b_r2 IS
        SELECT b_image, b_brand, b_name_eng, b_price
        FROM tb_branditem
        WHERE b_brand = ( SELECT b_brand
                          FROM tb_branditem
                          WHERE b_id = pb_id );
BEGIN
    SELECT b_brand INTO vb_brand
    FROM tb_branditem
    WHERE b_id = pb_id;
    
    vcount := 0;
    
    DBMS_OUTPUT.PUT_LINE( '---' || vb_brand || '의 다른 상품---' );
    
    OPEN cs_b_r2;
    LOOP
        FETCH cs_b_r2 INTO vb_image, vb_brand, vb_name_eng, vb_price;
        EXIT WHEN cs_b_r2%NOTFOUND OR vcount>=5;
        
        DBMS_OUTPUT.PUT_LINE('브랜드상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vb_brand);
        DBMS_OUTPUT.PUT_LINE(vb_name_eng);
        DBMS_OUTPUT.PUT_LINE('브랜드배송');
        DBMS_OUTPUT.PUT_LINE('즉시 구매가');
        DBMS_OUTPUT.PUT_LINE(vb_price || '원');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_b_r2;
END;

--  3) 브랜드 상품상세 전체출력
CREATE OR REPLACE PROCEDURE up_branditem_info
(
    pb_id   tb_branditem.b_id%type
)
IS
    vbs_crn         tb_branditem.bs_crn%type;
    vb_image        tb_branditem.b_image%type;
    vb_brand        tb_branditem.b_brand%type;
    vb_name_eng     tb_branditem.b_name_eng%type;
    vb_name_kor     tb_branditem.b_name_kor%type;
    vb_price        tb_branditem.b_price%type;
    vinterest_cnt   NUMBER;
    
    vb_detail       tb_branditem.b_detail%type;
    
    vbs_name        tb_brandseller.bs_name%type;
    vbs_mon         tb_brandseller.bs_mon%type;
    vbs_rep         tb_brandseller.bs_rep%type;
    vbs_address     tb_brandseller.bs_address%type;
    vbs_service     tb_brandseller.bs_service%type;
    
    vb_type         tb_branditem.b_type%type;
    vb_material     tb_branditem.b_material%type;
    vb_color        tb_branditem.b_color%type;
    vb_size         tb_branditem.b_size%type;
    vb_manuf        tb_branditem.b_manuf%type;
    vb_country      tb_branditem.b_country%type;
    vb_warning      tb_branditem.b_warning%type;
    vb_guarantee    tb_branditem.b_guarantee%type;
    vb_as           tb_branditem.b_as%type;
BEGIN
    SELECT bs_crn, b_image, b_brand, b_name_eng, b_name_kor, b_price, b_detail, b_type, b_material, b_color, b_size, b_manuf, b_country, b_warning, b_guarantee, b_as 
    INTO vbs_crn, vb_image, vb_brand, vb_name_eng, vb_name_kor, vb_price, vb_detail, vb_type, vb_material, vb_color, vb_size, vb_manuf, vb_country, vb_warning, vb_guarantee, vb_as 
    FROM tb_branditem
    WHERE b_id = pb_id;
    
    SELECT bs_name, bs_mon, bs_rep, bs_address, bs_service
    INTO vbs_name, vbs_mon, vbs_rep, vbs_address, vbs_service
    FROM tb_brandseller
    WHERE bs_crn = vbs_crn;
    
    --관심 수
    SELECT COUNT(inter_id) INTO vinterest_cnt FROM tb_interest WHERE b_id = pb_id;
    
    DBMS_OUTPUT.PUT_LINE( '이미지 대체 텍스트' );
    DBMS_OUTPUT.PUT_LINE( vb_brand );
    DBMS_OUTPUT.PUT_LINE( vb_name_eng );
    DBMS_OUTPUT.PUT_LINE( vb_name_kor );
    DBMS_OUTPUT.PUT_LINE( '구매가 : ' || vb_price || '원');
    DBMS_OUTPUT.PUT_LINE( '관심 상품 수 : '|| vinterest_cnt );
    DBMS_OUTPUT.PUT_LINE( '배송 정보 :' || CHR(10) || '    브랜드배송' || CHR(10) );
    DBMS_OUTPUT.PUT_LINE( '-------브랜드 상품 정보-------');
    DBMS_OUTPUT.PUT_LINE( vb_detail );
    DBMS_OUTPUT.PUT_LINE( '-------판매자 정보-------');
    DBMS_OUTPUT.PUT_LINE( '상호명 : ' || vbs_name );
    DBMS_OUTPUT.PUT_LINE( '사업자등록번호 : ' || vbs_crn );
    DBMS_OUTPUT.PUT_LINE( '통신판매업번호 : ' || vbs_mon );
    DBMS_OUTPUT.PUT_LINE( '대표자 : ' || vbs_rep);
    DBMS_OUTPUT.PUT_LINE( '사업장 소재지 : ' || vbs_address);
    DBMS_OUTPUT.PUT_LINE( '고객센터 : ' || vbs_service);
    DBMS_OUTPUT.PUT_LINE( '-------상품정보제공 고시-------');
    IF vb_type IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE( '종류 : ' || vb_type); 
    ELSIF vb_material IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE( '소재 : ' || vb_material);
    ELSIF vb_color IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE( '색상 : ' || vb_color);
    END IF;
    DBMS_OUTPUT.PUT_LINE( '크기/치수 : ' || vb_size );
    DBMS_OUTPUT.PUT_LINE( '제조사/수입자 : ' || vb_manuf );
    DBMS_OUTPUT.PUT_LINE( '제조국 : ' || vb_country );
    DBMS_OUTPUT.PUT_LINE( '취급시 주의사항 : ' || vb_warning );
    DBMS_OUTPUT.PUT_LINE( '품질보증기준 : ' || vb_guarantee );
    DBMS_OUTPUT.PUT_LINE( 'AS 책임자와 전화번호 : ' || vb_as );
    DBMS_OUTPUT.PUT_LINE( '-----------------------------' );
    up_bdeliv_recom;
    up_brand_recom2(pb_id);
END;

EXEC up_branditem_info(1);

--6. 95점 상품 상세정보
--  1) 95점 동일 상품
CREATE OR REPLACE PROCEDURE up_95_same_recom
(
    pi_id           tb_item.i_id%type
)
IS
    vi95_id         tb_95item.i95_id%type;
    vpbid_id        tb_95item.pbid_id%type;
    vi95_image      tb_95item.i95_image%type;
    vpbid_size      tb_panmaebid.pbid_size%type;
    vi_name_eng     tb_item.i_name_eng%type;
    vi95_price      tb_95item.i95_price%type;
    vcount          NUMBER;
    
    CURSOR cs_95_s_r IS
        SELECT i95_id, pbid_id, i95_image, i95_price
        FROM tb_95item
        WHERE i_id = pi_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE( '---95점 동일 상품---' );
    vcount := 0;
    
    OPEN cs_95_s_r;
    LOOP
        FETCH cs_95_s_r INTO vi95_id, vpbid_id, vi95_image, vi95_price;
        EXIT WHEN cs_95_s_r%NOTFOUND OR vcount>=5;
        
        SELECT pbid_size INTO vpbid_size
        FROM tb_panmaebid
        WHERE pbid_id = vpbid_id;
        
        SELECT i_name_eng INTO vi_name_eng
        FROM tb_item
        WHERE i_id = pi_id;
        
        DBMS_OUTPUT.PUT_LINE('95점 상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vpbid_size);
        DBMS_OUTPUT.PUT_LINE(vi_name_eng);
        DBMS_OUTPUT.PUT_LINE('빠른배송');
        DBMS_OUTPUT.PUT_LINE(vi95_price || '원');
        DBMS_OUTPUT.PUT_LINE('95점 구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_95_s_r;
END;

--  2) 95점 추천 상품
CREATE OR REPLACE PROCEDURE up_95item_list_recom
IS
    vi95_image      tb_95item.i95_image%type;
    vpbid_size      tb_panmaebid.pbid_size%type;
    vi_name_eng     tb_item.i_name_eng%type;
    vi95_price      tb_95item.i95_price%type;
    vcount          NUMBER;
    
    CURSOR cs_95il_r IS
        SELECT i95_image, pbid_size, i_name_eng, i95_price
        FROM tb_95item a JOIN tb_panmaebid b ON a.i_id = b.i_id AND a.pbid_id = b.pbid_id
                         JOIN tb_item c ON a.i_id = c.i_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE( '---95점 추천 상품---' );
    vcount := 0;
    
    OPEN cs_95il_r;
    LOOP
        FETCH cs_95il_r INTO vi95_image, vpbid_size, vi_name_eng, vi95_price;
        EXIT WHEN cs_95il_r%NOTFOUND OR vcount>=5;
        
        DBMS_OUTPUT.PUT_LINE('95점 상품 이미지 대체 텍스트');
        DBMS_OUTPUT.PUT_LINE(vpbid_size);
        DBMS_OUTPUT.PUT_LINE(vi_name_eng);
        DBMS_OUTPUT.PUT_LINE('빠른 배송');
        DBMS_OUTPUT.PUT_LINE(vi95_price||'원');
        DBMS_OUTPUT.PUT_LINE('95점 구매가');
        DBMS_OUTPUT.PUT_LINE('');
        
        vcount := vcount + 1;
    END LOOP;
    CLOSE cs_95il_r;
END;

--  3) 95점 상품상세 전체출력
CREATE OR REPLACE PROCEDURE up_95item_info
(
    pi95_id         tb_95item.i95_id%type
)
IS
    vi_id           tb_95item.i_id%type;
    vpbid_id        tb_95item.pbid_id%type;
    vi95_image      tb_95item.i95_image%type;
    vpbid_size      tb_panmaebid.pbid_size%type;
    vi_name_eng     tb_item.i_name_eng%type;
    vi_name_kor     tb_item.i_name_kor%type;
    vi95_price      tb_95item.i95_price%type;
    vi_model        tb_item.i_model%type;
    vi95_date       tb_95item.i95_date%type;
BEGIN
    SELECT i_id, pbid_id, i95_image, i95_price, i95_date
    INTO vi_id, vpbid_id, vi95_image, vi95_price, vi95_date
    FROM tb_95item
    WHERE i95_id = pi95_id;
    
    SELECT pbid_size
    INTO vpbid_size
    FROM tb_panmaebid
    WHERE pbid_id = vpbid_id;
    
    SELECT i_name_eng, i_name_kor, i_model
    INTO vi_name_eng, vi_name_kor, vi_model
    FROM tb_item
    WHERE i_id = vi_id;
   
    DBMS_OUTPUT.PUT_LINE( '이미지 대체 텍스트' );
    DBMS_OUTPUT.PUT_LINE( vpbid_size );
    DBMS_OUTPUT.PUT_LINE( vi_name_eng );
    DBMS_OUTPUT.PUT_LINE( vi_name_kor );
    DBMS_OUTPUT.PUT_LINE( '95점 구매가 : ' || vi95_price || '원');
    DBMS_OUTPUT.PUT_LINE( '배송 정보 :' || CHR(10) || '    빠른배송' || CHR(10) || '    창고보관' || CHR(10) );
    DBMS_OUTPUT.PUT_LINE( '-------95점 검수 리뷰-------');
    DBMS_OUTPUT.PUT_LINE( vi_model );
    DBMS_OUTPUT.PUT_LINE( vi_name_eng );
    DBMS_OUTPUT.PUT_LINE( vi_name_kor );
    DBMS_OUTPUT.PUT_LINE( '검수 결과 : 95점 합격' );
    DBMS_OUTPUT.PUT_LINE( '검수 일시 : ' || TO_CHAR(vi95_date, 'YY/MM/DD') || CHR(10) );
    
    up_95_same_recom(vi_id);
    up_95item_list_recom;
END;

EXEC up_95item_info(1);


----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
--[SHOP]
--SHOP 페이지 카테고리 목록 출력
EXEC up_shop_maincategory;

--선택에 따른 SHOP상품 목록 출력(배송 종류, 카테고리)
EXEC up_shop_list; -- 전체 상품
EXEC up_shop_list(null, '자켓'); -- 상품+브랜드상품 중 자켓 카테고리에 속한 상품 출력
EXEC up_shop_list('빠른 배송', '신발');
EXEC up_shop_list('브랜드 배송', '자켓');

--관심 상품 추가(이메일, i_id or b_id, 사이즈)
EXEC up_item_interest_print(1); -- i_id가 1인 상품의 유효 사이즈 출력
EXEC up_item_interest('lklk9803@gmail.com', 1, '&put_size'); -- 사이즈를 선택하여 i_id가 1인 상품을 관심 목록에 추가
SELECT * FROM tb_interest; -- 추가되었는지 확인

EXEC up_bitem_interest_print(1); -- b_id가 1인 상품의 유효 사이즈 출력
EXEC up_bitem_interest('lklk9803@gmail.com', 1, '&put_size'); -- 사이즈를 선택하여 b_id가 1인 상품을 관심 목록에 추가
SELECT * FROM tb_interest; -- 추가되었는지 확인


--[ 빠른배송/일반배송 상품 상세정보 ]
-- i_id로 제일 처음 화면 출력(시세는 12개월, 체결거래)
EXEC UP_ITEM_INFO(1);
-- i_id와 개월수로 시세 확인
EXEC up_item_info_mc(1, 3);
-- i_id와 분류별로 거래 확인
EXEC up_item_info_mc2(1, 1); -- 체결거래
EXEC up_item_info_mc2(1, 2); -- 판매 입찰
EXEC up_item_info_mc2(1, 3); -- 구매 입찰


--[ 브랜드 상품 상세정보 ]
-- b_id로 화면 출력
EXEC up_branditem_info(1);


--[ 95점 상품 상세정보 ]
-- i95_id로 화면 출력
EXEC up_95item_info(1);