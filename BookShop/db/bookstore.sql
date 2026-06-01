-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bookstore
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `author_id` int NOT NULL AUTO_INCREMENT,
  `author_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `bio` text COLLATE utf8mb4_general_ci,
  `image` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = đang hoạt động, 1 = đã ẩn/xóa mềm',
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Nguyễn Nhật Ánh',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020710/authors/sojpx8piaixo5wjhvtys.jpg',0),(2,'Robert Kiyosaki',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020731/authors/zm514gy5vas2do0mdjbn.jpg',0),(3,'Dale Carnegie',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020855/authors/lorw8ilp4fkafuwd69or.avif',0),(4,'Napoleon Hill',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020835/authors/hg7ygezudkwplegsdwap.jpg',0),(5,'Yuval Noah Harari',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021545/authors/zzey3qy9bjywnjnmlfkj.jpg',0),(6,'Paulo Coelho',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021496/authors/avueqwacnxjnrorh0hlq.jpg',0),(7,'George Orwell',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021409/authors/alyhpizt0d03nux6ixnh.jpg',0),(8,'J.K. Rowling',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021424/authors/smdmx23zu7qn61l3zwym.webp',0),(9,'Tô Hoài',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021089/authors/xvrkm3tsflj9hsipjx64.jpg',0),(10,'Nam Cao',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020965/authors/quzwtiyg31nbke4hbqlu.jpg',0),(12,'Richard Dawkins',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021249/authors/puhtsjvyoiquwhgn2s24.avif',0),(67,'Stephen Hawking',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021289/authors/og2fqfbmandsbq2bnssu.png',0);
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_images`
--

