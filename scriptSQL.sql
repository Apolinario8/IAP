-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema trabalho
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `trabalho` ;

-- -----------------------------------------------------
-- Schema trabalho
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `trabalho` ;
USE `trabalho` ;

-- -----------------------------------------------------
-- Table `trabalho`.`Sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`Sequence` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`Sequence` (
  `Sequence` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`Sequence`))
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`LOCUS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`LOCUS` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`LOCUS` (
  `Locus_Name` VARCHAR(15) NOT NULL,
  `Sequence_Length` INT NOT NULL,
  `Molecule_Type` VARCHAR(20) NOT NULL,
  `Topology` VARCHAR(15) NULL,
  `GenBank_Division` VARCHAR(7) NULL,
  `Modification_Date` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`Locus_Name`))
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`FEATURES`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`FEATURES` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`FEATURES` (
  `Source` VARCHAR(20) NOT NULL,
  `Taxon` VARCHAR(15) NOT NULL,
  `CDS` INT NULL,
  `gene` INT NULL,
  `mRNA` INT NULL,
  `regulatory` INT NULL,
  `protein_bind` INT NULL,
  `misc_features` INT NULL,
  `misc_difference` INT NULL,
  `sig_peptide` INT NULL,
  PRIMARY KEY (`Source`))
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`Gene_Bank`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`Gene_Bank` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`Gene_Bank` (
  `VERSION` VARCHAR(15) NOT NULL,
  `ACCESSION` VARCHAR(10) NOT NULL,
  `DEFINITION` VARCHAR(400) NOT NULL,
  `KEYWORDS` VARCHAR(200) NOT NULL,
  `ORGANISM` VARCHAR(45) NOT NULL,
  `TAXONOMY` VARCHAR(500) NOT NULL,
  `Sequence` VARCHAR(250) NOT NULL,
  `Locus_Name` VARCHAR(15) NOT NULL,
  `Source` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`VERSION`),
  INDEX `ferw3_idx` (`Sequence` ASC) VISIBLE,
  INDEX `gw4rfe_idx` (`Locus_Name` ASC) VISIBLE,
  INDEX `wge_idx` (`Source` ASC) VISIBLE,
  CONSTRAINT `ferw3`
    FOREIGN KEY (`Sequence`)
    REFERENCES `trabalho`.`Sequence` (`Sequence`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `gw4rfe`
    FOREIGN KEY (`Locus_Name`)
    REFERENCES `trabalho`.`LOCUS` (`Locus_Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `wge`
    FOREIGN KEY (`Source`)
    REFERENCES `trabalho`.`FEATURES` (`Source`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`Pubmed_information`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`Pubmed_information` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`Pubmed_information` (
  `Pubmed_id` VARCHAR(15) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `journal` VARCHAR(500) NOT NULL,
  `DOI` VARCHAR(60) NOT NULL,
  `abstract` VARCHAR(2000) NOT NULL,
  `affiliation` VARCHAR(200) NULL,
  PRIMARY KEY (`Pubmed_id`))
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`CDS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`CDS` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`CDS` (
  `protein_id` VARCHAR(15) NOT NULL,
  `Base_Span` VARCHAR(20) NOT NULL,
  `translation` VARCHAR(2000) NOT NULL,
  `gene` VARCHAR(45) NULL,
  `produto` VARCHAR(45) NOT NULL,
  `VERSION` VARCHAR(15) NOT NULL,
  `Source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`protein_id`),
  INDEX `fk07_idx` (`Source` ASC) VISIBLE,
  CONSTRAINT `fk07`
    FOREIGN KEY (`Source`)
    REFERENCES `trabalho`.`FEATURES` (`Source`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`REFERENCE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`REFERENCE` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`REFERENCE` (
  `journal` VARCHAR(200) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `consortium` VARCHAR(100) NULL,
  `comment` VARCHAR(1000) NULL,
  `pubmed_id` VARCHAR(15) NULL,
  INDEX `refw_idx` (`pubmed_id` ASC) VISIBLE,
  PRIMARY KEY (`journal`),
  CONSTRAINT `refw`
    FOREIGN KEY (`pubmed_id`)
    REFERENCES `trabalho`.`Pubmed_information` (`Pubmed_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`genbank_reference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`genbank_reference` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`genbank_reference` (
  `VERSION` VARCHAR(15) NOT NULL,
  `journal` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`VERSION`, `journal`),
  INDEX `wyr_idx` (`journal` ASC) VISIBLE,
  CONSTRAINT `54wytgrs`
    FOREIGN KEY (`VERSION`)
    REFERENCES `trabalho`.`Gene_Bank` (`VERSION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `wyr`
    FOREIGN KEY (`journal`)
    REFERENCES `trabalho`.`REFERENCE` (`journal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`authors` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`authors` (
  `author_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`author_name`))
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


-- -----------------------------------------------------
-- Table `trabalho`.`reference_authors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trabalho`.`reference_authors` ;

CREATE TABLE IF NOT EXISTS `trabalho`.`reference_authors` (
  `journal` VARCHAR(15) NOT NULL,
  `author_name` VARCHAR(45) NOT NULL,
  INDEX `fk10_idx` (`author_name` ASC) VISIBLE,
  PRIMARY KEY (`journal`, `author_name`),
  CONSTRAINT `fk10`
    FOREIGN KEY (`author_name`)
    REFERENCES `trabalho`.`authors` (`author_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk18`
    FOREIGN KEY (`journal`)
    REFERENCES `trabalho`.`REFERENCE` (`journal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM ROW_FORMAT=COMPRESSED;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
