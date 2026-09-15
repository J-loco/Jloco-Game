local npc = Npc(854, 1197)
--TODO: Lié à la quête 178
npc.accessories = {0, 1908, 8458, 0, 7082}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(3629, {3205, 3201})
    elseif answer == 3205 then p:ask(3633, {3201})
    elseif answer == 3201 then p:endDialog() -- TODO: quest 178
    end
end

RegisterNPCDef(npc)
