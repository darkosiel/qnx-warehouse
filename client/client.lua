ESX = exports['es_extended']:getSharedObject()

RegisterCommand('lager', function()
  open();
  displayWarehouse();
end)

RegisterNUICallback('buy', function(data)
  TriggerServerEvent('qnx-lager:buy', tostring(data.type), data.pin)
end)

RegisterNUICallback('changePin', function(data)
  TriggerServerEvent('qnx-lager:changePin', data.newPin)
end)

RegisterNUICallback('sellWarehouse', function(data)
  TriggerServerEvent('qnx-lager:sellWarehouse', data.pin)
end)

RegisterNUICallback('enterWarehouse', function(data)
  TriggerServerEvent('qnx-lager:enterWarehouse', data.pin)
end)

RegisterNetEvent('qnx-lager:DisplayMarker')
AddEventHandler('qnx-lager:DisplayMarker', function(owned)
  local ped = PlayerPedId()
  if not owned then
    SetEntityCoords(ped, Config.Warehouse.location)
    SetEntityHeading(ped, Config.Warehouse.heading)
    Citizen.CreateThread(function()
      while true do
        Wait(1)
        local sleep = true
        local ped = PlayerPedId()
        local coords = vector3(Config.Warehouse.location)
        local dist = #(GetEntityCoords(ped) - coords)

        if dist < 30 then
          sleep = false
          DrawMarker(Config.marker.type, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.marker.size.x,
            Config.marker.size.y, Config.marker.size.z, Config.marker.color.r, Config.marker.color.g,
            Config.marker.color.b, Config.marker.color.a, false, false, 2, Config.marker.rotate, nil, nil, false);
          if dist < 2 then
            showInfobar(Config.Locales['helpNotify'])
            if IsControlJustPressed(1, 38) then
              displayInventory();
              displayWarehouseItems();
            end
          end
        end

        if sleep then
          Wait(1000)
        end
      end
    end)
  end
end)

RegisterNUICallback('putItem', function(data)
  TriggerServerEvent('qnx-lager:putItem', tostring(data.name), tostring(data.label), tonumber(data.count))
end)

RegisterNUICallback('takeItem', function(data)
  TriggerServerEvent('qnx-lager:takeItem', tostring(data.name), tostring(data.label), tonumber(data.count))
end)

RegisterNUICallback('notify', function(data)
  local type = data.type

  if type == 'ungleich' then
    Notify(Config.Locales['ungleich'], 'client')
  end
end)

-- notify
RegisterNetEvent('warehouse:notify')
AddEventHandler('warehouse:notify', function(type, bType)
  if type == 'buy' then
    Notify(Config.Locales['bought']:format(bType), 'client')
  elseif type == 'maxWarehouse' then
    Notify(Config.Locales['maxWarehouse'], 'client')
  elseif type == 'invalidPin' then
    Notify(Config.Locales['invalidPin'], 'client')
  elseif type == 'owns' then
    Notify(Config.Locales['owns'], 'client')
  elseif type == 'noSpace' then
    Notify(Config.Locales['noSpace'], 'client')
  elseif type == 'noMoney' then
    Notify(Config.Locales['noMoney'], 'client')
  end
end)

RegisterNetEvent('warehouse:refresh')
AddEventHandler('warehouse:refresh', function(type)
  if type == 'warehouseitems' then
    displayWarehouseItems();
    displayInventory();
  elseif type == 'buy' then
    displayWarehouse();
  end
end)

RegisterNUICallback('close', function()
  SetNuiFocus(false, false)
end)
