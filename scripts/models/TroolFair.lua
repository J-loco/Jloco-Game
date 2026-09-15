-- Foire du Trool: mini-games are client scenarios (data/tutorials/<id>_7001010000.swf).
-- Their END action value comes back as the scenario result and selects the reward.

TroolFairTokenID = 1749

---@class TroolFairGame
---@field fee number kamas
---@field scenario number
---@field map number|nil game map (a copy of the stand map), nil to play in place
---@field cell number|nil
---@field exitMap number|nil
---@field exitCell number|nil
---@field rewards table<number, number> scenario result -> tokens

---@param p Player
---@param game TroolFairGame
function PlayTroolFairGame(p, game)
    p:endDialog()
    if not p:modKamas(-game.fee) then return end

    local onEnd = function(pl, _, result)
        local tokens = game.rewards[result]
        if tokens then
            pl:addItem(TroolFairTokenID, tokens)
        end
        if game.exitMap then
            pl:teleport(game.exitMap, game.exitCell)
        end
    end

    if not game.map then
        p:startScenario(game.scenario, "7001010000", onEnd)
        return
    end

    p:teleport(game.map, game.cell)
    -- Let the client load the game map before starting the scenario
    World:delayForMs(1500, function()
        if p:mapID() ~= game.map then return end
        p:startScenario(game.scenario, "7001010000", onEnd)
    end)
end
