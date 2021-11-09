/**
 * © Rolling Array https://rollingarray.co.in/
 *
 * long description for the file
 *
 * @summary C2 schema
 * @author code@rollingarray.co.in
 *
 * Created at     : 2021-05-16 14:32:19 
 * Last modified  : 2021-11-01 14:33:17
 */

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `c2_dev`
--
USE `c2_dev`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_activity`
--

DROP TABLE IF EXISTS `tbl_C2_activity`;
CREATE TABLE `tbl_C2_activity` (
  `C2_activity_id` varchar(200) NOT NULL,
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
  `C2_activity_review_performance` double(10,2) DEFAULT NULL,
  `C2_assignee_comment` varchar(1000) DEFAULT NULL,
  `C2_activity_locked` int(11) DEFAULT '0',
  `C2_activity_created_on` datetime DEFAULT NULL,
  `C2_activity_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_activity_comment`
--

DROP TABLE IF EXISTS `tbl_C2_activity_comment`;
CREATE TABLE `tbl_C2_activity_comment` (
  `C2_comment_id` varchar(200) NOT NULL,
  `C2_project_id` varchar(200) NOT NULL,
  `C2_assignee_user_id` varchar(200) NOT NULL,
  `C2_activity_id` varchar(200) NOT NULL,
  `C2_claimed_result_value` int(11) DEFAULT NULL,
  `C2_comment_description` varchar(1000) NOT NULL,
  `C2_comment_created_on` datetime DEFAULT NULL,
  `C2_comment_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_activity_review`
--

DROP TABLE IF EXISTS `tbl_C2_activity_review`;
CREATE TABLE `tbl_C2_activity_review` (
  `C2_activity_review_id` varchar(200) NOT NULL,
  `C2_project_id` varchar(200) NOT NULL DEFAULT '',
  `C2_activity_id` varchar(200) NOT NULL,
  `C2_reviewer_user_id` varchar(200) NOT NULL,
  `C2_achieved_result_value` int(11) DEFAULT NULL,
  `C2_performance_value` double(10,2) DEFAULT NULL,
  `C2_weighted_performance_value` double(10,2) DEFAULT NULL,
  `C2_reviewer_comment` varchar(1000) DEFAULT '',
  `C2_activity_review_created_on` datetime DEFAULT NULL,
  `C2_activity_review_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_current_operation_user`
--

DROP TABLE IF EXISTS `tbl_C2_current_operation_user`;
CREATE TABLE `tbl_C2_current_operation_user` (
  `C2_user_id` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_email_track`
--

