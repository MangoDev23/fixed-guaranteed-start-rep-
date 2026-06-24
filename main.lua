FGS = RegisterMod("Fixed Guaranteed Start REP+ ", 1)

require("config.lua")
require("save_load.lua")
require("mcm.lua")
require("tp.lua")

if ModConfigMenu then
    SaveHandler:load()
end

DEBUG_STRING = "[FGS]: "

local normalTreasureRoom = FGS.config["NormalTreasureRoom"]
local greedTreasureRoom = FGS.config["GreedTreasureRoom"]
local greedBossRoom = FGS.config["GreedBossRoom"]
local debug = FGS.config["Debug"]

local chosenTreasureItem = nil
local chosenBossGreedItem = nil

local recentItems = {}

local visited = false

local function getTableSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

local function itemInTable(table, element)
    for _, value in pairs(table) do
        if value.Name == element.Name then
            return true
        end
    end
    return false
end

-- Get a random item of quality 3 or higher from the specified pool
local function GetRandomQ34Item(pool)
    local tries = 50
    local retry = false
    local minQuality = 3
    local gameItemPool = Game():GetItemPool()
    local itemConfig = Isaac.GetItemConfig()
    local playerType = Isaac.GetPlayer():GetPlayerType()
    local entry = nil
    local item = nil
    local defaultItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_HALO)
    if FGS.config["OnlyOffensive"] then
        tries = 100
    end
    Isaac.DebugString(DEBUG_STRING .. "MinimumQuality: " .. tostring(FGS.config["MinimumQuality"]))
    if FGS.config["MinimumQuality"] then
        if(pool~=ItemPoolType.POOL_GREED_BOSS) then minQuality = 4 end
        tries = 150
        defaultItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
    end

    ::retry::
    for i = 1, tries do

        entry = gameItemPool:GetCollectible(pool, false, Random(), CollectibleType.COLLECTIBLE_NULL)
        item = itemConfig:GetCollectible(entry)
        if item and item.Quality >= minQuality then

            if not retry and itemInTable(recentItems, item) and tries < 350 then tries = tries + 50 end
            if (entry == CollectibleType.COLLECTIBLE_NULL 
                or itemInTable(recentItems, item)
                or item.Type == ItemType.ITEM_ACTIVE and not FGS.config["IncludeActiveItems"]
                or item.Type == ItemType.ITEM_FAMILIAR and not FGS.config["IncludeFamiliars"]
                or not item:HasTags(ItemConfig.TAG_OFFENSIVE) and (FGS.config["OnlyOffensive"] or playerType == PlayerType.PLAYER_THELOST_B)
                or playerType == PlayerType.PLAYER_THELOST and item:HasTags(ItemConfig.TAG_NO_LOST_BR)
            ) then goto continue end

            table.insert(recentItems, item)
            if getTableSize(recentItems) > 4 then
                table.remove(recentItems, 1)
            end

            return item

        end
        ::continue::
    end

    if itemInTable(recentItems, defaultItem) and not retry then
        retry = true
        tries = 100
        goto retry 
    end

    table.insert(recentItems, defaultItem)
    return defaultItem

end

-- Get the items if greed mode
local function GetRandomGreedItems()
    if greedTreasureRoom then
        chosenTreasureItem = GetRandomQ34Item(ItemPoolType.POOL_GREED_TREASURE)
    end
    if greedBossRoom then
        chosenBossGreedItem = GetRandomQ34Item(ItemPoolType.POOL_GREED_BOSS)
    end
end

-- Choose the items for the run
function FGS:OnGameStart(IsContinued)
    Isaac.DebugString(DEBUG_STRING .. "Active? = " .. tostring(FGS.config["Active"]))
    if not FGS.config["Active"] then return end
    normalTreasureRoom = FGS.config["NormalTreasureRoom"]
    greedTreasureRoom = FGS.config["GreedTreasureRoom"]
    greedBossRoom = FGS.config["GreedBossRoom"]

    if IsContinued then return end

    visited = false
    if(Game():IsGreedMode()) then 
        GetRandomGreedItems()
        if debug and chosenBossGreedItem and greedBossRoom then Isaac.DebugString(DEBUG_STRING .. "CHOSEN BOSS GREED item = " .. tostring(chosenBossGreedItem.Name)) end
    else if normalTreasureRoom then
        chosenTreasureItem = GetRandomQ34Item(ItemPoolType.POOL_TREASURE)
        end
    end
    if debug and chosenTreasureItem and (normalTreasureRoom or greedTreasureRoom) then Isaac.DebugString(DEBUG_STRING .. "CHOSEN TREASURE item = " .. tostring(chosenTreasureItem.Name)) end
    
end

-- replace the item in the first visited treasure room
function FGS:OnPreRoomEntitySpawn(type, variant, subType)
    if not FGS.config["Active"] then return {type, variant, subType} end
    if not visited and chosenTreasureItem and type == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE then
        local level = Game():GetLevel()
        local room = level:GetCurrentRoom()
        -- greed mode 
        if(Game():IsGreedMode()) then 
            if room:GetType() == RoomType.ROOM_TREASURE then
                local start = level:GetStartingRoomIndex()
                if debug then Isaac.DebugString(DEBUG_STRING .. "Current Room Index = " .. tostring(level:GetCurrentRoomIndex()) .. " | Start Room Index = " .. tostring(start)) end
                if(level:GetCurrentRoomIndex() == (start + 14)) then
                    if greedBossRoom and chosenBossGreedItem then
                        if debug then Isaac.DebugString(DEBUG_STRING .. "Changing BOSS GREED room item to " .. tostring(chosenBossGreedItem.Name)) end
                        visited = true
                        return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosenBossGreedItem.ID}
                    end
                else if greedTreasureRoom then
                    if debug then Isaac.DebugString(DEBUG_STRING .. "Changing TREASURE GREED room item to " .. tostring(chosenTreasureItem.Name)) end
                    visited = true
                    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosenTreasureItem.ID}
                    end
                end
            end
        else
        -- normal mode
            if room:GetType() == RoomType.ROOM_TREASURE and not room:IsMirrorWorld() and normalTreasureRoom then
                if debug then Isaac.DebugString(DEBUG_STRING .. "Changing TREASURE ROOM item to " .. tostring(chosenTreasureItem.Name)) end
                visited = true
                return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, chosenTreasureItem.ID}
            end
        end
    end
end


FGS:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FGS.OnGameStart)
FGS:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, FGS.OnPreRoomEntitySpawn)