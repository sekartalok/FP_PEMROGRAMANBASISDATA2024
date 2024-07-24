-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 08:12 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `car_rent`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCarAndNote` (IN `p_plate_num` VARCHAR(10), IN `p_brad` VARCHAR(50), IN `p_year` DATE, IN `p_IDnote` VARCHAR(10), IN `p_security_num` VARCHAR(10), IN `p_price` FLOAT, IN `p_date_rent` TIMESTAMP, IN `p_paid_off` BINARY)   BEGIN
    INSERT INTO car (plate_num, brad, year)
    VALUES (p_plate_num, p_brad, p_year);

    INSERT INTO note (IDnote, security_num, plate_num, price, date_rent, paid_off)
    VALUES (p_IDnote, p_security_num, p_plate_num, p_price, p_date_rent, p_paid_off);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteCarAndNotes` (IN `p_plate_num` VARCHAR(10))   BEGIN
    DELETE FROM note
    WHERE plate_num = p_plate_num;
    
    DELETE FROM car
    WHERE plate_num = p_plate_num;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `ServiceCount` (`plate_num` VARCHAR(10)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE count INT;
    
    SELECT COUNT(*)
    INTO count
    FROM service
    WHERE plate_num = plate_num;
    
    RETURN count;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `TotalAmountPaid` (`security_num` VARCHAR(10)) RETURNS FLOAT DETERMINISTIC BEGIN
    DECLARE total FLOAT;
    
    SELECT SUM(price)
    INTO total
    FROM note
    WHERE security_num = security_num;
    
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `car`
--

CREATE TABLE `car` (
  `plate_num` varchar(255) NOT NULL,
  `brand` varchar(255) NOT NULL,
  `year` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `car`
--

INSERT INTO `car` (`plate_num`, `brand`, `year`) VALUES
('ABC123', 'Toyota', 2020),
('JKL321', 'Chevrolet', 2018),
('LMN456', 'Ford', 2021),
('PQR654', 'Tesla', 2022),
('XYZ789', 'Honda', 2019);

-- --------------------------------------------------------

--
-- Stand-in structure for view `carrentalsummary`
-- (See below for the actual view)
--
CREATE TABLE `carrentalsummary` (
`user_name` varchar(255)
,`car_brand` varchar(255)
,`rent_price` float
,`date_rent` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `car_deletion_log`
--

CREATE TABLE `car_deletion_log` (
  `id` int(11) NOT NULL,
  `plate_num` varchar(10) DEFAULT NULL,
  `deletion_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `idcard`
--

CREATE TABLE `idcard` (
  `security_num` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `idcard`
--

INSERT INTO `idcard` (`security_num`, `name`, `address`) VALUES
('11111', 'Sarah Davis', '654 Cedar Boulevard'),
('12345', 'John Doe', '123 Elm Street'),
('54321', 'Emily Johnson', '789 Pine Road'),
('67890', 'Jane Smith', '456 Oak Avenue'),
('98765', 'Michael Brown', '321 Maple Lane');

-- --------------------------------------------------------

--
-- Table structure for table `mechanic`
--

CREATE TABLE `mechanic` (
  `IDmec` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `div` varchar(255) NOT NULL,
  `age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mechanic`
--

INSERT INTO `mechanic` (`IDmec`, `name`, `div`, `age`) VALUES
('M001', 'Alice Williams', 'Engine', 30),
('M002', 'Bob Martinez', 'Transmission', 45),
('M003', 'Charlie Taylor', 'Brakes', 38),
('M004', 'Diana Lewis', 'Electrical', 29),
('M005', 'Ethan Harris', 'Suspension', 35);

-- --------------------------------------------------------

--
-- Stand-in structure for view `mechanicservicecount`
-- (See below for the actual view)
--
CREATE TABLE `mechanicservicecount` (
`mechanic_name` varchar(255)
,`service_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `IDnote` varchar(255) NOT NULL,
  `security_num` varchar(255) NOT NULL,
  `plate_num` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `date_rent` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `paid_off` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`IDnote`, `security_num`, `plate_num`, `price`, `date_rent`, `paid_off`) VALUES
('N001', '12345', 'ABC123', 500, '2023-06-01 02:00:00', 1),
('N002', '67890', 'XYZ789', 300, '2023-06-15 03:30:00', 0),
('N003', '54321', 'LMN456', 450, '2023-07-01 04:00:00', 1),
('N004', '98765', 'JKL321', 350, '2023-07-15 07:00:00', 0),
('N005', '11111', 'PQR654', 600, '2023-08-01 08:30:00', 1);

--
-- Triggers `note`
--
DELIMITER $$
CREATE TRIGGER `update_user_score` AFTER INSERT ON `note` FOR EACH ROW BEGIN
    UPDATE User
    SET score = score + 1
    WHERE security_num = NEW.security_num;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `IDreceipt` varchar(255) NOT NULL,
  `IDnote` varchar(255) NOT NULL,
  `date_pay` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`IDreceipt`, `IDnote`, `date_pay`, `price`) VALUES
('R001', 'N001', '2023-06-02 03:00:00', 500),
('R002', 'N002', '2023-06-16 05:00:00', 300),
('R003', 'N003', '2023-07-02 06:00:00', 450),
('R004', 'N004', '2023-07-16 09:00:00', 350),
('R005', 'N005', '2023-08-02 10:00:00', 600);

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `IDnom` int(11) NOT NULL,
  `plate_num` varchar(255) NOT NULL,
  `IDmec` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`IDnom`, `plate_num`, `IDmec`) VALUES
(1, 'ABC123', 'M001'),
(2, 'XYZ789', 'M002'),
(3, 'LMN456', 'M003'),
(4, 'JKL321', 'M004'),
(5, 'PQR654', 'M005');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `security_num` varchar(255) NOT NULL,
  `date_create` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `score` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`security_num`, `date_create`, `score`) VALUES
