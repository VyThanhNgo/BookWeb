-- Table structure for table `users`
DROP TABLE IF EXISTS `users`;

CREATE TABLE
    `users` (
        `user_id` INT NOT NULL AUTO_INCREMENT,
        `username` VARCHAR(50) NOT NULL UNIQUE,
        `password` VARCHAR(255) NOT NULL,
        `email` VARCHAR(255) NOT NULL UNIQUE,
        `full_name` VARCHAR(255) NOT NULL,
        `phone` VARCHAR(20),
        `address` TEXT,
        `is_active` TINYINT (1) DEFAULT 1 NOT NULL,
        `role` VARCHAR(20) DEFAULT 'user',
        `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`user_id`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_username` ON `users` (`username`);

CREATE INDEX `idx_email` ON `users` (`email`);