DROP TABLE IF EXISTS `tbl_C2_email_track`;
CREATE TABLE `tbl_C2_email_track` (
  `C2_email_track_id` varchar(200) DEFAULT NULL,
  `C2_user_email` varchar(200) NOT NULL DEFAULT '',
  `C2_email_subject` varchar(200) DEFAULT NULL,
  `C2_email_content` varchar(1000) DEFAULT NULL,
  `C2_email_status` varchar(200) DEFAULT NULL,
  `C2_email_created_on` datetime DEFAULT NULL,
  `C2_email_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_goal`
--

DROP TABLE IF EXISTS `tbl_C2_goal`;
CREATE TABLE `tbl_C2_goal` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_goal_id` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_name` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_description` varchar(400) NOT NULL DEFAULT '',
  `C2_goal_created_on` varchar(200) NOT NULL DEFAULT '',
  `C2_goal_updated_on` varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_log_book`
--

DROP TABLE IF EXISTS `tbl_C2_log_book`;
CREATE TABLE `tbl_C2_log_book` (
  `C2_log_book_id` int(20) UNSIGNED NOT NULL,
  `C2_project_id` varchar(200) DEFAULT NULL,
  `C2_user_id` varchar(200) DEFAULT NULL,
  `C2_log_operation` varchar(200) DEFAULT NULL,
  `C2_log_module` varchar(100) DEFAULT NULL,
  `C2_log_module_operation_id` varchar(10000) DEFAULT NULL,
  `C2_log_on_field` varchar(100) DEFAULT NULL,
  `C2_log_old_content` varchar(10000) DEFAULT NULL,
  `C2_log_new_content` varchar(10000) DEFAULT NULL,
  `C2_log_created_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project`
--

DROP TABLE IF EXISTS `tbl_C2_project`;
CREATE TABLE `tbl_C2_project` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_name` varchar(200) NOT NULL,
  `C2_project_description` varchar(400) NOT NULL,
  `C2_project_created_on` datetime DEFAULT NULL,
  `C2_project_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_member_association`
--

DROP TABLE IF EXISTS `tbl_C2_project_member_association`;
CREATE TABLE `tbl_C2_project_member_association` (
  `C2_user_id` varchar(200) NOT NULL,
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_user_type_id` varchar(200) NOT NULL,
  `C2_user_credibility_score` double(10,2) DEFAULT NULL,
  `C2_project_member_created_on` datetime DEFAULT NULL,
  `C2_project_member_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_member_type`
--

DROP TABLE IF EXISTS `tbl_C2_project_member_type`;
CREATE TABLE `tbl_C2_project_member_type` (
  `C2_project_member_type_id` varchar(200) NOT NULL,
  `C2_project_member_type_name` varchar(200) NOT NULL,
  `C2_project_member_type_description` varchar(400) NOT NULL,
  `C2_user_access_privilege_level` int(11) DEFAULT NULL,
  `C2_crud_project` tinyint(4) DEFAULT '1',
  `C2_crud_member` tinyint(4) DEFAULT '1',
  `C2_crud_sprint` tinyint(4) DEFAULT '1',
  `C2_crud_goal` tinyint(4) DEFAULT '1',
  `C2_crud_activity` tinyint(4) DEFAULT '1',
  `C2_crud_comment` tinyint(4) DEFAULT '1',
  `C2_crud_reviewer` tinyint(4) DEFAULT '1',
  `C2_crud_review` tinyint(4) DEFAULT '1',
  `C2_view_credibility` tinyint(4) DEFAULT '1',
  `C2_view_sprint` tinyint(4) DEFAULT '1',
  `C2_view_goal` tinyint(4) DEFAULT '1',
  `C2_view_activity` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_project_settings`
--

DROP TABLE IF EXISTS `tbl_C2_project_settings`;
CREATE TABLE `tbl_C2_project_settings` (
  `C2_project_settings_id` int(11) NOT NULL,
  `C2_project_id` varchar(200) NOT NULL,
  `C2_project_settings_created_on` varchar(200) DEFAULT NULL,
  `C2_project_settings_update_on` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_sprint`
--

DROP TABLE IF EXISTS `tbl_C2_sprint`;
CREATE TABLE `tbl_C2_sprint` (
  `C2_project_id` varchar(200) NOT NULL,
  `C2_sprint_id` varchar(200) NOT NULL,
  `C2_sprint_name` varchar(200) NOT NULL,
  `C2_sprint_start_date` varchar(200) NOT NULL,
  `C2_sprint_end_date` varchar(200) NOT NULL,
  `C2_sprint_status` varchar(200) NOT NULL,
  `C2_sprint_created_on` datetime NOT NULL,
  `C2_sprint_updated_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_sp_log`
--

DROP TABLE IF EXISTS `tbl_C2_sp_log`;
CREATE TABLE `tbl_C2_sp_log` (
  `C2_sp_log` varchar(10000) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_user`
--

DROP TABLE IF EXISTS `tbl_C2_user`;
CREATE TABLE `tbl_C2_user` (
  `C2_user_id` varchar(200) NOT NULL,
  `C2_user_first_name` varchar(200) NOT NULL,
  `C2_user_last_name` varchar(200) NOT NULL,
  `C2_user_email` varchar(200) NOT NULL,
  `C2_user_status` varchar(200) NOT NULL DEFAULT '',
  `C2_user_verification_code` varchar(100) NOT NULL,
  `C2_user_password_reset_code` varchar(100) NOT NULL DEFAULT 'none',
  `C2_user_created_at` varchar(200) NOT NULL,
  `C2_user_updated_at` varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_C2_user_session`
--

DROP TABLE IF EXISTS `tbl_C2_user_session`;
CREATE TABLE `tbl_C2_user_session` (
  `C2_session_user_id` varchar(200) NOT NULL,
  `C2_session_user_platform` varchar(200) DEFAULT NULL,
  `C2_session_user_ip` varchar(200) DEFAULT NULL,
  `C2_session_user_login_type` varchar(200) DEFAULT NULL,
  `C2_session_created_on` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_C2_activity`
--
ALTER TABLE `tbl_C2_activity`
  ADD PRIMARY KEY (`C2_activity_id`),
  ADD KEY `tbl_C2_activity_fk_1` (`C2_project_id`),
  ADD KEY `tbl_C2_activity_fk_3` (`C2_assignee_user_id`),
  ADD KEY `tbl_C2_activity_fk_4` (`C2_goal_id`),
  ADD KEY `tbl_C2_activity_fk_2` (`C2_sprint_id`);

--
-- Indexes for table `tbl_C2_activity_comment`
--
ALTER TABLE `tbl_C2_activity_comment`
  ADD PRIMARY KEY (`C2_comment_id`),
  ADD KEY `tbl_C2_activity_comment_fk_1` (`C2_project_id`),
  ADD KEY `tbl_C2_activity_comment_fk_2` (`C2_assignee_user_id`),
  ADD KEY `tbl_C2_activity_comment_fk_3` (`C2_activity_id`);

--
-- Indexes for table `tbl_C2_activity_review`
--
ALTER TABLE `tbl_C2_activity_review`
  ADD PRIMARY KEY (`C2_activity_review_id`),
  ADD KEY `tbl_C2_activity_review_fk_1` (`C2_project_id`),
  ADD KEY `tbl_C2_activity_review_fk_2` (`C2_activity_id`),
  ADD KEY `tbl_C2_activity_review_fk_3` (`C2_reviewer_user_id`);

--
-- Indexes for table `tbl_C2_current_operation_user`
--
ALTER TABLE `tbl_C2_current_operation_user`
  ADD PRIMARY KEY (`C2_user_id`);

--
-- Indexes for table `tbl_C2_email_track`
--
ALTER TABLE `tbl_C2_email_track`
  ADD KEY `tbl_C2_email_track_fk_1` (`C2_user_email`);

--
-- Indexes for table `tbl_C2_goal`
--
ALTER TABLE `tbl_C2_goal`
  ADD PRIMARY KEY (`C2_goal_id`),
  ADD KEY `tbl_C2_goal_fk_1` (`C2_project_id`);

--
-- Indexes for table `tbl_C2_log_book`
--
ALTER TABLE `tbl_C2_log_book`
  ADD PRIMARY KEY (`C2_log_book_id`),
  ADD KEY `tbl_C2_log_book_fk_1` (`C2_project_id`);

--
-- Indexes for table `tbl_C2_project`
--
ALTER TABLE `tbl_C2_project`
  ADD PRIMARY KEY (`C2_project_id`),
  ADD KEY `C2_project_name` (`C2_project_name`);

--
-- Indexes for table `tbl_C2_project_member_association`
--
ALTER TABLE `tbl_C2_project_member_association`
  ADD KEY `C2_project_id` (`C2_project_id`),
  ADD KEY `tbl_C2_project_member_association_fk_2` (`C2_user_id`),
  ADD KEY `tbl_C2_project_member_association_fk_3` (`C2_project_user_type_id`);

--
-- Indexes for table `tbl_C2_project_member_type`
--
ALTER TABLE `tbl_C2_project_member_type`
  ADD PRIMARY KEY (`C2_project_member_type_id`);

--
-- Indexes for table `tbl_C2_project_settings`
--
ALTER TABLE `tbl_C2_project_settings`
  ADD PRIMARY KEY (`C2_project_settings_id`),
  ADD KEY `C2_project_id` (`C2_project_id`);

--
-- Indexes for table `tbl_C2_sprint`
--
ALTER TABLE `tbl_C2_sprint`
  ADD PRIMARY KEY (`C2_sprint_id`),
  ADD KEY `C2_project_id` (`C2_project_id`),
  ADD KEY `C2_sprint_start_date` (`C2_sprint_start_date`),
  ADD KEY `C2_sprint_end_date` (`C2_sprint_end_date`);

--
-- Indexes for table `tbl_C2_user`
--
ALTER TABLE `tbl_C2_user`
  ADD PRIMARY KEY (`C2_user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_C2_log_book`
--
ALTER TABLE `tbl_C2_log_book`
  MODIFY `C2_log_book_id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_C2_project_settings`
--
ALTER TABLE `tbl_C2_project_settings`
  MODIFY `C2_project_settings_id` int(11) NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `tbl_C2_activity_comment`
--
ALTER TABLE `tbl_C2_activity_comment`
  ADD CONSTRAINT `tbl_C2_activity_comment_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_C2_activity_comment_fk_2` FOREIGN KEY (`C2_assignee_user_id`) REFERENCES `tbl_C2_user` (`C2_user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_C2_activity_comment_fk_3` FOREIGN KEY (`C2_activity_id`) REFERENCES `tbl_C2_activity` (`C2_activity_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_C2_activity_review`
--
ALTER TABLE `tbl_C2_activity_review`
  ADD CONSTRAINT `tbl_C2_activity_review_fk_1` FOREIGN KEY (`C2_project_id`) REFERENCES `tbl_C2_project` (`C2_project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_C2_activity_review_fk_2` FOREIGN KEY (`C2_activity_id`) REFERENCES `tbl_C2_activity` (`C2_activity_id`),
  ADD CONSTRAINT `tbl_C2_activity_review_fk_3` FOREIGN KEY (`C2_reviewer_user_id`) REFERENCES `tbl_C2_user` (`C2_user_id`);

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
