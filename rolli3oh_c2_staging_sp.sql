-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Apr 22, 2021 at 03:01 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: rolli3oh_c2
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `proc_IF` (IN `segment` VARCHAR(200), IN `task_name` VARCHAR(200))  BEGIN
    IF segment != -1 THEN
        SELECT
                            tbl_C2_task.C2_segment AS segment,
                            tbl_C2_task.C2_task_id AS taskId,
                            tbl_C2_task.C2_task_name AS taskName,
                            tbl_C2_task.C2_task_end_date AS taskEndDate
                            FROM
                            tbl_C2_task
                            WHERE
                            tbl_C2_task.C2_segment = segment
                            AND
                            C2_task_name = task_name;
    ELSE
        SELECT
                            tbl_C2_task.C2_segment AS segment,
                            tbl_C2_task.C2_task_id AS taskId,
                            tbl_C2_task.C2_task_name AS taskName,
                            tbl_C2_task.C2_task_end_date AS taskEndDate
                            FROM
                            tbl_C2_task
                            WHERE
                            C2_task_name = task_name;
    END IF;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_activate_user_account` (IN `user_email` VARCHAR(200))  NO SQL
UPDATE 
tbl_C2_user
	SET
		C2_user_status  = "ACTIVE",
		C2_user_verification_code = "VEREFIED",
		C2_user_updated_at = now()
	WHERE 
		C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_add_new_log_book_entry` (IN `project_id` VARCHAR(200), IN `user_id` VARCHAR(200), IN `log_operation` VARCHAR(10), IN `log_module` VARCHAR(10), IN `module_operation_id` VARCHAR(200), IN `log_content` VARCHAR(10000))  NO SQL
INSERT INTO 
                        tbl_C2_log_book 
                            (
                                C2_project_id,
                                C2_user_id,  
                                C2_log_operation, 
                                C2_log_module,
                                C2_log_module_operation_id,
                                C2_log_content,
                                C2_log_created_on
                            ) 
                        values 
                            (
                                project_id,
                                user_id,
                                log_operation,
                                log_module,
                                module_operation_id,
                                log_content,
                                now()
                            )$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_attach_project_to_member` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `added_user_id` VARCHAR(200), IN `project_user_type_id` VARCHAR(200))  NO SQL
BEGIN
    /*current user	*/
	CALL sp_update_current_operation_user(user_id);
    INSERT INTO 
        tbl_C2_project_member_association 
            (
                C2_project_id, 
                C2_user_id, 
                C2_project_user_type_id,
                C2_project_member_created_on
            ) 
        values 
            (
                project_id,
                added_user_id,
                project_user_type_id,
                now()
            );
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_check_if_user_can_crud` (IN `project_id` VARCHAR(200), IN `user_id` VARCHAR(200))  NO SQL
SELECT 
    C2_crud_project AS crudProject,
    C2_crud_member AS crudMember,
    C2_crud_sprint AS crudSprint
FROM 
    tbl_C2_project_member_type
LEFT JOIN
    tbl_C2_project_member_association
ON
    tbl_C2_project_member_type.C2_project_member_type_id = tbl_C2_project_member_association.C2_project_user_type_id
WHERE 
    tbl_C2_project_member_association.C2_project_id = project_id
AND
    tbl_C2_project_member_association.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_delete_project` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `project_name` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	DELETE 
		FROM 
			tbl_C2_project 
		WHERE 
			C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_delete_project_member` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `added_user_id` VARCHAR(200))  NO SQL
BEGIN
/*current user	*/
	CALL sp_update_current_operation_user(user_id);
DELETE 
                        FROM 
                            tbl_C2_project_member_association
                        WHERE 
                            C2_project_id = project_id
                        AND 
                            C2_user_id = added_user_id;
                            END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_delete_sprint` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `sprint_name` VARCHAR(200))  NO SQL
BEGIN
/*current user	*/
	CALL sp_update_current_operation_user(user_id);
DELETE 
            FROM 
                tbl_C2_sprint 
            WHERE 
                C2_sprint_id = sprint_id;
                END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_delete_user_story` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `theme_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `user_story_name` VARCHAR(200))  NO SQL
BEGIN
/*current user	*/
	CALL sp_update_current_operation_user(user_id);
DELETE 
                        FROM 
                            tbl_C2_user_story 
                        WHERE 
                            C2_user_story_id = user_story_id;
                                
                                END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_generate_user_password_reset_Code` (IN `user_password_reset_code` VARCHAR(200), IN `user_email` VARCHAR(200))  NO SQL
UPDATE 
	tbl_C2_user
		SET
			C2_user_password_reset_code  = user_password_reset_code,
			C2_user_updated_at = now()
		WHERE 
			C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_access_privilege_details` ()  NO SQL
SELECT 
                            tbl_C2_project_member_type.C2_project_member_type_id AS userTypeId,
                            tbl_C2_project_member_type.C2_project_member_type_name AS userTypeName,
                            tbl_C2_project_member_type.C2_project_member_type_description AS userTypeDescription,
                            tbl_C2_project_member_type.C2_user_access_privilege_level AS userAccessPrivilegeLevel,
                            tbl_C2_project_member_type.C2_crud_project AS crudProject,
                            tbl_C2_project_member_type.C2_crud_theme AS crudTheme,
                            tbl_C2_project_member_type.C2_crud_member AS crudMember,
                            tbl_C2_project_member_type.C2_crud_sprint AS crudSprint,
                            tbl_C2_project_member_type.C2_crud_epic AS crudEpic,
                            tbl_C2_project_member_type.C2_crud_user_story AS crudUserStory,
                            tbl_C2_project_member_type.C2_crud_task_issue AS crudTaskIssue,
                            tbl_C2_project_member_type.C2_crud_release AS crudRelease,
                            tbl_C2_project_member_type.C2_crud_test_cycle AS crudTestCycle,
                            tbl_C2_project_member_type.C2_crud_test_case AS crudTestCase,
                            tbl_C2_project_member_type.C2_crud_test_cycle_execution AS crudTestCycleExecution,
                            tbl_C2_project_member_type.C2_crud_task_work_log AS crudTaskWorkLog,
                            tbl_C2_project_member_type.C2_crud_comment AS crudComment,
                            tbl_C2_project_member_type.C2_crud_sub_task AS crudSubTask,
                            tbl_C2_project_member_type.C2_crud_tag AS crudTag
                        FROM 
                            tbl_C2_project_member_type$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_measurement_criteria_for_project_sprint_userstory` (IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `user_story_id` VARCHAR(200))  NO SQL
