-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 03 Eyl 2021, 17:36:15
-- Sunucu sürümü: 10.4.20-MariaDB
-- PHP Sürümü: 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `depo`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcBoxOfOrderDelete` (IN `del` INT)  BEGIN
	
	#select * from boxoforder where boxoforder.bo_id = del;
	delete from boxoforder where boxoforder.bo_id = del;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcCustomerSearch` (IN `customerSearch` VARCHAR(255))  BEGIN
	select * from customer 
	where `cu_name` 
	like CONCAT('%',customerSearch,'%') or `cu_surname`
	like CONCAT('%',customerSearch,'%') or `cu_mobile`
	like CONCAT('%',customerSearch,'%') or `cu_company_title`
	like CONCAT('%',customerSearch,'%') or `cu_tax_number`
	like CONCAT('%',customerSearch,'%') or `cu_email`
	like CONCAT('%',customerSearch,'%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcDelete` (IN `del` INT)  BEGIN
	
	#select * from boxoforder where boxoforder.bo_id = del;
	delete from boxoforder where boxoforder.bo_id = del;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcPayInSearch` (IN `s` VARCHAR(255))  BEGIN

	select * from viewPayInTable 
	where `co_nameSurname` 
	like CONCAT('%',s,'%') or `co_ticketNo`
	like CONCAT('%',s,'%') ;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcPayOutSearch` (IN `payOutSearch` VARCHAR(255))  BEGIN
	
	SELECT * FROM cashboxout 
	WHERE cbOut_title
	LIKE CONCAT('%',payOutSearch,'%') or cbOut_payDetail
	LIKE CONCAT('%',payOutSearch,'%');
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcProductSearch` (IN `psearch` VARCHAR(255))  BEGIN
	
	SELECT * from product as p
	WHERE p.p_title
	LIKE CONCAT('%',psearch,'%') or p.p_code
	LIKE CONCAT('%',psearch,'%');
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcReportCashBoxIn` (IN `startDate` VARCHAR(255), IN `endDate` VARCHAR(255))  BEGIN
	
	select * from cashboxin 
	where cbIn_status = 1 and
	cbIn_date BETWEEN startDate and endDate;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcReportCOA` (IN `id` INT, IN `startDate` VARCHAR(255), IN `endDate` VARCHAR(255))  BEGIN
	
select * from view_checkoutactions 
where cu_id = id and paymentStatus = 1 and
co_date BETWEEN startDate and endDate;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcReportCOABoxIn` (IN `startDate` VARCHAR(255), IN `endDate` VARCHAR(255))  BEGIN
	select * from view_checkoutactions 
	where paymentStatus = 1 and
	co_date BETWEEN startDate and endDate;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcReportCOAOut` (IN `startDate` VARCHAR(255), IN `endDate` VARCHAR(255))  BEGIN
	select * from cashboxout 
	where cbOut_status = 2 and
	cbOut_date BETWEEN startDate and endDate;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcUpdateCashBoxInPriceAmount` (IN `paid` INT, IN `ticket` VARCHAR(255))  BEGIN
	
	UPDATE cashboxin AS cb
	SET cb.cbIn_payAmount = cb.cbIn_payAmount + paid
	where cb.cbIn_ticketNo = ticket and cb.updateStatus = 1;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcUpdateCompletedOrderPrice` (IN `ticketNo` VARCHAR(255), IN `payQTY` INT)  BEGIN
	
	#Update amounPaid and co_avail Value 
	UPDATE 
	completedorder as cOrder
	SET 
	cOrder.co_amountPaid = cOrder.co_amountPaid + payQTY,
	cOrder.co_avail = cOrder.co_avail - payQTY
	WHERE 
	cOrder.co_ticketNo = ticketNo AND 
	cOrder.co_amountPaid <= cOrder.totalPrice AND 
	payQTY <= cOrder.co_avail;
	
	#Update paymentStatus Value
	UPDATE completedorder as cOrder 
	SET cOrder.paymentStatus = 1
	WHERE cOrder.totalPrice = cOrder.co_amountPaid AND cOrder.co_ticketNo = ticketNo; 
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcUpdateProductStock` (IN `product_id` INT, IN `qty` INT)  BEGIN
	
	UPDATE product AS p
	SET p.p_quantity = p.p_quantity - qty
	WHERE p.p_id = product_id AND p.p_quantity >= qty;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcUpdateStatusBOD` (IN `input` INT)  BEGIN
	
	UPDATE boxoforder as bod
	SET bod.bo_status = 1
	WHERE bod.cu_id = input;
	
	UPDATE boxorder as b
	SET b.bo_status = 1
	WHERE b.bo_customer = input;
	
	

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxoforder`
--

CREATE TABLE `boxoforder` (
  `bod_id` int(11) NOT NULL,
  `bo_id` int(11) DEFAULT NULL,
  `bo_status` int(11) NOT NULL,
  `bo_ticketNo` varchar(255) DEFAULT NULL,
  `bo_total` int(11) NOT NULL,
  `bo_totalPrice` int(11) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `name_surname` varchar(255) DEFAULT NULL,
  `p_id` int(11) NOT NULL,
  `p_salePrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `boxoforder`
--

INSERT INTO `boxoforder` (`bod_id`, `bo_id`, `bo_status`, `bo_ticketNo`, `bo_total`, `bo_totalPrice`, `cu_id`, `name_surname`, `p_id`, `p_salePrice`, `p_title`) VALUES
(9, 20, 1, '095650230', 1, 1500, 8, 'Ceren Çabuk', 10, 1500, 'Canon Printer'),
(10, 21, 1, '096429230', 1, 5000, 11, 'Burak  Kaleci', 1, 5000, 'Buzdolabı'),
(11, 22, 1, '096429230', 1, 10500, 11, 'Burak  Kaleci', 4, 10500, 'Bilgisayar'),
(51, 52, 1, '225423895', 1, 10500, 2, 'Eymen ERUYAR', 4, 10500, 'Bilgisayar'),
(52, 53, 1, '226171304', 1, 5000, 3, 'Ali Yılmaz', 1, 5000, 'Buzdolabı'),
(53, 54, 1, '226171304', 1, 2650, 3, 'Ali Yılmaz', 5, 2650, 'Bulaşık Makinası'),
(54, 55, 1, '238879978', 1, 10500, 11, 'Burak  Kaleci', 4, 10500, 'Bilgisayar'),
(55, 56, 1, '241878223', 5, 375, 2, 'Eymen ERUYAR', 6, 75, 'Antep Fıstığı'),
(56, 57, 1, '317822336', 5, 25000, 7, 'Berat  Yılmaz', 2, 5000, 'Televizyon'),
(57, 58, 1, '330294889', 5, 7500, 9, 'Ahmet  Dursun', 10, 1500, 'Canon Printer'),
(58, 59, 1, '333775540', 2, 9000, 11, 'Burak  Kaleci', 12, 4500, 'Ekran Kartı'),
(59, 60, 1, '346620904', 2, 21000, 10, 'Osman  Parlaktuna', 4, 10500, 'Bilgisayar'),
(66, 67, 1, '617650982', 5, 7500, 1, 'Evren ERUYAR', 10, 1500, 'Canon Printer'),
(68, 69, 1, '669717000', 1, 4100, 12, 'Ayça Duman', 13, 4100, 'Apple Watch 6'),
(69, 70, 1, '669717000', 1, 5000, 12, 'Ayça Duman', 2, 5000, 'Televizyon'),
(70, 71, 1, '682802803', 1, 4100, 1, 'Evren ERUYAR', 13, 4100, 'Apple Watch 6'),
(71, 72, 1, '683058841', 5, 25000, 5, 'Veli Yılmaz', 1, 5000, 'Buzdolabı'),
(72, 73, 1, '683285642', 1, 4100, 8, 'Ceren Çabuk', 13, 4100, 'Apple Watch 6');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxorder`
--

CREATE TABLE `boxorder` (
  `bo_id` int(11) NOT NULL,
  `bo_customer` int(11) NOT NULL,
  `bo_product` int(11) NOT NULL,
  `bo_ticketNo` varchar(255) DEFAULT NULL,
  `bo_total` int(11) NOT NULL,
  `bo_totalPrice` int(12) NOT NULL,
  `bo_status` int(11) DEFAULT NULL,
  `bo_date` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `boxorder`
--

INSERT INTO `boxorder` (`bo_id`, `bo_customer`, `bo_product`, `bo_ticketNo`, `bo_total`, `bo_totalPrice`, `bo_status`, `bo_date`) VALUES
(5, 6, 1, '0006', 1, 0, 1, '26.08.2021'),
(10, 2, 4, '0011', 1, 0, 1, '28.08.2021'),
(20, 8, 10, '095650230', 1, 0, 1, '25.08.2021'),
(21, 11, 1, '096429230', 1, 0, 1, '01.08.2021'),
(22, 11, 4, '096429230', 1, 0, 1, '8.08.2021'),
(52, 2, 4, '225423895', 1, 0, 1, '29-08-2021'),
(53, 3, 1, '226171304', 1, 0, 1, '29-08-2021'),
(54, 3, 5, '226171304', 1, 0, 1, '29-08-2021'),
(55, 11, 4, '238879978', 1, 0, 1, '29-08-2021'),
(56, 2, 6, '241878223', 5, 0, 1, '29-08-2021'),
(57, 7, 2, '317822336', 5, 0, 1, '30-08-2021'),
(58, 9, 10, '330294889', 5, 0, 1, '30-08-2021'),
(59, 11, 12, '333775540', 2, 0, 1, '30-08-2021'),
(60, 10, 4, '346620904', 2, 0, 1, '30-08-2021'),
(67, 1, 10, '617650982', 5, 0, 1, '03-09-2021'),
(69, 12, 13, '669717000', 1, 0, 1, '03-09-2021'),
(70, 12, 2, '669717000', 1, 0, 1, '03-09-2021'),
(71, 1, 13, '682802803', 1, 0, 1, '03-09-2021'),
(72, 5, 1, '683058841', 5, 0, 1, '03-09-2021'),
(73, 8, 13, '683285642', 1, 0, 1, '03-09-2021');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxorder_cu_pro`
--

CREATE TABLE `boxorder_cu_pro` (
  `bo_id` int(11) NOT NULL,
  `bo_status` int(11) NOT NULL,
  `bo_ticketNo` varchar(255) DEFAULT NULL,
  `bo_total` int(11) NOT NULL,
  `bo_totalPrice` int(11) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `name_surname` varchar(255) DEFAULT NULL,
  `p_id` int(11) NOT NULL,
  `p_salePrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `cashboxin`
--

CREATE TABLE `cashboxin` (
  `cbIn_id` int(11) NOT NULL,
  `cbIn_customer` int(11) NOT NULL,
  `cbIn_date` varchar(255) DEFAULT NULL,
  `cbIn_payAmount` int(11) NOT NULL,
  `cbIn_payDetail` varchar(255) DEFAULT NULL,
  `cbIn_status` int(11) NOT NULL,
  `cbIn_ticketNo` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `cashboxin`
--

INSERT INTO `cashboxin` (`cbIn_id`, `cbIn_customer`, `cbIn_date`, `cbIn_payAmount`, `cbIn_payDetail`, `cbIn_status`, `cbIn_ticketNo`) VALUES
(19, 2, '2021-08-29', 10500, 'Detay', 1, '225423895'),
(20, 3, '2021-08-28', 7650, 'Detay', 1, '226171304'),
(21, 2, '2021-08-30', 375, 'Eymen - Detay', 1, '241878223'),
(22, 11, '2021-08-30', 9500, 'Burak - Detay', 1, '238879978'),
(23, 11, '2021-08-30', 1000, '', 1, '238879978'),
(94, 10, '2021-08-30', 1000, '', 1, '346620904'),
(95, 10, '2021-08-30', 20000, '', 1, '346620904'),
(96, 11, '2021-09-01', 9000, 'Burak - Ekran Kartı Ödeme', 1, '333775540'),
(97, 9, '2021-09-02', 2500, '', 1, '330294889'),
(98, 9, '2021-09-02', 5000, 'Ahmet - Detay Ödeme', 1, '330294889'),
(99, 12, '2021-09-03', 9100, 'Detay', 1, '669717000');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `cashboxout`
--

CREATE TABLE `cashboxout` (
  `cbOut_id` int(11) NOT NULL,
  `cbOut_date` varchar(255) DEFAULT NULL,
  `cbOut_payAmount` int(11) NOT NULL,
  `cbOut_payDetail` varchar(255) DEFAULT NULL,
  `cbOut_payType` int(11) NOT NULL,
  `cbOut_status` int(11) NOT NULL,
  `cbOut_title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `cashboxout`
--

INSERT INTO `cashboxout` (`cbOut_id`, `cbOut_date`, `cbOut_payAmount`, `cbOut_payDetail`, `cbOut_payType`, `cbOut_status`, `cbOut_title`) VALUES
(2, '2021-08-29', 250, 'Su Faturası', 0, 2, 'Su'),
(3, '2021-08-29', 550, 'Elektrik Faturası', 0, 2, 'Elektrik'),
(4, '2021-08-27', 12000, 'Maaş (3000*4)', 2, 2, 'Çalışan Maaşları'),
(5, '2021-08-30', 500, 'Personel Yemek', 0, 2, 'Yemek Gideri'),
(6, '2021-09-03', 1000, 'Fatura', 0, 2, 'Cam Masrafı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `completedorder`
--

CREATE TABLE `completedorder` (
  `co_id` int(32) NOT NULL,
  `c_id` int(32) NOT NULL,
  `p_id` int(32) NOT NULL,
  `co_nameSurname` varchar(255) NOT NULL,
  `co_ticketNo` varchar(255) NOT NULL,
  `totalPrice` int(32) NOT NULL,
  `co_amountPaid` int(32) NOT NULL,
  `co_avail` int(32) NOT NULL,
  `paymentStatus` int(32) NOT NULL,
  `co_date` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `completedorder`
--

INSERT INTO `completedorder` (`co_id`, `c_id`, `p_id`, `co_nameSurname`, `co_ticketNo`, `totalPrice`, `co_amountPaid`, `co_avail`, `paymentStatus`, `co_date`) VALUES
(1, 2, 4, 'Eymen ERUYAR', '225423895', 10500, 10500, 0, 1, '2021-08-29'),
(2, 3, 1, 'Ali Yılmaz', '226171304', 7650, 7650, 0, 1, '2021-08-28'),
(3, 11, 4, 'Burak  Kaleci', '238879978', 10500, 10500, 0, 1, '2021-08-30'),
(4, 2, 6, 'Eymen ERUYAR', '241878223', 375, 375, 0, 1, '2021-08-30'),
(5, 7, 2, 'Berat  Yılmaz', '317822336', 25000, 0, 25000, 0, '2021-08-26'),
(6, 9, 10, 'Ahmet  Dursun', '330294889', 7500, 7500, 0, 1, '2021-08-27'),
(7, 10, 4, 'Osman  Parlaktuna', '346620904', 21000, 21000, 0, 1, '2021-08-30'),
(8, 11, 12, 'Burak  Kaleci', '333775540', 9000, 9000, 0, 1, '2021-09-01'),
(9, 1, 10, 'Evren ERUYAR', '617650982', 7500, 0, 7500, 0, '2021-09-03'),
(10, 12, 13, 'Ayça Duman', '669717000', 9100, 9100, 0, 1, '2021-09-03'),
(12, 5, 1, 'Veli Yılmaz', '683058841', 25000, 0, 25000, 0, '2021-09-03'),
(13, 8, 13, 'Ceren Çabuk', '683285642', 4100, 0, 4100, 0, '2021-09-03');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer`
--

CREATE TABLE `customer` (
  `cu_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_password` varchar(32) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `cu_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customer`
--

INSERT INTO `customer` (`cu_id`, `cu_address`, `cu_code`, `cu_company_title`, `cu_email`, `cu_mobile`, `cu_name`, `cu_password`, `cu_phone`, `cu_surname`, `cu_tax_administration`, `cu_tax_number`, `status`, `cu_date`) VALUES
(1, 'Silivri', 652526192, 'Kuzu Grup', 'evren@mail.com', '05321569878', 'Evren', '', '', 'ERUYAR', 'İstanbul - Silivri', 45122154, 1, '2021-07-25 13:50:29'),
(2, 'GOP BULVARI MAHMUTPAŞA MAH. KUŞAK APT. NO: 289', 652582079, 'Yarbaç', 'eymen@mail.com', '05548398073', 'Eymen', '', '', 'ERUYAR', 'Tokat - Merkez', 456654, 1, '2021-08-25 15:50:29'),
(3, 'İstanbul - Sancaktepe', 652670739, '', 'ali@mail.com', '05569876581', 'Ali', '', '', 'Yılmaz', '', 123654, 2, '2021-08-28 12:50:29'),
(5, 'Üsküdar Mah.', 747199776, '', 'veli@mail.com', '05548398073', 'Veli', '', '', 'Yılmaz', 'İstanbul-Üsküdar', 789987, 2, '2021-08-25 12:50:29'),
(6, 'Kocaeli-İzmit', 835841903, '', 'mthn@mail.com', '05521497831', 'Metehan', '', '', 'Yılmaz', '', 512364, 2, '2021-08-25 12:50:29'),
(7, 'YTÜ-Teknopark', 835906280, 'Ziraat Teknoloji', 'berat@mail.com', '05659516545', 'Berat ', '', '', 'Yılmaz', 'İstanbul-Esenyurt', 886357, 1, '2021-08-25 12:50:29'),
(8, 'İstanbul-4.Levent', 835967357, 'Çabuk A.Ş', 'ceren@mail.com', '05559877234', 'Ceren', '', '', 'Çabuk', 'İstanbul-Levent', 413265, 1, '2021-08-25 12:50:29'),
(9, 'Sanayi Sit.- 21.Blok', 836059660, 'Dursun Oto', 'dursun@mail.com', '05549645235', 'Ahmet ', '', '', 'Dursun', 'Tokat - Merkez', 552312, 1, '2021-08-25 20:50:29'),
(10, 'Eskişehir-Vişnelik', 836160531, '', 'osman@mail.com', '05563124585', 'Osman ', '', '', 'Parlaktuna', '', 778985, 2, '2021-08-25 22:50:29'),
(11, 'ESOGÜ-Meşelik Kampüsü', 836213637, 'ESOGÜ', 'burak@mail.com', '05531264578', 'Burak ', '', '', 'Kaleci', 'Eskişehir-Odunpazarı', 996458, 1, '2021-08-25 21:50:29'),
(12, 'Finike Çarşı', 836265093, '', 'ayca@mail.com', '05547863154', 'Ayça', '', '', 'Duman', 'Antalya-Finike', 885697, 2, '2021-08-25 12:55:29');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer_boxorder`
--

CREATE TABLE `customer_boxorder` (
  `Customer_cu_id` int(11) NOT NULL,
  `boxOrder_bo_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customer_boxorder`
--

INSERT INTO `customer_boxorder` (`Customer_cu_id`, `boxOrder_bo_id`) VALUES
(1, 67),
(1, 71),
(2, 10),
(2, 52),
(2, 56),
(3, 53),
(3, 54),
(5, 72),
(6, 5),
(7, 57),
(8, 20),
(8, 73),
(9, 58),
(10, 60),
(11, 21),
(11, 22),
(11, 55),
(11, 59),
(12, 69),
(12, 70);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `hibernate_sequence`
--

CREATE TABLE `hibernate_sequence` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `hibernate_sequence`
--

INSERT INTO `hibernate_sequence` (`next_val`) VALUES
(21);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `product`
--

CREATE TABLE `product` (
  `p_id` int(11) NOT NULL,
  `p_buyPrice` int(11) NOT NULL,
  `p_code` int(11) NOT NULL,
  `p_detail` varchar(255) DEFAULT NULL,
  `p_quantity` int(11) NOT NULL,
  `p_salePrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL,
  `p_unit` varchar(255) DEFAULT NULL,
  `p_vat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `product`
--

INSERT INTO `product` (`p_id`, `p_buyPrice`, `p_code`, `p_detail`, `p_quantity`, `p_salePrice`, `p_title`, `p_unit`, `p_vat`) VALUES
(1, 2000, 564743604, 'A++ No-Frost', 495, 5000, 'Buzdolabı', '0', '2'),
(2, 2500, 569113012, 'Led-TV 42\'', 194, 5000, 'Televizyon', '0', '2'),
(3, 3000, 569189555, 'A++ Aqua', 100, 6000, 'Çamaşır Makinası', '0', '2'),
(4, 6500, 571579760, 'Apple Mac Book Pro', 18, 10500, 'Bilgisayar', '0', '3'),
(5, 1500, 572415835, 'A+', 15, 2650, 'Bulaşık Makinası', '0', '0'),
(6, 50, 572600261, 'Orta Kalite', 295, 75, 'Antep Fıstığı', '1', '0'),
(8, 150, 836451669, 'Halı Detay', 120, 450, 'Halı', '2', '0'),
(9, 1250, 836528966, '23\' LCD ', 15, 1750, 'Monitör', '0', '3'),
(10, 800, 836560748, 'Printer Detay', 40, 2000, 'Canon Printer', '0', '0'),
(11, 7999, 257275551, '64 GB (BLACK)', 5, 9999, 'Apple Iphone 12 Mini ', '0', '0'),
(12, 3500, 279293530, 'NVIDIA GEFORCE GTX1080 Tİ 4GB', 8, 4500, 'Ekran Kartı', '0', '0'),
(13, 3300, 449428658, 'Series 6 44 mm', 0, 4100, 'Apple Watch 6', '0', '0'),
(14, 5999, 669603721, '32 GB', 4, 7999, 'Apple Ipad ', '0', '0');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `reportcoa`
--

CREATE TABLE `reportcoa` (
  `cu_id` int(11) NOT NULL,
  `COA_endDate` varchar(255) DEFAULT NULL,
  `COA_startDate` varchar(255) DEFAULT NULL,
  `cbIn_status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `user`
--

CREATE TABLE `user` (
  `us_id` int(11) NOT NULL,
  `us_email` varchar(255) DEFAULT NULL,
  `us_name` varchar(255) DEFAULT NULL,
  `us_password` varchar(32) DEFAULT NULL,
  `us_surname` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `user`
--

INSERT INTO `user` (`us_id`, `us_email`, `us_name`, `us_password`, `us_surname`) VALUES
(2, 'eruyar123@gmail.com', 'Eyüp Eymen', '12345', 'ERUYAR');

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `viewboxordertable`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `viewboxordertable` (
`bo_id` int(11)
,`cu_id` int(11)
,`name_surname` varchar(511)
,`bo_ticketNo` varchar(255)
,`p_id` int(11)
,`p_title` varchar(255)
,`p_salePrice` int(11)
,`bo_total` int(11)
,`bo_totalPrice` bigint(21)
,`bo_status` int(11)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `viewpayintable`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `viewpayintable` (
`cbIn_id` int(11)
,`co_nameSurname` varchar(255)
,`co_ticketNo` varchar(255)
,`cbIn_payAmount` int(11)
,`cbIn_payDetail` varchar(255)
);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `view_boxorder_cupro`
--

CREATE TABLE `view_boxorder_cupro` (
  `bo_id` int(11) NOT NULL,
  `bo_status` int(11) NOT NULL,
  `bo_ticketNo` varchar(255) DEFAULT NULL,
  `bo_total` int(11) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `name_surname` varchar(255) DEFAULT NULL,
  `p_id` int(11) NOT NULL,
  `p_salePrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL,
  `totalPrice` int(11) NOT NULL,
  `bo_totalPrice` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `view_cashboxincompletedorder`
--

CREATE TABLE `view_cashboxincompletedorder` (
  `cbIn_id` int(11) NOT NULL,
  `cbIn_payAmount` int(11) NOT NULL,
  `cbIn_payDetail` varchar(255) DEFAULT NULL,
  `co_nameSurname` varchar(255) DEFAULT NULL,
  `co_ticketNo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `view_checkoutactions`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `view_checkoutactions` (
`co_ticketNo` varchar(255)
,`cu_id` int(11)
,`co_nameSurname` varchar(255)
,`cu_mobile` varchar(255)
,`cu_email` varchar(500)
,`co_amountPaid` int(32)
,`paymentStatus` int(32)
,`co_date` varchar(255)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı `viewboxordertable`
--
DROP TABLE IF EXISTS `viewboxordertable`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewboxordertable`  AS SELECT `bo`.`bo_id` AS `bo_id`, `c`.`cu_id` AS `cu_id`, concat(`c`.`cu_name`,' ',`c`.`cu_surname`) AS `name_surname`, `bo`.`bo_ticketNo` AS `bo_ticketNo`, `p`.`p_id` AS `p_id`, `p`.`p_title` AS `p_title`, `p`.`p_salePrice` AS `p_salePrice`, `bo`.`bo_total` AS `bo_total`, `bo`.`bo_total`* `p`.`p_salePrice` AS `bo_totalPrice`, `bo`.`bo_status` AS `bo_status` FROM ((`customer` `c` join `boxorder` `bo` on(`bo`.`bo_customer` = `c`.`cu_id`)) join `product` `p` on(`bo`.`bo_product` = `p`.`p_id`)) ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `viewpayintable`
--
DROP TABLE IF EXISTS `viewpayintable`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewpayintable`  AS SELECT `cbin`.`cbIn_id` AS `cbIn_id`, `co`.`co_nameSurname` AS `co_nameSurname`, `co`.`co_ticketNo` AS `co_ticketNo`, `cbin`.`cbIn_payAmount` AS `cbIn_payAmount`, `cbin`.`cbIn_payDetail` AS `cbIn_payDetail` FROM (`cashboxin` `cbin` join `completedorder` `co` on(`cbin`.`cbIn_ticketNo` = `co`.`co_ticketNo`)) ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `view_checkoutactions`
--
DROP TABLE IF EXISTS `view_checkoutactions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_checkoutactions`  AS SELECT `co`.`co_ticketNo` AS `co_ticketNo`, `c`.`cu_id` AS `cu_id`, `co`.`co_nameSurname` AS `co_nameSurname`, `c`.`cu_mobile` AS `cu_mobile`, `c`.`cu_email` AS `cu_email`, `co`.`co_amountPaid` AS `co_amountPaid`, `co`.`paymentStatus` AS `paymentStatus`, `co`.`co_date` AS `co_date` FROM (`completedorder` `co` join `customer` `c` on(`c`.`cu_id` = `co`.`c_id`)) WHERE `co`.`paymentStatus` = 1 ORDER BY `c`.`cu_id` ASC ;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `boxoforder`
--
ALTER TABLE `boxoforder`
  ADD PRIMARY KEY (`bod_id`);

--
-- Tablo için indeksler `boxorder`
--
ALTER TABLE `boxorder`
  ADD PRIMARY KEY (`bo_id`);

--
-- Tablo için indeksler `boxorder_cu_pro`
--
ALTER TABLE `boxorder_cu_pro`
  ADD PRIMARY KEY (`bo_id`);

--
-- Tablo için indeksler `cashboxin`
--
ALTER TABLE `cashboxin`
  ADD PRIMARY KEY (`cbIn_id`);

--
-- Tablo için indeksler `cashboxout`
--
ALTER TABLE `cashboxout`
  ADD PRIMARY KEY (`cbOut_id`);

--
-- Tablo için indeksler `completedorder`
--
ALTER TABLE `completedorder`
  ADD PRIMARY KEY (`co_id`);

--
-- Tablo için indeksler `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`cu_id`);

--
-- Tablo için indeksler `customer_boxorder`
--
ALTER TABLE `customer_boxorder`
  ADD UNIQUE KEY `UK_kk3ui15huu49o9iai366u2nhg` (`boxOrder_bo_id`),
  ADD UNIQUE KEY `UK_te7fip1kgawx999c762rf7kcn` (`boxOrder_bo_id`),
  ADD UNIQUE KEY `UK_tqadfy8jal7iuawjj9p8obk03` (`boxOrder_bo_id`),
  ADD KEY `FKbm6sr5tq04xxh44fp11sejjxd` (`Customer_cu_id`);

--
-- Tablo için indeksler `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`p_id`);

--
-- Tablo için indeksler `reportcoa`
--
ALTER TABLE `reportcoa`
  ADD PRIMARY KEY (`cu_id`);

--
-- Tablo için indeksler `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`us_id`),
  ADD UNIQUE KEY `UK_1ev325ejv65ugb2bp0or0y57k` (`us_email`),
  ADD UNIQUE KEY `UK_1xaoc5okbkain09uerrf3inpo` (`us_email`);

--
-- Tablo için indeksler `view_boxorder_cupro`
--
ALTER TABLE `view_boxorder_cupro`
  ADD PRIMARY KEY (`bo_id`);

--
-- Tablo için indeksler `view_cashboxincompletedorder`
--
ALTER TABLE `view_cashboxincompletedorder`
  ADD PRIMARY KEY (`cbIn_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `boxoforder`
--
ALTER TABLE `boxoforder`
  MODIFY `bod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- Tablo için AUTO_INCREMENT değeri `boxorder`
--
ALTER TABLE `boxorder`
  MODIFY `bo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- Tablo için AUTO_INCREMENT değeri `cashboxin`
--
ALTER TABLE `cashboxin`
  MODIFY `cbIn_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- Tablo için AUTO_INCREMENT değeri `cashboxout`
--
ALTER TABLE `cashboxout`
  MODIFY `cbOut_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `completedorder`
--
ALTER TABLE `completedorder`
  MODIFY `co_id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Tablo için AUTO_INCREMENT değeri `customer`
--
ALTER TABLE `customer`
  MODIFY `cu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Tablo için AUTO_INCREMENT değeri `product`
--
ALTER TABLE `product`
  MODIFY `p_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `user`
--
ALTER TABLE `user`
  MODIFY `us_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `customer_boxorder`
--
ALTER TABLE `customer_boxorder`
  ADD CONSTRAINT `FK7aie885ancyvmmw9y1fq29309` FOREIGN KEY (`boxOrder_bo_id`) REFERENCES `boxorder` (`bo_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKbm6sr5tq04xxh44fp11sejjxd` FOREIGN KEY (`Customer_cu_id`) REFERENCES `customer` (`cu_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKdif9bwob8ynk0kev940sf4pdr` FOREIGN KEY (`Customer_cu_id`) REFERENCES `customer` (`cu_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKmwdaaiyvs1nlstxoxhwdd044r` FOREIGN KEY (`Customer_cu_id`) REFERENCES `customer` (`cu_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKor3ndg8sdnwt6nnhgjn76h3cv` FOREIGN KEY (`boxOrder_bo_id`) REFERENCES `boxorder` (`bo_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FKqnrwc78y3or0i759uai7h4o71` FOREIGN KEY (`boxOrder_bo_id`) REFERENCES `boxorder` (`bo_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
