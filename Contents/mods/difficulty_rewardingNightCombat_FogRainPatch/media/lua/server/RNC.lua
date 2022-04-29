RewardingNightCombat = RewardingNightCombat or {}

RewardingNightCombat.multipliers = {0, 0.1, 0.15, 0.25, 0.5, 0.75, 1, 1.5, 2, 3, 4, 6.5, 9}
RewardingNightCombat.hours = {24, 1, 2, 3, 4 ,5, 6, 7, 8, 9, 10 , 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}

RewardingNightCombat.applySandboxVars = function()
    local options = getSandboxOptions();
    RewardingNightCombat.enabledIndicator = options:getOptionByName("RewardingNightCombat.enableIndicator"):getValue();
    RewardingNightCombat.startSummer = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.startTimeSummer"):getValue()];
    RewardingNightCombat.endSummer = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.endTimeSummer"):getValue()];
    RewardingNightCombat.startAutumn = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.startTimeAutumn"):getValue()];
    RewardingNightCombat.endAutumn = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.endTimeAutumn"):getValue()];
    RewardingNightCombat.startWinter = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.startTimeWinter"):getValue()];
    RewardingNightCombat.endWinter = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.endTimeWinter"):getValue()];
    RewardingNightCombat.startSpring = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.startTimeSpring"):getValue()];
    RewardingNightCombat.endSpring = RewardingNightCombat.hours[options:getOptionByName("RewardingNightCombat.endTimeSpring"):getValue()];
    RewardingNightCombat.axeMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.axeBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledAxeBonus = RewardingNightCombat.axeMultiplier ~= 0;
    RewardingNightCombat.longBluntMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.longBluntBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledLongBluntBonus = RewardingNightCombat.longBluntMultiplier ~= 0;
    RewardingNightCombat.shortBluntMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.shortBluntBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledShortBluntBonus = RewardingNightCombat.shortBluntMultiplier ~= 0;
    RewardingNightCombat.longBladeMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.longBladeBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledLongBladeBonus = RewardingNightCombat.longBladeMultiplier ~= 0;
    RewardingNightCombat.shortBladeMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.shortBladeBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledShortBladeBonus = RewardingNightCombat.shortBladeMultiplier ~= 0;
    RewardingNightCombat.spearMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.spearBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledSpearBonus = RewardingNightCombat.spearMultiplier ~= 0;
    RewardingNightCombat.aimingMultiplier = RewardingNightCombat.multipliers[options:getOptionByName("RewardingNightCombat.aimingBonusMultiplier"):getValue()];
    RewardingNightCombat.enabledAimingBonus = RewardingNightCombat.aimingMultiplier ~= 0;
    RewardingNightCombat.ignoreAimingXPNerf = options:getOptionByName("RewardingNightCombat.ignoreAimingXPNerf"):getValue()
end

RewardingNightCombat.isBetweenTimeInterval = function(current_month, current_hour)
    local setting_start_hour;
    local setting_end_hour;
    if current_month >= 5 and current_month <= 7 then --summer
        setting_start_hour = RewardingNightCombat.startSummer;
        setting_end_hour = RewardingNightCombat.endSummer;
        if (current_hour >= setting_start_hour or  current_hour < setting_end_hour) and setting_start_hour > setting_end_hour then
            return true;
        elseif current_hour >= setting_start_hour and current_hour < setting_end_hour then
            return true;
        end
    elseif current_month >= 8 and current_month <= 10 then --autumn
        setting_start_hour = RewardingNightCombat.startAutumn;
        setting_end_hour = RewardingNightCombat.endAutumn;
        if (current_hour >= setting_start_hour or  current_hour < setting_end_hour) and setting_start_hour > setting_end_hour then
            return true;
        elseif current_hour >= setting_start_hour and current_hour < setting_end_hour then
            return true;
        end
    elseif current_month == 11 or current_month <= 1 then --winter
        setting_start_hour = RewardingNightCombat.startWinter;
        setting_end_hour = RewardingNightCombat.endWinter;
        if (current_hour >= setting_start_hour or  current_hour < setting_end_hour) and setting_start_hour > setting_end_hour then
            return true;
        elseif current_hour >= setting_start_hour and current_hour < setting_end_hour then
            return true;
        end
    elseif current_month >= 2 and current_month <= 4 then --spring
        setting_start_hour = RewardingNightCombat.startSpring;
        setting_end_hour = RewardingNightCombat.endSpring;
        if (current_hour >= setting_start_hour or  current_hour < setting_end_hour) and setting_start_hour > setting_end_hour then
            return true;
        elseif current_hour >= setting_start_hour and current_hour < setting_end_hour then
            return true;
        end
    end
    return false
