function open()
  SendNUIMessage({
    action = 'open',
    state = true,
    Config = Config.Warehouse
  })
  SetNuiFocus(true, true)
end

function displayWarehouse()
  ESX.TriggerServerCallback('qnx-lager:getWarehouse', function(warehouse)
    SendNUIMessage({
      action = 'showWarehouse',
      warehouse = warehouse
    })
    print(json.encode(warehouse))
  end)
end

function displayInventory()
  ESX.TriggerServerCallback('qnx-lager:getInventory', function(items, weapons)
    local item = {}

    if items ~= nil then
      for k, v in pairs(items) do
        if items[k].count <= 0 then
          items[k] = nil
        else
          items[k].type = 'item_standard'
          table.insert(item, items[k])
        end
      end
    end

    for key, value in pairs(weapons) do
      local weaponHash = GetHashKey(weapons[key].name)
      local playerPed = PlayerPedId()
      if HasPedGotWeapon(playerPed, weaponHash, false) and weapons[key].name ~= 'WEAPON_UNARMED' then
        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
        table.insert(item, {
          label = weapons[key].label,
          count = ammo,
          limit = -1,
          type = 'item_weapon',
          name = weapons[key].name,
          usable = false,
          rare = false,
          canRemove = true
        })
      end
    end

    SendNUIMessage({
      action = 'inventory',
      item = item
    })
    SetNuiFocus(true, true)
  end)
end

function displayWarehouseItems()
  ESX.TriggerServerCallback('qnx-lager:getWarehouseItems', function(items)
    SendNUIMessage({
      action = 'lagerItems',
      items = items
    })
  end)
end

function showInfobar(msg)
  SetTextComponentFormat('STRING')
  AddTextComponentString(msg)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
