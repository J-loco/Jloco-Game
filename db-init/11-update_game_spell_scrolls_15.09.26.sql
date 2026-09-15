USE starloco_game;

-- Spell scrolls sold by Papycha had no on-use action, so double-clicking them did nothing.
-- Action type 6 = learn spell (args = spell id).
REPLACE INTO `objectsactions` VALUES (10602, '6', '414'); -- Apprivoisement de Monture
REPLACE INTO `objectsactions` VALUES (10603, '6', '413'); -- Capture d'Âmes
REPLACE INTO `objectsactions` VALUES (10604, '6', '366'); -- Marteau de Moon (player version; 293 is Moon's own spell)