end

RewardingNightCombat.OnWeaponHitXp = function(player, weapon, _, damage)
    if RewardingNightCombat.status then
        local min_fn = math.min;
        local original_exp = 0.0;
        local xp = 0.0;
        if weapon:isRanged() and RewardingNightCombat.enabledAimingBonus then
            if player:getPerkLevel(Perks.Aiming) < 5 or RewardingNightCombat.ignoreAimingXPNerf then
                original_exp = player:getLastHitCount() * 2.7;
                xp = original_exp * RewardingNightCombat.aimingMultiplier;
                player:getXp():AddXP(Perks.Aiming, xp);
            else
                original_exp = player:getLastHitCount();
                xp = original_exp * RewardingNightCombat.aimingMultiplier;
                player:getXp():AddXP(Perks.Aiming, xp);
            end
        else
            if weapon:getCategories():contains("Axe") and RewardingNightCombat.enabledAxeBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.axeMultiplier;
                player:getXp():AddXP(Perks.Axe, xp);
            elseif weapon:getCategories():contains("Blunt") and RewardingNightCombat.enabledLongBluntBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.longBluntMultiplier;
                player:getXp():AddXP(Perks.Blunt, xp);
            elseif weapon:getCategories():contains("Spear") and RewardingNightCombat.enabledSpearBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.spearMultiplier;
                player:getXp():AddXP(Perks.Spear, xp);
            elseif weapon:getCategories():contains("LongBlade") and RewardingNightCombat.enabledLongBluntBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.longBladeMultiplier;
                player:getXp():AddXP(Perks.LongBlade, xp);
            elseif weapon:getCategories():contains("SmallBlade") and RewardingNightCombat.enabledShortBladeBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.shortBladeMultiplier;
                player:getXp():AddXP(Perks.SmallBlade, xp);
            elseif weapon:getCategories():contains("SmallBlunt") and RewardingNightCombat.enabledShortBluntBonus then
                original_exp =  min_fn(damage * 0.9, 3);
                xp = original_exp * RewardingNightCombat.shortBluntMultiplier;
                player:getXp():AddXP(Perks.SmallBlunt, xp);
            end
        end
        --print("org xp: " ..original_exp.. " - bonus exp: " ..xp.. " ratio: " ..tostring((xp + original_exp)/original_exp))
    end
end

RewardingNightCombat.OnEveryHours = function()
    local game_time = getGameTime();
    local current_month = game_time:getMonth();
    local current_hour = game_time:getTimeOfDay();
    RewardingNightCombat.status = RewardingNightCombat.isBetweenTimeInterval(current_month, current_hour);
    if RewardingNightCombat.enabledIndicator then
        RewardingNightCombat.updateIndicator(RewardingNightCombat.status);
    end
end

RewardingNightCombat.OnGameStart = function()
    RewardingNightCombat.applySandboxVars();
    if RewardingNightCombat.enabledIndicator then
        RewardingNightCombat.initIndicator();
    end

    RewardingNightCombat.OnEveryHours();

    Events.EveryHours.Add(RewardingNightCombat.OnEveryHours);
    Events.OnWeaponHitXp.Add(RewardingNightCombat.OnWeaponHitXp);
end

Events.OnGameStart.Add(RewardingNightCombat.OnGameStart);