-- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_AGENCY
(
    AGC_ID              INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '교육기관 식별자', 
    AGC_SERIAL          VARCHAR(16)       NOT NULL    COMMENT '교육기관 지정코드', 
    AGC_NAME            VARCHAR(32)       NOT NULL    COMMENT '교육기관 명칭', 
    AGC_BOSS_NAME       VARCHAR(16)       NOT NULL    COMMENT '기관장 성명', 
    AGC_BOSS_TEL        VARCHAR(13)       NOT NULL    COMMENT '기관장 연락처', 
    AGC_CORP            VARCHAR(32)       NULL        COMMENT '법인명', 
    AGC_CORP_SERIAL     VARCHAR(14)       NULL        COMMENT '법인등록번호', 
    AGC_CORP_BOSS_NAME  VARCHAR(16)       NULL        COMMENT '법인 대표 성명', 
    AGC_CORP_BOSS_TEL   VARCHAR(13)       NULL        COMMENT '법인 대표 연락처', 
    AGC_ZIP             VARCHAR(5)        NOT NULL    COMMENT '소재지 우편번호(도로명)', 
    AGC_ADDRESS         VARCHAR(64)       NOT NULL    COMMENT '소재지 주소(도로명)', 
    ACC_ID              INT(18)    NULL        COMMENT '담당자 식별자', 
    CD_AREA             INT               NULL        COMMENT '지역구분 코드', 
    ADD_DATE            DATETIME          NOT NULL    COMMENT '등록일자', 
    CHNG_DATE           DATETIME          NOT NULL    COMMENT '최종변경일자', 
    USE_YN              VARCHAR(1)        NOT NULL    COMMENT '사용여부', 
    CD_ADD_STATE        INT               NOT NULL    COMMENT '등록 상태(등록:1, 변경2, 삭제3)', 
    AGC_NOTE            VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (AGC_ID)
);

ALTER TABLE MAS_AGENCY COMMENT '교육기관 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_AGENT
(
    AGT_ID          INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '교수요원 식별자', 
    AGC_ID          INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    CD_AGT_TYPE     INT               NOT NULL    COMMENT '인력구분 코드', 
    AGT_NAME        VARCHAR(16)       NOT NULL    COMMENT '교수요원 이름', 
    AGT_BIRTHDAY    DATE              NOT NULL    COMMENT '교수요원 생년월일', 
    AGT_TEL         VARCHAR(13)       NOT NULL    COMMENT '교수요원 전화번호', 
    REQUEST_DATE    DATETIME          NOT NULL    COMMENT '최초등록신청일자', 
    APPLY_DATE      DATETIME          NULL        COMMENT '최초등록승인일자', 
    FINAL_APL_DATE  DATETIME          NULL        COMMENT '최종등록승인일자', 
    CD_ADD_STATE    INT               NOT NULL    COMMENT '등록 상태', 
    CD_CHNG_STATE   INT               NULL        COMMENT '변경 상태', 
    AGT_NOTE        VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (AGT_ID)
);

ALTER TABLE MAS_AGENT COMMENT '교수요원 마스터';


CREATE TABLE MAS_BUSINESS_PLAN
(
    PLAN_ID         INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '연간사업계획서 식별자', 
    AGC_ID          INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    PLAN_TITLE      VARCHAR(32)       NOT NULL    COMMENT '연간사업계획서 제목', 
    NATIONAL_YN     VARCHAR(1)        NOT NULL    COMMENT '국비과정 수행여부', 
    NEW_YN          VARCHAR(1)        NOT NULL    COMMENT '신규과정 수행여부', 
    CAREER_YN       VARCHAR(1)        NOT NULL    COMMENT '경력자과정 수행여부', 
    LICENSE_YN      VARCHAR(1)        NOT NULL    COMMENT '국가자격소지자과정 수행여부', 
    ADVANCE_YN      VARCHAR(1)        NOT NULL    COMMENT '승급자과정 수행여부', 
    NATIONAL_COST   INT               NULL        COMMENT '국비과정 수강료', 
    NEW_COST        INT               NULL        COMMENT '신규과정 수강료', 
    CAREER_COST     INT               NULL        COMMENT '경력자과정 수강료', 
    LICENSE_COST    INT               NULL        COMMENT '국가자격소지자과정 수강료', 
    ADVANCE_COST    INT               NULL        COMMENT '승급자과정 수강료', 
    PERSONNEL       INT               NOT NULL    COMMENT '정원', 
    REQUEST_ID      INT(18)    NOT NULL    COMMENT '최초등록자', 
    REQUEST_DATE    DATETIME          NOT NULL    COMMENT '최초등록신청일자', 
    APPLY_ID        INT(18)    NULL        COMMENT '최초등록승인자', 
    APPLY_DATE      DATETIME          NULL        COMMENT '최초등록승인일자', 
    FINAL_APL_ID    INT(18)    NULL        COMMENT '최종등록승인자', 
    FINAL_APL_DATE  DATETIME          NULL        COMMENT '최종등록승인일자', 
    CD_ADD_STATE    INT               NOT NULL    COMMENT '등록 상태', 
    CD_CHNG_STATE   INT               NULL        COMMENT '변경 상태', 
    PLAN_NOTE       VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (PLAN_ID)
);

