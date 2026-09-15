local npc = Npc(202, 60)
--TODO: Quête Alignement Bonta #73
npc.colors = {14090508, 1086823, 16566964}
npc.accessories = {0, 1090, 0, 0, 0} 

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:endDialog() -- TODO: dialog unknown
    end
end

RegisterNPCDef(npc)
