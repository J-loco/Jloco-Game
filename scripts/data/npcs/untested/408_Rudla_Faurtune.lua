local npc = Npc(408, 9016)

npc.colors = {15323913, 6385110, 2954003}

-- Bouftou roulette: pay to play, the bouftou eats the apple once in a while and the player takes the jackpot.
-- The jackpot only lives in memory: it resets on restart and on script reload.
local fee = 500
local baseJackpot = 13450
local winChance = 200 -- 1 in winChance
local loseScenario, winScenario = 30, 31

RudlaFaurtuneJackpot = RudlaFaurtuneJackpot or baseJackpot

---@param p Player
---@param answer number
function npc:onTalk(p, answer)
    if answer == 0 then p:ask(1646, {1273}, tostring(RudlaFaurtuneJackpot))
    elseif answer == 1273 then
        if not p:modKamas(-fee) then
            p:endDialog()
            return
        end

        local won = math.random(winChance) == 1
        local prize = RudlaFaurtuneJackpot
        if won then
            RudlaFaurtuneJackpot = baseJackpot
        else
            RudlaFaurtuneJackpot = RudlaFaurtuneJackpot + fee // 2
        end

        p:endDialog()
        p:startScenario(won and winScenario or loseScenario, "7001010000", function(pl)
            if won then pl:modKamas(prize) end
        end)
    end
end

RegisterNPCDef(npc)
