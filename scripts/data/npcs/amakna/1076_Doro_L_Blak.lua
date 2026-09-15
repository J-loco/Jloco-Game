local npc = Npc(1076, 51)

npc.gender = 1
npc.colors = {0, 0, 15751868}
npc.accessories = {0, 8569, 8642, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(5788, {4987})
    elseif answer == 4987 then p:ask(5789, {4989})
    elseif answer == 4989 then p:endDialog() -- TODO: sneeze services (Q5792)
    end
end

RegisterNPCDef(npc)
