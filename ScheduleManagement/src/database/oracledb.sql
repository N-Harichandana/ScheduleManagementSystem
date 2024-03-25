CREATE TABLE BLOCKK(
BLOCK_ID VARCHAR2(4),
BLOCK_NAME VARCHAR2(20),
CONSTRAINT PKB PRIMARY KEY(BLOCK_ID));

CREATE TABLE CLASSROOM(
CLASSROOM_ID VARCHAR2(3),
HAS_PROJECTOR VARCHAR2(1),
BLOCK_ID VARCHAR2(4),
CONSTRAINT PKC PRIMARY KEY(CLASSROOM_ID),
CONSTRAINT FKC FOREIGN KEY(BLOCK_ID) REFERENCES  BLOCKK(BLOCK_ID) ON DELETE SET NULL);


CREATE TABLE DEPARTMENT(
DEPT_ID VARCHAR2(5),
DEPT_NAME VARCHAR2(20),
CONSTRAINT PKD PRIMARY KEY (DEPT_ID));

CREATE TABLE FACULTY(
FACULTY_ID VARCHAR2(5),
FACULTY_NAME VARCHAR2(30),
PH_NO NUMBER(10),
EMAIL VARCHAR2(30),
DESIGNATION VARCHAR(25),
DEPT_ID VARCHAR2(5),
CONSTRAINT PKF PRIMARY KEY(FACULTY_ID),
CONSTRAINT FKF FOREIGN KEY (DEPT_ID) REFERENCES DEPARTMENT(DEPT_ID)  ON DELETE SET NULL);

CREATE TABLE SECTION(
SEC_ID VARCHAR2(5),
SEC VARCHAR2(1),
SEM VARCHAR2(2),
ACADEMIC_YEAR NUMBER,
FACULTY_ID VARCHAR2(5),
CONSTRAINT PKSE PRIMARY KEY(SEC_ID),
CONSTRAINT FKSE FOREIGN KEY(FACULTY_ID) REFERENCES FACULTY(FACULTY_ID) ON DELETE SET NULL);

CREATE TABLE SUBJECT(
SUB_CODE VARCHAR2(10),
SUB_NAME VARCHAR(30),
SUB_ABBREVATION VARCHAR2(20),
CONSTRAINT PKS PRIMARY KEY(SUB_CODE));



CREATE TABLE HANDLES(
FACULTY_ID VARCHAR2(5),
SEC_ID  VARCHAR2(5),
SUB_CODE VARCHAR2(10),
BATCH_ID VARCHAR2(5),
CONSTRAINT PKH PRIMARY KEY(FACULTY_ID,SEC_ID,SUB_CODE,BATCH_ID),
CONSTRAINT FKH FOREIGN KEY(SUB_CODE) REFERENCES SUBJECT(SUB_CODE) ON DELETE SET NULL,
CONSTRAINT FKH2 FOREIGN KEY(FACULTY_ID) REFERENCES FACULTY(FACULTY_ID) ON DELETE SET NULL,
CONSTRAINT FKH3 FOREIGN KEY(SEC_ID) REFERENCES SECTION(SEC_ID) ON DELETE SET NULL);


CREATE TABLE CLASS_OR_LAB(
SUB_CODE VARCHAR2(10),
SEC_ID VARCHAR2(5),
FACULTY_ID VARCHAR2(5),
CLASSROOM_ID VARCHAR2(3),
BLOCK_ID VARCHAR2(4),
DAYY VARCHAR2(3),
TIMEE VARCHAR2(12),
DURATIONN NUMBER(1),
CONSTRAINT PKCL PRIMARY KEY (SUB_CODE,SEC_ID,FACULTY_ID,CLASSROOM_ID,BLOCK_ID,DAYY),
CONSTRAINT FKCL FOREIGN KEY(SUB_CODE) REFERENCES SUBJECT(SUB_CODE) ON DELETE SET NULL,
CONSTRAINT FKCL2 FOREIGN KEY(FACULTY_ID) REFERENCES FACULTY(FACULTY_ID) ON DELETE SET NULL,
CONSTRAINT FKCL4 FOREIGN KEY(CLASSROOM_ID) REFERENCES CLASSROOM(CLASSROOM_ID) ON DELETE SET NULL,
CONSTRAINT FKCL5 FOREIGN KEY(BLOCK_ID) REFERENCES BLOCKK(BLOCK_ID) ON DELETE SET NULL,
CONSTRAINT FKCL6 FOREIGN KEY(SEC_ID) REFERENCES SECTION(SEC_ID) ON DELETE SET NULL);




CREATE OR REPLACE TRIGGER check_classroom_availability
BEFORE INSERT OR UPDATE ON CLASS_OR_LAB
FOR EACH ROW
DECLARE
       classroom_available NUMBER;
BEGIN
       SELECT COUNT(*)
       INTO classroom_available
       FROM CLASS_OR_LAB
       WHERE CLASSROOM_ID = :NEW.CLASSROOM_ID
       AND DAYY = :NEW.DAYY
       AND TIMEE = :NEW.TIMEE
       AND DURATIONN = :NEW.DURATIONN;

       IF classroom_available > 0 THEN
           RAISE_APPLICATION_ERROR(-20001, 'Classroom is not available during the specified time slot');
       END IF;
END;
/