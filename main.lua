ParticlePlayers = {}

function Initialize(Plugin)
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED, OnPlayerDestroyed)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function GetValue(list)
	local value = {}
	for k, v in ipairs(list) do 
		value[v] = true
	end
	return value
end

local ParticleTypes = GetValue { "explode", "largeexplode", "fireworksspark", "bubble", "splash", "wake", "suspended", "depthsuspend", "crit", "magiccrit", "smoke", "largesmoke", "spell", "instantspell", "mobspell", "mobspellambient", "witchmagic", "dripwater", "driplava", "angryvillager", "happyvillager", "townaura", "note", "portal", "enchantmenttable", "flame", "lava", "footstep", "reddust", "snowballpoof", "slime", "heart", "barrier", "cloud", "snowshovel", "droplet", "endrod", "dragonbreath", "sweepattack", "spit", "totem" }

function HandleParticleTrailsCommand(Split, Player)
	if Split[2] == nil then
		local ListParticles = ""
		for key, value in pairs(ParticleTypes) do
			ListParticles = ListParticles .. key .. ", "
		end
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <particle>")
		Player:SendMessageInfo("Available particles: " .. ListParticles:sub(1, ListParticles:len() - 2))
	elseif Split[2] == "off" then
		ParticlePlayers[Player:GetUUID()] = nil
		Player:SendMessageInfo("You no longer have a particle trail")
	else
		if ParticleTypes[Split[2]] then
			ParticlePlayers[Player:GetUUID()] = Split[2]
			Player:SendMessageSuccess("You now have a particle trail")
		else
			Player:SendMessageFailure("Invalid particle name")
		end
		return true
	end
	return true
end

function OnPlayerDestroyed(Player)
	ParticlePlayers[Player:GetUUID()] = nil
end

function OnWorldTick(World, TimeDelta)
	World:ForEachPlayer(
		function(Player)
			-- Creates particles around the player
			if ParticlePlayers[Player:GetUUID()] == "note" then
				Player:GetWorld():BroadcastParticleEffect("note", Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), 0.5, 1, 0.5, math.random(1, 16), 10)
			elseif ParticlePlayers[Player:GetUUID()] ~= nil then
				Player:GetWorld():BroadcastParticleEffect(ParticlePlayers[Player:GetUUID()], Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), 0.5, 1, 0.5, 0, 10)
			end
		end
	)
end

function OnDisable()
	LOG("Disabled " .. cPluginManager:GetCurrentPlugin():GetName() .. "!")
end
