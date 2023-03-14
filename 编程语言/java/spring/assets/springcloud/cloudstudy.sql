/*
 Navicat Premium Data Transfer

 Source Server         : 腾讯云数据库
 Source Server Type    : MySQL
 Source Server Version : 50718
 Source Host           : cdb-34x5jpzg.cd.tencentcdb.com:10072
 Source Schema         : cloudstudy

 Target Server Type    : MySQL
 Target Server Version : 50718
 File Encoding         : 65001

 Date: 23/03/2022 11:35:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for DB_BOOK
-- ----------------------------
DROP TABLE IF EXISTS `DB_BOOK`;
CREATE TABLE `DB_BOOK` (
  `bid` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `desc` varchar(255) NOT NULL,
  PRIMARY KEY (`bid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of DB_BOOK
-- ----------------------------
BEGIN;
INSERT INTO `DB_BOOK` (`bid`, `title`, `desc`) VALUES (1, '深入理解Java虚拟机', '讲解JVM底层原理');
INSERT INTO `DB_BOOK` (`bid`, `title`, `desc`) VALUES (2, 'Java并发编程的艺术', '讲解并发编程的各种技术');
INSERT INTO `DB_BOOK` (`bid`, `title`, `desc`) VALUES (3, 'Java核心技术卷一', '讲解Java的基础知识等');
INSERT INTO `DB_BOOK` (`bid`, `title`, `desc`) VALUES (4, '计算机网络', '讲解计算机的网络实现原理和知识');
COMMIT;

-- ----------------------------
-- Table structure for DB_BORROW
-- ----------------------------
DROP TABLE IF EXISTS `DB_BORROW`;
CREATE TABLE `DB_BORROW` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_bid_uid` (`uid`,`bid`),
  KEY `f_bid` (`bid`),
  CONSTRAINT `f_bid` FOREIGN KEY (`bid`) REFERENCES `DB_BOOK` (`bid`),
  CONSTRAINT `f_uid` FOREIGN KEY (`uid`) REFERENCES `DB_USER` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of DB_BORROW
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for DB_USER
-- ----------------------------
DROP TABLE IF EXISTS `DB_USER`;
CREATE TABLE `DB_USER` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `age` int(11) NOT NULL,
  `sex` enum('男','女') NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of DB_USER
-- ----------------------------
BEGIN;
INSERT INTO `DB_USER` (`uid`, `name`, `age`, `sex`) VALUES (1, '小明', 18, '男');
INSERT INTO `DB_USER` (`uid`, `name`, `age`, `sex`) VALUES (2, '小红', 17, '女');
INSERT INTO `DB_USER` (`uid`, `name`, `age`, `sex`) VALUES (3, '小芳', 18, '女');
INSERT INTO `DB_USER` (`uid`, `name`, `age`, `sex`) VALUES (4, '小刚', 17, '男');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
