local npc = Npc(935, 11)

npc.gender = 1
npc.accessories = {0, 8918, 8919, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    -- TODO: travel to the chosen Scaéroport
    if answer == 0 then p:ask(4172, {3656, 3657, 3658, 3659})
    elseif answer == 3656 or answer == 3657 or answer == 3658 or answer == 3659 then p:endDialog()
    end
end

RegisterNPCDef(npc)
