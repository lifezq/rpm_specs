-- 更改数据库字符集utf8mb4 utf8mb4_general_ci -> utf8mb4 utf8mb4_unicode_ci
ALTER DATABASE `YOUR_DB` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- 1. 数据库默认字符集/排序规则
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA
WHERE SCHEMA_NAME = 'YOUR_DB';

-- 2. 表级不是 utf8mb4_unicode_ci 的表
SELECT TABLE_NAME, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'YOUR_DB'
  AND TABLE_TYPE = 'BASE TABLE'
  AND (TABLE_COLLATION IS NULL OR TABLE_COLLATION <> 'utf8mb4_unicode_ci')
ORDER BY TABLE_NAME;

-- 3. 列级仍为 general_ci 的文本列
SELECT TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME, COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'YOUR_DB'
  AND DATA_TYPE IN ('char','varchar','text','tinytext','mediumtext','longtext')
  AND COLLATION_NAME = 'utf8mb4_general_ci'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- 替换数据库字符串-开始
-- 建议低峰执行
SET @db := 'YOUR_DB';

-- 1) 数据库默认规则改为 unicode_ci
SET @sql := CONCAT('ALTER DATABASE `', @db, '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2) 逐表执行 CONVERT（仅处理 utf8mb4 相关表）
DROP PROCEDURE IF EXISTS sp_convert_collation;
DELIMITER $$
CREATE PROCEDURE sp_convert_collation(IN p_schema VARCHAR(64))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_table VARCHAR(128);

  DECLARE cur CURSOR FOR
    SELECT TABLE_NAME
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = p_schema
      AND TABLE_TYPE = 'BASE TABLE'
      AND TABLE_COLLATION LIKE 'utf8mb4%';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO v_table;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

    SET @ddl := CONCAT(
      'ALTER TABLE `', p_schema, '`.`', v_table,
      '` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci'
    );
    PREPARE s FROM @ddl;
    EXECUTE s;
    DEALLOCATE PREPARE s;
  END LOOP;
  CLOSE cur;
END$$
DELIMITER ;

CALL sp_convert_collation(@db);
DROP PROCEDURE IF EXISTS sp_convert_collation;
-- 替换数据库字符串-结束



-- 1) 表级是否还有非 unicode_ci
SELECT COUNT(*) AS bad_table_collation
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'YOUR_DB'
  AND TABLE_TYPE = 'BASE TABLE'
  AND (TABLE_COLLATION IS NULL OR TABLE_COLLATION <> 'utf8mb4_unicode_ci');

-- 2) 列级是否还有 general_ci
SELECT COUNT(*) AS bad_column_collation
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'YOUR_DB'
  AND COLLATION_NAME = 'utf8mb4_general_ci';

-- 3) 抽样看 ad_session_id 相关列
SELECT TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'YOUR_DB'
  AND COLUMN_NAME = 'ad_session_id'
ORDER BY TABLE_NAME;