ALTER TABLE MAS_BUSINESS_PLAN COMMENT '연간사업계획서 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE BEGIN_CLASS_LOGIC
(
    CLASS_ID             INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '개강 식별자', 
    AGC_ID               INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    WRITED_DATE          DATETIME          NOT NULL    COMMENT '작성일자', 
    WRITED_ID            INT(18)    NOT NULL    COMMENT '작성자', 
    CHNG_DATE            DATETIME          NOT NULL    COMMENT '최종변경일자', 
    CHNG_ID              INT(18)    NOT NULL    COMMENT '최종변경자', 
    CLASS_TITLE          VARCHAR(32)       NOT NULL    COMMENT '개강 제목', 
    CLASS_BEGIN_DATE     DATE              NOT NULL    COMMENT '개강 시작 일자', 
    CLASS_END_DATE       DATE              NOT NULL    COMMENT '개강 종료 일자', 
    STUDENT_TOTAL_COUNT  INT               NOT NULL    COMMENT '교육생 총원', 
    CLASS_NOTE           VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (CLASS_ID)
);

ALTER TABLE BEGIN_CLASS_LOGIC COMMENT '개강보고(이론/실기) 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_SUB_AGENCY
(
    SAGC_ID               INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '연계실습기관 식별자', 
    AGC_ID                INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    CD_FACILITY_LEV1      INT               NOT NULL    COMMENT '시설구분 코드(대)', 
    CD_FACILITY_LEV2      INT               NOT NULL    COMMENT '시설구분 코드(중)', 
    SAGC_NAME             VARCHAR(32)       NOT NULL    COMMENT '연계실습기관 명칭', 
    SAGC_ZIP              VARCHAR(5)        NOT NULL    COMMENT '소재지 우편번호(도로명)', 
    SAGC_ADDRESS          VARCHAR(64)       NOT NULL    COMMENT '소재지 주소(도로명)', 
    INSTALL_DATE          DATE              NOT NULL    COMMENT '설치 신고일', 
    SAGC_BOSS_NAME        VARCHAR(16)       NOT NULL    COMMENT '시설장 성명', 
    SAGC_BOSS_TEL         VARCHAR(13)       NOT NULL    COMMENT '시설장 연락처', 
    CONTRACT_BEGIN_DATE   DATE              NOT NULL    COMMENT '실습계약 시작일', 
    CONTRACT_END_DATE     DATE              NOT NULL    COMMENT '실습계약 종료일', 
    REQUEST_DATE          DATETIME          NOT NULL    COMMENT '최초등록신청일자', 
    APPLY_DATE            DATETIME          NULL        COMMENT '최초등록승인일자', 
    FINAL_APL_DATE        DATETIME          NULL        COMMENT '최종등록승인일자', 
    CD_ADD_STATE          INT               NOT NULL    COMMENT '등록 상태', 
    CD_CHNG_STATE         INT               NULL        COMMENT '변경 상태', 
    EVALUATION_RANK       VARCHAR(1)        NULL        COMMENT '평가등급', 
    EVALUATION_YEAR       VARCHAR(4)        NULL        COMMENT '등급판정년도', 
    MEMBER_TOTAL_COUNT    INT               NULL        COMMENT '입소자 정원', 
    MEMBER_CURRENT_COUNT  INT               NULL        COMMENT '입소자 현원', 
    STUDENT_TOTAL_COUNT   INT               NULL        COMMENT '실습 총 인원', 
    STUDENT_DAILY_COUNT   INT               NULL        COMMENT '1일 실습 인원', 
    STUDENT_DAILY_COST    INT               NULL        COMMENT '1인당 1일 실습비', 
    SAGC_NOTE             VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (SAGC_ID)
);

