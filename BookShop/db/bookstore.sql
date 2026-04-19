CREATE DATABASE  IF NOT EXISTS `bookstore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bookstore`;
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
  `author_name` varchar(255) NOT NULL,
  `bio` text,
  `image` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Nguyễn Nhật Ánh',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020710/authors/sojpx8piaixo5wjhvtys.jpg'),(2,'Robert Kiyosaki',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020731/authors/zm514gy5vas2do0mdjbn.jpg'),(3,'Dale Carnegie',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020855/authors/lorw8ilp4fkafuwd69or.avif'),(4,'Napoleon Hill',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020835/authors/hg7ygezudkwplegsdwap.jpg'),(5,'Yuval Noah Harari',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021545/authors/zzey3qy9bjywnjnmlfkj.jpg'),(6,'Paulo Coelho',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021496/authors/avueqwacnxjnrorh0hlq.jpg'),(7,'George Orwell',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021409/authors/alyhpizt0d03nux6ixnh.jpg'),(8,'J.K. Rowling',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021424/authors/smdmx23zu7qn61l3zwym.webp'),(9,'Tô Hoài',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021089/authors/xvrkm3tsflj9hsipjx64.jpg'),(10,'Nam Cao',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775020965/authors/quzwtiyg31nbke4hbqlu.jpg'),(12,'Richard Dawkins',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021249/authors/puhtsjvyoiquwhgn2s24.avif'),(67,'Stephen Hawking',NULL,'http://res.cloudinary.com/dqiefayjh/image/upload/v1775021289/authors/og2fqfbmandsbq2bnssu.png');
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
  `image_url` varchar(255) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `book_images_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `title` varchar(255) NOT NULL,
  `author_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `description` text,
  `image` varchar(500) DEFAULT NULL,
  `publish_year` int DEFAULT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `cover_type` varchar(50) DEFAULT NULL,
  `sold_quantity` int DEFAULT '0',
  PRIMARY KEY (`book_id`),
  KEY `author_id` (`author_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`),
  CONSTRAINT `books_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Cho tôi xin một vé đi tuổi thơ',1,1,50000.00,10,'Cuốn sách kể về tuổi thơ hồn nhiên qua góc nhìn của nhân vật Mùi. Những câu chuyện giản dị nhưng sâu sắc giúp người đọc nhớ lại thời thơ ấu đầy mơ mộng, đồng thời gửi gắm nhiều suy ngẫm về cách người lớn nhìn nhận thế giới của trẻ con. Đây là một trong những tác phẩm nổi bật và được yêu thích nhất của Nguyễn Nhật Ánh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774688881/books/qmxq98fwcklxzm5akk1u.jpg',2008,NULL,NULL,NULL,NULL,0),(2,'Rich Dad Poor Dad',2,3,120000.00,5,'Rich Dad Poor Dad của Robert Kiyosaki là cuốn sách nổi tiếng về tài chính cá nhân, kể lại những bài học mà tác giả học được từ hai người cha với hai tư duy hoàn toàn khác nhau về tiền bạc. Thông qua những câu chuyện thực tế, cuốn sách giúp người đọc hiểu rõ sự khác biệt giữa người làm việc vì tiền và người biết cách để tiền làm việc cho mình.\r\n\r\nCuốn sách tập trung vào việc thay đổi tư duy tài chính, giải thích các khái niệm như tài sản, tiêu sản và dòng tiền một cách đơn giản, dễ hiểu. Không chỉ cung cấp kiến thức, Rich Dad Poor Dad còn truyền cảm hứng mạnh mẽ, khuyến khích người đọc chủ động học hỏi, đầu tư và hướng đến mục tiêu tự do tài chính trong tương lai.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690124/books/gppx81otw3z0d2h0t3n4.webp',1997,NULL,NULL,NULL,NULL,0),(3,'Mắt Biếc',1,1,85000.00,20,'Mắt Biếc là một trong những tác phẩm nổi bật của Nguyễn Nhật Ánh, kể về câu chuyện tình yêu đơn phương đầy day dứt của Ngạn dành cho Hà Lan – cô gái có đôi mắt xanh biếc khiến bao người say đắm. Bối cảnh làng quê yên bình cùng những ký ức tuổi thơ trong sáng tạo nên một câu chuyện nhẹ nhàng nhưng sâu lắng.\r\n\r\nKhông chỉ là câu chuyện tình yêu, cuốn sách còn gợi lên nhiều cảm xúc về tuổi trẻ, sự trưởng thành và những tiếc nuối trong cuộc sống. Với lối viết giản dị nhưng giàu cảm xúc, Mắt Biếc đã chạm đến trái tim của nhiều thế hệ độc giả và trở thành một trong những tác phẩm được yêu thích nhất.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774688866/books/pyfswrt848psaboo6ilf.jpg',1990,NULL,NULL,NULL,NULL,0),(4,'Tôi Thấy Hoa Vàng Trên Cỏ Xanh',1,1,90000.00,15,'Tôi Thấy Hoa Vàng Trên Cỏ Xanh là một tác phẩm nổi tiếng của Nguyễn Nhật Ánh, kể về tuổi thơ của hai anh em Thiều và Tường tại một làng quê yên bình. Những câu chuyện xoay quanh cuộc sống thường ngày, tình bạn, tình anh em và những rung động đầu đời được khắc họa một cách chân thật, giản dị nhưng đầy cảm xúc.\r\n\r\nCuốn sách không chỉ gợi lại ký ức tuổi thơ trong sáng mà còn gửi gắm nhiều thông điệp sâu sắc về tình người, sự trưởng thành và những bài học trong cuộc sống. Với giọng văn nhẹ nhàng, gần gũi, tác phẩm đã chạm đến trái tim của đông đảo độc giả và trở thành một trong những cuốn sách được yêu thích nhất của Nguyễn Nhật Ánh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690308/books/v8zgjdvqjfoq2dim2avo.jpg',2010,NULL,NULL,NULL,NULL,0),(5,'Kính Vạn Hoa',1,1,75000.00,18,'Kính Vạn Hoa là bộ truyện dài nổi tiếng của Nguyễn Nhật Ánh, xoay quanh cuộc sống học đường và những câu chuyện thú vị của nhóm bạn Quý ròm, Tiểu Long và Hạnh. Mỗi tập truyện là một câu chuyện riêng biệt, đầy hài hước và gần gũi với lứa tuổi học sinh.\r\n\r\nBộ truyện không chỉ mang tính giải trí mà còn truyền tải nhiều bài học ý nghĩa về tình bạn, gia đình và cuộc sống. Với lối viết dí dỏm, sinh động, Kính Vạn Hoa đã trở thành một phần ký ức tuổi thơ của nhiều thế hệ độc giả Việt Nam.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690173/books/p2mb5frhbu2pxsjwfdaf.jpg',1995,NULL,NULL,NULL,NULL,0),(6,'Đắc Nhân Tâm',3,4,95000.00,30,'Đắc Nhân Tâm là một trong những cuốn sách nổi tiếng nhất của Dale Carnegie, tập trung vào nghệ thuật giao tiếp và cách ứng xử trong cuộc sống. Thông qua những nguyên tắc đơn giản nhưng hiệu quả, cuốn sách giúp người đọc hiểu cách tạo thiện cảm, xây dựng mối quan hệ và gây ảnh hưởng tích cực đến người khác.\r\n\r\nKhông chỉ dừng lại ở lý thuyết, cuốn sách còn đưa ra nhiều ví dụ thực tế, giúp người đọc dễ dàng áp dụng vào công việc và cuộc sống hàng ngày. Với giá trị vượt thời gian, Đắc Nhân Tâm đã trở thành một trong những cuốn sách kỹ năng sống bán chạy nhất thế giới và là lựa chọn hàng đầu cho những ai muốn phát triển bản thân.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690190/books/yhwinkgexnff31gfsltj.webp',1936,NULL,NULL,NULL,NULL,0),(7,'Nghĩ Giàu Làm Giàu',4,3,110000.00,12,'Nghĩ Giàu Làm Giàu là một trong những cuốn sách kinh điển về phát triển bản thân và tư duy thành công. Tác giả đã nghiên cứu những người giàu có và thành công để rút ra các nguyên tắc giúp đạt được mục tiêu trong cuộc sống.\r\n\r\nCuốn sách nhấn mạnh sức mạnh của suy nghĩ, niềm tin và sự kiên trì trong việc đạt được thành công. Đây là tài liệu quan trọng cho những ai muốn thay đổi tư duy và phát triển bản thân cả về tài chính lẫn cuộc sống.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690214/books/nyr8hk2zletovgvptkbs.jpg',1937,NULL,NULL,NULL,NULL,0),(8,'Sapiens: Lược Sử Loài Người',5,5,150000.00,8,'Sapiens: Lược Sử Loài Người là tác phẩm nổi tiếng của Yuval Noah Harari, đưa người đọc đi qua hành trình phát triển của loài người từ thời kỳ nguyên thủy đến xã hội hiện đại. Cuốn sách phân tích các bước ngoặt quan trọng như cách mạng nhận thức, cách mạng nông nghiệp và cách mạng khoa học, từ đó lý giải vì sao con người trở thành loài thống trị Trái Đất.\r\n\r\nVới lối viết cuốn hút và dễ hiểu, cuốn sách không chỉ cung cấp kiến thức lịch sử mà còn đặt ra nhiều câu hỏi sâu sắc về xã hội, văn hóa và tương lai của nhân loại. Đây là một trong những cuốn sách khoa học – lịch sử được đánh giá cao và phù hợp với mọi đối tượng độc giả muốn mở rộng hiểu biết.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690231/books/sdkj3ktiuwsqcfnq8g4v.jpg',2011,NULL,NULL,NULL,NULL,0),(9,'Nhà Giả Kim',6,7,88000.00,25,'Nhà Giả Kim kể về hành trình của Santiago – một chàng chăn cừu trẻ tuổi đi tìm kho báu theo giấc mơ của mình. Trên con đường đó, cậu gặp nhiều người và trải qua nhiều thử thách, từ đó học được những bài học quý giá về cuộc sống.\r\n\r\nCuốn sách mang thông điệp sâu sắc về việc theo đuổi ước mơ, lắng nghe trái tim và tin vào hành trình của bản thân. Với lối viết đơn giản nhưng đầy triết lý, tác phẩm đã truyền cảm hứng cho hàng triệu độc giả trên thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690258/books/klnlgnrmefvemrco392g.jpg',1988,NULL,NULL,NULL,NULL,0),(10,'1984',7,7,92000.00,14,'1984 là một tiểu thuyết kinh điển của George Orwell, mô tả một xã hội toàn trị nơi mọi hành động và suy nghĩ của con người đều bị kiểm soát. Nhân vật chính Winston Smith sống trong một thế giới bị giám sát chặt chẽ, nơi sự thật bị bóp méo và tự do cá nhân gần như không tồn tại.\r\n\r\nCuốn sách không chỉ là một câu chuyện giả tưởng mà còn là lời cảnh báo sâu sắc về quyền lực, sự kiểm soát và mất tự do. Với giá trị vượt thời gian, 1984 vẫn luôn là một trong những tác phẩm được đánh giá cao trong văn học thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690322/books/wtkpvjstd3q5ughdjuqe.jpg',1949,NULL,NULL,NULL,NULL,0),(11,'Trại Súc Vật',7,7,79000.00,16,'Trại Súc Vật là một tác phẩm nổi tiếng của George Orwell, sử dụng hình ảnh các loài vật để ẩn dụ cho xã hội loài người. Câu chuyện xoay quanh cuộc nổi dậy của các con vật chống lại con người để xây dựng một xã hội bình đẳng, nhưng dần dần lại bị biến chất bởi quyền lực.\r\n\r\nThông qua lối kể chuyện đơn giản nhưng sâu sắc, cuốn sách phản ánh những vấn đề về chính trị, quyền lực và sự tha hóa. Đây là một tác phẩm mang tính cảnh tỉnh, giúp người đọc hiểu rõ hơn về bản chất của xã hội và con người.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690337/books/gdgpjcbeglt7kza7u7fd.jpg',1945,NULL,NULL,NULL,NULL,0),(12,'Harry Potter và Hòn Đá Phù Thủy',8,7,120000.00,20,'Harry Potter và Hòn Đá Phù Thủy là phần đầu tiên trong loạt truyện nổi tiếng về cậu bé phù thủy Harry Potter. Câu chuyện bắt đầu khi Harry phát hiện mình là một phù thủy và được mời nhập học tại trường Hogwarts – nơi đào tạo phép thuật. Tại đây, cậu kết bạn với Ron và Hermione, đồng thời khám phá thế giới kỳ diệu đầy bí ẩn.\r\n\r\nKhông chỉ là một câu chuyện phiêu lưu hấp dẫn, cuốn sách còn truyền tải những thông điệp sâu sắc về tình bạn, lòng dũng cảm và sự lựa chọn giữa cái thiện và cái ác. Với cốt truyện lôi cuốn và thế giới phép thuật độc đáo, tác phẩm đã trở thành một trong những cuốn sách được yêu thích nhất trên toàn thế giới.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690377/books/zterccekdlgkqw3jy6em.jpg',1997,NULL,NULL,NULL,NULL,0),(13,'Dế Mèn Phiêu Lưu Ký',9,8,65000.00,22,'Dế Mèn Phiêu Lưu Ký là tác phẩm nổi tiếng của Tô Hoài, kể về hành trình trưởng thành của chú Dế Mèn – một chàng dế trẻ tuổi, bồng bột nhưng dũng cảm. Từ những sai lầm ban đầu, Dế Mèn bắt đầu chuyến phiêu lưu qua nhiều vùng đất, gặp gỡ nhiều người bạn và trải qua vô số thử thách.\r\n\r\nThông qua câu chuyện giàu tính nhân văn, cuốn sách truyền tải những bài học sâu sắc về tình bạn, lòng dũng cảm và trách nhiệm với hành động của bản thân. Với lối kể chuyện sinh động, gần gũi, tác phẩm không chỉ dành cho thiếu nhi mà còn chạm đến trái tim của nhiều thế hệ độc giả.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690396/books/oukx48srxtgj38f1c8mk.jpg',1941,NULL,NULL,NULL,NULL,0),(14,'Chí Phèo',10,8,55000.00,18,'Chí Phèo là tác phẩm tiêu biểu của Nam Cao, phản ánh số phận bi kịch của người nông dân trong xã hội cũ. Nhân vật Chí Phèo từ một người lương thiện bị đẩy vào con đường tha hóa, trở thành kẻ bị xã hội ruồng bỏ.\r\n\r\nTác phẩm không chỉ tố cáo xã hội bất công mà còn thể hiện khát vọng được làm người lương thiện của những con người bị áp bức. Với giá trị hiện thực và nhân đạo sâu sắc, đây là một trong những tác phẩm kinh điển của văn học Việt Nam.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690424/books/plb17scugkwtsztgmmuo.jpg',1941,NULL,NULL,NULL,NULL,0),(15,'Cha Giàu Cha Nghèo',2,3,120000.00,15,'Cuốn sách kể về những bài học tài chính từ hai người cha với tư duy hoàn toàn khác nhau về tiền bạc. Qua đó, người đọc hiểu được sự khác biệt giữa việc làm việc vì tiền và để tiền làm việc cho mình.\r\n\r\nVới cách viết dễ hiểu, sách giúp người đọc nắm được các khái niệm cơ bản như tài sản, tiêu sản và đầu tư, đồng thời truyền cảm hứng để đạt được tự do tài chính.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690463/books/nequcyqz16rrzk2z3irw.jpg',1997,NULL,NULL,NULL,NULL,0),(16,'Homo Deus',5,5,160000.00,7,'Homo Deus là phần tiếp theo của Sapiens, tập trung vào tương lai của loài người trong bối cảnh công nghệ phát triển mạnh mẽ. Cuốn sách đặt ra những câu hỏi lớn về việc con người sẽ đi về đâu khi trí tuệ nhân tạo và công nghệ sinh học ngày càng chi phối cuộc sống.\r\n\r\nVới góc nhìn sâu sắc, tác giả phân tích những khả năng như con người trở nên “bất tử”, nâng cấp trí tuệ hay mất đi vai trò trước máy móc. Đây là cuốn sách giúp người đọc suy ngẫm về tương lai và vị trí của con người trong thế giới hiện đại.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690480/books/lxyrngukbvyhwnsx8tea.jpg',2015,NULL,NULL,NULL,NULL,0),(17,'Quẳng Gánh Lo Đi Mà Vui Sống',3,4,85000.00,20,'Cuốn sách giúp người đọc nhận ra nguyên nhân của lo âu và cách kiểm soát suy nghĩ tiêu cực trong cuộc sống. Thông qua những nguyên tắc đơn giản và ví dụ thực tế, tác giả hướng dẫn cách sống tích cực và giảm căng thẳng.\r\n\r\nKhông chỉ mang tính lý thuyết, sách còn cung cấp nhiều phương pháp thực hành giúp người đọc thay đổi thói quen suy nghĩ, từ đó sống vui vẻ và hiệu quả hơn mỗi ngày.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690505/books/j5elbps5ckx7d1fgfrfn.jpg',1948,NULL,NULL,NULL,NULL,0),(18,'Vũ Trụ Trong Vỏ Hạt Dẻ ',67,6,120000.00,50,'Vũ Trụ Trong Vỏ Hạt Dẻ là một trong những tác phẩm khoa học nổi bật của Stephen Hawking, giúp người đọc tiếp cận những khái niệm phức tạp về vũ trụ theo cách đơn giản và dễ hiểu. Cuốn sách trình bày các lý thuyết hiện đại về không gian, thời gian, lỗ đen và nguồn gốc của vũ trụ, dựa trên những nghiên cứu tiên tiến trong vật lý.\r\n\r\nVới cách viết sinh động, kết hợp giữa khoa học và hình ảnh minh họa, cuốn sách không chỉ mang tính học thuật mà còn rất cuốn hút với người đọc phổ thông. Đây là lựa chọn tuyệt vời cho những ai yêu thích khám phá vũ trụ và muốn hiểu thêm về những bí ẩn của thế giới xung quanh.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690525/books/zddbnfepxxm2mkyugmsc.jpg',2001,NULL,NULL,NULL,NULL,0),(19,'Gen Vị Kỷ',12,1,200000.00,20,'Gen Vị Kỷ là một trong những cuốn sách khoa học nổi bật về sinh học tiến hóa, trong đó Richard Dawkins đưa ra góc nhìn mới về cách sự sống phát triển. Thay vì xem sinh vật là trung tâm, tác giả cho rằng gen mới chính là yếu tố quyết định, và mọi hành vi của sinh vật đều nhằm mục đích duy trì và truyền lại gen.\r\n\r\nCuốn sách giải thích các khái niệm phức tạp bằng ngôn ngữ dễ hiểu, giúp người đọc tiếp cận khoa học một cách thú vị. Đây là tác phẩm có ảnh hưởng lớn, không chỉ trong lĩnh vực sinh học mà còn thay đổi cách con người nhìn nhận về sự sống và tiến hóa.','http://res.cloudinary.com/dqiefayjh/image/upload/v1774690545/books/aotdrurybootuy7rc2na.webp',1976,'','','','Bìa mềm',0);
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
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Tiểu thuyết'),(2,'Công nghệ'),(3,'Kinh tế'),(4,'Tâm lý - Kỹ năng sống'),(5,'Lịch sử'),(6,'Khoa học'),(7,'Văn học nước ngoài'),(8,'Văn học Việt Nam');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
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
  `image_url` varchar(500) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_image_review` (`review_id`),
  CONSTRAINT `fk_image_review` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `fk_review_book` (`book_id`),
  KEY `fk_review_user` (`user_id`),
  CONSTRAINT `fk_review_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (2,19,1,4,'nhận dduocj hàng cũng nhanh, sách ok như hình','2026-04-19 13:55:50');
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
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `avatar` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `role` varchar(20) DEFAULT 'user',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'quynh','$2a$12$X9fvlDurTNIqwSHWnjtFe.XSaFrU6fhmohnEZv58QfcqDtjhJV.2m','shodakima@gmail.com','huong quynh','','',NULL,1,'user','2026-04-19 20:32:11');
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

-- Dump completed on 2026-04-19 21:01:07