('11111', '2023-05-20 04:55:00', 95),
('12345', '2023-01-01 03:00:00', 85),
('54321', '2023-03-10 01:20:00', 75),
('67890', '2023-02-15 07:30:00', 90),
('98765', '2023-04-05 09:45:00', 80);

-- --------------------------------------------------------

--
-- Structure for view `carrentalsummary`
--
DROP TABLE IF EXISTS `carrentalsummary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `carrentalsummary`  AS SELECT `idcard`.`name` AS `user_name`, `car`.`brand` AS `car_brand`, `note`.`price` AS `rent_price`, `note`.`date_rent` AS `date_rent` FROM ((`note` join `idcard` on(`note`.`security_num` = `idcard`.`security_num`)) join `car` on(`note`.`plate_num` = `car`.`plate_num`))  ;

-- --------------------------------------------------------

--
-- Structure for view `mechanicservicecount`
--
DROP TABLE IF EXISTS `mechanicservicecount`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mechanicservicecount`  AS SELECT `mechanic`.`name` AS `mechanic_name`, count(`service`.`IDnom`) AS `service_count` FROM (`mechanic` left join `service` on(`mechanic`.`IDmec` = `service`.`IDmec`)) GROUP BY `mechanic`.`name``name`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`plate_num`);

--
-- Indexes for table `car_deletion_log`
--
ALTER TABLE `car_deletion_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `idcard`
--
ALTER TABLE `idcard`
  ADD PRIMARY KEY (`security_num`);

--
-- Indexes for table `mechanic`
--
ALTER TABLE `mechanic`
  ADD PRIMARY KEY (`IDmec`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`IDnote`),
  ADD KEY `security_num` (`security_num`),
  ADD KEY `plate_num` (`plate_num`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`IDreceipt`),
  ADD KEY `IDnote` (`IDnote`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`IDnom`),
  ADD KEY `plate_num` (`plate_num`),
  ADD KEY `IDmec` (`IDmec`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`security_num`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `car_deletion_log`
--
ALTER TABLE `car_deletion_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `note_ibfk_1` FOREIGN KEY (`security_num`) REFERENCES `idcard` (`security_num`),
  ADD CONSTRAINT `note_ibfk_2` FOREIGN KEY (`plate_num`) REFERENCES `car` (`plate_num`);

--
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`IDnote`) REFERENCES `note` (`IDnote`);

--
-- Constraints for table `service`
--
ALTER TABLE `service`
  ADD CONSTRAINT `service_ibfk_1` FOREIGN KEY (`plate_num`) REFERENCES `car` (`plate_num`),
  ADD CONSTRAINT `service_ibfk_2` FOREIGN KEY (`IDmec`) REFERENCES `mechanic` (`IDmec`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`security_num`) REFERENCES `idcard` (`security_num`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
