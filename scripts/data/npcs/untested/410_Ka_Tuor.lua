local npc = Npc(410, 9016)

npc.colors = {7653097, 13652826, 7255879}

-- Mémoire de Blop, easy and hard modes
local easyGame = {fee = 20, scenario = 24, map = 6876, cell = 284, exitMap = 3334, exitCell = 216, rewards = {[1] = 1, [2] = 1, [3] = 7}}
local hardGame = {fee = 20, scenario = 27, map = 6876, cell = 284, exitMap = 3334, exitCell = 216, rewards = {[1] = 1, [2] = 1, [3] = 15}}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1672, {1290, 1291, 1289})
    elseif answer == 1289 then p:ask(1673, {1290, 1291})
    elseif answer == 1290 then PlayTroolFairGame(p, easyGame)
    elseif answer == 1291 then PlayTroolFairGame(p, hardGame)
    end
end

RegisterNPCDef(npc)
