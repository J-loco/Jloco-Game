USE `starloco_login`;

-- Account privacy toggles used by StarLoco-Web (pages/profile.php, include/rightmenu.php).
-- 1 = visible, 0 = hidden.
ALTER TABLE `world_accounts`
    ADD COLUMN IF NOT EXISTS `showOrHide` TINYINT(1) NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS `showOrHidePos` TINYINT(1) NOT NULL DEFAULT 0;
