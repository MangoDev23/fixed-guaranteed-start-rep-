require("save_load.lua")
-- MOD CONFIG MENU 

local MOD_NAME = "Fixed GS REP+"
local VERSION = "2.0"

local roomTab = "Rooms"
local itemTab = "Items"
local extraTab = "Extra"
local infoTab = "Info"

if ModConfigMenu then

    local function restartDisclaimer(tab)
        ModConfigMenu.AddSpace(MOD_NAME, tab)
        ModConfigMenu.AddTitle(MOD_NAME, tab, "RESTART THE RUN TO SEE")
        ModConfigMenu.AddTitle(MOD_NAME, tab, "ANY CHANGES ABOVE TAKE EFFECT")
        ModConfigMenu.AddSpace(MOD_NAME, tab)
    end

    ModConfigMenu.SetCategoryInfo(MOD_NAME, "Fixed Guaranteed Start Settings")

    -- Room Settings

    ModConfigMenu.AddText(MOD_NAME, roomTab, "Select which rooms you want to be affected")
    ModConfigMenu.AddSpace(MOD_NAME, roomTab)
    ModConfigMenu.AddSetting(MOD_NAME, roomTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["NormalTreasureRoom"] end,
        Display = function() return "Treasure Room: " .. (FGS.config["NormalTreasureRoom"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["NormalTreasureRoom"] = currentBool
            SaveHandler:save()
            end,
    })
    ModConfigMenu.AddSetting(MOD_NAME, roomTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["GreedTreasureRoom"] end,
        Display = function() return "Greed Treasure Room: " .. (FGS.config["GreedTreasureRoom"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["GreedTreasureRoom"] = currentBool 
            SaveHandler:save()
            end,
    })
    ModConfigMenu.AddSetting(MOD_NAME, roomTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["GreedBossRoom"] end,
        Display = function() return "Greed Silver Room: " .. (FGS.config["GreedBossRoom"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["GreedBossRoom"] = currentBool 
            SaveHandler:save()
            end,
    })

    restartDisclaimer(roomTab)

    -- Item Settings

    ModConfigMenu.AddText(MOD_NAME, itemTab, "Choose your item preferences :D")
    ModConfigMenu.AddSpace(MOD_NAME, itemTab)
    ModConfigMenu.AddSetting(MOD_NAME, itemTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["MinimumQuality"] end,
        Display = function() return "Minimum Quality: " .. (FGS.config["MinimumQuality"] and "4" or "3") end,
        OnChange = function(currentBool) 
            FGS.config["MinimumQuality"] = currentBool 
            SaveHandler:save()
            end,
    })
    ModConfigMenu.AddSetting(MOD_NAME, itemTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["IncludeActiveItems"] end,
        Display = function() return "Include Active Items: " .. (FGS.config["IncludeActiveItems"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["IncludeActiveItems"] = currentBool 
            SaveHandler:save()
            end,
    })
    ModConfigMenu.AddSetting(MOD_NAME, itemTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["IncludeFamiliars"] end,
        Display = function() return "Include Familiars: " .. (FGS.config["IncludeFamiliars"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["IncludeFamiliars"] = currentBool 
            SaveHandler:save()
            end,
    })
    ModConfigMenu.AddSetting(MOD_NAME, itemTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["OnlyOffensive"] end,
        Display = function() return "Only Offensive Items: " .. (FGS.config["OnlyOffensive"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["OnlyOffensive"] = currentBool 
            SaveHandler:save()
            end,
        Info = {"T. Lost Passive"},
    })

    restartDisclaimer(itemTab)

    -- Extra Settings

    ModConfigMenu.AddText(MOD_NAME, extraTab, "Extra Settings")
    ModConfigMenu.AddSpace(MOD_NAME, extraTab)
    ModConfigMenu.AddSetting(MOD_NAME, extraTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["PortalToTreasure"] end,
        Display = function() return "Portal to Treasure Room: " .. (FGS.config["PortalToTreasure"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["PortalToTreasure"] = currentBool 
            SaveHandler:save()
            end,
        Info = {"Portal to Treasure Room at new run."},
    })
    ModConfigMenu.AddText(MOD_NAME, extraTab, "It doesn't work in Greed Mode.")

    restartDisclaimer(extraTab)

    -- Info Tab

    ModConfigMenu.AddText(MOD_NAME, infoTab, function() return MOD_NAME end)
    ModConfigMenu.AddText(MOD_NAME, infoTab, function() return "Version " .. VERSION end)
    ModConfigMenu.AddSpace(MOD_NAME, infoTab)
    ModConfigMenu.AddSetting(MOD_NAME, infoTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function() return true end,
			Display = function() return "Reset to Default" end,
			OnChange = function(currentBool)
				for i,j in pairs(FGS.defaultConfig) do FGS.config[i] = j end
                SaveHandler:save()
			    end,
			Info = {"Resets configuration to default. This can't be undone."},
    })
    --Debug Settings
    ModConfigMenu.AddSetting(MOD_NAME, infoTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["Active"] end,
        Display = function() return "Activated: " .. (FGS.config["Active"] and "Yes" or "No") end,
        OnChange = function(currentBool) 
            FGS.config["Active"] = currentBool 
            SaveHandler:save()
            end,
        Info = {"If the mod is active or not."},
    })

    ModConfigMenu.AddSetting(MOD_NAME, infoTab, {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function() return FGS.config["Debug"] end,
        Display = function() return "Debug: " .. (FGS.config["Debug"] and "ON" or "OFF") end,
        OnChange = function(currentBool)
            FGS.config["Debug"] = currentBool 
            SaveHandler:save()
            end,
        Info = {"Turn ON/OFF debug messages."},
    })
end

