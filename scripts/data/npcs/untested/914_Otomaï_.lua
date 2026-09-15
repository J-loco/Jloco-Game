local npc = Npc(914, 9066)

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(4058, {3543, 3532, 3577, 3539})
    -- About Otomaï
    elseif answer == 3543 then p:ask(4069, {5347})
    elseif answer == 5347 then p:ask(6161, {5348})
    elseif answer == 5348 then p:ask(6162, {5349})
    elseif answer == 5349 then p:ask(6163, {5350})
    elseif answer == 5350 then p:ask(6164, {5351})
    elseif answer == 5351 then p:ask(6165, {5352})
    elseif answer == 5352 then p:ask(6166)
    -- About the island
    elseif answer == 3539 then p:ask(4066, {3698, 3705, 3700})
    elseif answer == 3698 then p:ask(4217, {3699})
    elseif answer == 3699 then p:ask(4218)
    elseif answer == 3705 then p:ask(4224)
    elseif answer == 3700 then p:ask(4219, {3701})
    elseif answer == 3701 then p:ask(4220, {3702})
    elseif answer == 3702 then p:ask(4221, {3703})
    elseif answer == 3703 then p:ask(4222, {3704})
    elseif answer == 3704 then p:ask(4223)
    -- TODO: constitution change and spell forgetting potions are not implemented
    elseif answer == 3577 then p:ask(4104, {3795, 3691})
    elseif answer == 3691 then p:ask(4213)
    elseif answer == 3795 then p:ask(4308)
    elseif answer == 3532 then p:ask(4067, {3566})
    elseif answer == 3566 then p:ask(4088)
    end
end

RegisterNPCDef(npc)
