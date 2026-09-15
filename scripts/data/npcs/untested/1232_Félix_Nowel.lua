local npc = Npc(1232, 30)

npc.accessories = {0, 8334, 8333, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(7607, {7611, 7607})
    elseif answer == 7607 then p:ask(7608, {7618})
    elseif answer == 7618 then p:ask(7606) -- TODO: assign a monster holding a stolen crate
    elseif answer == 7611 then p:endDialog()
    end
end

RegisterNPCDef(npc)