ALTER TABLE MAS_SUB_AGENCY COMMENT '연계실습기관 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_SUB_AGENT
(
    SAGT_ID         INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '실습지도자 식별자', 
    SAGC_ID         INT(18)    NOT NULL    COMMENT '연계실습기관 식별자', 
    CD_SAGT_TYPE    INT               NOT NULL    COMMENT '직무구분 코드', 
    SAGT_NAME       VARCHAR(16)       NOT NULL    COMMENT '실습지도자 이름', 
    SAGT_BIRTHDAY   DATE              NOT NULL    COMMENT '실습지도자 생년월일', 
    SAGT_TEL        VARCHAR(13)       NOT NULL    COMMENT '실습지도자 전화번호', 
    REQUEST_DATE    DATETIME          NOT NULL    COMMENT '최초등록신청일자', 
    APPLY_DATE      DATETIME          NULL        COMMENT '최초등록승인일자', 
    FINAL_APL_DATE  DATETIME          NULL        COMMENT '최종등록승인일자', 
    CD_ADD_STATE    INT               NOT NULL    COMMENT '등록 상태', 
    CD_CHNG_STATE   INT               NULL        COMMENT '변경 상태', 
    SAGT_NOTE       VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (SAGT_ID)
);

ALTER TABLE MAS_SUB_AGENT COMMENT '실습지도자 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE BEGIN_CLASS_PRACTICE
(
    CLASS_ID             INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '개강 식별자', 
    AGC_ID               INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    WRITED_DATE          DATETIME          NOT NULL    COMMENT '작성일자', 
    WRITED_ID            INT(18)    NOT NULL    COMMENT '작성자', 
    CHNG_DATE            DATETIME          NULL        COMMENT '최종변경일자', 
    CHNG_ID              INT(18)    NOT NULL    COMMENT '최종변경자', 
    CLASS_TITLE          VARCHAR(32)       NOT NULL    COMMENT '개강 제목', 
    CLASS_BEGIN_DATE     DATE              NOT NULL    COMMENT '개강 시작 일자', 
    CLASS_END_DATE       DATE              NOT NULL    COMMENT '개강 종료 일자', 
    STUDENT_TOTAL_COUNT  INT               NOT NULL    COMMENT '교육생 총원', 
    CLASS_NOTE           VARCHAR(256)      NULL        COMMENT '비고', 
    CD_ADD_STATE         INT               NULL        COMMENT '등록 상태(등록:1, 변경:2, 삭제:3)', 
    PRIMARY KEY (CLASS_ID)
);

ALTER TABLE BEGIN_CLASS_PRACTICE COMMENT '개강보고(실습) 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE BEGIN_CLASS_SUB_PRACTICE
(
    CLASS_ID             INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '개강 식별자', 
    AGC_ID               INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    WRITED_DATE          DATETIME          NOT NULL    COMMENT '작성일자', 
    WRITED_ID            INT(18)    NOT NULL    COMMENT '작성자', 
    CHNG_DATE            DATETIME          NULL        COMMENT '최종변경일자', 
    CHNG_ID              INT(18)    NOT NULL    COMMENT '최종변경자', 
    CLASS_TITLE          VARCHAR(32)       NOT NULL    COMMENT '개강 제목', 
    CLASS_BEGIN_DATE     DATE              NOT NULL    COMMENT '개강 시작 일자', 
    CLASS_END_DATE       DATE              NOT NULL    COMMENT '개강 종료 일자', 
    STUDENT_TOTAL_COUNT  INT               NOT NULL    COMMENT '교육생 총원', 
    CLASS_NOTE           VARCHAR(256)      NULL        COMMENT '비고', 
    CD_ADD_STATE         INT               NULL        COMMENT '등록 상태(등록:1, 변경:2, 삭제:3)', 
    PRIMARY KEY (CLASS_ID)
);

ALTER TABLE BEGIN_CLASS_SUB_PRACTICE COMMENT '개강보고(대체실습) 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE END_CLASS
(
    CLASS_ID             INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '수료 식별자', 
    AGC_ID               INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    WRITED_DATE          DATETIME          NOT NULL    COMMENT '작성일자', 
    WRITED_ID            INT(18)    NOT NULL    COMMENT '작성자', 
    CHNG_DATE            DATETIME          NOT NULL    COMMENT '최종변경일자', 
    CHNG_ID              INT(18)    NOT NULL    COMMENT '최종변경자', 
    CLASS_TITLE          VARCHAR(32)       NOT NULL    COMMENT '수료 제목', 
    END_DATE             DATE              NOT NULL    COMMENT '수료 일자', 
    STUDENT_TOTAL_COUNT  INT               NOT NULL    COMMENT '교육생 총원', 
    CLASS_NOTE           VARCHAR(256)      NULL        COMMENT '비고', 
    CD_ADD_STATE         INT               NULL        COMMENT '등록 상태(등록:1, 변경:2, 삭제:3)', 
    PRIMARY KEY (CLASS_ID)
);

