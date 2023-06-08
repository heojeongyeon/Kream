<프로필 정보 창>
--프로필정보 출력 프로시저
CREATE OR REPLACE PROCEDURE 프로필정보출력
(
pemail tb_member.m_email%type
)
is
begin
FOR  vrow IN (  SELECT  *    FROM tb_member where m_email= pemail ) 
   LOOP
     DBMS_OUTPUT.PUT_LINE( '프로필 정보' );
     DBMS_OUTPUT.PUT_LINE( vrow.m_name );
     DBMS_OUTPUT.PUT_LINE( NVL(vrow.m_image, '이미지 없음')|| '[이미지 변경]' || '[삭제]' );
     DBMS_OUTPUT.PUT_LINE( '로그인 정보' );
     DBMS_OUTPUT.PUT_LINE( '이메일 : ' ||SUBSTR(vrow.m_email,0,1) 
     ||lpad('*', length(substr(vrow.m_email,INSTR(vrow.m_email, '@')))-1, '*')|| substr(vrow.m_email,INSTR(vrow.m_email, '@')-1 )  
     || '[변경]'); 
     DBMS_OUTPUT.PUT_LINE( '비밀번호 : ' || lpad('*', length(vrow.m_pw),'*') || '[변경]' );
     DBMS_OUTPUT.PUT_LINE( '개인정보' );
     DBMS_OUTPUT.PUT_LINE( '이름 : '  || vrow.m_name || '[변경]' );
     DBMS_OUTPUT.PUT_LINE( '휴대폰 번호 : '  || vrow.m_tel || '[변경]' );
     DBMS_OUTPUT.PUT_LINE( '신발 사이즈 : ' || vrow.m_size || '[변경]' );
     DBMS_OUTPUT.PUT_LINE( '광고성 정보 수신' );
     DBMS_OUTPUT.PUT_LINE( '문자 메시지 ' || vrow.m_email_agree);
     DBMS_OUTPUT.PUT_LINE( '이메일 ' || vrow.m_mail_agree);
     DBMS_OUTPUT.PUT_LINE( '[회원 탈퇴]');
   END LOOP; 
end;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- 프로필 사진 변경 프로시저 (사진주소, 이메일 받으면 사진 변경)
CREATE OR REPLACE PROCEDURE 프로필사진변경
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
-- 프로필 사진 삭제 프로시저 (이메일 받으면 사진 삭제)
CREATE OR REPLACE PROCEDURE 프로필사진삭제

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
--비밀번호 변경 프로시저
CREATE OR REPLACE PROCEDURE 비밀번호변경
(   
    pm_pw tb_member.m_pw%type -- 원래 비번
    ,pupdatepw tb_member.m_pw%type --.변경 할 비번
)
IS
vemail tb_member.m_email%type;
BEGIN
    select m_email into vemail
    from tb_member where m_email='shiueo@naver.com';
    
   IF pm_pw = pupdatepw THEN DBMS_OUTPUT.PUT_LINE( '원래 비밀번호랑 동일합니다.' );
   ELSE  update tb_member set m_pw = pupdatepw where m_email=vemail;
   DBMS_OUTPUT.PUT_LINE( '비밀번호 성공적으로 변경되었습니다.' );
   END IF;
END;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- 이름 변경하기
CREATE OR REPLACE PROCEDURE 이름변경 
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
     DBMS_OUTPUT.PUT_LINE('회원 이름이 ' || pname || '으로 변경 되었다.');
     
END;

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- 휴대폰 번호 변경 하기
CREATE OR REPLACE PROCEDURE 휴대폰번호변경 -- 회원 이메일 받으면 받은 이름으로 변경
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
     
     DBMS_OUTPUT.PUT_LINE('회원 번호가 ' || ptel || '으로 변경 되었다.');
END;

----------------------------------------------------------------------------------------------------------------------------
-- 신발 사이즈 선택사항 출력
CREATE OR REPLACE PROCEDURE  신발사이즈선택사항
IS
BEGIN
    dbms_output.put_line('사이즈선택');
  FOR vrow  IN ( SELECT * FROM TB_SIZE WHERE S_ID BETWEEN 2 AND 18)
  LOOP    
    DBMS_OUTPUT.PUT_LINE( vrow.S_SIZE );    
  END LOOP; 
