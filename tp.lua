function FGS:SpawnTP(IsContinued)
    if IsContinued or Game():IsGreedMode() or not FGS.config["PortalToTreasure"] or not FGS.config["Active"] then return end
    local game = Game()
    local room = game:GetRoom()
    local centerPos = room:GetCenterPos()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, 0, centerPos, Vector(0,0), nil)
end

FGS:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FGS.SpawnTP)