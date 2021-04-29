-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Apr 29, 2021 at 03:26 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `rolli3oh_c2`
--
CREATE DATABASE IF NOT EXISTS `rolli3oh_c2` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `rolli3oh_c2`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_activity`
--

DROP TABLE IF EXISTS `tbl_C2_activity`;
CREATE TABLE IF NOT EXISTS `tbl_C2_activity` (
  `C2_activity_id` varchar(200) DEFAULT NULL,
  `C2_project_id` varchar(200) DEFAULT NULL,
  `C2_sprint_id` varchar(200) DEFAULT NULL,
  `C2_assignee_user_id` varchar(200) DEFAULT NULL,
  `C2_goal_id` varchar(200) DEFAULT NULL,
  `C2_activity_name` varchar(400) DEFAULT NULL,
  `C2_activity_weight` int(11) DEFAULT NULL,
  `C2_activity_measurement_type` varchar(100) DEFAULT NULL,
  `C2_activity_result_type` varchar(100) DEFAULT NULL,
  `C2_criteria_poor_value` int(11) DEFAULT NULL,
  `C2_criteria_improvement_value` int(11) DEFAULT NULL,
  `C2_criteria_expectation_value` int(11) DEFAULT NULL,
  `C2_criteria_exceed_value` int(11) DEFAULT NULL,
  `C2_criteria_outstanding_value` int(11) DEFAULT NULL,
  `C2_characteristics_higher_better` int(11) DEFAULT '1',
  `C2_activity_achieved_fact` int(11) DEFAULT NULL,
  `C2_assignee_comment` varchar(1000) DEFAULT NULL,
  `C2_activity_locked` int(11) DEFAULT '0',
  `C2_activity_created_at` datetime DEFAULT NULL,
  `C2_activity_updated_at` datetime DEFAULT NULL,
  KEY `tbl_C2_activity_fk_1` (`C2_project_id`),
  KEY `tbl_C2_activity_fk_3` (`C2_assignee_user_id`),
  KEY `tbl_C2_activity_fk_4` (`C2_goal_id`),
  KEY `tbl_C2_activity_fk_2` (`C2_sprint_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_activity`
--
DROP TRIGGER IF EXISTS `tbl_C2_activity_AFTER_DELETE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_AFTER_DELETE` AFTER DELETE ON `tbl_C2_activity` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'DELETE',
				C2_user_id = user_id,
                C2_project_id = OLD.C2_project_id,
                C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
                C2_log_on_field = 'ACTIVITY_NAME',
				C2_log_old_content = OLD.C2_activity_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_activity_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_AFTER_INSERT` AFTER INSERT ON `tbl_C2_activity` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
                C2_project_id = NEW.C2_project_id,
                C2_log_module = 'activity',
				C2_log_module_operation_id = NEW.C2_activity_id,
                C2_log_on_field = 'ACTIVITY_NAME',
				C2_log_old_content = NEW.C2_activity_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_activity_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_activity` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
	/*if activity name updated*/
	IF (OLD.C2_activity_name <> NEW.C2_activity_name) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'ACTIVITY_NAME',
				C2_log_old_content = OLD.C2_activity_name,
				C2_log_new_content = NEW.C2_activity_name,
				C2_log_created_on = NOW(); 
	END IF;
	
	/*if sprint updated*/
	IF (OLD.C2_sprint_id <> NEW.C2_sprint_id) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'SPRINT',
				C2_log_old_content = OLD.C2_sprint_id,
				C2_log_new_content = NEW.C2_sprint_id,
				C2_log_created_on = NOW(); 
	END IF;
	
	/*if weight updated*/
	IF (OLD.C2_weight <> NEW.C2_weight) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'WEIGHT',
				C2_log_old_content = OLD.C2_weight,
				C2_log_new_content = NEW.C2_weight,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement type updated*/
	IF (OLD.C2_activity_measurement_type <> NEW.C2_activity_measurement_type) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'MEASUREMENT_TYPE',
				C2_log_old_content = OLD.C2_activity_measurement_type,
				C2_log_new_content = NEW.C2_activity_measurement_type,
				C2_log_created_on = NOW(); 
	END IF;

    /*if result type updated*/
	IF (OLD.C2_activity_result_type <> NEW.C2_activity_result_type) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'RESULT_TYPE',
				C2_log_old_content = OLD.C2_activity_result_type,
				C2_log_new_content = NEW.C2_activity_result_type,
				C2_log_created_on = NOW(); 
	END IF;
		
    /*if measurement criteria numeric poor value updated*/
	IF (OLD.C2_criteria_poor_value <> NEW.C2_criteria_poor_value) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'POOR_VALUE',
				C2_log_old_content = OLD.C2_criteria_poor_value,
				C2_log_new_content = NEW.C2_criteria_poor_value,
				C2_log_created_on = NOW(); 
	END IF;

	/*if measurement criteria numeric improvement value updated*/
	IF (OLD.C2_criteria_improvement_value <> NEW.C2_criteria_improvement_value) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'IMPROVEMENT_VALUE',
				C2_log_old_content = OLD.C2_criteria_improvement_value,
				C2_log_new_content = NEW.C2_criteria_improvement_value,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement criteria numeric expectation value updated*/
	IF (OLD.C2_criteria_expectation_value <> NEW.C2_criteria_expectation_value) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'EXPECTATION_VALUE',
				C2_log_old_content = OLD.C2_criteria_expectation_value,
				C2_log_new_content = NEW.C2_criteria_expectation_value,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement criteria numeric exceed value updated*/
	IF (OLD.C2_criteria_exceed_value <> NEW.C2_criteria_exceed_value) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'EXCEED_VALUE',
				C2_log_old_content = OLD.C2_criteria_exceed_value,
				C2_log_new_content = NEW.C2_criteria_exceed_value,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement criteria numeric outstanding value updated*/
	IF (OLD.C2_criteria_outstanding_value <> NEW.C2_criteria_outstanding_value) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'OUTSTANDING_VALUE',
				C2_log_old_content = OLD.C2_criteria_outstanding_value,
				C2_log_new_content = NEW.C2_criteria_outstanding_value,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement type updated*/
	IF (OLD.C2_characteristics_higher_better <> NEW.C2_characteristics_higher_better) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'HIGHER_BETTER',
				C2_log_old_content = OLD.C2_characteristics_higher_better,
				C2_log_new_content = NEW.C2_characteristics_higher_better,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement type updated*/
	IF (OLD.C2_activity_achieved_fact <> NEW.C2_activity_achieved_fact) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'FACT',
				C2_log_old_content = OLD.C2_activity_achieved_fact,
				C2_log_new_content = NEW.C2_activity_achieved_fact,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement type updated*/
	IF (OLD.C2_assignee_comment <> NEW.C2_assignee_comment) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'COMMENT',
				C2_log_old_content = OLD.C2_assignee_comment,
				C2_log_new_content = NEW.C2_assignee_comment,
				C2_log_created_on = NOW(); 
	END IF;

    /*if measurement type updated*/
	IF (OLD.C2_activity_locked <> NEW.C2_activity_locked) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'LOCKED',
				C2_log_old_content = OLD.C2_activity_locked,
				C2_log_new_content = NEW.C2_activity_locked,
				C2_log_created_on = NOW(); 
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_activity_review`
--