END;
-- 사이즈 변경 프로시저    
CREATE OR REPLACE PROCEDURE 신발사이즈변경
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
    DBMS_OUTPUT.PUT_LINE( '사이즈가 성공적으로 변경되었습니다.' ); 
    ELSE DBMS_OUTPUT.PUT_LINE( '선택사항에 있는 사이즈를 선택해주세요.' ); 
    END IF;
END;
----------------------------------------------------------------------------------------------------------------------------
-- 광고성 정보 수신 변경
-- 1이면 수신 동의 
-- 0이면 수신 거부
CREATE OR REPLACE PROCEDURE 광고정보수신변경
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
--회원 탈퇴 약관 동의
create or replace procedure 회원탈퇴약관동의출력
is
begin
    DBMS_OUTPUT.PUT_LINE('(동의 (1) 비동의(0) )KREAM을 탈퇴하면 회원 정보 및 서비스 이용 기록이 삭제됩니다.
내 프로필, 거래내역(구매/판매), 관심상품, 보유상품, STYLE 게시물(게시물/댓글), 미사용 보유 포인트 등 사용자의 모든 정보가 사라지며 재가입 하더라도 복구가 불가능합니다.
탈퇴 14일 이내 재가입할 수 없으며, 탈퇴 후 동일 이메일로 재가입할 수 없습니다');
DBMS_OUTPUT.PUT_LINE('(동의 (1) 비동의(0) ) 후 동일 이메일로 재가입할 수 없습니다
관련 법령 및 내부 기준에 따라 별도 보관하는 경우에는 일부 정보가 보관될 수 있습니다.
1. 전자상거래 등 소비자 보호에 관한 법률
계약 또는 청약철회 등에 관한 기록: 5년 보관
대금결제 및 재화 등의 공급에 관한 기록: 5년 보관
소비자의 불만 또는 분쟁처리에 관한 기록: 3년 보관');
    DBMS_OUTPUT.PUT_LINE('(동의 (1) 비동의(0) )KREAM 탈퇴가 제한된 경우에는 아래 내용을 참고하시기 바랍니다.
진행 중인 거래(판매/구매)가 있을 경우: 해당 거래 종료 후 탈퇴 가능
진행 중인 입찰(판매/구매)가 있을 경우: 해당 입찰 삭제 후 탈퇴 가능');
    DBMS_OUTPUT.PUT_LINE('(동의 (1) 비동의(0) )회원탈퇴 안내를 모두 확인하였으며 탈퇴에 동의합니다.');
end;


-- 모두 1 체크하면 회원 삭제
create or replace procedure 회원탈퇴
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
        
        if p1 = 1 and p2 =1 and p3 =1 and p4=1 then DBMS_OUTPUT.PUT_LINE( ' shiueo@naver.com 회원탈퇴.' );
        DELETE TB_MEMBER WHERE M_EMAIL = vm_email;
        -- tb_member에 참조된 모든 테이블 삭제해보기..
        else DBMS_OUTPUT.PUT_LINE( ' shiueo@naver.com 회원유지.' ); 
        end if;
end;

----------------------------------------------------------------------------------------------------------------------------
-- 주소록 페이지 출력
CREATE OR REPLACE PROCEDURE 주소록페이지출력
(
pemail tb_member.m_email%type
)
is
begin

FOR  vrow IN (  SELECT  *    FROM tb_delivery where m_email= pemail order by d_basic desc , d_id asc) --  커서 생성
   LOOP
    if vrow.d_basic=1 then
     DBMS_OUTPUT.PUT_LINE( '주소록' );
     DBMS_OUTPUT.PUT_LINE( '[+ 새 배송지 추가]' );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_name, 0,1) || lpad('*', length(vrow.d_name)-1,'*')  || ' 기본배송지');
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_tel,0,3)||'-'||substr(vrow.d_tel,5,1)||'***-*'||substr(vrow.d_tel,11) );
     DBMS_OUTPUT.PUT_LINE( '('||vrow.d_zip||')' || vrow.d_ads ||' '|| vrow.d_detail || '[수정]  [삭제]');
     DBMS_OUTPUT.PUT_LINE( '===============================================================================' );
     elsif vrow.d_basic=0 then
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_name, 0,1) || lpad('*', length(vrow.d_name)-1,'*') );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.d_tel,0,3)||'-'||substr(vrow.d_tel,5,1)||'***-*'||substr(vrow.d_tel,11) );
     DBMS_OUTPUT.PUT_LINE( '('||vrow.d_zip||')' || vrow.d_ads ||' '|| vrow.d_detail || '[기본 배송지]  [수정]  [삭제]');
     DBMS_OUTPUT.PUT_LINE( '===============================================================================' );
     end if;
   END LOOP; 
