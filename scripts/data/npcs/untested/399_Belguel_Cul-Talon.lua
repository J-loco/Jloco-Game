local npc = Npc(399, 9056)

-- Tir au ballon
local game = {fee = 20, scenario = 28, map = 6866, cell = 422, exitMap = 3452, exitCell = 181, rewards = {[1] = 1, [2] = 1, [3] = 7}}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1667, {1286, 1287})
    elseif answer == 1287 then p:ask(1668, {1286})
    elseif answer == 1286 then PlayTroolFairGame(p, game)
    end
end

RegisterNPCDef(npc)
