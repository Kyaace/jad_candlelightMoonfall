RewardingNightCombat = RewardingNightCombat or {}

RewardingNightCombat.indicator = nil

RewardingNightCombat.fetchTooltipText = function()
    local text = { }

    if RewardingNightCombat.enabledAxeBonus then
        table.insert(text, "Axe: " ..tostring(RewardingNightCombat.axeMultiplier + 1.0).. "x")
    end

    if RewardingNightCombat.enabledLongBluntBonus then
        table.insert(text, "Long Blunt: " ..tostring(RewardingNightCombat.longBluntMultiplier + 1.0).."x")
    end

    if RewardingNightCombat.enabledShortBluntBonus then
        table.insert(text, "Short Blunt: " ..tostring(RewardingNightCombat.shortBluntMultiplier + 1.0).."x")
    end

    if RewardingNightCombat.enabledLongBladeBonus then
        table.insert(text, "Long Blade: " ..tostring(RewardingNightCombat.longBladeMultiplier + 1.0).."x")
    end

    if RewardingNightCombat.enabledShortBladeBonus then
        table.insert(text, "Short Blade: " ..tostring(RewardingNightCombat.shortBladeMultiplier + 1.0).."x")
    end

    if RewardingNightCombat.enabledSpearBonus then
        table.insert(text, "Spear: " ..tostring(RewardingNightCombat.spearMultiplier + 1.0).."x")
    end

    if RewardingNightCombat.enabledAimingBonus then
        table.insert(text, "Aiming: " ..tostring(RewardingNightCombat.aimingMultiplier + 1.0).."x")
    end

    return table.concat(text,"\n")
end

RewardingNightCombat.initIndicator = function()
    if RewardingNightCombat.indicator == nil then
        RewardingNightCombat.indicator = ISImage:new(getCore():getScreenWidth() - 210, 12, 32, 32, Texture.getSharedTexture("media/ui/RNC_indicator_icon.png"));
        RewardingNightCombat.indicator:initialise();
        RewardingNightCombat.indicator:setVisible(false);
        RewardingNightCombat.indicator:setMouseOverText(RewardingNightCombat.fetchTooltipText())
        RewardingNightCombat.indicator:addToUIManager();
    end
end

RewardingNightCombat.updateIndicator = function(status)
    if RewardingNightCombat.indicator ~= nil then
        RewardingNightCombat.indicator:setVisible(status);
    end
end