end;

--주소추가 프로시저
CREATE OR REPLACE PROCEDURE 주소추가
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
-- 결제 정보
CREATE OR REPLACE PROCEDURE 결제정보창출력
(
pemail tb_member.m_email%type
)
is
begin

FOR  vrow IN (  SELECT  *    FROM tb_card where m_email= pemail ORDER BY C_PAY DESC) --  커서 생성
   LOOP
     IF vrow.c_pay=1 then
     DBMS_OUTPUT.PUT_LINE( '[결제 정보]         '  ||  '     [+새 카드 추가하기]' );
     DBMS_OUTPUT.PUT_LINE( substr(vrow.c_bank,0,2) || lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'|| substr(vrow.c_id, -4,3)||'*' || ' 기본 결제 ' || ' [삭제] ');
     DBMS_OUTPUT.PUT_LINE( '===================================================' );
     ELSIF vrow.c_pay=0 THEN 
     DBMS_OUTPUT.PUT_LINE( substr(vrow.c_bank,0,2) || lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'||lpad('*',4,'*')||'-'|| substr(vrow.c_id, -4,3)||'*'
     || '[기본 결제]     [삭제] ');
     END IF;
   END LOOP; 
end;

--카드 추가하기
CREATE OR REPLACE PROCEDURE 카드추가
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
--실행

----------------------------------------------------------------------------------------------------------------------------
--판매정산계좌
CREATE OR REPLACE PROCEDURE 판매정산계좌
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
    
    DBMS_OUTPUT.PUT_LINE( '[정산 계좌 변경]' );
    DBMS_OUTPUT.PUT_LINE( '등록된 계좌 정보 : ' || pbank ||' '|| substr(pnum, 0,4 ) || lpad('*', length(pnum)-4, '*')
    ||'/'
    ||substr(pname,0,1)|| lpad('*',length(pname)-1,'*'));
    
    DBMS_OUTPUT.PUT_LINE( '[은행명 : ]' );
    DBMS_OUTPUT.PUT_LINE( '[계좌번호] (-없이 입력하세요) : ' );
    DBMS_OUTPUT.PUT_LINE( '[예금주] : ' );
END;

----------------------------------------------------------------------------------------------------------------------------
--현금 영수증 정보 변경 후 출력
CREATE OR REPLACE PROCEDURE 현금영수증
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
    from tb_receipt where m_email= 'hyungjs1234@naver.com'; -- 회원 아이디
    
    DBMS_OUTPUT.PUT_LINE( '현금영수증 정보' );
    DBMS_OUTPUT.PUT_LINE( '형태 : ' );
    IF ptype='미신청' THEN 
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = NULL, R_CARDNUM =NULL WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( '[저장하기]' );
    ELSIF ptype='개인소득공제(휴대폰)' THEN
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = ptel, R_CARDNUM =NULL WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( '휴대폰번호 : '|| ptel );
    DBMS_OUTPUT.PUT_LINE( '현금영수증 신청 정보를 저장하여 자동으로 발급되는 것에 동의합니다.' ||pcheck );
    ELSIF ptype='개인소득공제(현금영수증카드)' THEN
    UPDATE tb_receipt SET R_TYPE = ptype ,R_TEL = NULL, R_CARDNUM =pcardnum WHERE M_EMAIL =vemail ;
    DBMS_OUTPUT.PUT_LINE( ptype );
    DBMS_OUTPUT.PUT_LINE( '카드번호 : '|| pcardnum );
    DBMS_OUTPUT.PUT_LINE( '현금영수증 신청 정보를 저장하여 자동으로 발급되는 것에 동의합니다.' ||pcheck );
    END IF;
END;

-----------------------------------------------------------------------------------------
--포인트 
-- 
-- 누적 포인트 적립 트리거 : TB_GPOINT에 포인트 INSERT 시 TB_MEMBER 테이블의 m_point에 추가하는 기능
CREATE OR REPLACE TRIGGER 누적포인트_적립트리거
AFTER
INSERT ON TB_GPOINT
FOR EACH ROW  
BEGIN
     UPDATE TB_MEMBER SET m_point = m_point + :NEW.gp_point WHERE M_EMAIL= :NEW.M_EMAIL;
END;
--누적 포인트 사용 트리거 : TB_SPOINT에 사용포인트 INSERT시 TB_MEMBER 테이블의 M_POINT 차감
CREATE OR REPLACE TRIGGER 누적포인트_사용트리거
AFTER
INSERT ON TB_SPOINT
FOR EACH ROW  
BEGIN
     UPDATE TB_MEMBER SET m_point = m_point - :NEW.sp_point WHERE M_EMAIL= :NEW.M_EMAIL;
END;
--사용가능 포인트 출력 프로시저
CREATE OR REPLACE PROCEDURE 사용가능포인트
(
Pemail tb_member.m_email%type
)
IS
    vpoint tb_member.m_point%type;
BEGIN 
     select  M_POINT into VPOINT
     from tb_member where m_email= Pemail;
    DBMS_OUTPUT.PUT_LINE('사용 가능한 포인트 ' || VPOINT ||'P');
END;
---------------------------------
--소멸예정 포인트 출력 프로시저
CREATE OR REPLACE PROCEDURE 소멸예정포인트
(
Pemail tb_member.m_email%type
)
IS 
vpoint_extinct tb_gpoint.gp_point%type;
BEGIN
   SELECT GP_POINT INTO vpoint_extinct 
    FROM TB_GPOINT WHERE m_email= Pemail AND (TO_CHAR(GP_DATE+ (INTERVAL '1' YEAR), 'YY/MM')) =  (TO_CHAR(SYSDATE, 'YY/MM'));
    DBMS_OUTPUT.PUT_LINE('이번달 소멸예정 포인트 ' || vpoint_extinct ||'P'  || '  [+포인트 적립하기]');                
  
END;

------------------------------------
CREATE OR REPLACE PROCEDURE 포인트삭제  -- 포인트 기간 지난거 삭제하는 프로시저.
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



--포인트 삭제 트리거(프로시저로 기간 지난 포인트 누적포인트에서 빼기)
CREATE OR REPLACE TRIGGER 누적포인트_차감트리거 
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
EXEC 프로필정보출력('회원 이메일')  
EXEC 프로필사진변경('프로필 이미지'); 
EXEC 프로필사진삭제; 
EXEC 비밀번호변경('현재 비밀번호', '변경할 비밀번호 ') 
EXEC 이름변경('바꾸고자 하는 이름명' ) 
EXEC 휴대폰번호변경('휴대폰번호 입력' )
EXEC 신발사이즈선택사항;
EXEC 신발사이즈변경('사이즈') 바꾸고자 하는 사이즈로 입력
EXEC 광고정보수신변경(이메일수신동의여부,문자동의여부); 1: 동의 0 비동의
EXEC 회원탈퇴약관동의출력;
EXEC 회원탈퇴(1,1,1,1)  1:동의 0:비동의 // 모두 1이면 회원탈퇴// 하나라도 0이면 회원유지
EXEC 주소록페이지출력('회원 이메일') 
EXEC 주소추가('이름', '전화번호', 우편번호, '주소', '상세주소', 기본배송지);  // 기본배송지 (1) // 아니면 0
EXEC 결제정보창출력('회원 이메일') 
EXEC 카드추가(카드번호,'유효기간','생년월일',비밀번호,'은행명',기본결제 여부);  // 기본결제(1) // 아니면 0
EXEC 판매정산계좌('은행명', '계좌번호', '예금주')
EXEC 현금영수증('현금영수증형태', '휴대폰번호/현금영수증카드번호/ NULL' ) '현금영수증형태' = '개인소득공제(휴대폰)' / '개인소득공제(현금영수증카드)' / '미신청'
EXEC 사용가능포인트('회원이메일');
EXEC 소멸예정포인트('회원이메일');
EXEC 포인트삭제; 실행 시 유효기간 지난 포인트 삭제

