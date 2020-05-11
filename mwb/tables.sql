-- MySQL Script generated by MySQL Workbench
-- Sun May 10 01:55:57 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema skladista
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema skladista
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `skladista` DEFAULT CHARACTER SET utf8 ;
USE `skladista` ;

-- -----------------------------------------------------
-- Table `skladista`.`proizvodjaci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`proizvodjaci` ;

CREATE TABLE IF NOT EXISTS `skladista`.`proizvodjaci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `skladista`.`kategorije`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`kategorije` ;

CREATE TABLE IF NOT EXISTS `skladista`.`kategorije` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  `nadkategorija` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `nadkategorija_fk`
    FOREIGN KEY (`nadkategorija`)
    REFERENCES `skladista`.`kategorije` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `nadkategorija_fk_idx` ON `skladista`.`kategorije` (`id` ASC, `nadkategorija` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`proizvodi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`proizvodi` ;

CREATE TABLE IF NOT EXISTS `skladista`.`proizvodi` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  `proizvodjac` INT UNSIGNED NULL,
  `kategorija` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `proiz_kat_fk`
    FOREIGN KEY (`kategorija`)
    REFERENCES `skladista`.`kategorije` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `proiz_man_fk`
    FOREIGN KEY (`proizvodjac`)
    REFERENCES `skladista`.`proizvodjaci` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `proiz_kat_fk_idx` ON `skladista`.`proizvodi` (`kategorija` ASC) ;

CREATE INDEX `proiz_man_fk_idx` ON `skladista`.`proizvodi` (`proizvodjac` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`dobavljaci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`dobavljaci` ;

CREATE TABLE IF NOT EXISTS `skladista`.`dobavljaci` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `skladista`.`proizvodi_dobavljaca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`proizvodi_dobavljaca` ;

CREATE TABLE IF NOT EXISTS `skladista`.`proizvodi_dobavljaca` (
  `proizvod_id` INT UNSIGNED NOT NULL,
  `dobavljac_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`proizvod_id`, `dobavljac_id`),
  CONSTRAINT `pd_dobavljac_fk`
    FOREIGN KEY (`dobavljac_id`)
    REFERENCES `skladista`.`dobavljaci` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pd_proizvod_fk`
    FOREIGN KEY (`proizvod_id`)
    REFERENCES `skladista`.`proizvodi` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `pd_dobacljac_fk_idx` ON `skladista`.`proizvodi_dobavljaca` (`dobavljac_id` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`skladista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`skladista` ;

