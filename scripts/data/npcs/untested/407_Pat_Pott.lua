local npc = Npc(407, 9016)

npc.colors = {15855980, 14400316, 15102315}

-- Tofu Smash
local game = {fee = 20, scenario = 21, map = 6864, cell = 169, exitMap = 3297, exitCell = 410, rewards = {[1] = 1, [2] = 1, [3] = 8}}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1677, {1297, 1295})
    elseif answer == 1295 then p:ask(1678, {1297})
    elseif answer == 1297 then PlayTroolFairGame(p, game)
    end
end

RegisterNPCDef(npc)
