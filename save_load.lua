local json = require("json")

SaveHandler = {
    save = function()
        if not FGS or not FGS.config then return end
        local ok, err = pcall(function()
            local jsonString = json.encode(FGS.config)
            FGS:SaveData(jsonString)
        end)
        if not ok then
            if FGS.config.Debug then
                Isaac.DebugString(DEBUG_STRING .. "save failed:" .. err)
                print(debug.traceback())
            end
        end
    end,

    load = function()
        if not FGS or not FGS.config then return end
        if not FGS:HasData() then return end

        local ok, err = pcall(function()
            local jsonString = FGS:LoadData()
            FGS.config = json.decode(jsonString)
        end)
        if not ok then
            if FGS.config.Debug then
                Isaac.DebugString(DEBUG_STRING .. "load failed:" .. err)
                print(debug.traceback())
            end
            for i,j in pairs(FGS.defaultConfig) do FGS.config[i] = j end
        end
    end,
}