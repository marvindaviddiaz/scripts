-- mysql - size data

SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024 / 1024), 2) AS "Size (GB)"
FROM information_schema.TABLES
WHERE table_schema = "fel"
ORDER BY (data_length + index_length) DESC;

-- oracle - job to create partition table every month

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'LOG_DTE_DETAIL_PART_JOB',
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'DECLARE
                            partition_name  varchar2(5);
                            partition_until varchar2(10);
                            partition_ddl   varchar2(255);
                          BEGIN
                            SELECT TO_CHAR(ADD_MONTHS(current_date, 1), ''MON'') || TO_CHAR(ADD_MONTHS(current_date, 1), ''YY'') INTO partition_name FROM dual;
                            SELECT TO_CHAR(ADD_MONTHS(current_date, 2), ''YYYY-MM'') || ''-01'' INTO partition_until FROM dual;
                            partition_ddl := ''ALTER TABLE LOG_DTE_DETAIL ADD PARTITION ''|| partition_name ||'' VALUES LESS THAN (TO_DATE ('''''' || partition_until || '''''', ''''YYYY-MM-DD'''')) TABLESPACE TBS_LOG_DTE_DETAIL'' || partition_name;
                            execute immediate partition_ddl;
                          END;',
      start_date      =>  NULL,
      repeat_interval => 'freq=monthly;bymonthday=10;byhour=8;byminute=0;bysecond=0;',
      end_date        =>  NULL,
      enabled         =>  TRUE,
      comments        => 'Creación Partición LOG_DTE_DETAIL');
END;

BEGIN
  DBMS_SCHEDULER.DROP_JOB ('LOG_DTE_DETAIL_PART_JOB');
END;
