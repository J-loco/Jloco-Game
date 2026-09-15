local npc = Npc(400, 9016)

npc.colors = {635643, 15855954, 16275218}

-- TODO: Koinkoin fishing game (answer 1305 "Demander une canne pour un essai") is not implemented
---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1661, {1304})
    elseif answer == 1304 then p:ask(1688)
    end
end

RegisterNPCDef(npc)
