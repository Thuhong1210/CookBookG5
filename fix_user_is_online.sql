-- Fix missing is_online column in user table
-- Run this script in your MySQL database

USE Mycookbook_db;

-- Add is_online column if it doesn't exist
-- This will only add the column if it doesn't already exist
SET @dbname = DATABASE();
SET @tablename = 'user';
SET @columnname = 'is_online';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (TABLE_SCHEMA = @dbname)
      AND (TABLE_NAME = @tablename)
      AND (COLUMN_NAME = @columnname)
  ) > 0,
  'SELECT 1', -- Column exists, do nothing
  CONCAT('ALTER TABLE `', @tablename, '` ADD COLUMN `', @columnname, '` TINYINT(1) DEFAULT 0 NOT NULL AFTER `is_admin`')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Update existing records to have is_online = 0 by default (if column exists)
UPDATE `user` SET `is_online` = 0 WHERE `is_online` IS NULL;