DROP TABLE IF EXISTS `book_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `idx_book_images_book_id` (`book_id`),
  CONSTRAINT `fk_book_images_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_images`
--

LOCK TABLES `book_images` WRITE;
/*!40000 ALTER TABLE `book_images` DISABLE KEYS */;
INSERT INTO `book_images` VALUES (1,19,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776490051/books/etkc3sehja4vzyo3hznt.jpg'),(2,19,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776490053/books/jlhmrez5vsw1fjxtyetz.jpg'),(3,19,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776490054/books/tqbafnffhnj2bzf6pf6w.jpg'),(4,19,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776490056/books/nrckowqxqj9idfjqqgh7.jpg');
/*!40000 ALTER TABLE `book_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `author_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `image` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `publish_year` int DEFAULT NULL,
  `isbn` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `language` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cover_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sold_quantity` int DEFAULT '0',
  `slug` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `origin_price` decimal(10,2) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = đang bán, 1 = đã ẩn/xóa mềm',
  PRIMARY KEY (`book_id`),
  KEY `idx_books_author_id` (`author_id`),
  KEY `idx_books_category_id` (`category_id`),
  CONSTRAINT `fk_books_author` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`),
  CONSTRAINT `fk_books_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Cho tôi xin một vé đi tuổi thơ',1,1,50000.00,10,'Cuốn sách kể về tuổi thơ hồn nhiên qua góc nhìn của nhân vật Mùi. Những câu chuyện giản dị nhưng sâu sắc giúp người đọc nhớ lại thời thơ ấu đầy mơ mộng, đồng thời gửi gắm nhiều suy ngẫm về cách người lớn nhìn nhận thế giới của trẻ con. Đây là một trong những tác phẩm nổi bật và được yêu thích nhất của Nguyễn Nhật Ánh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774688881/books/qmxq98fwcklxzm5akk1u.jpg',2008,'978-604-1-08532-1','NXB Trẻ','Tiếng Việt','Bìa mềm',0,'cho-toi-xin-mot-ve-di-tuoi-tho',70000.00,0),(2,'Rich Dad Poor Dad',2,3,120000.00,5,'Rich Dad Poor Dad của Robert Kiyosaki là cuốn sách nổi tiếng về tài chính cá nhân, kể lại những bài học mà tác giả học được từ hai người cha với hai tư duy hoàn toàn khác nhau về tiền bạc. Thông qua những câu chuyện thực tế, cuốn sách giúp người đọc hiểu rõ sự khác biệt giữa người làm việc vì tiền và người biết cách để tiền làm việc cho mình.\r\n\r\nCuốn sách tập trung vào việc thay đổi tư duy tài chính, giải thích các khái niệm như tài sản, tiêu sản và dòng tiền một cách đơn giản, dễ hiểu. Không chỉ cung cấp kiến thức, Rich Dad Poor Dad còn truyền cảm hứng mạnh mẽ, khuyến khích người đọc chủ động học hỏi, đầu tư và hướng đến mục tiêu tự do tài chính trong tương lai.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690124/books/gppx81otw3z0d2h0t3n4.webp',1997,'978-604-77-3329-0','NXB Tổng Hợp TP.HCM','Tiếng Việt','Bìa mềm',0,'rich-dad-poor-dad',160000.00,0),(3,'Mắt Biếc',1,1,85000.00,20,'Mắt Biếc là một trong những tác phẩm nổi bật của Nguyễn Nhật Ánh, kể về câu chuyện tình yêu đơn phương đầy day dứt của Ngạn dành cho Hà Lan – cô gái có đôi mắt xanh biếc khiến bao người say đắm. Bối cảnh làng quê yên bình cùng những ký ức tuổi thơ trong sáng tạo nên một câu chuyện nhẹ nhàng nhưng sâu lắng.\r\n\r\nKhông chỉ là câu chuyện tình yêu, cuốn sách còn gợi lên nhiều cảm xúc về tuổi trẻ, sự trưởng thành và những tiếc nuối trong cuộc sống. Với lối viết giản dị nhưng giàu cảm xúc, Mắt Biếc đã chạm đến trái tim của nhiều thế hệ độc giả và trở thành một trong những tác phẩm được yêu thích nhất.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774688866/books/pyfswrt848psaboo6ilf.jpg',1990,'978-604-1-08531-4','NXB Trẻ','Tiếng Việt','Bìa mềm',0,'mat-biec',110000.00,0),(4,'Tôi Thấy Hoa Vàng Trên Cỏ Xanh',1,1,90000.00,15,'Tôi Thấy Hoa Vàng Trên Cỏ Xanh là một tác phẩm nổi tiếng của Nguyễn Nhật Ánh, kể về tuổi thơ của hai anh em Thiều và Tường tại một làng quê yên bình. Những câu chuyện xoay quanh cuộc sống thường ngày, tình bạn, tình anh em và những rung động đầu đời được khắc họa một cách chân thật, giản dị nhưng đầy cảm xúc.\r\n\r\nCuốn sách không chỉ gợi lại ký ức tuổi thơ trong sáng mà còn gửi gắm nhiều thông điệp sâu sắc về tình người, sự trưởng thành và những bài học trong cuộc sống. Với giọng văn nhẹ nhàng, gần gũi, tác phẩm đã chạm đến trái tim của đông đảo độc giả và trở thành một trong những cuốn sách được yêu thích nhất của Nguyễn Nhật Ánh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690308/books/v8zgjdvqjfoq2dim2avo.jpg',2010,'978-604-1-08533-8','NXB Trẻ','Tiếng Việt','Bìa mềm',0,'toi-thay-hoa-vang-tren-co-xanh',90000.00,0),(5,'Kính Vạn Hoa',1,1,75000.00,18,'Kính Vạn Hoa là bộ truyện dài nổi tiếng của Nguyễn Nhật Ánh, xoay quanh cuộc sống học đường và những câu chuyện thú vị của nhóm bạn Quý ròm, Tiểu Long và Hạnh. Mỗi tập truyện là một câu chuyện riêng biệt, đầy hài hước và gần gũi với lứa tuổi học sinh.\r\n\r\nBộ truyện không chỉ mang tính giải trí mà còn truyền tải nhiều bài học ý nghĩa về tình bạn, gia đình và cuộc sống. Với lối viết dí dỏm, sinh động, Kính Vạn Hoa đã trở thành một phần ký ức tuổi thơ của nhiều thế hệ độc giả Việt Nam.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690173/books/p2mb5frhbu2pxsjwfdaf.jpg',1995,'978-604-1-08534-5','NXB Trẻ','Tiếng Việt','Bìa mềm',0,'kinh-van-hoa',75000.00,0),(6,'Đắc Nhân Tâm',3,4,95000.00,30,'Đắc Nhân Tâm là một trong những cuốn sách nổi tiếng nhất của Dale Carnegie, tập trung vào nghệ thuật giao tiếp và cách ứng xử trong cuộc sống. Thông qua những nguyên tắc đơn giản nhưng hiệu quả, cuốn sách giúp người đọc hiểu cách tạo thiện cảm, xây dựng mối quan hệ và gây ảnh hưởng tích cực đến người khác.\r\n\r\nKhông chỉ dừng lại ở lý thuyết, cuốn sách còn đưa ra nhiều ví dụ thực tế, giúp người đọc dễ dàng áp dụng vào công việc và cuộc sống hàng ngày. Với giá trị vượt thời gian, Đắc Nhân Tâm đã trở thành một trong những cuốn sách kỹ năng sống bán chạy nhất thế giới và là lựa chọn hàng đầu cho những ai muốn phát triển bản thân.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690190/books/yhwinkgexnff31gfsltj.webp',1936,'978-604-77-1540-1','NXB Tổng Hợp TP.HCM','Tiếng Việt','Bìa mềm',0,'dac-nhan-tam',120000.00,0),(7,'Nghĩ Giàu Làm Giàu',4,3,110000.00,12,'Nghĩ Giàu Làm Giàu là một trong những cuốn sách kinh điển về phát triển bản thân và tư duy thành công. Tác giả đã nghiên cứu những người giàu có và thành công để rút ra các nguyên tắc giúp đạt được mục tiêu trong cuộc sống.\r\n\r\nCuốn sách nhấn mạnh sức mạnh của suy nghĩ, niềm tin và sự kiên trì trong việc đạt được thành công. Đây là tài liệu quan trọng cho những ai muốn thay đổi tư duy và phát triển bản thân cả về tài chính lẫn cuộc sống.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690214/books/nyr8hk2zletovgvptkbs.jpg',1937,'978-604-77-2345-1','NXB Tổng Hợp TP.HCM','Tiếng Việt','Bìa mềm',0,'nghi-giau-lam-giau',110000.00,0),(8,'Sapiens: Lược Sử Loài Người',5,5,150000.00,8,'Sapiens: Lược Sử Loài Người là tác phẩm nổi tiếng của Yuval Noah Harari, đưa người đọc đi qua hành trình phát triển của loài người từ thời kỳ nguyên thủy đến xã hội hiện đại. Cuốn sách phân tích các bước ngoặt quan trọng như cách mạng nhận thức, cách mạng nông nghiệp và cách mạng khoa học, từ đó lý giải vì sao con người trở thành loài thống trị Trái Đất.\r\n\r\nVới lối viết cuốn hút và dễ hiểu, cuốn sách không chỉ cung cấp kiến thức lịch sử mà còn đặt ra nhiều câu hỏi sâu sắc về xã hội, văn hóa và tương lai của nhân loại. Đây là một trong những cuốn sách khoa học – lịch sử được đánh giá cao và phù hợp với mọi đối tượng độc giả muốn mở rộng hiểu biết.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690231/books/sdkj3ktiuwsqcfnq8g4v.jpg',2011,'978-604-77-3400-6','NXB Tri Thức','Tiếng Việt','Bìa mềm',0,'sapiens-luoc-su-loai-nguoi',140000.00,0),(9,'Nhà Giả Kim',6,7,88000.00,25,'Nhà Giả Kim kể về hành trình của Santiago – một chàng chăn cừu trẻ tuổi đi tìm kho báu theo giấc mơ của mình. Trên con đường đó, cậu gặp nhiều người và trải qua nhiều thử thách, từ đó học được những bài học quý giá về cuộc sống.\r\n\r\nCuốn sách mang thông điệp sâu sắc về việc theo đuổi ước mơ, lắng nghe trái tim và tin vào hành trình của bản thân. Với lối viết đơn giản nhưng đầy triết lý, tác phẩm đã truyền cảm hứng cho hàng triệu độc giả trên thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690258/books/klnlgnrmefvemrco392g.jpg',1988,'978-604-2-00351-2','NXB Hội Nhà Văn','Tiếng Việt','Bìa mềm',0,'nha-gia-kim',110000.00,0),(10,'1984',7,7,92000.00,14,'1984 là một tiểu thuyết kinh điển của George Orwell, mô tả một xã hội toàn trị nơi mọi hành động và suy nghĩ của con người đều bị kiểm soát. Nhân vật chính Winston Smith sống trong một thế giới bị giám sát chặt chẽ, nơi sự thật bị bóp méo và tự do cá nhân gần như không tồn tại.\r\n\r\nCuốn sách không chỉ là một câu chuyện giả tưởng mà còn là lời cảnh báo sâu sắc về quyền lực, sự kiểm soát và mất tự do. Với giá trị vượt thời gian, 1984 vẫn luôn là một trong những tác phẩm được đánh giá cao trong văn học thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690322/books/wtkpvjstd3q5ughdjuqe.jpg',1949,'978-604-2-01984-0','NXB Hội Nhà Văn','Tiếng Việt','Bìa mềm',0,'1984',92000.00,0),(11,'Trại Súc Vật',7,7,79000.00,16,'Trại Súc Vật là một tác phẩm nổi tiếng của George Orwell, sử dụng hình ảnh các loài vật để ẩn dụ cho xã hội loài người. Câu chuyện xoay quanh cuộc nổi dậy của các con vật chống lại con người để xây dựng một xã hội bình đẳng, nhưng dần dần lại bị biến chất bởi quyền lực.\r\n\r\nThông qua lối kể chuyện đơn giản nhưng sâu sắc, cuốn sách phản ánh những vấn đề về chính trị, quyền lực và sự tha hóa. Đây là một tác phẩm mang tính cảnh tỉnh, giúp người đọc hiểu rõ hơn về bản chất của xã hội và con người.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690337/books/gdgpjcbeglt7kza7u7fd.jpg',1945,'978-604-2-01945-1','NXB Hội Nhà Văn','Tiếng Việt','Bìa mềm',0,'trai-suc-vat',79000.00,0),(12,'Harry Potter và Hòn Đá Phù Thủy',8,7,120000.00,20,'Harry Potter và Hòn Đá Phù Thủy là phần đầu tiên trong loạt truyện nổi tiếng về cậu bé phù thủy Harry Potter. Câu chuyện bắt đầu khi Harry phát hiện mình là một phù thủy và được mời nhập học tại trường Hogwarts – nơi đào tạo phép thuật. Tại đây, cậu kết bạn với Ron và Hermione, đồng thời khám phá thế giới kỳ diệu đầy bí ẩn.\r\n\r\nKhông chỉ là một câu chuyện phiêu lưu hấp dẫn, cuốn sách còn truyền tải những thông điệp sâu sắc về tình bạn, lòng dũng cảm và sự lựa chọn giữa cái thiện và cái ác. Với cốt truyện lôi cuốn và thế giới phép thuật độc đáo, tác phẩm đã trở thành một trong những cuốn sách được yêu thích nhất trên toàn thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690377/books/zterccekdlgkqw3jy6em.jpg',1997,'978-604-1-12345-7','NXB Trẻ','Tiếng Việt','Bìa mềm',0,'harry-potter-va-hon-da-phu-thuy',120000.00,0),(13,'Dế Mèn Phiêu Lưu Ký',9,8,65000.00,22,'Dế Mèn Phiêu Lưu Ký là tác phẩm nổi tiếng của Tô Hoài, kể về hành trình trưởng thành của chú Dế Mèn – một chàng dế trẻ tuổi, bồng bột nhưng dũng cảm. Từ những sai lầm ban đầu, Dế Mèn bắt đầu chuyến phiêu lưu qua nhiều vùng đất, gặp gỡ nhiều người bạn và trải qua vô số thử thách.\r\n\r\nThông qua câu chuyện giàu tính nhân văn, cuốn sách truyền tải những bài học sâu sắc về tình bạn, lòng dũng cảm và trách nhiệm với hành động của bản thân. Với lối kể chuyện sinh động, gần gũi, tác phẩm không chỉ dành cho thiếu nhi mà còn chạm đến trái tim của nhiều thế hệ độc giả.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690396/books/oukx48srxtgj38f1c8mk.jpg',1941,'978-604-09-2345-6','NXB Kim Đồng','Tiếng Việt','Bìa mềm',0,'de-men-phieu-luu-ky',65000.00,0),(14,'Chí Phèo',10,8,55000.00,18,'Chí Phèo là tác phẩm tiêu biểu của Nam Cao, phản ánh số phận bi kịch của người nông dân trong xã hội cũ. Nhân vật Chí Phèo từ một người lương thiện bị đẩy vào con đường tha hóa, trở thành kẻ bị xã hội ruồng bỏ.\r\n\r\nTác phẩm không chỉ tố cáo xã hội bất công mà còn thể hiện khát vọng được làm người lương thiện của những con người bị áp bức. Với giá trị hiện thực và nhân đạo sâu sắc, đây là một trong những tác phẩm kinh điển của văn học Việt Nam.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690424/books/plb17scugkwtsztgmmuo.jpg',1941,'978-604-1-09876-5','NXB Văn Học','Tiếng Việt','Bìa mềm',0,'chi-pheo',55000.00,0),(15,'Cha Giàu Cha Nghèo',2,3,120000.00,15,'Cuốn sách kể về những bài học tài chính từ hai người cha với tư duy hoàn toàn khác nhau về tiền bạc. Qua đó, người đọc hiểu được sự khác biệt giữa việc làm việc vì tiền và để tiền làm việc cho mình.\r\n\r\nVới cách viết dễ hiểu, sách giúp người đọc nắm được các khái niệm cơ bản như tài sản, tiêu sản và đầu tư, đồng thời truyền cảm hứng để đạt được tự do tài chính.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690463/books/nequcyqz16rrzk2z3irw.jpg',1997,'978-604-77-3330-6','NXB Tổng Hợp TP.HCM','Tiếng Việt','Bìa mềm',0,'cha-giau-cha-ngheo',120000.00,0),(16,'Homo Deus',5,5,160000.00,7,'Homo Deus là phần tiếp theo của Sapiens, tập trung vào tương lai của loài người trong bối cảnh công nghệ phát triển mạnh mẽ. Cuốn sách đặt ra những câu hỏi lớn về việc con người sẽ đi về đâu khi trí tuệ nhân tạo và công nghệ sinh học ngày càng chi phối cuộc sống.\r\n\r\nVới góc nhìn sâu sắc, tác giả phân tích những khả năng như con người trở nên “bất tử”, nâng cấp trí tuệ hay mất đi vai trò trước máy móc. Đây là cuốn sách giúp người đọc suy ngẫm về tương lai và vị trí của con người trong thế giới hiện đại.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690480/books/lxyrngukbvyhwnsx8tea.jpg',2015,'978-604-77-4521-7','NXB Tri Thức','Tiếng Việt','Bìa mềm',0,'homo-deus',200000.00,0),(17,'Quẳng Gánh Lo Đi Mà Vui Sống',3,4,85000.00,20,'Cuốn sách giúp người đọc nhận ra nguyên nhân của lo âu và cách kiểm soát suy nghĩ tiêu cực trong cuộc sống. Thông qua những nguyên tắc đơn giản và ví dụ thực tế, tác giả hướng dẫn cách sống tích cực và giảm căng thẳng.\r\n\r\nKhông chỉ mang tính lý thuyết, sách còn cung cấp nhiều phương pháp thực hành giúp người đọc thay đổi thói quen suy nghĩ, từ đó sống vui vẻ và hiệu quả hơn mỗi ngày.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690505/books/j5elbps5ckx7d1fgfrfn.jpg',1948,'978-604-77-1541-8','NXB Tổng Hợp TP.HCM','Tiếng Việt','Bìa mềm',0,'quang-ganh-lo-di-ma-vui-song',85000.00,0),(18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',67,6,120000.00,50,'Vũ Trụ Trong Vỏ Hạt Dẻ là một trong những tác phẩm khoa học nổi bật của Stephen Hawking, giúp người đọc tiếp cận những khái niệm phức tạp về vũ trụ theo cách đơn giản và dễ hiểu. Cuốn sách trình bày các lý thuyết hiện đại về không gian, thời gian, lỗ đen và nguồn gốc của vũ trụ, dựa trên những nghiên cứu tiên tiến trong vật lý.\r\n\r\nVới cách viết sinh động, kết hợp giữa khoa học và hình ảnh minh họa, cuốn sách không chỉ mang tính học thuật mà còn rất cuốn hút với người đọc phổ thông. Đây là lựa chọn tuyệt vời cho những ai yêu thích khám phá vũ trụ và muốn hiểu thêm về những bí ẩn của thế giới xung quanh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690525/books/zddbnfepxxm2mkyugmsc.jpg',2001,'978-604-77-3654-3','NXB Trẻ','Tiếng Việt','Bìa cứng',0,'vu-tru-trong-vo-hat-de',120000.00,0),(19,'Gen Vị Kỷ',12,1,200000.00,20,'Gen Vị Kỷ là một trong những cuốn sách khoa học nổi bật về sinh học tiến hóa, trong đó Richard Dawkins đưa ra góc nhìn mới về cách sự sống phát triển. Thay vì xem sinh vật là trung tâm, tác giả cho rằng gen mới chính là yếu tố quyết định, và mọi hành vi của sinh vật đều nhằm mục đích duy trì và truyền lại gen.\r\n\r\nCuốn sách giải thích các khái niệm phức tạp bằng ngôn ngữ dễ hiểu, giúp người đọc tiếp cận khoa học một cách thú vị. Đây là tác phẩm có ảnh hưởng lớn, không chỉ trong lĩnh vực sinh học mà còn thay đổi cách con người nhìn nhận về sự sống và tiến hóa.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690545/books/aotdrurybootuy7rc2na.webp',1976,'978-604-77-3721-2','NXB Tri Thức','Tiếng Việt','Bìa mềm',0,'gen-vi-ky',250000.00,0);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = đang hoạt động, 1 = đã ẩn/xóa mềm',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Tiểu thuyết',0),(2,'Công nghệ',0),(3,'Kinh tế',0),(4,'Tâm lý - Kỹ năng sống',0),(5,'Lịch sử',0),(6,'Khoa học',0),(7,'Văn học nước ngoài',0),(8,'Văn học Việt Nam',0);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `book_title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  `line_total` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,1,19,'Gen Vị Kỷ',1,200000,200000),(2,1,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',4,120000,480000),(3,1,17,'Quẳng Gánh Lo Đi Mà Vui Sống',1,85000,85000),(4,2,19,'Gen Vị Kỷ',1,200000,200000),(5,2,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',5,120000,600000),(6,2,17,'Quẳng Gánh Lo Đi Mà Vui Sống',1,85000,85000),(7,3,19,'Gen Vị Kỷ',3,200000,600000),(8,3,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',3,120000,360000),(9,3,17,'Quẳng Gánh Lo Đi Mà Vui Sống',2,85000,170000),(10,3,2,'Rich Dad Poor Dad',2,120000,240000),(11,3,3,'Mắt Biếc',2,85000,170000),(12,4,19,'Gen Vị Kỷ',3,200000,600000),(13,4,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',3,120000,360000),(14,5,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',5,120000,600000),(15,5,17,'Quẳng Gánh Lo Đi Mà Vui Sống',4,85000,340000),(16,6,19,'Gen Vị Kỷ',3,200000,600000),(17,6,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',2,120000,240000),(18,6,17,'Quẳng Gánh Lo Đi Mà Vui Sống',3,85000,255000),(19,6,16,'Homo Deus',2,160000,320000),(20,7,19,'Gen Vị Kỷ',1,200000,200000),(21,7,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',5,120000,600000),(22,7,17,'Quẳng Gánh Lo Đi Mà Vui Sống',2,85000,170000),(23,8,16,'Homo Deus',1,160000,160000),(24,8,15,'Cha Giàu Cha Nghèo',1,120000,120000),(25,8,14,'Chí Phèo',2,55000,110000),(26,8,17,'Quẳng Gánh Lo Đi Mà Vui Sống',2,85000,170000),(27,8,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',2,120000,240000),(28,9,17,'Quẳng Gánh Lo Đi Mà Vui Sống',1,85000,85000),(29,9,16,'Homo Deus',1,160000,160000),(30,10,19,'Gen Vị Kỷ',1,200000,200000),(31,10,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',1,120000,120000),(32,10,17,'Quẳng Gánh Lo Đi Mà Vui Sống',1,85000,85000),(33,10,16,'Homo Deus',1,160000,160000),(34,10,15,'Cha Giàu Cha Nghèo',1,120000,120000),(35,11,19,'Gen Vị Kỷ',1,200000,200000),(36,11,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',1,120000,120000),(37,11,17,'Quẳng Gánh Lo Đi Mà Vui Sống',1,85000,85000),(38,12,18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',2,120000,240000),(39,12,17,'Quẳng Gánh Lo Đi Mà Vui Sống',4,85000,340000),(40,12,19,'Gen Vị Kỷ',1,200000,200000),(41,12,15,'Cha Giàu Cha Nghèo',1,120000,120000),(42,12,14,'Chí Phèo',1,55000,55000);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `order_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address_line` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ward` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `district` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `province` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_general_ci,
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subtotal` double DEFAULT NULL,
  `shipping_fee` double DEFAULT NULL,
  `discount_amount` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_user` (`user_id`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,NULL,'ORD-AABA0FF0','Nhi','nhituyet20102005@gmail.com','0386032441','902','','','','','BANK_TRANSFER','PENDING',765000,0,0,765000,'2026-04-02 06:40:09'),(2,NULL,'ORD-3AD97713','Nhi','phamtrantuananh.18082003@gmail.com','0386032441','902 khu phố 1','90736','3695','202','','BANK_TRANSFER','PENDING',885000,0,0,885000,'2026-04-02 07:22:22'),(3,NULL,'ORD-79EA3016','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','902 khu phố 1','90736','3695','202','','COD','PENDING',1540000,0,0,1540000,'2026-04-02 07:24:13'),(4,NULL,'ORD-97D82A2C','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','902 khu phố 1',NULL,NULL,NULL,'','COD','PENDING',960000,21001,0,981001,'2026-04-02 07:51:21'),(5,NULL,'ORD-FC468684','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','36',NULL,NULL,NULL,'','COD','PENDING',940000,78997,0,1018997,'2026-04-02 07:58:26'),(6,NULL,'ORD-2D39429C','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','34','Xã Tống Phan','Huyện Phù Cừ','Hưng Yên','','COD','PENDING',1415000,91071,0,1506071,'2026-04-02 08:22:49'),(7,NULL,'ORD-B62531B6','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','23','Xã Biển Bạch Đông','Huyện Thới Bình','Cà Mau','','COD','PENDING',970000,51502,0,1021502,'2026-04-02 13:57:55'),(8,NULL,'ORD-87BC00FC','Nhi Phạm Tuyết','23130223@st.hcmuaf.edu.vn','0386032441','95 tân lập','Xã Viên An','Huyện Ngọc Hiển','Cà Mau','','COD','PENDING',800000,46503,0,846503,'2026-04-02 14:14:18'),(9,NULL,'ORD-875171DA','Tuấn any phạm','phamtrantuananh.18082003@gmail.com','0386032441','902','Xã Công Sơn','Huyện Cao Lộc','Lạng Sơn','','COD','PENDING',245000,34000,0,279000,'2026-04-02 14:49:18'),(10,NULL,'ORD-49FAD73E','user123','user123@gmail.com','0386032441','36','Xã Tống Phan','Huyện Phù Cừ','Hưng Yên','','COD','PENDING',685000,58999,0,743999,'2026-04-12 15:34:25'),(11,3,'ORD-128EDACC','nhi','nhi@gmail.com','0386032441','100','Thị trấn Điện Biên Đông','Huyện Điện Biên Đông','Điện Biên','','COD','PENDING',405000,49000,0,454000,'2026-05-29 16:14:07'),(12,3,'ORD-04805102','nhi','nhi@gmail.com','0386032441','45','Xã Cán Cấu','Huyện Si Ma Cai','Lào Cai','','COD','PENDING',955000,78997,0,1033997,'2026-05-31 04:55:33');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `method` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_images`
--

DROP TABLE IF EXISTS `review_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `idx_review_images_review_id` (`review_id`),
  CONSTRAINT `fk_review_images_review` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_images`
--

LOCK TABLES `review_images` WRITE;
/*!40000 ALTER TABLE `review_images` DISABLE KEYS */;
INSERT INTO `review_images` VALUES (1,2,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776606948/reviews/vwhpvvjhuwwva0f2sumy.jpg'),(2,2,'http://res.cloudinary.com/dqiefayjh/image/upload/v1776606950/reviews/x3899azbhzormkrsiutr.jpg');
/*!40000 ALTER TABLE `review_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int DEFAULT '5',
  `comment` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `idx_reviews_book_id` (`book_id`),
  KEY `idx_reviews_user_id` (`user_id`),
  CONSTRAINT `fk_reviews_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=691 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (2,19,1,4,'nhận dduocj hàng cũng nhanh, sách ok như hình','2026-04-19 06:55:50'),(646,1,1,5,'Sách rất hay, đọc rất cuốn!','2026-05-31 12:09:45'),(647,1,1,4,'Nội dung tốt, giao hàng nhanh.','2026-05-31 12:09:45'),(648,1,1,3,'Bình thường, không có gì đặc biệt.','2026-05-31 12:09:45'),(649,1,1,5,'Tuyệt vời, sẽ mua lại!','2026-05-31 12:09:45'),(650,1,1,2,'Hơi thất vọng.','2026-05-31 12:09:45'),(651,1,1,5,'Cuốn sách gợi lại bao ký ức tuổi thơ, đọc xong thấy ấm lòng lắm!','2026-05-31 12:12:34'),(652,1,1,4,'Văn phong nhẹ nhàng, dễ đọc. Rất phù hợp để thư giãn.','2026-05-31 12:12:34'),(653,1,1,3,'Bình thường, không có gì đặc biệt so với các tác phẩm khác của tác giả.','2026-05-31 12:12:34'),(654,1,1,5,'Tuyệt vời! Mình đọc một mạch không nghỉ.','2026-05-31 12:12:34'),(655,1,1,2,'Hơi thất vọng, mình kỳ vọng nhiều hơn.','2026-05-31 12:12:34'),(656,1,1,4,'Sách in đẹp, chất lượng giấy tốt, nội dung hay.','2026-05-31 12:12:34'),(657,1,1,5,'Món quà tuyệt vời cho các bé nhỏ trong nhà!','2026-05-31 12:12:34'),(658,2,1,5,'Thay đổi hoàn toàn tư duy tài chính của mình sau khi đọc xong!','2026-05-31 12:12:34'),(659,2,1,4,'Kiến thức rất thực tế, dễ áp dụng vào cuộc sống.','2026-05-31 12:12:34'),(660,2,1,3,'Đọc rồi nhưng khó áp dụng ở Việt Nam lắm.','2026-05-31 12:12:34'),(661,2,1,5,'Cuốn sách gối đầu giường của mình, đọc đi đọc lại nhiều lần.','2026-05-31 12:12:34'),(662,2,1,4,'Rất hay cho người mới bắt đầu tìm hiểu về tài chính.','2026-05-31 12:12:34'),(663,2,1,1,'Nội dung lặp đi lặp lại, không có gì mới.','2026-05-31 12:12:34'),(664,3,1,5,'Đọc xong khóc cả buổi, câu chuyện tình yêu quá đẹp và buồn.','2026-05-31 12:12:34'),(665,3,1,5,'Tác phẩm hay nhất của Nguyễn Nhật Ánh theo mình.','2026-05-31 12:12:34'),(666,3,1,4,'Cảm xúc dâng trào, lối viết tinh tế và chân thật.','2026-05-31 12:12:34'),(667,3,1,3,'Hơi dài ở đoạn giữa nhưng kết thúc rất hay.','2026-05-31 12:12:34'),(668,3,1,5,'Đã xem phim rồi nhưng đọc sách vẫn hay hơn nhiều!','2026-05-31 12:12:34'),(669,3,1,4,'Nhân vật Hà Lan để lại ấn tượng rất sâu trong lòng mình.','2026-05-31 12:12:34'),(670,6,1,5,'Cuốn sách kinh điển mọi người nên đọc ít nhất một lần trong đời.','2026-05-31 12:12:34'),(671,6,1,4,'Nhiều bài học quý giá về cách ứng xử và giao tiếp.','2026-05-31 12:12:34'),(672,6,1,5,'Áp dụng vào công việc thấy hiệu quả rõ rệt!','2026-05-31 12:12:34'),(673,6,1,3,'Một số nguyên tắc hơi cũ, không còn phù hợp lắm với thời hiện đại.','2026-05-31 12:12:34'),(674,6,1,4,'Đọc lần 2 vẫn rút ra được nhiều điều mới.','2026-05-31 12:12:34'),(675,6,1,5,'Sách giao hàng nhanh, đóng gói cẩn thận, nội dung tuyệt vời!','2026-05-31 12:12:34'),(676,8,1,5,'Cuốn sách mở mang tầm nhìn về lịch sử loài người, đọc không thể dừng lại.','2026-05-31 12:12:34'),(677,8,1,5,'Harari viết rất cuốn hút dù đề tài khá nặng.','2026-05-31 12:12:34'),(678,8,1,4,'Cần đọc chậm để thấm, nhưng rất xứng đáng bỏ thời gian.','2026-05-31 12:12:34'),(679,8,1,3,'Hay nhưng hơi khô khan ở một số chương.','2026-05-31 12:12:34'),(680,8,1,4,'Thay đổi cách mình nhìn nhận xã hội và con người.','2026-05-31 12:12:34'),(681,9,1,5,'Triết lý sâu sắc, mỗi lần đọc lại thấy một điều mới.','2026-05-31 12:12:34'),(682,9,1,5,'Cuốn sách truyền cảm hứng nhất mình từng đọc!','2026-05-31 12:12:34'),(683,9,1,4,'Ngắn nhưng đầy ý nghĩa, rất phù hợp để tặng bạn bè.','2026-05-31 12:12:34'),(684,9,1,3,'Hành trình hơi đơn giản, nhưng thông điệp đẹp.','2026-05-31 12:12:34'),(685,9,1,5,'Câu chuyện về ước mơ và hành trình theo đuổi nó rất chạm lòng.','2026-05-31 12:12:34'),(686,12,1,5,'Tuổi thơ của cả một thế hệ! Đọc lại vẫn thấy hay như lần đầu.','2026-05-31 12:12:34'),(687,12,1,5,'Thế giới phép thuật được xây dựng cực kỳ chi tiết và hấp dẫn.','2026-05-31 12:12:34'),(688,12,1,4,'Bản dịch tiếng Việt khá tốt, giữ được cái hồn của nguyên tác.','2026-05-31 12:12:34'),(689,12,1,5,'Con mình mê lắm, đọc một mạch hết luôn!','2026-05-31 12:12:34'),(690,12,1,3,'Hay nhưng mình thích các phần sau hơn phần đầu này.','2026-05-31 12:12:34');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_general_ci,
  `avatar` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `role` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'user',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_username` (`username`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'quynh','$2a$12$X9fvlDurTNIqwSHWnjtFe.XSaFrU6fhmohnEZv58QfcqDtjhJV.2m','shodakima@gmail.com','huong quynh','','',NULL,1,'user','2026-04-19 20:32:11'),(2,'user123','$2a$12$QC1k8ssztxUn7axnHNhn7.yit9YdSIFiYBufHjj82c7d78zAbXK6C','user123@gmail.com','user123','','',NULL,1,'user','2026-04-20 15:24:40'),(3,'nhi','$2a$12$/CBjC0jpju.JZrh3o0EUKeVLVxRsBv7BP10/f9YkR3zdFuSqRP93q','nhi@gmail.com','Nhi',NULL,NULL,NULL,1,'admin','2026-05-29 23:10:03');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-02  1:06:29
