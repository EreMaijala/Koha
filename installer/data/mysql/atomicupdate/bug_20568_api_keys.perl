$DBversion = "XXX";
if(CheckVersion($DBversion)) {

    if (!TableExists('api_keys')) {
        $dbh->do(q{
            CREATE TABLE `api_keys` (
                `id`          INT(11) NOT NULL AUTO_INCREMENT,
                `patron_id`   INT(11) NOT NULL,
                `client_id`   VARCHAR(191) NOT NULL,
                `secret`      VARCHAR(191) NOT NULL,
                `description` VARCHAR(255) NOT NULL,
                `active`      TINYINT(1) DEFAULT 1 NOT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `client_id` (`client_id`),
                UNIQUE KEY `secret` (`secret`),
                KEY `patron_id` (`patron_id`),
                CONSTRAINT `api_keys_fk_patron_id`
                  FOREIGN KEY (`patron_id`)
                  REFERENCES `borrowers` (`borrowernumber`)
                  ON DELETE CASCADE ON UPDATE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        });
    }

    $dbh->do(q{
        INSERT IGNORE INTO `systempreferences`
            (variable,value,explanation,options,type)
        VALUES
            ('AllowPatronsManageAPIKeysInOPAC', '0', 'If enabled, patrons can manage their own API keys in the OPAC', NULL, 'YesNo');
    });

    print "Upgrade to $DBversion done (Bug 20568 - Add API key management interface for patrons)\n";
    SetVersion($DBversion);
}