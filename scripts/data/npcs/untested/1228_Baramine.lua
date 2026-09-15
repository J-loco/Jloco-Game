local npc = Npc(1228, 1073)

npc.gender = 1

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(7583, {7582})
    elseif answer == 7582 then p:ask(7584)
    end
end

RegisterNPCDef(npc)
