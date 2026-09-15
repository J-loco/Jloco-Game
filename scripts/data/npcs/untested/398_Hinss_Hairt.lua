local npc = Npc(398, 9016)

npc.colors = {16777215, 16777215, 16777215}

-- Token exchange. K: answer choosing the amount, V: gift question, token price and gift answer -> item
local tiers = {
    [1307] = {question = 1691, price = 50, gifts = {[1312] = 6603, [1313] = 6617, [1314] = 6618, [1315] = 6619, [1316] = 6626}},
    [1308] = {question = 1694, price = 100, gifts = {[1317] = 6606, [1318] = 6607, [1319] = 6608, [1320] = 6610, [1321] = 6611,
                                                    [1322] = 6612, [1323] = 6613, [1324] = 6614, [1325] = 6615, [1326] = 6616}},
    [1309] = {question = 1695, price = 250, gifts = {[1327] = 6620, [1328] = 6621, [1329] = 6658}},
    [1310] = {question = 1692, price = 500, gifts = {[1330] = 6605, [1331] = 6624}},
    [1311] = {question = 1693, price = 2000, gifts = {[1332] = 6622, [1333] = 6625}},
}

---@param tier table
---@return number[]
local function giftAnswers(tier)
    local answers = {}
    for answer in pairs(tier.gifts) do
        table.insert(answers, answer)
    end
    table.sort(answers)
    return answers
end

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1648, {1306})
    elseif answer == 1306 then p:ask(1690, {1307, 1308, 1309, 1310, 1311})
    elseif tiers[answer] then p:ask(tiers[answer].question, giftAnswers(tiers[answer]))
    else
        for _, tier in pairs(tiers) do
            local item = tier.gifts[answer]
            if item then
                if p:getItem(TroolFairTokenID, tier.price) and p:consumeItem(TroolFairTokenID, tier.price) then
                    p:addItem(item)
                    p:endDialog()
                else
                    p:ask(1696)
                end
                return
            end
        end
    end
end

RegisterNPCDef(npc)
