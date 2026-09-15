local npc = Npc(680, 9006)

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(2831, {2443})
    elseif answer == 2443 then p:ask(1186)
    end
end

RegisterNPCDef(npc)
