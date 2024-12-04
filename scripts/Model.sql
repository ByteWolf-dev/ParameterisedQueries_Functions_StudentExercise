DROP TABLE EMPLOYEES;
CREATE TABLE employees (
                           employee_id   NUMBER         NOT NULL,
                           first_name    VARCHAR2(1000) NOT NULL,
                           last_name     VARCHAR2(1000) NOT NULL,
                           date_of_birth DATE           NOT NULL,
                           phone_number  VARCHAR2(1000) NOT NULL,
                           junk          CHAR(1000)     DEFAULT 'JUNK',
                           CONSTRAINT employees_pk PRIMARY KEY (employee_id)
);

DELETE FROM EMPLOYEES;
INSERT INTO employees (employee_id,  first_name,
                       last_name,    date_of_birth,
                       phone_number)
SELECT LEVEL,
       DBMS_RANDOM.STRING('u', 1) ||
       DBMS_RANDOM.STRING('l', DBMS_RANDOM.value(2,10)),
       DBMS_RANDOM.STRING('u', 1) ||
       DBMS_RANDOM.STRING('l', DBMS_RANDOM.value(2,10)),
       SYSDATE - (DBMS_RANDOM.normal() * 365 * 10) - 40 * 365,
       TRUNC(DBMS_RANDOM.VALUE(1000,10000))
FROM DUAL
CONNECT BY level <= 10000;
COMMIT;

