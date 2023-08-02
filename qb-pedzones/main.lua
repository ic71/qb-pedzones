local Peds = {}
local insidePoint = false
local Ped = nil


CreateThread(function()
    while true do 
        Wait(500)
        local PlayerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(PlayerPed)

        for k, ped in pairs(Peds) do
            if Peds[k].zone:isPointInside(pedCoords) then
                insidePoint = true

                local PedModel = ped.model
                local PedCoords = ped.coords

                RequestModel(PedModel)

                while not HasModelLoaded(PedModel) do
                    Wait(10)
                end

                if not DoesEntityExist(Ped) then
                    Ped = CreatePed(1, PedModel, PedCoords.x, PedCoords.y, PedCoords.z, ped.heading, false, true)
                    if ped.behaviour.invincible then
                        SetEntityInvincible(Ped, true)
                    end
                    if ped.behaviour.canMove then
                        SetPedCanPlayAmbientAnims(Ped, true)
                        SetPedCanRagdollFromPlayerImpact(Ped, false)
                    end
                    if ped.behaviour.ignorePlayer then
                        SetBlockingOfNonTemporaryEvents(Ped, true)
                        FreezeEntityPosition(Ped, true)
                    end
                    if ped.behaviour.clipboard then
                        TaskStartScenarioInPlace(Ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                    end
                    if ped.behaviour.PizzaAnim then
                        TaskStartScenarioInPlace(Ped, 'CODE_HUMAN_CROSS_ROAD_WAIT', 0, true)
                    end
                    if ped.behaviour.SmokeWeed then
                        TaskStartScenarioInPlace(Ped, 'WORLD_HUMAN_DRUG_DEALER', 0, true)
                    end
                end

                while insidePoint == true do
                    if not Peds[k].zone:isPointInside(GetEntityCoords(PlayerPed)) then
                        insidePoint = false

                        if DoesEntityExist(Ped) then
                            DeletePed(Ped)
                        end
                    end

                    Wait(5)
                end
            end
        end
    end
end)

function CreateNPC(type,model,anim,dict,pos,help)
    Citizen.CreateThread(function()
      -- Define variables
      local hash = GetHashKey(model)
      local talking = false
  
      -- Loads model
      RequestModel(hash)
      while not HasModelLoaded(hash) do
        Wait(1)
      end
  
      -- Loads animation
      RequestAnimDict(anim)
      while not HasAnimDictLoaded(anim) do
        Wait(1)
      end
  
      -- Creates ped when everything is loaded
      local ped = CreatePed(type, hash, pos.x, pos.y, pos.z, pos.h, false, true)
      SetEntityHeading(ped, pos.h)
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,anim,dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
      
      -- Process NPC interaction
      while true do
        Citizen.Wait(0)
        local your = GetEntityCoords(GetPlayerPed(-1), false)
      end
    end)
  end

---ضيف هنا الكواد 