BEGIN
    SELECT 
        tbl_C2_task_type_measurement_criteria.C2_task_type_measurement_criteria_id as taskTypeMeasurementCriteriaId,
        tbl_C2_task_type_measurement_criteria.C2_project_id as projectId,
        tbl_C2_task_type_measurement_criteria.C2_sprint_id as sprintId,
        tbl_C2_sprint.C2_sprint_name as sprintName,
        tbl_C2_sprint.C2_sprint_start_date as sprintStartDate,
        tbl_C2_sprint.C2_sprint_end_date as sprintEndDate,
        tbl_C2_task_type_measurement_criteria.C2_user_story_id as userStoryId,
        tbl_C2_user_story.C2_user_story_name as userStoryName,
        tbl_C2_user_story.C2_user_story_description as userStoryDescription,
        tbl_C2_task_type_measurement_criteria.C2_task_type_id as taskTypeId,
        tbl_C2_task_type.C2_task_type_name as taskTypeName,
        tbl_C2_task_type.C2_task_type_description as taskTypeDescription,
        tbl_C2_task_type_measurement_criteria.C2_characteristics_higher_better AS characteristicsHigherBetter,
        tbl_C2_task_type_measurement_criteria.C2_measurement_purpose as measurementPurpose,
        tbl_C2_task_type_measurement_criteria.C2_task_type_measurement_type as taskTypeMeasurementType,
        tbl_C2_task_type_measurement_criteria.C2_criteria_poor_value as criteriaPoorValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_improvement_value as criteriaImprovementValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_expectation_value as criteriaExpectationValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_exceed_value as criteriaExceedValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_outstanding_value as criteriaOutstandingValue
        
    FROM 
        tbl_C2_task_type_measurement_criteria
    LEFT JOIN
      tbl_C2_sprint
    ON
      tbl_C2_task_type_measurement_criteria.C2_sprint_id = tbl_C2_sprint.C2_sprint_id
    LEFT JOIN
      tbl_C2_task_type
    ON
      tbl_C2_task_type_measurement_criteria.C2_task_type_id = tbl_C2_task_type.C2_task_type_id
    LEFT JOIN
      tbl_C2_user_story
    ON
      tbl_C2_task_type_measurement_criteria.C2_user_story_id =  tbl_C2_user_story.C2_user_story_id
    WHERE 
        tbl_C2_task_type_measurement_criteria.C2_project_id = project_id
	AND
		tbl_C2_task_type_measurement_criteria.C2_sprint_id = sprint_id
	AND
		tbl_C2_task_type_measurement_criteria.C2_user_story_id = user_story_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_projects_for_user` (IN `user_id` VARCHAR(200))  NO SQL
SELECT
    tbl_C2_project.C2_project_id AS projectId,
    tbl_C2_project.C2_project_name AS projectName,
    tbl_C2_project.C2_project_description AS projectDescription,
    DATE_FORMAT(tbl_C2_project.C2_project_created_on,'%D %b %Y %r') AS projectCreatedOn

FROM 
    tbl_C2_project
LEFT JOIN
    tbl_C2_project_member_association  
ON
    tbl_C2_project.C2_project_id = tbl_C2_project_member_association.C2_project_id
WHERE 
    tbl_C2_project_member_association.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_project_administrators` (IN `project_id` VARCHAR(200))  BEGIN
	SELECT
		tbl_C2_project_member_association.C2_user_id AS userId,
		tbl_C2_project_member_association.C2_project_id AS projectId,
		tbl_C2_project_member_association.C2_project_user_type_id AS projectUserTypeId,
		tbl_C2_project_member_type.C2_project_member_type_name AS projectMemberTypeName,
		tbl_C2_user.C2_user_first_name AS userFirstName,
		tbl_C2_user.C2_user_last_name AS userLastName,
		tbl_C2_user.C2_user_email AS userEmail
		
	FROM 
		tbl_C2_project_member_association
	LEFT JOIN
		tbl_C2_project_member_type
	ON
		tbl_C2_project_member_association.C2_project_user_type_id = tbl_C2_project_member_type.C2_project_member_type_id
	LEFT JOIN
		tbl_C2_user
	ON
		tbl_C2_project_member_association.C2_user_id = tbl_C2_user.C2_user_id
	WHERE 
		tbl_C2_project_member_association.C2_project_id = project_id
	AND
		tbl_C2_project_member_type.C2_project_member_type_id = 'PROJECTUSERTYPEID_0001';
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_project_members` (IN `project_id` VARCHAR(200))  BEGIN
	SELECT
		tbl_C2_project_member_association.C2_user_id AS userId,
		tbl_C2_project_member_association.C2_project_id AS projectId,
		tbl_C2_project_member_association.C2_project_user_type_id AS projectUserTypeId,
		tbl_C2_project_member_type.C2_project_member_type_name AS projectMemberTypeName,
		tbl_C2_user.C2_user_first_name AS userFirstName,
		tbl_C2_user.C2_user_last_name AS userLastName,
		tbl_C2_user.C2_user_email AS userEmail
		
	FROM 
		tbl_C2_project_member_association
	LEFT JOIN
		tbl_C2_project_member_type
	ON
		tbl_C2_project_member_association.C2_project_user_type_id = tbl_C2_project_member_type.C2_project_member_type_id
	LEFT JOIN
		tbl_C2_user
	ON
		tbl_C2_project_member_association.C2_user_id = tbl_C2_user.C2_user_id
	WHERE 
		tbl_C2_project_member_association.C2_project_id = project_id
	AND
		tbl_C2_project_member_type.C2_project_member_type_id = 'PROJECTUSERTYPEID_0002';
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_project_settings` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_project_settings.C2_project_id AS projectId,
                            tbl_C2_project_settings.C2_over_all_completion_status_id AS overAllCompletionStatusId,
                            tbl_C2_project_settings.C2_sprint_close_move_item_status_id AS sprintCloseMoveItemStatusId,
                            tbl_C2_task_status.C2_task_status_name AS taskStatusName
                        FROM 
                            tbl_C2_project_settings
                        LEFT JOIN
                            tbl_C2_task_status
                        ON
                            tbl_C2_project_settings.C2_over_all_completion_status_id = tbl_C2_task_status.C2_task_status_id
                        WHERE
                            tbl_C2_project_settings.C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_project_users` (IN `project_id` VARCHAR(200))  BEGIN
	SELECT
		tbl_C2_project_member_association.C2_user_id AS userId,
		tbl_C2_project_member_association.C2_project_id AS projectId,
		tbl_C2_project_member_association.C2_project_user_type_id AS projectUserTypeId,
		tbl_C2_project_member_type.C2_project_member_type_name AS projectMemberTypeName,
		tbl_C2_user.C2_user_first_name AS userFirstName,
		tbl_C2_user.C2_user_last_name AS userLastName,
		tbl_C2_user.C2_user_email AS userEmail
		
	FROM 
		tbl_C2_project_member_association
	LEFT JOIN
		tbl_C2_project_member_type
	ON
		tbl_C2_project_member_association.C2_project_user_type_id = tbl_C2_project_member_type.C2_project_member_type_id
	LEFT JOIN
		tbl_C2_user
	ON
		tbl_C2_project_member_association.C2_user_id = tbl_C2_user.C2_user_id
	WHERE 
		tbl_C2_project_member_association.C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_sprints` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_sprint.C2_sprint_id AS sprintId,
                            tbl_C2_sprint.C2_sprint_name AS sprintName,
                            tbl_C2_sprint.C2_sprint_start_date AS sprintStartDate,
                            tbl_C2_sprint.C2_sprint_end_date AS sprintEndDate,
                            tbl_C2_sprint.C2_sprint_status AS sprintStatus
                        FROM 
                            tbl_C2_sprint
                        WHERE 
                            tbl_C2_sprint.C2_project_id = project_id
                        ORDER BY 
                            C2_sprint_created_on DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_sprints_by_created_asc` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_sprint.C2_sprint_id AS sprintId,
                            tbl_C2_sprint.C2_sprint_name AS sprintName,
                            tbl_C2_sprint.C2_sprint_start_date AS sprintStartDate,
                            tbl_C2_sprint.C2_sprint_end_date AS sprintEndDate,
                            tbl_C2_sprint.C2_sprint_status AS sprintStatus
                        FROM 
                            tbl_C2_sprint
                        WHERE 
                            tbl_C2_sprint.C2_project_id = project_id
                        ORDER BY 
                            C2_sprint_created_on ASC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_sprints_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                tbl_C2_sprint.C2_project_id AS projectId,
                tbl_C2_sprint.C2_sprint_id AS sprintId,
                tbl_C2_sprint.C2_sprint_name AS sprintName,
                tbl_C2_sprint.C2_sprint_start_date AS sprintStartDate,
                tbl_C2_sprint.C2_sprint_end_date AS sprintEndDate,
                tbl_C2_sprint.C2_sprint_status AS sprintStatus
            FROM 
                tbl_C2_sprint
            LEFT JOIN
                tbl_C2_project
            ON
                tbl_C2_sprint.C2_project_id = tbl_C2_project.C2_project_id
            WHERE 
                tbl_C2_sprint.C2_project_id = project_id
            AND 
                tbl_C2_sprint.C2_sprint_name != 'No Sprint'
                ORDER BY C2_sprint_created_on DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_task_reviewers_for_task_sprint` (IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `task_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `matrix_user_id` VARCHAR(200))  NO SQL
SELECT 
	DISTINCT tbl_C2_task_review.C2_task_review_id AS taskReviewId,
    tbl_C2_task_review.C2_project_id AS projectId,
    tbl_C2_task_review.C2_sprint_id AS sprintId,
    tbl_C2_task_review.C2_task_id AS taskId,
    tbl_C2_task_review.C2_reviewer_user_id AS reviewerUserId,
    tbl_C2_user.C2_user_first_name AS userFirstName,
    tbl_C2_user.C2_user_last_name AS userLastName,
    tbl_C2_user.C2_user_email AS userEmail,
    tbl_C2_task_review.C2_achieved_result_value AS achievedResultValue,
    tbl_C2_task_review.C2_reviewer_comment AS reviewerComment,
    tbl_C2_task.C2_task_type_id AS taskTypeId,
    tbl_C2_task_type_measurement_criteria.C2_task_type_measurement_type AS taskTypeMeasurementType,
    tbl_C2_task_type_measurement_criteria.C2_characteristics_higher_better AS characteristicsHigherBetter,
    tbl_C2_task_type_measurement_criteria.C2_criteria_poor_value AS criteriaPoorValue,
    tbl_C2_task_type_measurement_criteria.C2_criteria_improvement_value AS criteriaImprovementValue,
    tbl_C2_task_type_measurement_criteria.C2_criteria_expectation_value AS criteriaExpectationValue,
    tbl_C2_task_type_measurement_criteria.C2_criteria_exceed_value AS criteriaExceedValue,
    tbl_C2_task_type_measurement_criteria.C2_criteria_outstanding_value AS criteriaOutstandingValue
FROM 
    tbl_C2_task_review
LEFT JOIN
	tbl_C2_user
ON
	tbl_C2_task_review.C2_reviewer_user_id =  tbl_C2_user.C2_user_id
LEFT JOIN
	tbl_C2_task
ON
	tbl_C2_task_review.C2_task_id = tbl_C2_task.C2_task_id
LEFT JOIN
	tbl_C2_task_type_measurement_criteria
ON
	tbl_C2_task.C2_task_type_id = tbl_C2_task_type_measurement_criteria.C2_task_type_id
RIGHT JOIN
	tbl_C2_user_performance_matrix
ON
	tbl_C2_task.C2_user_story_id = tbl_C2_user_performance_matrix.C2_user_story_id
WHERE 
    tbl_C2_task_review.C2_project_id = project_id
AND 
    tbl_C2_task_review.C2_sprint_id = sprint_id
AND 
    tbl_C2_task_review.C2_task_id = task_id
AND
	tbl_C2_task_type_measurement_criteria.C2_user_story_id = user_story_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_task_type_measurement_criteria_for_project` (IN `project_id` VARCHAR(200))  NO SQL
BEGIN
    SELECT 
        tbl_C2_task_type_measurement_criteria.C2_task_type_measurement_criteria_id as taskTypeMeasurementCriteriaId,
        tbl_C2_task_type_measurement_criteria.C2_project_id as projectId,
        tbl_C2_task_type_measurement_criteria.C2_sprint_id as sprintId,
        tbl_C2_sprint.C2_sprint_name as sprintName,
        tbl_C2_sprint.C2_sprint_start_date as sprintStartDate,
        tbl_C2_sprint.C2_sprint_end_date as sprintEndDate,
        tbl_C2_task_type_measurement_criteria.C2_user_story_id as userStoryId,
        tbl_C2_user_story.C2_user_story_name as userStoryName,
        tbl_C2_user_story.C2_user_story_description as userStoryDescription,
        tbl_C2_task_type_measurement_criteria.C2_task_type_id as taskTypeId,
        tbl_C2_task_type.C2_task_type_name as taskTypeName,
        tbl_C2_task_type.C2_task_type_description as taskTypeDescription,
        tbl_C2_task_type_measurement_criteria.C2_measurement_purpose as measurementPurpose,
        tbl_C2_task_type_measurement_criteria.C2_task_type_measurement_type as taskTypeMeasurementType,
        tbl_C2_task_type_measurement_criteria.C2_criteria_poor_value as criteriaPoorValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_improvement_value as criteriaImprovementValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_expectation_value as criteriaExpectationValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_exceed_value as criteriaExceedValue,
        tbl_C2_task_type_measurement_criteria.C2_criteria_outstanding_value as criteriaOutstandingValue,
        tbl_C2_task_type_measurement_criteria.C2_characteristics_higher_better as characteristicsHigherBetter
        
    FROM 
        tbl_C2_task_type_measurement_criteria
    LEFT JOIN
      tbl_C2_sprint
    ON
      tbl_C2_task_type_measurement_criteria.C2_sprint_id = tbl_C2_sprint.C2_sprint_id
    LEFT JOIN
      tbl_C2_task_type
    ON
      tbl_C2_task_type_measurement_criteria.C2_task_type_id = tbl_C2_task_type.C2_task_type_id
    LEFT JOIN
      tbl_C2_user_story
    ON
      tbl_C2_task_type_measurement_criteria.C2_user_story_id =  tbl_C2_user_story.C2_user_story_id
    WHERE 
        tbl_C2_task_type_measurement_criteria.C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_users` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_user.C2_user_id AS userId, 
                            tbl_C2_user.C2_user_first_name AS userFirstName, 
                            tbl_C2_user.C2_user_last_name AS userLastName,
                             tbl_C2_user.C2_user_email AS userEmail,
                            tbl_C2_user.C2_user_designation AS userDesignation,
                            tbl_C2_project_member_association.C2_project_user_type_id AS userTypeId,
                            tbl_C2_project_member_type.C2_project_member_type_name AS userTypeName
                        FROM 
                            tbl_C2_user  
                        LEFT JOIN    
                            tbl_C2_project_member_association  
                        ON
                            tbl_C2_user.C2_user_id = tbl_C2_project_member_association.C2_user_id
                        LEFT JOIN
                        	tbl_C2_project_member_type
                        ON
                        	tbl_C2_project_member_association.C2_project_user_type_id = tbl_C2_project_member_type.C2_project_member_type_id
                        WHERE 
                            tbl_C2_project_member_association.C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_users_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT
                tbl_C2_user.C2_user_id AS userId,
                tbl_C2_user.C2_user_first_name AS userFirstName,
                tbl_C2_user.C2_user_last_name AS userLastName,
                tbl_C2_user.C2_user_email AS userEmail,
                tbl_C2_user.C2_user_designation AS userDesignation,
                tbl_C2_project_member_type.C2_project_member_type_name AS userTypeName
            FROM
                tbl_C2_user
            LEFT JOIN
                tbl_C2_project_member_association
            ON
                tbl_C2_user.C2_user_id = tbl_C2_project_member_association.C2_user_id
            LEFT JOIN
                tbl_C2_project_member_type
            ON
                tbl_C2_project_member_association.C2_project_user_type_id = tbl_C2_project_member_type.C2_project_member_type_id
            WHERE
                tbl_C2_project_member_association.C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_users_in_domain` (IN `domain_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_user.C2_user_id AS userId, 
                            tbl_C2_user.C2_user_first_name AS userFirstName, 
                            tbl_C2_user.C2_user_last_name AS userLastName,
                             tbl_C2_user.C2_user_email AS userEmail,
                            tbl_C2_user.C2_user_designation AS userDesignation
                        FROM 
                            tbl_C2_user  
                        LEFT JOIN    
                            tbl_C2_domain  
                        ON
                            tbl_C2_user.C2_user_domain = tbl_C2_domain.C2_domain_name
                        WHERE 
                            tbl_C2_domain.C2_domain_id = domain_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_user_performance_stories_for_user_project_sprint` (IN `project_id` VARCHAR(200), IN `matrix_user_id` VARCHAR(200), IN `sprint_id` VARCHAR(200))  NO SQL
BEGIN
    SELECT 
        tbl_C2_user_performance_matrix.C2_user_performance_matrix_id as userPerformanceMatrixId,
        tbl_C2_user_performance_matrix.C2_project_id as projectId,
        tbl_C2_user_performance_matrix.C2_sprint_id as sprintId,
        tbl_C2_sprint.C2_sprint_name as sprintName,
        tbl_C2_sprint.C2_sprint_start_date as sprintStartDate,
        tbl_C2_sprint.C2_sprint_end_date as sprintEndDate,
        tbl_C2_user_performance_matrix.C2_user_story_id as userStoryId,
        tbl_C2_user_story.C2_user_story_name as userStoryName,
        tbl_C2_user_story.C2_user_story_description as userStoryDescription,
        tbl_C2_user_performance_matrix.C2_weight as weight,
        tbl_C2_user_performance_matrix.C2_matrix_user_id as matrixUserId,
        tbl_C2_user.C2_user_first_name as userFirstName,
        tbl_C2_user.C2_user_last_name as userLastName,
        tbl_C2_user.C2_user_email as userEmail
        
    FROM 
        tbl_C2_user_performance_matrix
    LEFT JOIN
      tbl_C2_sprint
    ON
      tbl_C2_user_performance_matrix.C2_sprint_id = tbl_C2_sprint.C2_sprint_id
    LEFT JOIN
      tbl_C2_user_story
    ON
      tbl_C2_user_performance_matrix.C2_user_story_id =  tbl_C2_user_story.C2_user_story_id
    LEFT JOIN
        tbl_C2_user
    ON
        tbl_C2_user_performance_matrix.C2_matrix_user_id = tbl_C2_user.C2_user_id
    WHERE 
        tbl_C2_user_performance_matrix.C2_project_id = project_id
	AND
		tbl_C2_user_performance_matrix.C2_sprint_id = sprint_id
	AND
		tbl_C2_user_performance_matrix.C2_matrix_user_id = matrix_user_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_all_user_story_for_project` (IN `project_id` VARCHAR(200))  BEGIN
	SELECT 
		C2_project_id AS projectId,
		C2_user_story_id AS userStoryId,
		C2_user_story_name AS userStoryName,
		C2_user_story_description AS userStoryDescription
	FROM 
		tbl_C2_user_story
	WHERE 
		C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_basic_project_details` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
    C2_project_id AS projectId,
    C2_project_name AS projectName,
    C2_project_description AS projectDescription 
FROM 
    tbl_C2_project 
WHERE 
    C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_current_operation_user` (OUT `user_id` VARCHAR(200))  NO SQL
BEGIN
      SELECT C2_user_id FROM tbl_C2_current_operation_user;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_domain_id_by_user_id` (IN `user_id` VARCHAR(200))  NO SQL
SELECT 
    C2_domain_id AS domainId
FROM 
    tbl_C2_domain 
LEFT JOIN
    tbl_C2_user
ON
    tbl_C2_user.C2_user_domain = tbl_C2_domain.C2_domain_name
WHERE 
    tbl_C2_user.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_if_user_inactive` (IN `user_email` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_email
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email
                        AND
                            C2_user_status = 'INACTIVE'$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_log_book` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `log_book_id` INT(20))  NO SQL
BEGIN
SET @Query = '';
    SET @Q_log_book_items  = '';
    SET @Q_orderby  = '';
    SET @Q_limit  = '';
    SET @Q_project_id = '';
    
    SET @Query = '
    SELECT
		tbl_C2_log_book.C2_log_book_id AS logBookId,
        tbl_C2_log_book.C2_project_id AS projectId,
        tbl_C2_log_book.C2_user_id AS byUserId,
        tbl_C2_user.C2_user_first_name AS byUserFirstName,
        tbl_C2_user.C2_user_last_name AS byUserLastName,
        tbl_C2_log_book.C2_log_operation AS opetrationType,
        tbl_C2_log_book.C2_log_module AS onModule,
        tbl_C2_log_book.C2_log_module_operation_id AS operationId,
        tbl_C2_log_book.C2_log_on_field AS onField,
        tbl_C2_log_book.C2_log_old_content AS oldContent,
        tbl_C2_log_book.C2_log_new_content AS newContent,
        DATE_FORMAT(tbl_C2_log_book.C2_log_created_on,"%D %b %Y %r") AS createdOn
    FROM
        tbl_C2_log_book
    LEFT JOIN
        tbl_C2_user
    ON
        tbl_C2_log_book.C2_user_id = tbl_C2_user.C2_user_id';
    
    SET @Q_project_id  = CONCAT(' WHERE tbl_C2_log_book.C2_project_id =  "',project_id,'"');
    
    IF log_book_id != -1 THEN
        SET @Q_log_book_items  = CONCAT(' AND tbl_C2_log_book.C2_log_book_id < ' , log_book_id);
    END IF;
    
    SET @Q_orderby  = CONCAT(' ORDER BY tbl_C2_log_book.C2_log_book_id DESC');

    SET @Q_limit  = CONCAT(' LIMIT 10');
      
	SET @Query = CONCAT(@Query, @Q_project_id, @Q_log_book_items, @Q_orderby, @Q_limit);

INSERT INTO tbl_C2_sp_log VALUES(@Query);

PREPARE stmt FROM @Query;
  
EXECUTE stmt;
DEALLOCATE PREPARE stmt; 

END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_member_count_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            COUNT(C2_user_id) AS noOfMember
                        FROM 
                            tbl_C2_project_member_association 
                        WHERE 
                            C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_no_sprint_id_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            C2_sprint_id as sprintId
                        FROM 
                            tbl_C2_sprint 
                        WHERE 
                            C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_project_member_association` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_project_member_association.C2_user_id AS userId
                        FROM 
                            tbl_C2_project_member_association  
                        WHERE 
                            tbl_C2_project_member_association.C2_project_id = project_id
                        AND
                            tbl_C2_project_member_association.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_project_name_by_project_id` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            C2_project_name as projectName
                        FROM 
                            tbl_C2_project 
                        WHERE 
                            C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_sign_in_user` (IN `user_email` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_id AS userId,
                            C2_user_password AS userPassword
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email
                        AND
                            C2_user_status = 'ACTIVE'$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_sprints_between_dates` (IN `project_id` VARCHAR(200), IN `start_date` VARCHAR(200), IN `end_date` VARCHAR(200))  NO SQL
SELECT
                            tbl_C2_sprint.C2_project_id AS projectId,
                            tbl_C2_sprint.C2_sprint_id AS sprintId,
                            tbl_C2_sprint.C2_sprint_name AS sprintName,
                            DATE_FORMAT(tbl_C2_sprint.C2_sprint_created_on,'%D %b %Y %r') AS sprintCreatedOn
                        FROM
                            tbl_C2_sprint
                        WHERE
                            tbl_C2_sprint.C2_project_id = project_id
                        AND
                            tbl_C2_sprint.C2_sprint_status != 'NO_SPRINT_STATUS'
                        AND
                            tbl_C2_sprint.C2_sprint_status != 'Future'
                        AND
                            DATE_FORMAT(tbl_C2_sprint.C2_sprint_created_on, '%Y-%m-%d') >= start_date
                        AND
                            DATE_FORMAT(tbl_C2_sprint.C2_sprint_created_on, '%Y-%m-%d') <= end_date
                        ORDER BY
                            tbl_C2_sprint.C2_sprint_created_on DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_sprint_count_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT 
                            COUNT(C2_sprint_id) AS noOfSprint
                        FROM 
                            tbl_C2_sprint 
                        WHERE 
                            C2_project_id = project_id
                        AND
                            C2_sprint_name != 'No Sprint'$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_sprint_name_by_sprint_id` (IN `operation_id` VARCHAR(200))  NO SQL
BEGIN
    SELECT 
        C2_sprint_name as sprintName
    FROM 
        tbl_C2_sprint
    WHERE 
        C2_sprint_id = operation_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_user_details_by_email` (IN `user_email` VARCHAR(200))  NO SQL
SELECT
                            tbl_C2_user.C2_user_id AS userId,  
                            tbl_C2_user.C2_user_first_name AS userFirstName, 
                            tbl_C2_user.C2_user_last_name AS userLastName,
                            tbl_C2_user.C2_user_email AS userEmail,
                            tbl_C2_user.C2_user_security_answer_1 AS userSecurityAnswer1,
                            tbl_C2_user.C2_user_security_answer_2 AS userSecurityAnswer2
                        FROM 
                            tbl_C2_user  
                        WHERE 
                            tbl_C2_user.C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_user_details_by_id` (IN `user_id` VARCHAR(200))  NO SQL
SELECT
                            tbl_C2_user.C2_user_id AS userId,  
                            tbl_C2_user.C2_user_first_name AS userFirstName, 
                            tbl_C2_user.C2_user_last_name AS userLastName,
                            tbl_C2_user.C2_user_email AS userEmail,
                            tbl_C2_user.C2_user_security_answer_1 AS userSecurityAnswer1,
                            tbl_C2_user.C2_user_security_answer_2 AS userSecurityAnswer2
                        FROM 
                            tbl_C2_user  
                        WHERE 
                            tbl_C2_user.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_user_details_by_search_text` (IN `user_id` VARCHAR(200), IN `search_key` VARCHAR(200))  BEGIN  
   set @sql = concat("
   SELECT
		tbl_C2_user.C2_user_id AS userId,  
		tbl_C2_user.C2_user_first_name AS userFirstName, 
		tbl_C2_user.C2_user_last_name AS userLastName,
		tbl_C2_user.C2_user_email AS userEmail
	FROM
		tbl_C2_user 
	WHERE 
    (
		tbl_C2_user.C2_user_first_name LIKE CONCAT('%" , search_key , "%')
	OR 
		tbl_C2_user.C2_user_last_name LIKE CONCAT('%" , search_key , "%')
	OR 
		tbl_C2_user.C2_user_email LIKE CONCAT('%" , search_key , "%')
	)
	AND
		tbl_C2_user.C2_user_id != '5f3fe04c08618' /*System user*/
    AND
		tbl_C2_user.C2_user_status = 'ACTIVE'
	");
	
    /*INSERT INTO tbl_C2_sp_log VALUES(@sql);*/
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_user_domain_details` (IN `user_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_user.C2_user_domain AS userDomainName,
                            tbl_C2_domain.C2_domain_id AS userDomainId,
                            tbl_C2_domain.C2_domain_controller_user_id AS userDomainControllerId,
                            tbl_C2_user.C2_user_first_name AS userDomainControllerFirstName,
                            tbl_C2_user.C2_user_last_name AS userDomainControllerLastName,
                            tbl_C2_user.C2_user_email AS userDomainControllerEmail,
                            tbl_C2_domain.C2_domain_status AS userDomainStatus
                        FROM 
                            tbl_C2_user 
                       	LEFT JOIN 
                       		tbl_C2_domain
                       	ON
                           tbl_C2_user.C2_user_domain = tbl_C2_domain.C2_domain_name
                        WHERE 
                            tbl_C2_user.C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_get_user_name_by_user_id` (IN `operation_id` VARCHAR(200))  NO SQL
BEGIN
    SELECT 
       CONCAT(C2_user_first_name, ' ',C2_user_last_name)  as userName
    FROM 
        tbl_C2_user 
    WHERE 
        C2_user_id = operation_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_domain_already_exist` (IN `user_domain` VARCHAR(200))  NO SQL
SELECT 
                            C2_domain_id AS domainId
                        FROM 
                             tbl_C2_domain 
                        WHERE 
                             C2_domain_name = user_domain$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_existing_user` (IN `user_email` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_id
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_measurement_criteria_already_added_to_same_task_type` (IN `project_id` VARCHAR(200), IN `measurement_purpose` VARCHAR(400))  NO SQL
SELECT 
    C2_task_type_id AS taskTypeId
FROM 
    tbl_C2_task_type_measurement_criteria
WHERE 
    tbl_C2_task_type_measurement_criteria.C2_measurement_purpose = measurement_purpose 
AND 
    tbl_C2_task_type_measurement_criteria.C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_member_already_same_project` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200))  NO SQL
SELECT 
    C2_user_id as userId
FROM 
    tbl_C2_project_member_association
WHERE 
    tbl_C2_project_member_association.C2_user_id =user_id
AND
    tbl_C2_project_member_association.C2_project_id =project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_member_associated_to_any_task_for_project` (IN `project_id` VARCHAR(200), IN `user_id` VARCHAR(200))  NO SQL
SELECT 
                            tbl_C2_task.C2_task_assigned_user_id
                        FROM 
                            tbl_C2_task 
                        LEFT JOIN
                            tbl_C2_user_story
                        ON
                            tbl_C2_task.C2_user_story_id = tbl_C2_user_story.C2_user_story_id
                        LEFT JOIN
                             tbl_C2_theme
                        ON
                            tbl_C2_user_story.C2_theme_id = tbl_C2_theme.C2_theme_id
                        WHERE 
                            tbl_C2_theme.C2_project_id = project_id
                        AND
                            tbl_C2_task.C2_task_assigned_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_password_reset_code_exist` (IN `user_email` VARCHAR(200), IN `user_password_reset_code` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_email
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email
                        AND
                            C2_user_password_reset_code = user_password_reset_code$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_performance_matrix_already_same_user` (IN `project_id` VARCHAR(200), IN `matrix_user_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `user_story_id` VARCHAR(200))  NO SQL
SELECT 
    C2_user_performance_matrix_id AS C2_user_performance_matrix_id
FROM 
    tbl_C2_user_performance_matrix
WHERE 
    tbl_C2_user_performance_matrix.C2_project_id = project_id 
AND 
    tbl_C2_user_performance_matrix.C2_matrix_user_id = matrix_user_id
AND 
    tbl_C2_user_performance_matrix.C2_sprint_id = sprint_id
AND 
    tbl_C2_user_performance_matrix.C2_user_story_id = user_story_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_project_already_exist` (IN `project_name` VARCHAR(200))  NO SQL
SELECT 
    tbl_C2_project.C2_project_name
FROM 
    tbl_C2_project
WHERE 
    tbl_C2_project.C2_project_name = project_name$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_sprint_already_created_for_same_project` (IN `sprint_name` VARCHAR(200), IN `project_id` VARCHAR(200))  NO SQL
SELECT 
    tbl_C2_sprint.C2_sprint_id
FROM 
    tbl_C2_sprint
WHERE 
    tbl_C2_sprint.C2_sprint_name = sprint_name
AND 
    tbl_C2_sprint.C2_project_id = project_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_task_already_created_for_same_user_story` (IN `task_name` VARCHAR(200), IN `user_story_id` VARCHAR(200))  NO SQL
SELECT 
                                C2_task_id AS taskId
                            FROM 
                                tbl_C2_task
                            WHERE 
                                tbl_C2_task.C2_user_story_id = user_story_id 
                            AND 
                                tbl_C2_task.C2_task_name = task_name$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_task_present_for_sprint` (IN `sprint_id` VARCHAR(200))  NO SQL
SELECT 
                            C2_task_id AS taskId 
                        FROM 
                            tbl_C2_task_sprint_association 
                        WHERE 
                            C2_sprint_id = sprint_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_user_identified` (IN `user_email` VARCHAR(200), IN `user_security_answer_1` VARCHAR(200), IN `user_security_answer_2` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_id AS userId
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email
                        AND
                            C2_user_security_answer_1 = user_security_answer_1
                        AND
                            C2_user_security_answer_2 = user_security_answer_2$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_user_story_already_created_for_same_project` (IN `user_story_name` VARCHAR(200), IN `project_id` VARCHAR(200))  NO SQL
SELECT 
    C2_user_story_id AS userStoryId
FROM 
    tbl_C2_user_story
WHERE 
    tbl_C2_user_story.C2_project_id = project_id 
AND 
    tbl_C2_user_story.C2_user_story_name = user_story_name$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_user_story_has_items` (IN `user_story_id` VARCHAR(200))  NO SQL
SELECT 
                            C2_task_id as taskId
                        FROM 
                            tbl_C2_task
                        LEFT JOIN
                             tbl_C2_user_story
                        ON
                            tbl_C2_task.C2_user_story_id = tbl_C2_user_story.C2_user_story_id
                        WHERE 
                            tbl_C2_user_story.C2_user_story_id = user_story_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_if_verification_code_valid` (IN `user_email` VARCHAR(200), IN `user_verification_code` VARCHAR(200))  NO SQL
SELECT 
                            C2_user_email
                        FROM 
                            tbl_C2_user 
                        WHERE 
                            C2_user_email = user_email
                        AND 
                            C2_user_verification_code = user_verification_code$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_domain` (IN `domain_id` VARCHAR(200), IN `user_domain` VARCHAR(200), IN `domain_controller_user_id` VARCHAR(200), IN `domain_status` VARCHAR(200))  NO SQL
INSERT INTO 
                        tbl_C2_domain 
                            (
                                C2_domain_id,
                                C2_domain_name, 
                                C2_domain_controller_user_id, 
                                C2_domain_status, 
                                C2_domain_created_at
                            ) 
                        values 
                            (
                                domain_id,
                                user_domain, domain_controller_user_id,
                                domain_status,
                                now()
                            )$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_project` (IN `user_id` VARCHAR(200), IN `project_name` VARCHAR(200), IN `project_id` VARCHAR(200), IN `project_description` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	INSERT INTO 
		tbl_C2_project 
			(
				C2_project_name,  
				C2_project_id, 
				C2_project_description,
				C2_project_created_on
			) 
		values 
			(
				project_name,
				project_id,
				project_description,
				now()
			);			
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_session` (IN `user_id` VARCHAR(200), IN `user_platform` VARCHAR(200), IN `user_ip` VARCHAR(200), IN `user_login_type` VARCHAR(200))  NO SQL
BEGIN
INSERT INTO 
	tbl_C2_user_session 
		(
			C2_session_user_id, 
			C2_session_user_platform, 
            C2_session_user_ip, 
            C2_session_user_login_type,
			C2_session_created_on
		) 
	values 
		(
			user_id,
			user_platform,
            user_ip,
            user_login_type,
			now()
		);
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_sprint` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `sprint_name` VARCHAR(200), IN `sprint_start_date` VARCHAR(200), IN `sprint_end_date` VARCHAR(200), IN `sprint_status` VARCHAR(200))  NO SQL
BEGIN
/*current user	*/
	CALL sp_update_current_operation_user(user_id);
INSERT INTO 
    tbl_C2_sprint 
        (
            C2_project_id, 
            C2_sprint_id, 
            C2_sprint_name,  
            C2_sprint_start_date,
            C2_sprint_end_date,
            C2_sprint_status,
            C2_sprint_created_on
        ) 
    values 
        (
            project_id,
            sprint_id,
            sprint_name,
            sprint_start_date,
            sprint_end_date,
            sprint_status,
            now()
        );
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_task` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `task_type_id` VARCHAR(200), IN `task_id` VARCHAR(200), IN `assignee_user_id` VARCHAR(200), IN `task_name` VARCHAR(200), IN `task_key_completion_indicator` VARCHAR(1000))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	INSERT INTO 
		tbl_C2_task 
			(
				C2_assignee_user_id,
				C2_project_id,
                C2_sprint_id,
				C2_user_story_id, 
				C2_task_type_id, 
				C2_task_id,  
				C2_task_name,
				C2_task_key_completion_indicator,
				C2_task_created_on
			) 
	values 
		(
				assignee_user_id,
				project_id,
                sprint_id,
				user_story_id,
				task_type_id,
				task_id,
				task_name,
				task_key_completion_indicator,
				now()
			);
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_task_review` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `task_id` VARCHAR(200), IN `task_review_id` VARCHAR(200), IN `reviewer_user_id` VARCHAR(200), IN `achieved_result_value` INT(11), IN `reviewer_comment` VARCHAR(1000))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	INSERT INTO 
		tbl_C2_task_review 
			(
				C2_project_id,
				C2_sprint_id,
				C2_task_id, 
				C2_task_review_id, 
				C2_reviewer_user_id,  
				C2_achieved_result_value,
				C2_reviewer_comment,
				C2_task_review_created_on
			) 
	values 
		(
				project_id,
				sprint_id,
				task_id,
				task_review_id,
				reviewer_user_id,
				achieved_result_value,
				reviewer_comment,
				now()
			);
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_user` (IN `user_id` VARCHAR(200), IN `user_first_name` VARCHAR(200), IN `user_last_name` VARCHAR(200), IN `user_password` VARCHAR(200), IN `user_email` VARCHAR(200), IN `user_status` VARCHAR(200), IN `user_security_answer_1` VARCHAR(200), IN `user_security_answer_2` VARCHAR(200), IN `user_verification_code` VARCHAR(200))  NO SQL
INSERT INTO 
tbl_C2_user 
(
	C2_user_id,
	C2_user_first_name, 
	C2_user_last_name, 
	C2_user_password, 
	C2_user_email, 
	C2_user_status,
	C2_user_security_answer_1,
	C2_user_security_answer_2,
	C2_user_verification_code,
	C2_user_created_at
) 
values 
(
	user_id,
	user_first_name,
	user_last_name,
	user_password,
	user_email,
	user_status,
	user_security_answer_1,
	user_security_answer_2,
	user_verification_code,
	now()
)$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_new_user_story` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `user_story_name` VARCHAR(200), IN `user_story_description` VARCHAR(400))  NO SQL
BEGIN
    /*current user	*/
	CALL sp_update_current_operation_user(user_id);
    INSERT INTO 
    tbl_C2_user_story 
        (
            C2_project_id, 
            C2_user_story_id, 
            C2_user_story_name,  
            C2_user_story_description,
            C2_user_story_created_on
        ) 
    values 
        (
            project_id,
            user_story_id,
            user_story_name,
            user_story_description,
            now()
        );
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_project_settings` (IN `project_id` VARCHAR(200), IN `user_id` VARCHAR(200), IN `over_all_completion_status_id` INT(20))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	
    INSERT INTO 
	tbl_C2_project_settings 
		(
			C2_project_id,
			C2_over_all_completion_status_id,
			C2_project_settings_created_on
		) 
	values 
		(
			project_id,
			over_all_completion_status_id,
			now()
		);
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_task_type_measurement_criteria` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `task_type_id` VARCHAR(200), IN `measurement_purpose` VARCHAR(400), IN `task_type_measurement_criteria_id` VARCHAR(200), IN `task_type_measurement_type` VARCHAR(10), IN `criteria_poor_value` INT(11), IN `criteria_improvement_value` INT(11), IN `criteria_expectation_value` INT(11), IN `criteria_exceed_value` INT(11), IN `criteria_outstanding_value` INT(11), IN `characteristics_higher_better` INT(11))  NO SQL
BEGIN
    /*current user	*/
	CALL sp_update_current_operation_user(user_id);
    INSERT INTO 
    tbl_C2_task_type_measurement_criteria 
        (
            C2_project_id, 
            C2_sprint_id, 
            C2_user_story_id,
            C2_task_type_measurement_criteria_id, 
            C2_task_type_id,
            C2_measurement_purpose,
            C2_task_type_measurement_type,  
            C2_criteria_poor_value,
            C2_criteria_improvement_value,
            C2_criteria_expectation_value,
            C2_criteria_exceed_value,
            C2_criteria_outstanding_value,
            C2_characteristics_higher_better,
            C2_task_type_measurement_criteria_created_at
        ) 
    values 
        (
            project_id,
            sprint_id,
            user_story_id,
            task_type_measurement_criteria_id,
            task_type_id,
            measurement_purpose,
            task_type_measurement_type,
            criteria_poor_value,
            criteria_improvement_value,
            criteria_expectation_value,
            criteria_exceed_value,
            criteria_outstanding_value,
            characteristics_higher_better,
            now()
        );
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_insert_user_performance_matrix` (IN `user_performance_matrix_id` VARCHAR(200), IN `user_id` VARCHAR(200), IN `matrix_user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `weight` INT(11))  NO SQL
BEGIN
    /*current user	*/
	CALL sp_update_current_operation_user(user_id);
    
    INSERT INTO 
    tbl_C2_user_performance_matrix 
        (
            C2_user_performance_matrix_id, 
            C2_project_id, 
            C2_sprint_id, 
            C2_user_story_id,
            C2_matrix_user_id,
            C2_weight,
            C2_user_performance_matrix_created_on
        ) 
    values 
        (
            user_performance_matrix_id, 
            project_id, 
            sprint_id, 
            user_story_id,
            matrix_user_id,
            weight,
            now()
        );
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_is_sprintis_active` (IN `sprint_id` VARCHAR(100))  NO SQL
SELECT 
                C2_sprint_id AS sprintId
            FROM 
                tbl_C2_sprint 
            WHERE 
                (
                    C2_sprint_id = sprint_id
                AND 
                    C2_sprint_status = "Active"
                )
            OR
                (
                    C2_sprint_id = sprint_id
                AND 
                    C2_sprint_status = "NO_SPRINT_STATUS"
                )$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_pull_all_tasks_for_project` (IN `project_id` VARCHAR(200))  NO SQL
SELECT
                            DISTINCT tbl_C2_task_sprint_association.C2_task_id AS taskId,
                            tbl_C2_task.C2_segment AS segment,
                            tbl_C2_task.C2_task_name AS taskName,
                            tbl_C2_task.C2_task_end_date AS taskEndDate,

                            tbl_C2_theme.C2_theme_id AS themeId,
                            tbl_C2_theme.C2_theme_name AS themeName,

                            tbl_C2_task.C2_task_type_id AS taskTypeId,
                            tbl_C2_task_type.C2_task_type_name AS taskTypeName,

                            tbl_C2_task.C2_user_story_id AS userStoryId,
                            tbl_C2_user_story.C2_user_story_name AS userStoryName,
                            
                            tbl_C2_task.C2_priority_level_id AS priorityLevelId,
                            tbl_C2_priority_levels.C2_priority_level_name AS priorityLevelName,
                            tbl_C2_priority_levels.C2_priority_level_color AS priorityLevelColor,
                            
                            tbl_C2_task.C2_task_assigned_user_id AS taskAssignedUserId,
                            tbl_C2_user.C2_user_first_name AS userFirstName,
                            tbl_C2_user.C2_user_last_name AS userLastName,
                            
                            (
                                SELECT 
                                    tbl_C2_task_sprint_association.C2_task_status_id 
                                FROM 
                                    tbl_C2_task_sprint_association 
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS taskStatusId,
                            (
                                SELECT 
                                    tbl_C2_task_status.C2_task_status_name
                                FROM 
                                    tbl_C2_task_status 
                                LEFT JOIN
                                    tbl_C2_task_sprint_association
                                ON
                                    tbl_C2_task_status.C2_task_status_id = tbl_C2_task_sprint_association.C2_task_status_id
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS taskStatusName,
                            (
                                SELECT 
                                    tbl_C2_task_status.C2_task_status_color
                                FROM 
                                    tbl_C2_task_status 
                                LEFT JOIN
                                    tbl_C2_task_sprint_association
                                ON
                                    tbl_C2_task_status.C2_task_status_id = tbl_C2_task_sprint_association.C2_task_status_id
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS taskStatusColor,
                            (
                                SELECT 
                                    tbl_C2_task_sprint_association.C2_sprint_id
                                FROM 
                                    tbl_C2_task_sprint_association 
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS sprintId,
                            (
                                SELECT 
                                    tbl_C2_sprint.C2_sprint_name
                                FROM
                                    tbl_C2_sprint
                                LEFT JOIN
                                    tbl_C2_task_sprint_association
                                ON
                                    tbl_C2_sprint.C2_sprint_id = tbl_C2_task_sprint_association.C2_sprint_id
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS sprintName,
                            (
                                SELECT 
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on 
                                FROM 
                                    tbl_C2_task_sprint_association 
                                WHERE 
                                    tbl_C2_task_sprint_association.C2_task_id = taskId
                                ORDER BY
                                    tbl_C2_task_sprint_association.C2_task_sprint_association_created_on DESC
                                LIMIT 1
                            ) AS taskLastUpdated                            
                        FROM
                            tbl_C2_task_sprint_association
                        RIGHT JOIN
                            tbl_C2_task  
                        ON
                            tbl_C2_task_sprint_association.C2_task_id = tbl_C2_task.C2_task_id
                        LEFT JOIN
                            tbl_C2_user_story
                        ON
                            tbl_C2_task.C2_user_story_id = tbl_C2_user_story.C2_user_story_id
                        LEFT JOIN
                            tbl_C2_theme  
                        ON
                            tbl_C2_user_story.C2_theme_id = tbl_C2_theme.C2_theme_id
                        LEFT JOIN
                            tbl_C2_priority_levels
                        ON
                            tbl_C2_task.C2_priority_level_id = tbl_C2_priority_levels.C2_priority_level_id
                        LEFT JOIN
                            tbl_C2_task_type
                        ON
                            tbl_C2_task.C2_task_type_id = tbl_C2_task_type.C2_task_type_id
                        LEFT JOIN
                            tbl_C2_user
                        ON
                            tbl_C2_task.C2_task_assigned_user_id =  tbl_C2_user.C2_user_id
                        WHERE 
                            tbl_C2_theme.C2_project_id = project_id
                        ORDER BY
                         	taskLastUpdated DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_pull_all_tasks_for_project_for_sprint` (IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200))  NO SQL
SELECT
                            tbl_C2_task.C2_segment AS segment,
                            tbl_C2_task.C2_task_id AS taskId,
                            tbl_C2_task.C2_task_name AS taskName,
                            tbl_C2_task.C2_task_end_date AS taskEndDate,

                            tbl_C2_task.C2_user_story_id AS userStoryId,
                            tbl_C2_user_story.C2_user_story_name AS userStoryName,
                            
                            tbl_C2_theme.C2_theme_id AS themeId,
                            tbl_C2_theme.C2_theme_name AS themeName,

                            tbl_C2_task.C2_task_type_id AS taskTypeId,
                            tbl_C2_task_type.C2_task_type_name AS taskTypeName,

                            tbl_C2_task.C2_priority_level_id AS priorityLevelId,
                            tbl_C2_priority_levels.C2_priority_level_name AS priorityLevelName,
                            tbl_C2_priority_levels.C2_priority_level_color AS priorityLevelColor,

                            tbl_C2_task.C2_task_assigned_user_id AS taskAssignedUserId,
                            tbl_C2_user.C2_user_first_name AS userFirstName,
                            tbl_C2_user.C2_user_last_name AS userLastName,

                            tbl_C2_task_sprint_association.C2_sprint_id AS sprintId,
                            tbl_C2_sprint.C2_sprint_name AS sprintName,

                            tbl_C2_task_sprint_association.C2_task_status_id AS taskStatusId,
                            tbl_C2_task_status.C2_task_status_name AS taskStatusName,
                            tbl_C2_task_status.C2_task_status_color AS taskStatusColor,
                            tbl_C2_task_sprint_association.C2_task_sprint_association_created_on AS taskLastUpdated
                        FROM
                            tbl_C2_task_sprint_association
                        LEFT JOIN
                            tbl_C2_task
                        ON
                            tbl_C2_task_sprint_association.C2_task_id = tbl_C2_task.C2_task_id
                        LEFT JOIN
                            tbl_C2_user_story
                        ON
                            tbl_C2_task.C2_user_story_id = tbl_C2_user_story.C2_user_story_id
                        LEFT JOIN
                            tbl_C2_theme
                        ON
                            tbl_C2_user_story.C2_theme_id = tbl_C2_theme.C2_theme_id
                        LEFT JOIN
                            tbl_C2_task_type
                        ON
                            tbl_C2_task.C2_task_type_id = tbl_C2_task_type.C2_task_type_id
                        LEFT JOIN
                            tbl_C2_priority_levels
                        ON
                            tbl_C2_task.C2_priority_level_id = tbl_C2_priority_levels.C2_priority_level_id
                        LEFT JOIN
                            tbl_C2_user
                        ON
                            tbl_C2_task.C2_task_assigned_user_id = tbl_C2_user.C2_user_id

                        LEFT JOIN
                            tbl_C2_sprint
                        ON
                            tbl_C2_task_sprint_association.C2_sprint_id = tbl_C2_sprint.C2_sprint_id
                        LEFT JOIN
                            tbl_C2_task_status
                        ON
                            tbl_C2_task_sprint_association.C2_task_status_id = tbl_C2_task_status.C2_task_status_id
                        AND
                            tbl_C2_sprint.C2_project_id = tbl_C2_task_status.C2_project_id
                        WHERE
                            COALESCE(tbl_C2_task_sprint_association.C2_sprint_id, '') = sprint_id
                        AND
                            tbl_C2_theme.C2_project_id = project_id
                        ORDER BY
                            taskLastUpdated DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_pull_all_tasks_for_user_for_sprint` (IN `sprint_id` VARCHAR(200), IN `user_id` VARCHAR(200))  NO SQL
SELECT
                            tbl_C2_task.C2_segment AS segment,
                            tbl_C2_task.C2_task_id AS taskId,
                            tbl_C2_task.C2_task_name AS taskName,
                            tbl_C2_task.C2_task_end_date AS taskEndDate,

                            tbl_C2_task.C2_user_story_id AS userStoryId,
                            tbl_C2_user_story.C2_user_story_name AS userStoryName,
                            
                            tbl_C2_theme.C2_theme_id AS themeId,
                            tbl_C2_theme.C2_theme_name AS themeName,

                            tbl_C2_task.C2_task_type_id AS taskTypeId,
                            tbl_C2_task_type.C2_task_type_name AS taskTypeName,

                            tbl_C2_task.C2_priority_level_id AS priorityLevelId,
                            tbl_C2_priority_levels.C2_priority_level_name AS priorityLevelName,
                            tbl_C2_priority_levels.C2_priority_level_color AS priorityLevelColor,

                            tbl_C2_task.C2_task_assigned_user_id AS taskAssignedUserId,
                            tbl_C2_user.C2_user_first_name AS userFirstName,
                            tbl_C2_user.C2_user_last_name AS userLastName,

                            tbl_C2_task_sprint_association.C2_sprint_id AS sprintId,
                            tbl_C2_sprint.C2_sprint_name AS sprintName,

                            tbl_C2_task_sprint_association.C2_task_status_id AS taskStatusId,
                            tbl_C2_task_status.C2_task_status_name AS taskStatusName,
                            tbl_C2_task_status.C2_task_status_color AS taskStatusColor,
                            tbl_C2_task_sprint_association.C2_task_sprint_association_created_on AS taskLastUpdated
                        FROM
                            tbl_C2_task_sprint_association
                        LEFT JOIN
                            tbl_C2_task
                        ON
                            tbl_C2_task_sprint_association.C2_task_id = tbl_C2_task.C2_task_id
                        LEFT JOIN
                            tbl_C2_user_story
                        ON
                            tbl_C2_task.C2_user_story_id = tbl_C2_user_story.C2_user_story_id
                        LEFT JOIN
                            tbl_C2_theme
                        ON
                            tbl_C2_user_story.C2_theme_id = tbl_C2_theme.C2_theme_id
                        LEFT JOIN
                            tbl_C2_task_type
                        ON
                            tbl_C2_task.C2_task_type_id = tbl_C2_task_type.C2_task_type_id
                        LEFT JOIN
                            tbl_C2_priority_levels
                        ON
                            tbl_C2_task.C2_priority_level_id = tbl_C2_priority_levels.C2_priority_level_id
                        LEFT JOIN
                            tbl_C2_user
                        ON
                            tbl_C2_task.C2_task_assigned_user_id = tbl_C2_user.C2_user_id

                        LEFT JOIN
                            tbl_C2_sprint
                        ON
                            tbl_C2_task_sprint_association.C2_sprint_id = tbl_C2_sprint.C2_sprint_id
                        LEFT JOIN
                            tbl_C2_task_status
                        ON
                            tbl_C2_task_sprint_association.C2_task_status_id = tbl_C2_task_status.C2_task_status_id
                        AND
                            tbl_C2_sprint.C2_project_id = tbl_C2_task_status.C2_project_id
                        WHERE
                            tbl_C2_task_sprint_association.C2_sprint_id = sprint_id
                        AND
                            tbl_C2_task.C2_task_assigned_user_id = user_id
                        ORDER BY
                            taskLastUpdated DESC$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_regenerate_user_account_activation_code` (IN `user_verification_code` VARCHAR(200), IN `user_email` VARCHAR(200))  NO SQL
UPDATE 
	tbl_C2_user
		SET
			C2_user_verification_code  = user_verification_code,
			C2_user_updated_at = now()
		WHERE 
			C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_updated_user_profile` (IN `user_id` VARCHAR(200), IN `user_email` VARCHAR(200), IN `user_first_name` VARCHAR(200), IN `user_last_name` VARCHAR(200), IN `user_security_answer_1` VARCHAR(200), IN `user_security_answer_2` VARCHAR(200), IN `user_designation` VARCHAR(200), IN `user_password` VARCHAR(200))  NO SQL
UPDATE  
                        tbl_C2_user 
                            SET
                                C2_user_first_name = user_first_name,
                                C2_user_last_name = user_last_name,
                                C2_user_designation = user_designation,
                                C2_user_security_answer_1 = user_security_answer_1,
                                C2_user_security_answer_2 = user_security_answer_1,
                                C2_user_password = user_password,
                                C2_user_updated_at = now()
                        WHERE 
                            C2_user_id = user_id$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_current_operation_user` (IN `user_id` VARCHAR(200))  NO SQL
BEGIN
      UPDATE tbl_C2_current_operation_user
      SET C2_user_id = user_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_password` (IN `user_password` VARCHAR(200), IN `user_email` VARCHAR(200))  NO SQL
UPDATE 
                        tbl_C2_user
                            SET
                                C2_user_password  = user_password,
                                C2_user_password_reset_code = "NONE",
                                C2_user_updated_at = now()
                            WHERE 
                                C2_user_email = user_email$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_project` (IN `user_id` VARCHAR(200), IN `project_name` VARCHAR(200), IN `project_description` VARCHAR(400), IN `project_id` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
    
    /*update data*/
	UPDATE 
		tbl_C2_project
			SET
				C2_project_name  = project_name,
				C2_project_description = project_description,
				C2_project_updated_on = now()
			WHERE 
				C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_project_member_access` (IN `user_id` VARCHAR(200), IN `added_user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `project_user_type_id` VARCHAR(200))  NO SQL
BEGIN
/*current user	*/
	CALL sp_update_current_operation_user(user_id);
UPDATE 
                        tbl_C2_project_member_association
                            SET
                                C2_project_user_type_id  = project_user_type_id,
                                C2_project_member_updated_on = now()
                            WHERE 
                                C2_user_id = added_user_id
                            AND 
                                C2_project_id = project_id;
                                END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_project_settings` (IN `project_id` VARCHAR(200), IN `user_id` VARCHAR(200), IN `over_all_completion_status_id` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	
    UPDATE 
		tbl_C2_project_settings
			SET
				C2_over_all_completion_status_id  = over_all_completion_status_id,
				C2_project_settings_update_on = now()
			WHERE 
				C2_project_id = project_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_sprint` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `sprint_name` VARCHAR(200), IN `sprint_start_date` VARCHAR(200), IN `sprint_end_date` VARCHAR(200), IN `sprint_status` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
	UPDATE 
		tbl_C2_sprint
	SET
		C2_sprint_name  = sprint_name,
		C2_sprint_start_date = sprint_start_date,
		C2_sprint_end_date = sprint_end_date,
        C2_sprint_status = sprint_status,
		C2_sprint_updated_on = now()
	WHERE 
		C2_sprint_id = sprint_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_task` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `task_id` VARCHAR(200), IN `task_name` VARCHAR(200), IN `task_description` VARCHAR(400), IN `task_key_completion_indicator` VARCHAR(1000))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
    
	UPDATE 
		tbl_C2_task
	SET
		C2_task_name  = task_name,
		C2_task_description = task_description,
		C2_task_key_completion_indicator = task_key_completion_indicator,
		C2_task_updated_on = now()
	WHERE 
		C2_task_id = task_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_task_review` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `task_review_id` VARCHAR(200), IN `reviewer_user_id` VARCHAR(200), IN `achieved_result_value` INT(11), IN `reviewer_comment` VARCHAR(1000))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
    
	UPDATE 
		tbl_C2_task_review
	SET
		C2_achieved_result_value = achieved_result_value,
        C2_reviewer_comment = reviewer_comment,
		C2_task_review_updated_on = now()
	WHERE 
		C2_task_review_id = task_review_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_task_sprint_association` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `task_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `task_estimation` VARCHAR(200), IN `task_story_point` VARCHAR(200), IN `task_status_id` VARCHAR(200))  NO SQL
BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
    UPDATE 
        tbl_C2_task_sprint_association
    SET
        C2_task_estimation  = task_estimation,
        C2_task_story_point  = task_story_point,
        C2_task_status_id = task_status_id,
        C2_task_sprint_association_updated_on = now()
    WHERE 
        C2_sprint_id = sprint_id
    AND 
        C2_task_id = task_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_task_type_measurement_criteria` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `sprint_id` VARCHAR(200), IN `task_type_measurement_criteria_id` VARCHAR(200), IN `criteria_poor_value` INT(11), IN `criteria_improvement_value` INT(11), IN `criteria_expectation_value` INT(11), IN `criteria_exceed_value` INT(11), IN `criteria_outstanding_value` INT(11))  BEGIN
	/*current user	*/
	CALL sp_update_current_operation_user(user_id);
    UPDATE
		tbl_C2_task_type_measurement_criteria 
	SET
		C2_sprint_id = sprint_id,
		C2_criteria_poor_value = criteria_poor_value,
		C2_criteria_improvement_value = criteria_improvement_value,
		C2_criteria_expectation_value = criteria_expectation_value,
		C2_criteria_exceed_value = criteria_exceed_value,
		C2_criteria_outstanding_value = criteria_outstanding_value,
		C2_task_type_measurement_criteria_updated_at = now()
	WHERE
		task_type_measurement_criteria_id = task_type_measurement_criteria_id;
END$$

CREATE DEFINER=`rolli3oh`@`localhost` PROCEDURE `sp_update_user_story` (IN `user_id` VARCHAR(200), IN `project_id` VARCHAR(200), IN `user_story_id` VARCHAR(200), IN `user_story_name` VARCHAR(200), IN `user_story_description` VARCHAR(400))  NO SQL
BEGIN
    /*current user	*/
	CALL sp_update_current_operation_user(user_id);
    UPDATE 
    tbl_C2_user_story
        SET
            C2_user_story_name  = user_story_name,
            C2_user_story_description = user_story_description,
            C2_user_story_updated_on = now()
        WHERE 
            C2_user_story_id = user_story_id;
            
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_activity
--

CREATE TABLE tbl_C2_activity (
  C2_activity_id varchar(200) DEFAULT NULL,
  C2_project_id varchar(200) DEFAULT NULL,
  C2_sprint_id varchar(200) DEFAULT NULL,
  C2_assignee_user_id varchar(200) DEFAULT NULL,
  C2_activity_measurement_purpose varchar(400) DEFAULT NULL,
  C2_weight int(11) DEFAULT NULL,
  C2_activity_key_completion_indicator varchar(1000) DEFAULT NULL,
  C2_task_type_measurement_type varchar(10) DEFAULT NULL,
  C2_criteria_poor_value int(11) DEFAULT NULL,
  C2_criteria_improvement_value int(11) DEFAULT NULL,
  C2_criteria_expectation_value int(11) DEFAULT NULL,
  C2_criteria_exceed_value int(11) DEFAULT NULL,
  C2_criteria_outstanding_value int(11) DEFAULT NULL,
  C2_characteristics_higher_better int(11) DEFAULT '1',
  C2_activity_achieved_fact int(11) DEFAULT NULL,
  C2_assignee_comment varchar(1000) DEFAULT NULL,
  C2_task_type_measurement_criteria_created_at datetime DEFAULT NULL,
  C2_task_type_measurement_criteria_updated_at datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_activity_review
--

CREATE TABLE tbl_C2_activity_review (
  C2_activity_review_id varchar(200) NOT NULL DEFAULT '',
  C2_project_id varchar(200) DEFAULT NULL,
  C2_activity_id varchar(200) NOT NULL DEFAULT '',
  C2_reviewer_user_id varchar(200) NOT NULL DEFAULT '',
  C2_achieved_result_value int(11) NOT NULL,
  C2_reviewer_comment varchar(1000) NOT NULL,
  C2_activity_review_created_on datetime DEFAULT NULL,
  C2_activity_review_updated_on datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_current_operation_user
--

CREATE TABLE tbl_C2_current_operation_user (
  C2_user_id varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_log_book
--

CREATE TABLE tbl_C2_log_book (
  C2_log_book_id int(20) UNSIGNED NOT NULL,
  C2_project_id varchar(200) DEFAULT NULL,
  C2_user_id varchar(200) DEFAULT NULL,
  C2_log_operation varchar(200) DEFAULT NULL,
  C2_log_module varchar(100) DEFAULT NULL,
  C2_log_module_operation_id varchar(10000) DEFAULT NULL,
  C2_log_on_field varchar(100) DEFAULT NULL,
  C2_log_old_content varchar(10000) DEFAULT NULL,
  C2_log_new_content varchar(10000) DEFAULT NULL,
  C2_log_created_on datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_objective
--

CREATE TABLE tbl_C2_objective (
  C2_project_id varchar(200) NOT NULL,
  C2_objective_id varchar(200) NOT NULL DEFAULT '',
  C2_objective_name varchar(200) NOT NULL DEFAULT '',
  C2_objective_description varchar(400) NOT NULL DEFAULT '',
  C2_objective_created_on varchar(200) NOT NULL DEFAULT '',
  C2_objective_updated_on varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_project
--

CREATE TABLE tbl_C2_project (
  C2_project_id varchar(200) NOT NULL,
  C2_project_name varchar(200) NOT NULL,
  C2_project_description varchar(400) NOT NULL,
  C2_project_created_on datetime DEFAULT NULL,
  C2_project_updated_on datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_project_member_association
--

CREATE TABLE tbl_C2_project_member_association (
  C2_user_id varchar(200) NOT NULL,
  C2_project_id varchar(200) NOT NULL,
  C2_project_user_type_id varchar(200) NOT NULL,
  C2_project_member_created_on datetime DEFAULT NULL,
  C2_project_member_updated_on datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_project_member_type
--

CREATE TABLE tbl_C2_project_member_type (
  C2_project_member_type_id varchar(200) NOT NULL,
  C2_project_member_type_name varchar(200) NOT NULL,
  C2_project_member_type_description varchar(400) NOT NULL,
  C2_user_access_privilege_level int(11) DEFAULT NULL,
  C2_crud_project tinyint(4) DEFAULT '1',
  C2_crud_member tinyint(4) DEFAULT '1',
  C2_crud_sprint tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_project_settings
--

CREATE TABLE tbl_C2_project_settings (
  C2_project_settings_id int(11) NOT NULL,
  C2_project_id varchar(200) NOT NULL,
  C2_project_settings_created_on varchar(200) DEFAULT NULL,
  C2_project_settings_update_on varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_sprint
--

CREATE TABLE tbl_C2_sprint (
  C2_project_id varchar(200) NOT NULL,
  C2_sprint_id varchar(200) NOT NULL,
  C2_sprint_name varchar(200) NOT NULL,
  C2_sprint_start_date varchar(200) NOT NULL,
  C2_sprint_end_date varchar(200) NOT NULL,
  C2_sprint_status varchar(200) NOT NULL,
  C2_sprint_created_on datetime NOT NULL,
  C2_sprint_updated_on datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_sp_log
--

CREATE TABLE tbl_C2_sp_log (
  C2_sp_log varchar(10000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_user
--

CREATE TABLE tbl_C2_user (
  C2_user_id varchar(200) NOT NULL,
  C2_user_first_name varchar(200) NOT NULL,
  C2_user_last_name varchar(200) NOT NULL,
  C2_user_password varchar(200) NOT NULL,
  C2_user_email varchar(200) NOT NULL,
  C2_user_security_answer_1 varchar(200) NOT NULL,
  C2_user_security_answer_2 varchar(200) NOT NULL,
  C2_user_status varchar(200) NOT NULL DEFAULT '',
  C2_user_verification_code varchar(100) NOT NULL,
  C2_user_password_reset_code varchar(100) NOT NULL DEFAULT 'none',
  C2_user_created_at varchar(200) NOT NULL,
  C2_user_updated_at varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table tbl_C2_user_session
--

CREATE TABLE tbl_C2_user_session (
  C2_session_user_id varchar(200) NOT NULL,
  C2_session_user_platform varchar(200) DEFAULT NULL,
  C2_session_user_ip varchar(200) DEFAULT NULL,
  C2_session_user_login_type varchar(200) DEFAULT NULL,
  C2_session_created_on datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table tbl_C2_activity
--
ALTER TABLE tbl_C2_activity
  ADD KEY tbl_C2_task_type_measurement_criteria_fk_2 (C2_project_id),
  ADD KEY tbl_C2_task_type_measurement_criteria_fk_3 (C2_activity_id),
  ADD KEY tbl_C2_task_type_measurement_criteria_fk_4 (C2_sprint_id);

--
-- Indexes for table tbl_C2_activity_review
--
ALTER TABLE tbl_C2_activity_review
  ADD PRIMARY KEY (C2_activity_review_id),
  ADD KEY tbl_C2_task_review_fk_1 (C2_project_id),
  ADD KEY tbl_C2_task_review_fk_3 (C2_activity_id),
  ADD KEY tbl_C2_task_review_fk_4 (C2_reviewer_user_id);

--
-- Indexes for table tbl_C2_current_operation_user
--
ALTER TABLE tbl_C2_current_operation_user
  ADD PRIMARY KEY (C2_user_id);

--
-- Indexes for table tbl_C2_log_book
--
ALTER TABLE tbl_C2_log_book
  ADD PRIMARY KEY (C2_log_book_id),
  ADD KEY tbl_C2_log_book_fk_1 (C2_project_id);

--
-- Indexes for table tbl_C2_objective
--
ALTER TABLE tbl_C2_objective
  ADD PRIMARY KEY (C2_objective_id),
  ADD KEY tbl_C2_user_story_fk_1 (C2_project_id);

--
-- Indexes for table tbl_C2_project
--
ALTER TABLE tbl_C2_project
  ADD PRIMARY KEY (C2_project_id),
  ADD KEY C2_project_name (C2_project_name);

--
-- Indexes for table tbl_C2_project_member_association
--
ALTER TABLE tbl_C2_project_member_association
  ADD KEY C2_project_id (C2_project_id),
  ADD KEY tbl_C2_project_member_association_fk_2 (C2_user_id),
  ADD KEY tbl_C2_project_member_association_fk_3 (C2_project_user_type_id);

--
-- Indexes for table tbl_C2_project_member_type
--
ALTER TABLE tbl_C2_project_member_type
  ADD PRIMARY KEY (C2_project_member_type_id);

--
-- Indexes for table tbl_C2_project_settings
--
ALTER TABLE tbl_C2_project_settings
  ADD PRIMARY KEY (C2_project_settings_id),
  ADD KEY C2_project_id (C2_project_id);

--
-- Indexes for table tbl_C2_sprint
--
ALTER TABLE tbl_C2_sprint
  ADD PRIMARY KEY (C2_sprint_id),
  ADD KEY C2_project_id (C2_project_id),
  ADD KEY C2_sprint_start_date (C2_sprint_start_date),
  ADD KEY C2_sprint_end_date (C2_sprint_end_date);

--
-- Indexes for table tbl_C2_user
--
ALTER TABLE tbl_C2_user
  ADD PRIMARY KEY (C2_user_id);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table tbl_C2_log_book
--
ALTER TABLE tbl_C2_log_book
  MODIFY C2_log_book_id int(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table tbl_C2_project_settings
--
ALTER TABLE tbl_C2_project_settings
  MODIFY C2_project_settings_id int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table tbl_C2_activity
--
ALTER TABLE tbl_C2_activity
  ADD CONSTRAINT tbl_C2_task_type_measurement_criteria_fk_2 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id),
  ADD CONSTRAINT tbl_C2_task_type_measurement_criteria_fk_3 FOREIGN KEY (C2_activity_id) REFERENCES tbl_c2_objective (C2_objective_id),
  ADD CONSTRAINT tbl_C2_task_type_measurement_criteria_fk_4 FOREIGN KEY (C2_sprint_id) REFERENCES tbl_C2_sprint (C2_sprint_id);

--
-- Constraints for table tbl_C2_log_book
--
ALTER TABLE tbl_C2_log_book
  ADD CONSTRAINT tbl_C2_log_book_fk_1 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table tbl_C2_objective
--
ALTER TABLE tbl_C2_objective
  ADD CONSTRAINT tbl_C2_user_story_fk_1 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table tbl_C2_project_member_association
--
ALTER TABLE tbl_C2_project_member_association
  ADD CONSTRAINT tbl_C2_project_member_association_fk_1 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id) ON DELETE CASCADE,
  ADD CONSTRAINT tbl_C2_project_member_association_fk_2 FOREIGN KEY (C2_user_id) REFERENCES tbl_C2_user (C2_user_id),
  ADD CONSTRAINT tbl_C2_project_member_association_fk_3 FOREIGN KEY (C2_project_user_type_id) REFERENCES tbl_C2_project_member_type (C2_project_member_type_id);

--
-- Constraints for table tbl_C2_project_settings
--
ALTER TABLE tbl_C2_project_settings
  ADD CONSTRAINT tbl_C2_project_settings_fk_1 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id) ON DELETE CASCADE;

--
-- Constraints for table tbl_C2_sprint
--
ALTER TABLE tbl_C2_sprint
  ADD CONSTRAINT tbl_C2_sprint_fk_1 FOREIGN KEY (C2_project_id) REFERENCES tbl_C2_project (C2_project_id) ON DELETE CASCADE;