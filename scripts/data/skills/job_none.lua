-- SKILLS NOT LINKED TO A JOB

-- No skill object use
SKILLS[0] = function(p, cellID)
    -- print("SKILL 0 USED", p:name(), cellID)
    -- Use map object without skill
    local mapDef = p:map():def()
    local handler = mapDef.onObjectUse[cellID]
    if not handler then
        print("NO HANDLER FOR CELL", mapDef.id, cellID)
        return false
    end

    if type(handler) ~= "function" then
        error("Non-skill map object use handler must be functions")
    end

    return handler(p, 0)
end

-- Save Zaap
SKILLS[44] = function(p, _)
    local md = p:map():def()
    p:savePosition(md.id, md.zaapCell)
end

-- Heal: fountain of youth (62), pot (111)
SKILLS[62] = function (p, _)
    p:setLifePercent(100)
    p:sendLangMessage("area.map.gamecase.startaction.fountain")
end
SKILLS[111] = SKILLS[62]

-- Crafts without job, recipes in jobs_data under the skill id
registerWorkshopSkill(22)   -- Peel potatoes (potato table)
registerWorkshopSkill(110)  -- Wood bench
registerWorkshopSkill(121)  -- Crush resources (crusher)
registerWorkshopSkill(151)  -- Summon a fairy (fireworks workbench)

-- Break items into runes (crusher)
registerWorkshopSkill(181, function(p) p:openCrusher() end)

-- Craftsmen book
SKILLS[170] = function(p, _) p:openCraftsmenBook() end

-- Draw water from well
registerGatherSkill(102,
    4,
    function(_) return 1500 end,
    function(p)
        -- 311: Water
        gatherSkillAddItem(p, 311, math.random(1, 10))
    end,
    respawnBetweenMillis(120000, 420000)
)

-- Pick up potatoes (potato heap)
registerGatherSkill(42,
    4,
    function(_) return 1500 end,
    function(p)
        -- 537: Potato
        gatherSkillAddItem(p, 537, math.random(1, 5))
    end,
    respawnBetweenMillis(600000, 600000)
)

-- Fish a Quaquack at the fair
registerGatherSkill(152,
    4,
    function(_) return 1500 end,
    function(p)
        -- 6659: Quaquack
        gatherSkillAddItem(p, 6659, 1)
    end,
    respawnBetweenMillis(10000, 10000)
)

-- Use Zaap
SKILLS[114] = function(p, _)        p:openZaap() end

-- Use Zaapi
SKILLS[157] = function(p, _)        p:openZaapi() end

-- Use garbage bin
SKILLS[153] = function(p, cellID)   p:openTrunk(cellID) end

-- Use Switch
SKILLS[179] = function(p, cellId)
    local switchHandler = p:map():def().switches[cellId]
    if not switchHandler then return end
    if p:map():getAnimationState(cellId) ~= AnimStates.READY then return end

    if switchHandler(p) then
        p:map():setAnimationState(cellId, AnimStates.IN_USE)
    end
end

-- Use Astrub Breed Statue
SKILLS[183] = function(p, _)
    teleportByBreed(p, INCARNAM_STATUES)
end