ALTER TABLE END_CLASS COMMENT '수료보고 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_STUDENT
(
    STU_ID                 INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '교육생 식별자', 
    AGC_ID                 INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    CD_CLASS_TYPE          INT               NOT NULL    COMMENT '과정구분 코드', 
    LICENSE_SERIAL         VARCHAR(32)       NULL        COMMENT '자격번호', 
    STU_NAME               VARCHAR(16)       NOT NULL    COMMENT '교육생 성명', 
    STU_ID_NUMBER          VARCHAR(14)       NOT NULL    COMMENT '교육생 주민등록번호', 
    STU_TEL                VARCHAR(13)       NOT NULL    COMMENT '교육생 연락처', 
    STU_ZIP                VARCHAR(5)        NOT NULL    COMMENT '소재지 우편번호(도로명)', 
    STU_ADDRESS            VARCHAR(64)       NOT NULL    COMMENT '소재지 주소(도로명)', 
    L_LECTURE_ID           INT(18)    NULL        COMMENT '이론/실기 개강보고 식별자', 
    P_LECTURE_ID           INT(18)    NULL        COMMENT '실습 개강보고 식별자', 
    S_LECTURE_ID           INT(18)    NULL        COMMENT '대체실습 개강보고 식별자', 
    COMPLETE_REPORT_ID     INT(18)    NULL        COMMENT '수료보고 식별자', 
    ADD_DATE               DATETIME          NOT NULL    COMMENT '등록일자', 
    CD_ADD_STATE           INT               NOT NULL    COMMENT '등록 상태(등록:1, 변경:2, 삭제:3)', 
    CHNG_DATE              DATETIME          NOT NULL    COMMENT '최종변경일자', 
    COMPLETE_DATE          DATE              NULL        COMMENT '수료일자', 
    TEST_NAME              VARCHAR(64)       NULL        COMMENT '시험명', 
    TEST_DATE              DATE              NULL        COMMENT '시험일자', 
    PASS_DATE              DATE              NULL        COMMENT '합격일자', 
    PASS_NUMBER            VARCHAR(32)       NULL        COMMENT '합격번호', 
    DISQUALIFICATION_YN    VARCHAR(1)        NULL        COMMENT '결격유무', 
    DISQUALIFICATION_DATE  DATE              NULL        COMMENT '결격기간', 
    L_TIME                 INT               NULL        COMMENT '이론/실기 이수시간', 
    P_TIME1                INT               NULL        COMMENT '실습(시설) 이수시간', 
    P_TIME2                INT               NULL        COMMENT '실습(재가) 이수시간', 
    S_TIME                 INT               NULL        COMMENT '실습(대체) 이수시간', 
    STU_NOTE               VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (STU_ID)
);

