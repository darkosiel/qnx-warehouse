CREATE TABLE `warehouse` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` longtext DEFAULT NULL,
    `username` VARCHAR(25) DEFAULT NULL,
    `pin` VARCHAR(25) DEFAULT NULL,
    `price` INT(255) NOT NULL DEFAULT '0',
    `lagertype` VARCHAR(12) DEFAULT NULL,
    `maxWeight` INT(12) DEFAULT NULL,
    `lagerWeight` INT(12) NOT NULL DEFAULT '0',
    `items` longtext DEFAULT NULL,
    `buyTime` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY(`id`)  
);       