local npc = Npc(537, 80)

npc.colors = {16777215, 0, 0}
npc.accessories = {0, 6863, 6886, 0, 7069}

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(2284, {1915, 1918})
    elseif answer == 1915 then p:ask(2285, {1916})
    elseif answer == 1916 then p:ask(2286, {1917})
    elseif answer == 1917 then p:ask(2287, {1910})
    elseif answer == 1910 then p:endDialog()
    elseif answer == 1918 then p:ask(2288)
    end
end

RegisterNPCDef(npc)
