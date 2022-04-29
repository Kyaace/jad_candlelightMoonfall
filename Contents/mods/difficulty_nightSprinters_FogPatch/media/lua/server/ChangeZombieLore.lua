--TODO: see if SandboxVars is a better way to go. I don't think it is updated properly, but might be worth it for the increase in preformance
--gets the starting time for when zombies will follow the modified speed value
--Called on: Everything
local function getStartTime()
	local gametime = GameTime:getInstance();
	local month = gametime:getMonth();
	if month>=2 and month<=4 then
		return getSandboxOptions():getOptionByName("NightSprinters.startSpring"):getValue();
	elseif month>=5 and month<=7 then
		return getSandboxOptions():getOptionByName("NightSprinters.startSummer"):getValue();
	elseif month>=8 and month<=10 then
		return getSandboxOptions():getOptionByName("NightSprinters.startAutumn"):getValue();
	end
	return getSandboxOptions():getOptionByName("NightSprinters.startWinter"):getValue();
end

--TODO: see if SandboxVars is a better way to go. I don't think it is updated properly, but might be worth it for the increase in preformance
--gets the ending time for when zombies will stop following the modified speed value
--Called on: Everything
local function getEndTime()
	local gametime = GameTime:getInstance();
	local month = gametime:getMonth();
	if month>=2 and month<=4 then
		return getSandboxOptions():getOptionByName("NightSprinters.endSpring"):getValue();
	elseif month>=5 and month<=7 then
		return getSandboxOptions():getOptionByName("NightSprinters.endSummer"):getValue();
	elseif month>=8 and month<=10 then
		return getSandboxOptions():getOptionByName("NightSprinters.endAutumn"):getValue();
	end
	return getSandboxOptions():getOptionByName("NightSprinters.endWinter"):getValue();
end

--This method changes the zombie speed of zombies loaded by the server, but not on the client
--Called on: Server
local function changeServerSideZoms(zombie)
	zombie:makeInactive(true);
	zombie:makeInactive(false);
end

local function updateAllServerZoms()
	local zombieList = getCell():getZombieList();
	local zomSize = zombieList:size() - 1;
	for i=0,zomSize do
		changeServerSideZoms(zombieList:get(i));
	end
end

--Essentially, I used to use this when I still used mod options, now that I don't I need to update every thing
--Called on: Servers and singleplayer
local function nsupdateSettings()
	local globalData = getGameTime():getModData();
	
	if globalData.NSSETTINGS then
		getSandboxOptions():set("NightSprinters.startSummer",globalData.NSSETTINGS.startSummer - 1);
		getSandboxOptions():set("NightSprinters.endSummer",globalData.NSSETTINGS.endSummer - 1);
		getSandboxOptions():set("NightSprinters.startAutumn",globalData.NSSETTINGS.startAutumn - 1);
		getSandboxOptions():set("NightSprinters.endAutumn",globalData.NSSETTINGS.endAutumn - 1);
		getSandboxOptions():set("NightSprinters.startWinter",globalData.NSSETTINGS.startWinter - 1);
		getSandboxOptions():set("NightSprinters.endWinter",globalData.NSSETTINGS.endWinter - 1);
		getSandboxOptions():set("NightSprinters.startSpring",globalData.NSSETTINGS.startSpring - 1);
		getSandboxOptions():set("NightSprinters.endSpring",globalData.NSSETTINGS.endSpring - 1);

		getSandboxOptions():set("NightSprinters.rainSprinters",globalData.NSSETTINGS.rainSprinters);
		getSandboxOptions():set("NightSprinters.fogSprinters",globalData.NSSETTINGS.fogSprinters);
		getSandboxOptions():set("NightSprinters.normalZombies",globalData.NSSETTINGS.normalSpeed);
		getSandboxOptions():set("NightSprinters.modifiedZombies",globalData.NSSETTINGS.modifiedSpeed);
	
		globalData.NSSETTINGS = nil;
	end	
end

--This method is crucial as it is in charge of changing the lore speed given the time and settings
--Called on: Everything
local function changeLore()
	local gTime = getGameTime();
	local hour = gTime:getTimeOfDay();
	local startTime = getStartTime();
	local endTime = getEndTime();
	local rain = RainManager:getRainIntensity();
	local rv = 0;
	local clim = getClimateManager();
    local FOG_ID = 5;
	local fog_Man = clim:getClimateFloat(FOG_ID);
	local fog = fog_Man:getAdminValue()
	local fv = 0;
	local oldSpeed = getSandboxOptions():getOptionByName("ZombieLore.Speed"):getValue();
	local newSpeed;
	--Debug prints.
	-- print("Inside of changeLore");
	-- print("Hour: "..hour);
	-- print("Fog: "..fog);
	-- print("Rain: "..rain);

	if (hour >= startTime and hour < endTime) then--If between start and end Time
		newSpeed = getSandboxOptions():getOptionByName("NightSprinters.modifiedZombies"):getValue()
	elseif (rain>rv and getSandboxOptions():getOptionByName("NightSprinters.rainSprinters"):getValue()) then--If raining and option enabled
		newSpeed = getSandboxOptions():getOptionByName("NightSprinters.modifiedZombies"):getValue()
	elseif (fog>fv and getSandboxOptions():getOptionByName("NightSprinters.fogSprinters"):getValue()) then--If foggy and option enabled
		newSpeed = getSandboxOptions():getOptionByName("NightSprinters.modifiedZombies"):getValue()
		--print("Fog check true!")
	elseif (hour>=startTime or hour<endTime) and startTime>endTime then
		newSpeed = getSandboxOptions():getOptionByName("NightSprinters.modifiedZombies"):getValue()
	else--Make normal speed
		newSpeed = getSandboxOptions():getOptionByName("NightSprinters.normalZombies"):getValue()
	end
	print("NewSpeed: "..newSpeed);

	if newSpeed ~= oldSpeed then
		getSandboxOptions():set("ZombieLore.Speed",newSpeed);

		if isServer() then
			updateAllServerZoms();
		--plays a sounds when zombies speed changes. Special thanks to both SpagootNoodels and ManoRusso for the idea
		--elseif newSpeed == SandboxVars.NightSprinters.modifiedSpeed then
		--	getSoundManager():PlaySound("PZ_WolfHowl_05", true, 0.0);
		--else
		--	getSoundManager():PlaySound("bird8", true, 0.0);
		end
	end

	--Shouldn't really go here, but I am a bit rushed atm
	nsupdateSettings()
end



--handles event types for each type of game instance: server, singleplayer, and client in that order(Not really needed anymore honestly)
--Called on: Everything
local function handleEvents()
	Events.EveryTenMinutes.Add(changeLore);
	changeLore();
end


Events.OnGameStart.Add(handleEvents);
Events.OnServerStarted.Add(handleEvents);