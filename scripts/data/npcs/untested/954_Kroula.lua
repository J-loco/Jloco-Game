local npc = Npc(954, 120)

npc.accessories = {0, 8989, 0, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(4226, {3710})
    elseif answer == 3710 then p:ask(4227, {3711})
    elseif answer == 3711 then p:ask(4228)
    end
end

RegisterNPCDef(npc)