ALTER TABLE MAS_STUDENT COMMENT '교육생 마스터(본 테이블은 출결관리솔루션과 맵핑하여 해당 교육생의 출결 상황을 보고, 수정할 수 있어야 합니다.)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PLAN_CLASS
(
    MAPPER_ID    INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PLAN_ID      INT(18)    NOT NULL    COMMENT '연간사업계획서 식별자', 
    CD_CLS_LEV1  INT               NOT NULL    COMMENT '담당 과목 코드(대)', 
    CD_CLS_LEV2  INT               NOT NULL    COMMENT '담당 과목 코드(중)', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PLAN_CLASS COMMENT '연간사업계획서-과목별 교수요원 맵퍼(과목 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_LOGIC_CLASS
(
    MAPPER_ID    INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID     INT(18)    NOT NULL    COMMENT '개강 식별자', 
    CD_CLS_LEV1  INT               NOT NULL    COMMENT '담당 과목 코드(대)', 
    CD_CLS_LEV2  INT               NOT NULL    COMMENT '담당 과목 코드(중)', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_LOGIC_CLASS COMMENT '개강고보(이론/실기)-과목별 교수요원 맵퍼(과목 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PRACTICE_TIME_TABLE
(
    MAPPER_ID         INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID          INT(18)    NOT NULL    COMMENT '개강 식별자', 
    CD_FACILITY_LEV1  INT               NOT NULL    COMMENT '시설구분 코드(대)', 
    CD_FACILITY_LEV2  INT               NOT NULL    COMMENT '시설구분 코드(중)', 
    SAGC_ID           INT(18)    NOT NULL    COMMENT '연계실습기관 식별자', 
    BEGIN_DATE        DATE              NOT NULL    COMMENT '실습 시작 일자', 
    END_DATE          DATE              NOT NULL    COMMENT '실습 종료 일자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PRACTICE_TIME_TABLE COMMENT '개강고보(실습)-계획표 맵퍼(계획 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_ACCOUNT
(
    ACC_ID         INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '계정 식별자', 
    AGC_SERIAL     VARCHAR(16)       NOT NULL    COMMENT '교육기관 지정코드', 
    USER_ID        VARCHAR(32)       NOT NULL    COMMENT '접속 식별자', 
    USER_PASSWORD  VARCHAR(64)       NOT NULL    COMMENT '접속 비밀번호', 
    USER_NAME      VARCHAR(16)       NOT NULL    COMMENT '이름', 
    USER_TEL       VARCHAR(13)       NOT NULL    COMMENT '휴대전화번호', 
    PRIMARY KEY (ACC_ID)
);

ALTER TABLE MAS_ACCOUNT COMMENT '계정 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_CODE
(
    CD_TOP        INT            NOT NULL    COMMENT '코드 분류(대)', 
    CD_MIDDLE     INT            NOT NULL    COMMENT '코드 분류(중)', 
    CD_BOTTOM     INT            NOT NULL    COMMENT '코드 분류(소)', 
    CD_TOP_KR     VARCHAR(32)    NULL        COMMENT '코드 분류(대) 한글', 
    CD_MIDDLE_KR  VARCHAR(32)    NULL        COMMENT '코드 분류(중) 한글', 
    CD_BOTTOM_KR  VARCHAR(32)    NULL        COMMENT '코드 분류(소) 한글', 
    PRIMARY KEY (CD_TOP, CD_MIDDLE, CD_BOTTOM)
);

ALTER TABLE MAS_CODE COMMENT '시스템 코드 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE AGENT_LICENSE
(
    LCNS_ID           INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '자격사항 식별자', 
    AGT_ID            INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    LCNS_NAME         VARCHAR(32)       NOT NULL    COMMENT '자격사항 명칭', 
    LCNS_OBTAIN_DATE  DATE              NOT NULL    COMMENT '자격사항 취득일', 
    LCNS_NOTE         VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (LCNS_ID)
);

ALTER TABLE AGENT_LICENSE COMMENT '교수요원 자격사항';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_FILE
(
    FILE_ID             INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '파일 식별자', 
    CD_TABLE            VARCHAR(45)       NULL        COMMENT '테이블구분 코드', 
    ID_PK               INT(18)    NULL        COMMENT '마스터 식별자', 
    ORIGINAL_FILE_NAME  VARCHAR(64)       NULL        COMMENT '원본 파일 명칭', 
    SERVER_FILE_NAME    VARCHAR(1000)       NULL        COMMENT '저장 파일 명칭', 
    PRIMARY KEY (FILE_ID)
);

ALTER TABLE MAS_FILE COMMENT '통합 파일 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE AGENT_CAREER
(
    CRR_ID          INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '경력사항 식별자', 
    AGT_ID          INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    CRR_NAME        VARCHAR(32)       NOT NULL    COMMENT '경력사항 명칭', 
    CRR_BEGIN_DATE  DATE              NOT NULL    COMMENT '경력사항 시작일', 
    CRR_END_DATE    DATE              NOT NULL    COMMENT '경력사항 종료일', 
    CRR_NOTE        VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (CRR_ID)
);

ALTER TABLE AGENT_CAREER COMMENT '교수요원 경력사항';


-- MAS_AGENCY Table Create SQL
CREATE TABLE AGENT_OUTSIDE_LECTURE
(
    LCTR_ID    INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '타 교육기관 출강 식별자', 
    AGT_ID     INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    LCTR_NAME  VARCHAR(32)       NOT NULL    COMMENT '타 기관명', 
    LCTR_NOTE  VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (LCTR_ID)
);

ALTER TABLE AGENT_OUTSIDE_LECTURE COMMENT '교수요원 타 교육기관 출강 여부';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_AGENT_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    AGT_ID         INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_AGENT_CHANGE COMMENT '교수요원 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_AGENCY_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    AGC_ID         INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태(등록:1, 변경2, 삭제3)', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_AGENCY_CHANGE COMMENT '교육기관 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_SUB_AGENCY_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    SAGC_ID        INT(18)    NOT NULL    COMMENT '연계실습기관 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_SUB_AGENCY_CHANGE COMMENT '연계실습기관 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE SUB_AGENCY_CONTRACT_DOCUMENT
(
    CONT_DOC_ID       INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '첨부서류 식별자', 
    SAGC_ID           INT(18)    NOT NULL    COMMENT '연계실습기관 식별자', 
    CD_CONT_DOC_TYPE  INT               NOT NULL    COMMENT '첨부서류 유형', 
    CONT_DOC_NOTE     VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (CONT_DOC_ID)
);

ALTER TABLE SUB_AGENCY_CONTRACT_DOCUMENT COMMENT '연계실습기관 계약 첨부 서류';


-- MAS_AGENCY Table Create SQL
CREATE TABLE AGENT_CLASS
(
    CLS_ID       INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '담당과목 식별자', 
    AGT_ID       INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    CD_CLS_LEV1  INT               NOT NULL    COMMENT '담당 과목 코드(대)', 
    CD_CLS_LEV2  INT               NOT NULL    COMMENT '담당 과목 코드(중)', 
    PRIMARY KEY (CLS_ID)
);

ALTER TABLE AGENT_CLASS COMMENT '교수요원 담당과목';

-- MAS_AGENCY Table Create SQL
CREATE TABLE SUB_AGENT_LICENSE
(
    LCNS_ID           INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '자격사항 식별자', 
    SAGT_ID           INT(18)    NOT NULL    COMMENT '실습지도자 식별자', 
    LCNS_NAME         VARCHAR(32)       NOT NULL    COMMENT '자격사항 명칭', 
    LCNS_OBTAIN_DATE  DATE              NOT NULL    COMMENT '자격사항 취득일', 
    LCNS_NOTE         VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (LCNS_ID)
);

ALTER TABLE SUB_AGENT_LICENSE COMMENT '실습지도자 자격사항';


-- MAS_AGENCY Table Create SQL
CREATE TABLE SUB_AGENT_CAREER
(
    CRR_ID          INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '경력사항 식별자', 
    SAGT_ID         INT(18)    NOT NULL    COMMENT '실습지도자 식별자', 
    CRR_NAME        VARCHAR(32)       NOT NULL    COMMENT '경력사항 명칭', 
    CRR_BEGIN_DATE  DATE              NOT NULL    COMMENT '경력사항 시작일', 
    CRR_END_DATE    DATE              NOT NULL    COMMENT '경력사항 종료일', 
    CRR_NOTE        VARCHAR(64)       NOT NULL    COMMENT '비고', 
    PRIMARY KEY (CRR_ID)
);

ALTER TABLE SUB_AGENT_CAREER COMMENT '실습지도자 경력사항';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_SELF_CHECK
(
    CHECK_ID     INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '자체점검 식별자', 
    AGC_ID       INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    CHECK_TITLE  VARCHAR(32)       NOT NULL    COMMENT '제목', 
    WRITED_DATE  DATETIME          NOT NULL    COMMENT '작성일자', 
    WRITED_ID    INT(18)    NOT NULL    COMMENT '작성자', 
    PRIMARY KEY (CHECK_ID)
);

ALTER TABLE MAS_SELF_CHECK COMMENT '자체점검 마스터';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PLAN_SAGENCY
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PLAN_ID    INT(18)    NOT NULL    COMMENT '연간사업계획서 식별자', 
    SAGC_ID    INT(18)    NOT NULL    COMMENT '연계실습기관 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PLAN_SAGENCY COMMENT '연간사업계획서-연계실습기관 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_BUSINESS_PLAN_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    PLAN_ID        INT(18)    NOT NULL    COMMENT '연간사업계획서 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_BUSINESS_PLAN_CHANGE COMMENT '사업계획서 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PLAN_SAGENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PLAN_ID    INT(18)    NOT NULL    COMMENT '연간사업계획서 식별자', 
    SAGT_ID    INT(18)    NOT NULL    COMMENT '실습지도자 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PLAN_SAGENT COMMENT '연간사업계획서-실습지도자 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_SUB_AGENT_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    SAGT_ID        INT(18)    NOT NULL    COMMENT '실습지도자 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_SUB_AGENT_CHANGE COMMENT '실습지도자 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PLAN_AGENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PLAN_ID    INT(18)    NOT NULL    COMMENT '연간사업계획서 식별자', 
    AGT_ID     INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PLAN_AGENT COMMENT '연간사업계획서-교수요원 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_LOGIC_STUDENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID   INT(18)    NOT NULL    COMMENT '개강 식별자', 
    STU_ID     INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_LOGIC_STUDENT COMMENT '개강고보(이론/실기)-교육생 맵퍼';

-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_CLASS_LOGIC_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    CLASS_ID       INT(18)    NOT NULL    COMMENT '개강 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_CLASS_LOGIC_CHANGE COMMENT '개강보고(이론/실기) 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_LOGIC_TIME_TABLE
(
    MAPPER_ID     INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID      INT(18)    NOT NULL    COMMENT '개강 식별자', 
    LECTURE_DATE  DATE              NOT NULL    COMMENT '강의 날짜', 
    BEGIN_TIME    TIME              NOT NULL    COMMENT '강의 시작 시간', 
    END_TIME      TIME              NOT NULL    COMMENT '강의 종료 시간', 
    CD_CLS_LEV1   INT               NOT NULL    COMMENT '담당 과목 코드(대)', 
    CD_CLS_LEV2   INT               NOT NULL    COMMENT '담당 과목 코드(중)', 
    AGT_ID        INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_LOGIC_TIME_TABLE COMMENT '개강고보(이론/실기)-시간표 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_CLASS_PRACTICE_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    CLASS_ID       INT(18)    NOT NULL    COMMENT '개강 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_CLASS_PRACTICE_CHANGE COMMENT '개강보고(실습) 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PRACTICE_STUDENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID   INT(18)    NOT NULL    COMMENT '개강 식별자', 
    STU_ID     INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PRACTICE_STUDENT COMMENT '개강고보(실습)-교육생 맵퍼';

-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PLAN_CLASS_AGENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PARENT_ID  INT(18)    NOT NULL    COMMENT '과목부문 맵퍼 식별자', 
    AGT_ID     INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    AGT_TYPE   INT        NOT NULL    COMMENT '교수구분(이론:1, 실기:2)', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PLAN_CLASS_AGENT COMMENT '연간사업계획서-과목별 교수요원 맵퍼(교수요원 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_LOGIC_CLASS_AGENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PARENT_ID  INT(18)    NOT NULL    COMMENT '과목부문 맵퍼 식별자', 
    AGT_ID     INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    AGT_TYPE   INT        NOT NULL    COMMENT '교수구분(이론:1, 실기:2)', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_LOGIC_CLASS_AGENT COMMENT '연간사업계획서-과목별 교수요원 맵퍼(교수요원 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_PRACTICE_TIME_TABLE_STUDENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    PARENT_ID  INT(18)    NOT NULL    COMMENT '계획부문 맵퍼 식별자', 
    STU_ID     INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_PRACTICE_TIME_TABLE_STUDENT COMMENT '연간사업계획서-과목별 교수요원 맵퍼(교수요원 부문)';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_CLASS_SUB_PRACTICE_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    CLASS_ID       INT(18)    NOT NULL    COMMENT '개강 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_CLASS_SUB_PRACTICE_CHANGE COMMENT '개강보고(대체실습) 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_SUB_PRACTICE_STUDENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID   INT(18)    NOT NULL    COMMENT '개강 식별자', 
    STU_ID     INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_SUB_PRACTICE_STUDENT COMMENT '개강고보(대체실습)-교육생 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_SUB_PRACTICE_TIME_TABLE
(
    MAPPER_ID     INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID      INT(18)    NOT NULL    COMMENT '개강 식별자', 
    LECTURE_DATE  DATE              NOT NULL    COMMENT '강의 날짜', 
    BEGIN_TIME    TIME              NOT NULL    COMMENT '강의 시작 시간', 
    END_TIME      TIME              NOT NULL    COMMENT '강의 종료 시간', 
    LECTURE_NAME  VARCHAR(64)       NOT NULL    COMMENT '과목명', 
    AGT_ID        INT(18)    NOT NULL    COMMENT '교수요원 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_SUB_PRACTICE_TIME_TABLE COMMENT '개강고보(대체실습)-시간표 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAPPER_END_STUDENT
(
    MAPPER_ID  INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '맵퍼 식별자', 
    CLASS_ID   INT(18)    NOT NULL    COMMENT '수료 식별자', 
    STU_ID     INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    PRIMARY KEY (MAPPER_ID)
);

ALTER TABLE MAPPER_END_STUDENT COMMENT '수료보고-교육생 맵퍼';


-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_END_CLASS_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    CLASS_ID       INT(18)    NOT NULL    COMMENT '수료 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_END_CLASS_CHANGE COMMENT '수료보고 변경 이력';


-- MAS_AGENCY Table Create SQL
CREATE TABLE MAS_AGENCY_WORKER
(
    WORKER_ID    INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '사무원 식별자', 
    AGC_ID       INT(18)    NOT NULL    COMMENT '교육기관 식별자', 
    WORKER_RANK  VARCHAR(16)       NOT NULL    COMMENT '사무원 직책', 
    WORKER_NAME  VARCHAR(16)       NOT NULL    COMMENT '사무원 이름', 
    WORKER_TEL   VARCHAR(13)       NOT NULL    COMMENT '사무원 전화번호', 
    AGT_NOTE     VARCHAR(256)      NULL        COMMENT '비고', 
    PRIMARY KEY (WORKER_ID)
);

ALTER TABLE MAS_AGENCY_WORKER COMMENT '사무원 마스터';

-- MAS_AGENCY Table Create SQL
CREATE TABLE HIS_STUDENT_CHANGE
(
    CHNG_ID        INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '변경이력 식별자', 
    STU_ID         INT(18)    NOT NULL    COMMENT '교육생 식별자', 
    CHNG_DATE      DATETIME          NOT NULL    COMMENT '변경이력 발생 일자', 
    CHNG_JSON      VARCHAR(4096)     NOT NULL    COMMENT '변경 후 JSON', 
    CD_CHNG_STATE  INT               NOT NULL    COMMENT '변경 상태', 
    PRIMARY KEY (CHNG_ID)
);

ALTER TABLE HIS_STUDENT_CHANGE COMMENT '교육생 변경 이력';


CREATE TABLE BBS_MASTER (
	BBS_ID          INT(18)		  NOT NULL AUTO_INCREMENT COMMENT '게시판 식별자', 
	BBS_NAME        VARCHAR(255)      NOT NULL COMMENT '게시판명',
	BBS_TYPE        VARCHAR(6)        NOT NULL DEFAULT '1' COMMENT '게시판 유형', 
	HAS_REPLY       VARCHAR(1)            NULL DEFAULT 'N' COMMENT '댓글 가능 여부', 
	HAS_ATTACH      VARCHAR(1)          NULL DEFAULT 'N' COMMENT '첨부 가능 여부', 
	MAX_FILE_NUMBER INT(2)              NULL DEFAULT 0 COMMENT '최대 첨부파일수', 
	MAX_FILE_SIZE   INT(10)             NULL DEFAULT 0 COMMENT '최대 파일 크기', 
	IS_USE          VARCHAR(1)            NULL DEFAULT 'Y' COMMENT '사용 여부', 
	REG_ID          INT(18)           NOT NULL COMMENT '등록자 식별자', 
	REG_DATE        DATETIME	  NOT NULL COMMENT '등록일시', 
	MOD_ID          INT(18)           NULL COMMENT '최종 수정자 식별자', 
	MOD_DATE        DATETIME	      NULL COMMENT '최종 수정일시',
	PRIMARY KEY (BBS_ID)
);

ALTER TABLE BBS_MASTER COMMENT '게시판';

CREATE TABLE BBS_ARTICLE (
	ARTICLE_ID       INT(18)                NOT NULL AUTO_INCREMENT COMMENT '게시글 식별자', 
	BBS_ID           INT(18)                NOT NULL COMMENT '게시판 식별자', 
	CATEGORY         VARCHAR(2)			NULL COMMENT '카테고리', 
	SUBJECT          VARCHAR(100)		NOT NULL COMMENT '제목', 
	CONTENT          TEXT                           NULL COMMENT '내용', 
	IS_NOTICE        VARCHAR(1)			NULL COMMENT '공지여부', 
	READ_COUNT       INT(10)			NULL DEFAULT 0 COMMENT '읽은 횟수',
	USER_TEL	 VARCHAR(13)		NULL COMMENT '연락처',
	REG_ID           INT(18)		NOT NULL COMMENT '등록자 식별자', 
	REG_DATE         DATETIME		NOT NULL COMMENT '등록일시', 
	MOD_ID           INT(18)			NULL COMMENT '최종 수정자 식별자', 
	MOD_DATE         DATETIME			NULL COMMENT '최종 수정일시',
	PRIMARY KEY (ARTICLE_ID)
);

ALTER TABLE BBS_ARTICLE COMMENT '게시글';

CREATE TABLE MAS_MESSAGE
(
    MSG_ID           INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '쪽지 식별자', 
    SEND_DATE        DATETIME          NOT NULL    COMMENT '발신 일자', 
    SENDER_AGC_ID    INT(18)    NOT NULL    COMMENT '발신 교육기관 식별자', 
    RECEIVER_AGC_ID  INT(18)    NOT NULL    COMMENT '수신 교육기관 식별자', 
    MSG_TEXT         VARCHAR(256)      NULL        COMMENT '쪽지 내용', 
    CHECKED_DATE     DATETIME          NULL        COMMENT '확인 일자', 
    PRIMARY KEY (MSG_ID)
);

ALTER TABLE MAS_MESSAGE COMMENT '쪽지 마스터';

CREATE TABLE MAS_POPUP
(
    POPUP_ID      INT(18)    NOT NULL    AUTO_INCREMENT COMMENT '팝업 식별자', 
    AGC_ID        INT(18)    NOT NULL    COMMENT '게시자', 
    BEGIN_DATE    DATETIME          NOT NULL    COMMENT '게시 시작일', 
    END_DATE      DATETIME          NOT NULL    COMMENT '게시 종료일', 
    POPUP_X       INT(4)     NOT NULL    COMMENT '게시물 가로 좌표', 
    POPUP_Y       INT(4)     NOT NULL    COMMENT '게시물 세로 좌표', 
    POPUP_WIDTH   INT(4)     NOT NULL    COMMENT '게시물 너비', 
    POPUP_HEIGHT  INT(4)     NOT NULL    COMMENT '게시물 높이', 
    WRITED_DATE   DATETIME          NOT NULL    COMMENT '작성 일자', 
    PRIMARY KEY (POPUP_ID)
);

ALTER TABLE MAS_POPUP COMMENT '팝업 마스터';