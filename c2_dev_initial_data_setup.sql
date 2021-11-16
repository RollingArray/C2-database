-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 15, 2021 at 03:35 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `c2_dev`
--

--
-- Dumping data for table `tbl_C2_project_member_type`
--
a
INSERT INTO `tbl_C2_project_member_type` (`C2_project_member_type_id`, `C2_project_member_type_name`, `C2_project_member_type_description`, `C2_user_access_privilege_level`, `C2_crud_project`, `C2_crud_member`, `C2_crud_sprint`, `C2_crud_goal`, `C2_crud_activity`, `C2_crud_comment`, `C2_crud_reviewer`, `C2_crud_review`, `C2_crud_review_lock`, `C2_view_credibility`, `C2_view_sprint`, `C2_view_goal`, `C2_view_activity`) VALUES
('PROJECTUSERTYPEID_0001', 'Admin', 'Owner of Project', 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1),
('PROJECTUSERTYPEID_0002', 'Assignee', 'Activity Assignee in a Project', 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
('PROJECTUSERTYPEID_0003', 'Reviewer', 'Activity Reviewer in a Project', 3, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);

--
-- Dumping data for table `tbl_C2_user`
--

INSERT INTO `tbl_C2_user` (`C2_user_id`, `C2_user_first_name`, `C2_user_last_name`, `C2_user_email`, `C2_user_status`, `C2_user_verification_code`, `C2_user_password_reset_code`, `C2_user_created_at`, `C2_user_updated_at`) VALUES
('5f3fe04c08618', 'System', '', '', '', '', 'none', '2021-04-22 07:21:50', '');