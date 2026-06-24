-- Edit this (FGS.config) to change your preferences changing the values (true/false), and then reload the mod.
-- Disable ModConfigMenu in order for this to work.
FGS.config = {
    ["Active"] = true,
    ["NormalTreasureRoom"] = true,
    ["GreedTreasureRoom"] = true,
    ["GreedBossRoom"] = true,
    ["MinimumQuality"] = true, -- false = 3, true = 4
    ["IncludeActiveItems"] = true,
    ["IncludeFamiliars"] = true,
    ["OnlyOffensive"] = false,
    ["PortalToTreasure"] = true,
    ["Debug"] = false,
}

-- WITHOUT ModConfigMenu this has NO EFFECT, do not touch.
FGS.defaultConfig = {
    ["Active"] = true,
    ["NormalTreasureRoom"] = true,
    ["GreedTreasureRoom"] = true,
    ["GreedBossRoom"] = true,
    ["MinimumQuality"] = false, 
    ["IncludeActiveItems"] = true,
    ["IncludeFamiliars"] = true,
    ["OnlyOffensive"] = false,
    ["PortalToTreasure"] = false,
    ["Debug"] = false,
}