CREATE TABLE IF NOT EXISTS `skladista`.`skladista` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  `naziv_lokacije` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `skladista`.`proizvodi_skladista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`proizvodi_skladista` ;

CREATE TABLE IF NOT EXISTS `skladista`.`proizvodi_skladista` (
  `proizvod_id` INT UNSIGNED NOT NULL,
  `skladiste_id` INT UNSIGNED NOT NULL,
  `kolicina` INT UNSIGNED NULL,
  PRIMARY KEY (`proizvod_id`, `skladiste_id`),
  CONSTRAINT `proiz_sklad_fk`
    FOREIGN KEY (`skladiste_id`)
    REFERENCES `skladista`.`skladista` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sklad_proiz_fk`
    FOREIGN KEY (`proizvod_id`)
    REFERENCES `skladista`.`proizvodi` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `proiz_sklad_fk_idx` ON `skladista`.`proizvodi_skladista` (`skladiste_id` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`osobe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`osobe` ;

CREATE TABLE IF NOT EXISTS `skladista`.`osobe` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Ime` VARCHAR(45) NULL,
  `Prezime` VARCHAR(45) NULL,
  `Telefon` VARCHAR(45) NULL,
  `datum_zaposljavanja` DATE NULL,
  `JMBG` VARCHAR(45) NOT NULL,
  `naziv_lokacije` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `JMBG_UNIQUE` ON `skladista`.`osobe` (`JMBG` ASC) ;



-- -----------------------------------------------------
-- Table `skladista`.`prava_pristupa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`prava_pristupa` ;

CREATE TABLE IF NOT EXISTS `skladista`.`prava_pristupa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `skladista`.`korisnicki_racuni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`korisnicki_racuni` ;

CREATE TABLE IF NOT EXISTS `skladista`.`korisnicki_racuni` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `osoba_id` INT UNSIGNED NULL,
  `pravo_pristupa` INT UNSIGNED NOT NULL,
  `password` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `racun_pristup_fk`
    FOREIGN KEY (`pravo_pristupa`)
    REFERENCES `skladista`.`prava_pristupa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `racun_osoba_fk`
    FOREIGN KEY (`osoba_id`)
    REFERENCES `skladista`.`osobe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `EMAIL_UNIQUE` ON `skladista`.`korisnicki_racuni` (`email` ASC) ;

CREATE UNIQUE INDEX `osoba_id_UNIQUE` ON `skladista`.`korisnicki_racuni` (`osoba_id` ASC) ;

CREATE INDEX `racun_pristup_fk_idx` ON `skladista`.`korisnicki_racuni` (`pravo_pristupa` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`stanja_kupovine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`stanja_kupovine` ;

CREATE TABLE IF NOT EXISTS `skladista`.`stanja_kupovine` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stanje` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `skladista`.`kupovine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`kupovine` ;

CREATE TABLE IF NOT EXISTS `skladista`.`kupovine` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `korisnicki_racun` INT UNSIGNED NULL,
  `stanje_id` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `kupovina_racun_fk`
    FOREIGN KEY (`korisnicki_racun`)
    REFERENCES `skladista`.`korisnicki_racuni` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `kupovina_stanje_fk`
    FOREIGN KEY (`stanje_id`)
    REFERENCES `skladista`.`stanja_kupovine` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `kupovina_racun_fk_idx` ON `skladista`.`kupovine` (`korisnicki_racun` ASC) ;

CREATE INDEX `kupovina_stanje_fk_idx` ON `skladista`.`kupovine` (`stanje_id` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`proizvodi_kupovine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`proizvodi_kupovine` ;

CREATE TABLE IF NOT EXISTS `skladista`.`proizvodi_kupovine` (
  `proizvod_id` INT UNSIGNED NOT NULL,
  `kupovina_id` INT UNSIGNED NOT NULL,
  `kolicina` INT NULL,
  PRIMARY KEY (`proizvod_id`, `kupovina_id`),
  CONSTRAINT `kup_pro_fk`
    FOREIGN KEY (`proizvod_id`)
    REFERENCES `skladista`.`proizvodi` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pro_kup_fk`
    FOREIGN KEY (`kupovina_id`)
    REFERENCES `skladista`.`kupovine` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `pro_kup_fk_idx` ON `skladista`.`proizvodi_kupovine` (`kupovina_id` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`narudzba`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`narudzba` ;

CREATE TABLE IF NOT EXISTS `skladista`.`narudzba` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `korisnicki_racun` INT UNSIGNED NOT NULL,
  `skladiste_id` INT UNSIGNED NOT NULL,
  `datum_kreiranja` DATE NULL,
  `datum_isporuke` DATE NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `narudzba_racun_fk`
    FOREIGN KEY (`korisnicki_racun`)
    REFERENCES `skladista`.`korisnicki_racuni` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `narudzba_skladiste_fk`
    FOREIGN KEY (`skladiste_id`)
    REFERENCES `skladista`.`skladista` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `narudzba_racun_idx` ON `skladista`.`narudzba` (`korisnicki_racun` ASC) ;

CREATE INDEX `narudzba_skladiste_fk_idx` ON `skladista`.`narudzba` (`skladiste_id` ASC) ;


-- -----------------------------------------------------
-- Table `skladista`.`artikli_narudzbe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skladista`.`artikli_narudzbe` ;

CREATE TABLE IF NOT EXISTS `skladista`.`artikli_narudzbe` (
  `dobavljac_id` INT UNSIGNED NOT NULL,
  `proizvod_id` INT UNSIGNED NOT NULL,
  `narudzba_id` INT UNSIGNED NOT NULL,
  `kolicina` INT NULL,
  PRIMARY KEY (`narudzba_id`, `proizvod_id`, `dobavljac_id`),
  CONSTRAINT `art_pd_fk`
    FOREIGN KEY (`dobavljac_id` , `proizvod_id`)
    REFERENCES `skladista`.`proizvodi_dobavljaca` (`dobavljac_id` , `proizvod_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `art_nar_fk`
    FOREIGN KEY (`narudzba_id`)
    REFERENCES `skladista`.`narudzba` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `art_pd_fk_idx` ON `skladista`.`artikli_narudzbe` (`dobavljac_id` ASC, `proizvod_id` ASC) ;

CREATE INDEX `art_nar_fk_idx` ON `skladista`.`artikli_narudzbe` (`narudzba_id` ASC) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO prava_pristupa(id, naziv) VALUES (1, "ADMIN");
INSERT INTO prava_pristupa(id, naziv) VALUES (2, "UPOSLENIK");
INSERT INTO prava_pristupa(id, naziv) VALUES (3, "KUPAC");


INSERT INTO osobe(Ime, Prezime, Telefon, datum_zaposljavanja, JMBG, naziv_lokacije)
VALUES ("Admin", "Admin", "(+387)61/123-456", now(), "2101999175009", "Sarajevo, Safvet-bega Basagica 33");

INSERT INTO korisnicki_racuni(osoba_id, pravo_pristupa, password, email)
VALUES (
	1,
	1,
	"$2b$10$bXtk.6HbvmPfNXA5HMeJXeK//J2MjWcBGbioO6bjw.NWO2WQErflm",
	"admin@admin.com"
	);