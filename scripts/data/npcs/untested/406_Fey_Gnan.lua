local npc = Npc(406, 9016)

npc.colors = {16755963, 15410549, 15607978}

-- Larva race, played on the stand map; the NPC promises 40 tokens to the winner
local game = {fee = 40, scenario = 25, rewards = {[1] = 40}}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1681, {1299, 1298})
    elseif answer == 1298 then p:ask(1682, {1299})
    elseif answer == 1299 then PlayTroolFairGame(p, game)
    end
end

RegisterNPCDef(npc)
