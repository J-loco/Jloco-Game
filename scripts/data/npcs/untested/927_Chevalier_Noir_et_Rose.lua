local npc = Npc(927, 120)

npc.colors = {393216, 393216, 393216}
npc.accessories = {0, 8569, 0, 0, 0}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(4137, {3632})
    elseif answer == 3632 then p:endDialog() -- TODO: cross the bridge
    end
end

RegisterNPCDef(npc)