DROP TABLE IF EXISTS `tbl_C2_activity_review`;
CREATE TABLE IF NOT EXISTS `tbl_C2_activity_review` (
  `C2_activity_review_id` varchar(200) NOT NULL DEFAULT '',
  `C2_project_id` varchar(200) DEFAULT NULL,
  `C2_activity_id` varchar(200) NOT NULL DEFAULT '',
  `C2_reviewer_user_id` varchar(200) NOT NULL DEFAULT '',
  `C2_achieved_result_value` int(11) NOT NULL,
  `C2_reviewer_comment` varchar(1000) NOT NULL,
  `C2_activity_review_created_on` datetime DEFAULT NULL,
  `C2_activity_review_updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`C2_activity_review_id`),
  KEY `tbl_C2_task_review_fk_1` (`C2_project_id`),
  KEY `tbl_C2_task_review_fk_3` (`C2_activity_id`),
  KEY `tbl_C2_task_review_fk_4` (`C2_reviewer_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_activity_review`
--
DROP TRIGGER IF EXISTS `tbl_C2_task_review_AFTER_DELETE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_task_review_AFTER_DELETE` AFTER DELETE ON `tbl_C2_activity_review` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'DELETE',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'TASK_REVIEW',
				C2_log_module_operation_id = OLD.C2_task_review_id,
				C2_log_created_on = NOW(); 		
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_task_review_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_task_review_AFTER_INSERT` AFTER INSERT ON `tbl_C2_activity_review` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO 
		tbl_C2_log_book
	SET 
		C2_log_operation = 'CREATE',
		C2_user_id = user_id,
		C2_project_id = NEW.C2_project_id,
		C2_log_module = 'TASK_REVIEW',
		C2_log_module_operation_id = CONCAT(NEW.C2_task_review_id,' ', NEW.C2_task_id),
		C2_log_created_on = NOW(); 
                
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_task_review_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_task_review_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_activity_review` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
	/*if different task review sprint*/
	IF (OLD.C2_sprint_id <> NEW.C2_sprint_id) THEN
    INSERT INTO tbl_C2_log_book
       SET 
         C2_log_operation = 'EDIT',
         C2_user_id = user_id,
         C2_project_id = OLD.C2_project_id,
         C2_log_module = 'TASK_REVIEW',
         C2_log_module_operation_id = OLD.C2_task_review_id,
         C2_log_on_field = 'TASK_REVIEW_SPRINT',
         C2_log_old_content = OLD.C2_sprint_id,
         C2_log_new_content = NEW.C2_sprint_id,
         C2_log_created_on = NOW(); 
	END IF;

  /*if different task review sprint*/
	IF (OLD.C2_sprint_id <> NEW.C2_sprint_id) THEN
    INSERT INTO tbl_C2_log_book
       SET 
         C2_log_operation = 'EDIT',
         C2_user_id = user_id,
         C2_project_id = OLD.C2_project_id,
         C2_log_module = 'TASK_REVIEW',
         C2_log_module_operation_id = OLD.C2_task_review_id,
         C2_log_on_field = 'TASK_REVIEW_REVIEWER',
         C2_log_old_content = OLD.C2_reviewer_user_id,
         C2_log_new_content = NEW.C2_reviewer_user_id,
         C2_log_created_on = NOW(); 
	END IF;

  /*if different task review achieved result value*/
	IF (OLD.C2_achieved_result_value <> NEW.C2_achieved_result_value) THEN
    INSERT INTO tbl_C2_log_book
       SET 
         C2_log_operation = 'EDIT',
         C2_user_id = user_id,
         C2_project_id = OLD.C2_project_id,
         C2_log_module = 'TASK_REVIEW',
         C2_log_module_operation_id = OLD.C2_task_review_id,
         C2_log_on_field = 'TASK_REVIEW_ACHIEVED_RESULT_VALUE',
         C2_log_old_content = OLD.C2_achieved_result_value,
         C2_log_new_content = NEW.C2_achieved_result_value,
         C2_log_created_on = NOW(); 
	END IF;

  /*if different task review reviewer comment*/
	IF (OLD.C2_reviewer_comment <> NEW.C2_reviewer_comment) THEN
    INSERT INTO tbl_C2_log_book
       SET 
         C2_log_operation = 'EDIT',
         C2_user_id = user_id,
         C2_project_id = OLD.C2_project_id,
         C2_log_module = 'TASK_REVIEW',
         C2_log_module_operation_id = OLD.C2_task_review_id,
         C2_log_on_field = 'TASK_REVIEW_REVIEWER_COMMENT',
         C2_log_old_content = OLD.C2_reviewer_comment,
         C2_log_new_content = NEW.C2_reviewer_comment,
         C2_log_created_on = NOW(); 
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_current_operation_user`
--

DROP TABLE IF EXISTS `tbl_C2_current_operation_user`;
CREATE TABLE IF NOT EXISTS `tbl_C2_current_operation_user` (
  `C2_user_id` varchar(200) NOT NULL,
  PRIMARY KEY (`C2_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_goal`
--

DROP TABLE IF EXISTS `tbl_C2_goal`;
CREATE TABLE IF NOT EXISTS `tbl_C2_goal` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_goal_id` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_name` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_description` varchar(400) NOT NULL DEFAULT '',
  `C2_goal_created_on` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_updated_on` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`C2_goal_id`),
  KEY `tbl_C2_goal_fk_1` (`C2_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_goal`
--
DROP TRIGGER IF EXISTS `tbl_C2_goal_AFTER_DELETE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_goal_AFTER_DELETE` AFTER DELETE ON `tbl_C2_goal` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'DELETE',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'goal',
				C2_log_module_operation_id = OLD.C2_goal_id,
                C2_log_on_field = 'NAME',
				C2_log_old_content = OLD.C2_goal_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_goal_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_goal_AFTER_INSERT` AFTER INSERT ON `tbl_C2_goal` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
				C2_project_id = NEW.C2_project_id,
				C2_log_module = 'goal',
				C2_log_module_operation_id = NEW.C2_goal_id,
                C2_log_on_field = 'NAME',
				C2_log_old_content = NEW.C2_goal_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_goal_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_goal_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_goal` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
	/*if */
	IF (OLD.C2_goal_name <> NEW.C2_goal_name) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'goal',
				C2_log_module_operation_id = OLD.C2_goal_id,
				C2_log_on_field = 'NAME',
				C2_log_old_content = OLD.C2_goal_name,
				C2_log_new_content = NEW.C2_goal_name,
				C2_log_created_on = NOW(); 
	END IF;
		
	IF (OLD.C2_goal_description <> NEW.C2_goal_description) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'goal',
				C2_log_module_operation_id = OLD.C2_goal_id,
				C2_log_on_field = 'DESCRIPTION',
				C2_log_old_content = OLD.C2_goal_description,
				C2_log_new_content = NEW.C2_goal_description,
				C2_log_created_on = NOW(); 
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_log_book`
--

DROP TABLE IF EXISTS `tbl_C2_log_book`;
CREATE TABLE IF NOT EXISTS `tbl_C2_log_book` (
  `C2_log_book_id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `C2_project_id` varchar(200) DEFAULT NULL,
  `C2_user_id` varchar(200) DEFAULT NULL,
  `C2_log_operation` varchar(200) DEFAULT NULL,
  `C2_log_module` varchar(100) DEFAULT NULL,
  `C2_log_module_operation_id` varchar(10000) DEFAULT NULL,
  `C2_log_on_field` varchar(100) DEFAULT NULL,
  `C2_log_old_content` varchar(10000) DEFAULT NULL,
  `C2_log_new_content` varchar(10000) DEFAULT NULL,
  `C2_log_created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`C2_log_book_id`),
  KEY `tbl_C2_log_book_fk_1` (`C2_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project`
--

DROP TABLE IF EXISTS `tbl_C2_project`;
CREATE TABLE IF NOT EXISTS `tbl_C2_project` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_name` varchar(200) NOT NULL,
  `C2_project_description` varchar(400) NOT NULL,
  `C2_project_created_on` datetime DEFAULT NULL,
  `C2_project_updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`C2_project_id`),
  KEY `C2_project_name` (`C2_project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_project`
--
DROP TRIGGER IF EXISTS `tbl_C2_project_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_AFTER_INSERT` AFTER INSERT ON `tbl_C2_project` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
	INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
				C2_project_id = NEW.C2_project_id,
				C2_log_module = 'PROJECT',
				C2_log_module_operation_id = NEW.C2_project_id,
                C2_log_on_field = 'NAME',
				C2_log_old_content = NEW.C2_project_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_project_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_project` FOR EACH ROW BEGIN
	
    DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
	/*if */
	IF (OLD.C2_project_name <> NEW.C2_project_name) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'PROJECT',
				C2_log_module_operation_id = OLD.C2_project_id,
				C2_log_on_field = 'NAME',
				C2_log_old_content = OLD.C2_project_name,
				C2_log_new_content = NEW.C2_project_name,
				C2_log_created_on = NOW(); 
		END IF;
        
        IF (OLD.C2_project_description <> NEW.C2_project_description) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'PROJECT',
				C2_log_module_operation_id = OLD.C2_project_id,
				C2_log_on_field = 'DESCRIPTION',
				C2_log_old_content = OLD.C2_project_description,
				C2_log_new_content = NEW.C2_project_description,
				C2_log_created_on = NOW(); 
		END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_member_association`
--

DROP TABLE IF EXISTS `tbl_C2_project_member_association`;
CREATE TABLE IF NOT EXISTS `tbl_C2_project_member_association` (
  `C2_user_id` varchar(200) NOT NULL,
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_user_type_id` varchar(200) NOT NULL,
  `C2_project_member_created_on` datetime DEFAULT NULL,
  `C2_project_member_updated_on` datetime DEFAULT NULL,
  KEY `C2_project_id` (`C2_project_id`),
  KEY `tbl_C2_project_member_association_fk_2` (`C2_user_id`),
  KEY `tbl_C2_project_member_association_fk_3` (`C2_project_user_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_project_member_association`
--
DROP TRIGGER IF EXISTS `tbl_C2_project_member_association_AFTER_DELETE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_member_association_AFTER_DELETE` AFTER DELETE ON `tbl_C2_project_member_association` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'DELETE',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'MEMBER',
				C2_log_module_operation_id = OLD.C2_user_id,
				C2_log_created_on = NOW(); 		
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_project_member_association_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_member_association_AFTER_INSERT` AFTER INSERT ON `tbl_C2_project_member_association` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
	INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
				C2_project_id = NEW.C2_project_id,
				C2_log_module = 'MEMBER',
				C2_log_module_operation_id = CONCAT(NEW.C2_user_id, ' ', NEW.C2_project_user_type_id),
				C2_log_created_on = NOW(); 		
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_project_member_association_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_member_association_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_project_member_association` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'MEMBER',
				C2_log_module_operation_id = OLD.C2_user_id,
				C2_log_on_field = 'USER_TYPE',
				C2_log_old_content = OLD.C2_project_user_type_id,
				C2_log_new_content = NEW.C2_project_user_type_id,
				C2_log_created_on = NOW(); 		
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_member_type`
--

DROP TABLE IF EXISTS `tbl_C2_project_member_type`;
CREATE TABLE IF NOT EXISTS `tbl_C2_project_member_type` (
  `C2_project_member_type_id` varchar(200) NOT NULL,
  `C2_project_member_type_name` varchar(200) NOT NULL,
  `C2_project_member_type_description` varchar(400) NOT NULL,
  `C2_user_access_privilege_level` int(11) DEFAULT NULL,
  `C2_crud_project` tinyint(4) DEFAULT '1',
  `C2_crud_member` tinyint(4) DEFAULT '1',
  `C2_crud_sprint` tinyint(4) DEFAULT '1',
  `C2_crud_goal` tinyint(4) DEFAULT '1',
  `C2_crud_activity` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`C2_project_member_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_settings`
--

DROP TABLE IF EXISTS `tbl_C2_project_settings`;
CREATE TABLE IF NOT EXISTS `tbl_C2_project_settings` (
  `C2_project_settings_id` int(11) NOT NULL AUTO_INCREMENT,
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_settings_created_on` varchar(200) DEFAULT NULL,
  `C2_project_settings_update_on` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`C2_project_settings_id`),
  KEY `C2_project_id` (`C2_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_project_settings`
--
DROP TRIGGER IF EXISTS `tbl_C2_project_settings_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_project_settings_AFTER_INSERT` AFTER INSERT ON `tbl_C2_project_settings` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
				C2_project_id = NEW.C2_project_id,
				C2_log_module = 'PROJECT_SETTINGS',
				C2_log_module_operation_id = NEW.C2_over_all_completion_status_id,
                C2_log_on_field = 'OVER_ALL_COMPLETION_STATUS_ID',
				C2_log_old_content = NEW.C2_over_all_completion_status_id,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_sprint`
--

DROP TABLE IF EXISTS `tbl_C2_sprint`;
CREATE TABLE IF NOT EXISTS `tbl_C2_sprint` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_sprint_id` varchar(200) NOT NULL,
  `C2_sprint_name` varchar(200) NOT NULL,
  `C2_sprint_start_date` varchar(200) NOT NULL,
  `C2_sprint_end_date` varchar(200) NOT NULL,
  `C2_sprint_status` varchar(200) NOT NULL,
  `C2_sprint_created_on` datetime NOT NULL,
  `C2_sprint_updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`C2_sprint_id`),
  KEY `C2_project_id` (`C2_project_id`),
  KEY `C2_sprint_start_date` (`C2_sprint_start_date`),
  KEY `C2_sprint_end_date` (`C2_sprint_end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `tbl_C2_sprint`
--
DROP TRIGGER IF EXISTS `tbl_C2_sprint_AFTER_DELETE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_sprint_AFTER_DELETE` AFTER DELETE ON `tbl_C2_sprint` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
		SET 
			C2_log_operation = 'DELETE',
			C2_user_id = user_id,
			C2_project_id = OLD.C2_project_id,
			C2_log_module = 'SPRINT',
			C2_log_module_operation_id = OLD.C2_sprint_id,
            C2_log_on_field = 'NAME',
			C2_log_old_content = OLD.C2_sprint_name,
			C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_sprint_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_sprint_AFTER_INSERT` AFTER INSERT ON `tbl_C2_sprint` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
                C2_project_id = NEW.C2_project_id,
                C2_log_module = 'SPRINT',
				C2_log_module_operation_id = NEW.C2_sprint_id,
                C2_log_on_field = 'NAME',
				C2_log_old_content = NEW.C2_sprint_name,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tbl_C2_sprint_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `tbl_C2_sprint_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_sprint` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;

  /*if sprint name updated*/
  IF (OLD.C2_sprint_name <> NEW.C2_sprint_name) THEN
    INSERT INTO 
      tbl_C2_log_book
    SET 
      C2_log_operation = 'EDIT',
      C2_user_id = user_id,
      C2_project_id = OLD.C2_project_id,
      C2_log_module = 'SPRINT',
      C2_log_module_operation_id = OLD.C2_sprint_id,
      C2_log_on_field = 'NAME',
      C2_log_old_content = OLD.C2_sprint_name,
      C2_log_new_content = NEW.C2_sprint_name,
      C2_log_created_on = NOW(); 
  END IF;


  /*if state date updated*/
  IF (OLD.C2_sprint_start_date <> NEW.C2_sprint_start_date) THEN
  	INSERT INTO 
      tbl_C2_log_book
  	SET 
  			C2_log_operation = 'EDIT',
  			C2_user_id = user_id,
  			C2_project_id = OLD.C2_project_id,
  			C2_log_module = 'SPRINT',
  			C2_log_module_operation_id = OLD.C2_sprint_id,
  			C2_log_on_field = 'START_DATE',
  			C2_log_old_content = OLD.C2_sprint_start_date,
  			C2_log_new_content = NEW.C2_sprint_start_date,
  			C2_log_created_on = NOW(); 
  	END IF;

  /*if end date updated*/
  IF (OLD.C2_sprint_end_date <> NEW.C2_sprint_end_date) THEN
    INSERT INTO 
      tbl_C2_log_book
    SET 
      C2_log_operation = 'EDIT',
      C2_user_id = user_id,
      C2_project_id = OLD.C2_project_id,
      C2_log_module = 'SPRINT',
      C2_log_module_operation_id = OLD.C2_sprint_id,
      C2_log_on_field = 'END_DATE',
      C2_log_old_content = OLD.C2_sprint_end_date,
      C2_log_new_content = NEW.C2_sprint_end_date,
      C2_log_created_on = NOW(); 
  END IF;

  /*if end date updated*/
  IF (OLD.C2_sprint_status <> NEW.C2_sprint_status) THEN
    INSERT INTO 
      tbl_C2_log_book
    SET 
      C2_log_operation = 'EDIT',
      C2_user_id = user_id,
      C2_project_id = OLD.C2_project_id,
      C2_log_module = 'SPRINT',
      C2_log_module_operation_id = OLD.C2_sprint_id,
      C2_log_on_field = 'STATUS',
      C2_log_old_content = OLD.C2_sprint_status,
      C2_log_new_content = NEW.C2_sprint_status,
      C2_log_created_on = NOW(); 
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_sp_log`
--

DROP TABLE IF EXISTS `tbl_C2_sp_log`;
CREATE TABLE IF NOT EXISTS `tbl_C2_sp_log` (
  `C2_sp_log` varchar(10000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_user`
--

DROP TABLE IF EXISTS `tbl_C2_user`;
CREATE TABLE IF NOT EXISTS `tbl_C2_user` (
  `C2_user_id` varchar(200) NOT NULL,
  `C2_user_first_name` varchar(200) NOT NULL,
  `C2_user_last_name` varchar(200) NOT NULL,
  `C2_user_password` varchar(200) NOT NULL,
  `C2_user_email` varchar(200) NOT NULL,
  `C2_user_security_answer_1` varchar(200) NOT NULL,
  `C2_user_security_answer_2` varchar(200) NOT NULL,
  `C2_user_status` varchar(200) NOT NULL DEFAULT '',
  `C2_user_verification_code` varchar(100) NOT NULL,
  `C2_user_password_reset_code` varchar(100) NOT NULL DEFAULT 'none',
  `C2_user_created_at` varchar(200) NOT NULL,
  `C2_user_updated_at` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`C2_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_user_session`
--

DROP TABLE IF EXISTS `tbl_C2_user_session`;
CREATE TABLE IF NOT EXISTS `tbl_C2_user_session` (
  `C2_session_user_id` varchar(200) NOT NULL,
  `C2_session_user_platform` varchar(200) DEFAULT NULL,
  `C2_session_user_ip` varchar(200) DEFAULT NULL,
  `C2_session_user_login_type` varchar(200) DEFAULT NULL,
  `C2_session_created_on` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_C2_activity`
--
ALTER TABLE `tbl_C2_activity`
  ADD CONSTRAINT `tbl_C2_activity_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_C2_activity_fk_2` FOREIGN KEY (`C2_sprint_id`) REFERENCES `tbl_C2_sprint` (`C2_sprint_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `tbl_C2_activity_fk_3` FOREIGN KEY (`C2_assignee_user_id`) REFERENCES `tbl_C2_user` (`C2_user_id`),
  ADD CONSTRAINT `tbl_C2_activity_fk_4` FOREIGN KEY (`C2_goal_id`) REFERENCES `tbl_C2_goal` (`C2_goal_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_C2_goal`
--
ALTER TABLE `tbl_C2_goal`
  ADD CONSTRAINT `tbl_C2_goal_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_C2_log_book`
--
ALTER TABLE `tbl_C2_log_book`
  ADD CONSTRAINT `tbl_C2_log_book_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_C2_project_member_association`
--
ALTER TABLE `tbl_C2_project_member_association`
  ADD CONSTRAINT `tbl_C2_project_member_association_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_C2_project_member_association_fk_2` FOREIGN KEY (`C2_user_id`) REFERENCES `tbl_C2_user` (`C2_user_id`),
  ADD CONSTRAINT `tbl_C2_project_member_association_fk_3` FOREIGN KEY (`C2_project_user_type_id`) REFERENCES `tbl_C2_project_member_type` (`C2_project_member_type_id`);

--
-- Constraints for table `tbl_C2_project_settings`
--
ALTER TABLE `tbl_C2_project_settings`
  ADD CONSTRAINT `tbl_C2_project_settings_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_C2_sprint`
--
ALTER TABLE `tbl_C2_sprint`
  ADD CONSTRAINT `tbl_C2_sprint_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE;
