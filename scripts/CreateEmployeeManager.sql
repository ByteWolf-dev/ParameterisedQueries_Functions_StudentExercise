--create a new user
--Connect as Sys-Admin of your the PDB (XEPDB1)
SELECT * FROM dba_users;

DROP USER EmployeeManager;

CREATE USER EmployeeManager
    IDENTIFIED BY EmployeeManager
    DEFAULT tablespace USERS
    TEMPORARY tablespace temp
    quota unlimited ON USERS;

grant connect to EmployeeManager;
grant resource to EmployeeManager;

COMMIT;

SELECT * FROM dba_users;


