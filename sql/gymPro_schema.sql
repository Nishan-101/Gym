
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Database: `gymprodb`

-- Table structure for table `attendance`


CREATE TABLE `attendance` (
  `attendance_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `attended_date` date NOT NULL,
  `status` enum('present','absent') DEFAULT 'present'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

-- Table structure for table `classes`


CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL,
  `class_name` varchar(100) NOT NULL,
  `trainer_id` int(11) NOT NULL,
  `schedule_datetime` datetime NOT NULL,
  `duration_minutes` int(11) NOT NULL DEFAULT 60,
  `capacity` int(11) NOT NULL DEFAULT 20,
  `enrolled_count` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `classes`

INSERT INTO `classes` (`class_id`, `class_name`, `trainer_id`, `schedule_datetime`, `duration_minutes`, `capacity`, `enrolled_count`, `description`, `is_active`, `created_at`) VALUES
(1, 'Morning HIIT', 3, '2026-05-19 22:31:46', 45, 20, 1, 'Burn calories fast with HIIT.', 1, '2026-05-18 16:46:46'),
(2, 'Power Yoga', 2, '2026-05-20 22:31:46', 60, 15, 1, 'Strength and flexibility flow.', 1, '2026-05-18 16:46:46'),
(3, 'Weight Training 101', 1, '2026-05-21 22:31:46', 60, 10, 2, 'Beginner weight training guide.', 1, '2026-05-18 16:46:46'),
(4, 'Cardio Blast', 3, '2026-05-22 22:31:46', 30, 25, 1, 'Fast-paced cardio for all levels.', 1, '2026-05-18 16:46:46');


-- Table structure for table `class_enrollments`

CREATE TABLE `class_enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `enrolled_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('enrolled','cancelled') DEFAULT 'enrolled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Dumping data for table `class_enrollments`


INSERT INTO `class_enrollments` (`enrollment_id`, `user_id`, `class_id`, `enrolled_date`, `status`) VALUES
(2, 4, 1, '2026-05-18 17:56:10', 'enrolled'),
(3, 4, 2, '2026-05-18 17:56:12', 'enrolled'),
(4, 4, 3, '2026-05-18 17:56:14', 'enrolled'),
(7, 4, 4, '2026-05-18 17:56:29', 'enrolled'),
(8, 3, 3, '2026-05-18 18:02:04', 'enrolled');


--
-- Table structure for table `contact_inquiries`
--

CREATE TABLE `contact_inquiries` (
  `inquiry_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `membership_plans`
--

CREATE TABLE `membership_plans` (
  `plan_id` int(11) NOT NULL,
  `plan_name` varchar(100) NOT NULL,
  `duration_months` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Dumping data for table `membership_plans`

INSERT INTO `membership_plans` (`plan_id`, `plan_name`, `duration_months`, `price`, `description`, `is_active`, `created_at`) VALUES
(1, 'Basic', 1, 1500.00, 'Gym floor and basic equipment.', 1, '2026-05-18 16:46:46'),
(2, 'Standard', 3, 4000.00, 'Gym access + 1 group class per week.', 1, '2026-05-18 16:46:46'),
(3, 'Premium', 6, 7500.00, 'Unlimited classes + trainer session.', 1, '2026-05-18 16:46:46'),
(4, 'Annual', 12, 13000.00, 'Full year with all premium benefits.', 1, '2026-05-18 16:46:46');

-- --------------------------------------------------------

--
-- Table structure for table `member_attendance`
--

CREATE TABLE `member_attendance` (
  `attendance_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `attendance_date` date NOT NULL,
  `check_in_time` time DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `member_attendance`


INSERT INTO `member_attendance` (`attendance_id`, `user_id`, `attendance_date`, `check_in_time`, `note`, `status`, `verified_by`, `verified_at`, `created_at`) VALUES
(1, 3, '2026-05-18', '23:23:25', '', 'verified', 2, '2026-05-18 17:41:29', '2026-05-18 17:38:25'),
(2, 4, '2026-05-18', '23:39:50', '', 'verified', 2, '2026-05-18 17:55:17', '2026-05-18 17:54:50'),
(3, 3, '2026-05-19', '01:16:41', '', 'verified', 2, '2026-05-18 19:31:59', '2026-05-18 19:31:41');


-- Table structure for table `member_memberships`

CREATE TABLE `member_memberships` (
  `membership_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `payment_status` enum('paid','pending','overdue') NOT NULL DEFAULT 'pending',
  `payment_date` date DEFAULT NULL,
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `member_memberships`


INSERT INTO `member_memberships` (`membership_id`, `user_id`, `plan_id`, `start_date`, `end_date`, `payment_status`, `payment_date`, `amount_paid`, `created_at`) VALUES
(1, 4, 2, '2026-05-15', '2026-08-15', 'paid', '2026-05-18', 4000.00, '2026-05-18 17:57:12'),
(2, 3, 4, '2026-05-12', '2027-05-12', 'paid', '2026-05-18', 13000.00, '2026-05-18 17:57:41');


-- Table structure for table `trainers`

CREATE TABLE `trainers` (
  `trainer_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `specialization` varchar(150) NOT NULL,
  `experience_years` int(11) DEFAULT 0,
  `bio` text DEFAULT NULL,
  `schedule` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Dumping data for table `trainers`


INSERT INTO `trainers` (`trainer_id`, `full_name`, `email`, `phone`, `specialization`, `experience_years`, `bio`, `schedule`, `is_active`, `created_at`) VALUES
(1, 'Nishan Bhusal', 'Nishan@gympro.com', '9801111111', 'Strength & Conditioning', 5, 'Certified weight training coach.', 'Mon-Fri 6AM-2PM', 1, '2026-05-18 16:46:46'),
(2, 'Aayush Dhimal', 'aayush@gympro.com', '9802222222', 'Yoga & Flexibility', 4, 'Mindfulness yoga instructor.', 'Mon-Sat 7AM-1PM', 1, '2026-05-18 16:46:46'),
(3, 'Sachin Basyal', 'kaledon@gympro.com', '9803333333', 'Cardio & HIIT', 6, 'High-energy HIIT coach.', 'Tue-Sun 8AM-4PM', 1, '2026-05-18 16:46:46'),
(4, 'Naveen Subedi', 'naveen@gmail.com', '9887878787', 'Boxing & MMA', 0, '', 'mon - Fri 6AM - 2PM', 1, '2026-05-18 16:50:54'),
(5, 'kalsang', 'kalsang@gmail.com', '9886766767', 'Yoga & Flexibility', 5, '', 'Mon-Sat 7AM-1PM', 1, '2026-05-18 18:01:06');

--


-- Table structure for table `users`


CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `address` text DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `role` enum('admin','member') NOT NULL DEFAULT 'member',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `users`


INSERT INTO `users` (`user_id`, `full_name`, `email`, `phone`, `password`, `date_of_birth`, `gender`, `address`, `profile_photo`, `role`, `status`, `created_at`) VALUES
(1, 'GymPro Admin', 'admin@gympro.com', '9800000000', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', '1990-01-01', 'Male', 'Kathmandu, Nepal', NULL, 'admin', 'approved', '2026-05-18 16:46:46'),
(2, 'Nishan Bhusal', 'nikhilbhusal100@gmail.com', '9763610723', '$2a$10$qtbcaV8XOG7WKR1sUo.ksuMd3vrimbVjcui0A3dUE5d3k4ToC2ZSW', '2021-01-19', 'Male', 'Manigram', NULL, 'admin', 'approved', '2026-05-18 16:48:35'),
(3, 'Samrat Bhandari', 'samrat@gmail.com', '9887676767', '$2a$10$OTM7ZF5AWq2FhEQ08zz0VuSdyjY0KYz.O9fbc76EoY1KtEZVIinnO', '2026-05-06', 'Male', 'Manigram', 'user_3_1779124803742.png', 'member', 'approved', '2026-05-18 16:51:42'),
(4, 'Kiran', 'kiran@gmail.com', '9882837887', '$2a$10$06uz43azeKcRlIblax3sx.qlZsHJnkJjVOT4Cpd3O4KkWRJRKRpba', '2026-05-01', 'Male', 'tilottama', NULL, 'member', 'approved', '2026-05-18 17:53:24');


-- Indexes for dumped tables

-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `class_id` (`class_id`),
  ADD KEY `idx_date` (`attended_date`);

-- Indexes for table `classes`
ALTER TABLE `classes`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `trainer_id` (`trainer_id`),
  ADD KEY `idx_schedule` (`schedule_datetime`);

-- Indexes for table `class_enrollments`

  ALTER TABLE `class_enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD UNIQUE KEY `uq_user_class` (`user_id`,`class_id`),
  ADD KEY `class_id` (`class_id`);


-- Indexes for table `contact_inquiries`

ALTER TABLE `contact_inquiries`
  ADD PRIMARY KEY (`inquiry_id`);


-- Indexes for table `membership_plans`

ALTER TABLE `membership_plans`
  ADD PRIMARY KEY (`plan_id`);


-- Indexes for table `member_attendance`

ALTER TABLE `member_attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD UNIQUE KEY `uq_user_date` (`user_id`,`attendance_date`),
  ADD KEY `verified_by` (`verified_by`),
  ADD KEY `idx_status` (`status`);


-- Indexes for table `member_memberships`

ALTER TABLE `member_memberships`
  ADD PRIMARY KEY (`membership_id`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_payment_status` (`payment_status`);

-- Indexes for table `trainers`
ALTER TABLE `trainers`
  ADD PRIMARY KEY (`trainer_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_status` (`status`);


-- AUTO_INCREMENT for dumped tables



-- AUTO_INCREMENT for table `attendance`

ALTER TABLE `attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT;


-- AUTO_INCREMENT for table `classes`

ALTER TABLE `classes`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


-- AUTO_INCREMENT for table `class_enrollments`

ALTER TABLE `class_enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;


-- AUTO_INCREMENT for table `contact_inquiries`

ALTER TABLE `contact_inquiries`
  MODIFY `inquiry_id` int(11) NOT NULL AUTO_INCREMENT;

  
-- AUTO_INCREMENT for table `membership_plans`

ALTER TABLE `membership_plans`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


-- AUTO_INCREMENT for table `member_attendance`

ALTER TABLE `member_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;


-- AUTO_INCREMENT for table `member_memberships`

ALTER TABLE `member_memberships`
  MODIFY `membership_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;


-- AUTO_INCREMENT for table `trainers`

ALTER TABLE `trainers`
  MODIFY `trainer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

-- AUTO_INCREMENT for table `users`
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


-- Constraints for dumped tables


-- Constraints for table `attendance`

ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE;

-- Constraints for table `classes`
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`trainer_id`);

-- Constraints for table `class_enrollments`
ALTER TABLE `class_enrollments`
  ADD CONSTRAINT `class_enrollments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `class_enrollments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE;


-- Constraints for table `member_attendance`

ALTER TABLE `member_attendance`
  ADD CONSTRAINT `member_attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `member_attendance_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;


-- Constraints for table `member_memberships`

ALTER TABLE `member_memberships`
  ADD CONSTRAINT `member_memberships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `member_memberships_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `membership_plans` (`plan_id`);
COMMIT;

