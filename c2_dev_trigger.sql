-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: May 16, 2021 at 08:56 AM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `rolli3oh_c2`
--

-- --------------------------------------------------------

--
-- Triggers `tbl_C2_activity`
--
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
	
    /*if weight updated*/
	IF (OLD.C2_activity_weight <> NEW.C2_activity_weight) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity',
				C2_log_module_operation_id = OLD.C2_activity_id,
				C2_log_on_field = 'WEIGHT',
				C2_log_old_content = OLD.C2_activity_weight,
				C2_log_new_content = NEW.C2_activity_weight,
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

--
-- Triggers `tbl_C2_activity_comment`
--
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_comment_AFTER_DELETE` AFTER DELETE ON `tbl_C2_activity_comment` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'DELETE',
				C2_user_id = user_id,
                C2_project_id = OLD.C2_project_id,
                C2_log_module = 'activity_comment',
				C2_log_module_operation_id = OLD.C2_comment_id,
                C2_log_on_field = 'COMMENT',
				C2_log_old_content = OLD.C2_comment_description,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_comment_AFTER_INSERT` AFTER INSERT ON `tbl_C2_activity_comment` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

    SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
    
    INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'CREATE',
				C2_user_id = user_id,
                C2_project_id = NEW.C2_project_id,
                C2_log_module = 'activity_comment',
				C2_log_module_operation_id = NEW.C2_comment_id,
                C2_log_on_field = 'COMMENT',
				C2_log_old_content = NEW.C2_comment_description,
				C2_log_created_on = NOW(); 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tbl_C2_activity_comment_AFTER_UPDATE` AFTER UPDATE ON `tbl_C2_activity_comment` FOR EACH ROW BEGIN
	DECLARE user_id VARCHAR(200);

	SELECT C2_user_id INTO user_id  FROM tbl_C2_current_operation_user;
	
	/*if */
	IF (OLD.C2_comment_description <> NEW.C2_comment_description) THEN
		INSERT INTO tbl_C2_log_book
			SET 
				C2_log_operation = 'EDIT',
				C2_user_id = user_id,
				C2_project_id = OLD.C2_project_id,
				C2_log_module = 'activity_comment',
				C2_log_module_operation_id = OLD.C2_comment_id,
				C2_log_on_field = 'COMMENT',
				C2_log_old_content = OLD.C2_comment_description,
				C2_log_new_content = NEW.C2_comment_description,
				C2_log_created_on = NOW(); 
	END IF;
END
$$
DELIMITER ;

--
-- Triggers `tbl_C2_goal`
--
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

--
-- Triggers `tbl_C2_project`
--
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

--
-- Triggers `tbl_C2_project_member_association`
--
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

--
-- Triggers `tbl_C2_sprint`
--
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