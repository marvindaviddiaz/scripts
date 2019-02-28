-- mysql - size data

SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024 / 1024), 2) AS "Size (GB)"
FROM information_schema.TABLES
WHERE table_schema = "fel"
ORDER BY (data_length + index_length) DESC;

-- oracle - job to create partition table every month

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
      job_name        => 'LOG_DTE_PART_JOB',
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'DECLARE
                            partition_name  varchar2(5);
                            partition_until varchar2(10);
                            tablespace_ddl  varchar2(255);
                            partition_ddl   varchar2(255);
                          BEGIN
                            SELECT TO_CHAR(ADD_MONTHS(current_date, 1), ''MON'') || TO_CHAR(ADD_MONTHS(current_date, 1), ''YY'') INTO partition_name FROM dual;
                            SELECT TO_CHAR(ADD_MONTHS(current_date, 2), ''YYYY-MM'') || ''-01'' INTO partition_until FROM dual;
                            tablespace_ddl := ''create tablespace TBS_LOG_DTE'' || partition_name || '' DATAFILE ''||CHR(39)||''+DATA''||CHR(39)||'' size 100m reuse autoextend on next 100m extent management local segment space management auto'';
                            execute immediate tablespace_ddl;
                            partition_ddl := ''ALTER TABLE LOG_DTE ADD PARTITION ''|| partition_name ||'' VALUES LESS THAN (TO_DATE ('''''' || partition_until || '''''', ''''YYYY-MM-DD'''')) TABLESPACE TBS_LOG_DTE'' || partition_name;
                            execute immediate partition_ddl;
                          END;',
			start_date      =>  '01-JAN-19 01.00.00 AM America/Guatemala',
      repeat_interval => 'freq=monthly;bymonthday=-1;byhour=2;byminute=0;bysecond=0;',
      end_date        =>  NULL,
      enabled         =>  TRUE,
      comments        => 'Creación Partición LOG_DTE');
END;

BEGIN
  DBMS_SCHEDULER.DROP_JOB ('LOG_DTE_DETAIL_PART_JOB');
END;
