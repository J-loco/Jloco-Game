local npc = Npc(330, 1197)
--TODO: Lié aux quêtes d'Alignement 29 Bonta
npc.accessories = {0, 2097, 0, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    -- TODO: Q2859 bail (2506 -> Q1633) and leaving the prison are not implemented
    if answer == 0 then p:ask(1288, {2488})
    elseif answer == 2488 then p:ask(2859)
    end
end

RegisterNPCDef(npc)
