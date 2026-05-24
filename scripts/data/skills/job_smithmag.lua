-- Smithmagic / Forgemagie workshop skills
-- Permanent ateliers: no animation state change, always available.

local function smithmagicSkill(jobID, skillID)
    SKILLS[skillID] = function(p, _)
        if p:jobLevel(jobID) == 0 then return end
        p:useCraftSkill(skillID, 3)
    end
end

smithmagicSkill(43, 1)    -- Forgemage de Dague
smithmagicSkill(44, 113)  -- Forgemage d'Épée
smithmagicSkill(47, 115)  -- Forgemage de Hache
smithmagicSkill(45, 116)  -- Forgemage de Marteau
smithmagicSkill(46, 117)  -- Forgemage de Pelle
smithmagicSkill(48, 118)  -- Sculptemage d'Arc
smithmagicSkill(49, 119)  -- Sculptemage de Baguette
smithmagicSkill(50, 120)  -- Sculptemage de Bâton
smithmagicSkill(62, 163)  -- Cordomage (bottes)
smithmagicSkill(62, 164)  -- Cordomage (ceinture)
smithmagicSkill(63, 168)  -- Joaillomage (amulette)
smithmagicSkill(63, 169)  -- Joaillomage (anneau)
smithmagicSkill(64, 165)  -- Costumage (chapeau)
smithmagicSkill(64, 166)  -- Costumage (sac)
smithmagicSkill(64, 167)  -- Costumage (cape)
