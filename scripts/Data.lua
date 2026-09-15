-- Init script for static data VM

---@type table<fun>
POST_INITS = {}

-- Load constant data
requireReload("data/AdminCommands")
requireReload("data/AdminGroups")
requireReload("data/Breed")
requireReload("data/ExchangeActions")
requireReload("data/Experience")
requireReload("data/FightTypes")
requireReload("data/GearSlots")
requireReload("data/Animations")
requireReload("data/InteractiveObjects")
requireReload("data/Jobs")
requireReload("data/ObjectiveTypes")
requireReload("data/Skills")

-- Define classes
requireReload("models/NPC")
requireReload("models/TroolFair")
requireReload("models/MapDef")
requireReload("models/Quest")
requireReload("models/QuestObjectives")
requireReload("models/InteractiveObjectDef")

-- Load instances
loadPack("data/animations")
loadPack("data/objects") -- Always load after animations
loadPack("data/skills") -- Always load after objects
loadPack("data/npcs")
loadPack("data/maps")
loadPack("data/quests")
loadPack("data/dungeons") -- Always load after maps

-- Load other gameplay features
requireReload("data/Dopples")
requireReload("data/Wanted")


-- Load event handlers
loadPack("eventhandlers")

-- Register Maps to Java
for _, map in pairs(MAPS) do
    RegisterMapDef(map)
end

-- Run POST_INITS handlers
for _, fn in ipairs(POST_INITS) do
    fn()
end

-- Report the object skills a player can use but no script handles: using them silently does nothing.
-- Mount park skills (175-178) are handled in Java (Player.useMountParkSkill) before reaching the scripts.
do
    local javaSkills = {[175] = true, [176] = true, [177] = true, [178] = true}
    local missing = {}
    for _, io in pairs(IO_DEFS) do
        for _, skillID in ipairs(io.skills) do
            if not SKILLS[skillID] and not javaSkills[skillID] then
                missing[skillID] = true
            end
        end
    end
    local list = {}
    for skillID in pairs(missing) do
        list[#list + 1] = skillID
    end
    table.sort(list)
    if #list > 0 then
        JLogF("Object skills without handler: {}", table.concat(list, ","))
    end
end
