local npc = Npc(396, 9016)

npc.colors = {2654703, 4033774, 13762560}

local ticketID = 6653
local fee = 10

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    -- TODO: The ticket is valid 24 hours, but scripts can't set its date stat yet
    if answer == 0 then p:ask(1686, {1302})
    elseif answer == 1302 then
        if not p:getItem(ticketID) and p:modKamas(-fee) then
            p:addItem(ticketID)
        end
        p:endDialog()
    end
end

RegisterNPCDef(npc)
