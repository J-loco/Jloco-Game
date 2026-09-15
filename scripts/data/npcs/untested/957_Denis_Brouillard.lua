local npc = Npc(957, 9110)

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(4235, {3716})
    elseif answer == 3716 then p:ask(4236, {3717})
    elseif answer == 3717 then p:ask(4237, {3718})
    elseif answer == 3718 then p:ask(4238)
    end
end

RegisterNPCDef(npc)
