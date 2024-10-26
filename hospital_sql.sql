SELECT * FROM organizations;

ALTER TABLE hospital_db.organizations
CHANGE COLUMN ZIP ZIP INT NULL DEFAULT NULL;

DESCRIBE organizations;

-----------------------------
SELECT * FROM payers;

UPDATE `hospital_db`.`payers`
SET `ZIP` = NULL
WHERE `ZIP` = '';

UPDATE `hospital_db`.`payers`
SET `NAME` = NULL
WHERE `NAME` = '';

UPDATE `hospital_db`.`payers`
SET `ADDRESS` = NULL
WHERE `ADDRESS` = '';

UPDATE `hospital_db`.`payers`
SET `CITY` = NULL
WHERE `CITY` = '';

UPDATE `hospital_db`.`payers`
SET `PHONE` = NULL
WHERE `PHONE` = '';

UPDATE `hospital_db`.`payers`
SET `STATE_HEADQUARTERED` = NULL
WHERE `STATE_HEADQUARTERED` = '';

ALTER TABLE `hospital_db`.`payers`
CHANGE COLUMN `ZIP` `ZIP` INT NULL DEFAULT NULL;

DESCRIBE payers;

---------------------
SELECT * FROM procedures;

DESCRIBE procedures;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE `hospital_db`.`procedures`
CHANGE COLUMN `CODE` `CODE` BIGINT NULL DEFAULT NULL;

UPDATE `hospital_db`.`procedures`
SET `START` = STR_TO_DATE(SUBSTRING(`START`, 1, 19), '%Y-%m-%dT%H:%i:%s');

UPDATE `hospital_db`.`procedures`
SET `STOP` = STR_TO_DATE(SUBSTRING(`STOP`, 1, 19), '%Y-%m-%dT%H:%i:%s');

ALTER TABLE procedures
CHANGE COLUMN `START` START_T DATETIME NULL DEFAULT NULL;

ALTER TABLE procedures
CHANGE COLUMN `STOP` STOP_T DATETIME NULL DEFAULT NULL;

ALTER TABLE `hospital_db`.`procedures` 
CHANGE COLUMN `BASE_COST` `BASE_COST` INT NULL DEFAULT NULL;

UPDATE procedures
SET REASONCODE = ''
WHERE REASONCODE = NULL;

ALTER TABLE `hospital_db`.`procedures` 
CHANGE COLUMN `REASONCODE` `REASONCODE` VARCHAR(20) NULL DEFAULT NULL;

----------------------

SELECT * FROM encounters;

UPDATE `hospital_db`.`encounters`
SET `START` = STR_TO_DATE(SUBSTRING(`START`, 1, 19), '%Y-%m-%dT%H:%i:%s');

ALTER TABLE hospital_db.encounters
CHANGE COLUMN START START_T DATETIME NULL DEFAULT NULL;

UPDATE `hospital_db`.`encounters`
SET `STOP` = STR_TO_DATE(SUBSTRING(`STOP`, 1, 19), '%Y-%m-%dT%H:%i:%s');

ALTER TABLE hospital_db.encounters
CHANGE COLUMN STOP STOP_T DATETIME NULL DEFAULT NULL;

ALTER TABLE hospital_db.encounters
CHANGE COLUMN `CODE` `CODE` INT NULL DEFAULT NULL;

ALTER TABLE hospital_db.encounters
CHANGE COLUMN BASE_ENCOUNTER_COST BASE_ENCOUNTER_COST FLOAT NULL DEFAULT NULL;

ALTER TABLE hospital_db.encounters
CHANGE COLUMN TOTAL_CLAIM_COST TOTAL_CLAIM_COST FLOAT NULL DEFAULT NULL; 

ALTER TABLE hospital_db.encounters
CHANGE COLUMN PAYER_COVERAGE PAYER_COVERAGE FLOAT NULL DEFAULT NULL; 

UPDATE hospital_db.encounters
SET REASONCODE = NULL
WHERE REASONCODE = '';

ALTER TABLE hospital_db.encounters
CHANGE COLUMN REASONCODE REASONCODE BIGINT NULL DEFAULT NULL; 

DESCRIBE encounters;

USE hospital_db;

-------------------------

SELECT * FROM patients;

ALTER TABLE hospital_db.patients
CHANGE COLUMN BIRTHDATE BIRTHDATE DATETIME NULL DEFAULT NULL;

UPDATE hospital_db.patients
SET DEATHDATE = NULL
WHERE DEATHDATE = '';

ALTER TABLE hospital_db.patients
CHANGE COLUMN DEATHDATE DEATHDATE DATETIME NULL DEFAULT NULL;

UPDATE hospital_db.patients
SET ZIP = NULL
WHERE ZIP = '';

ALTER TABLE hospital_db.patients
CHANGE COLUMN ZIP ZIP INT NULL DEFAULT NULL;

DESCRIBE patients;

USE hospital_db;

----

SELECT * FROM encounters;
SELECT * FROM organizations;
SELECT * FROM patients;
SELECT * FROM payers;
SELECT * FROM procedures;




