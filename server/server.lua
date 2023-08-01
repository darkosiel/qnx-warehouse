ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('qnx-lager:getInventory', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  cb(xPlayer.inventory, xPlayer.loadout)
end)

function moneyChecker(money, price)
  if money >= price then
    return true
  end
  return false
end

function ownerCheck(xPlayer, callback)
  MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
    if result[1] then
      callback(false)
    else
      callback(true)
    end
  end)
end

function buyLager(xPlayer, pin, price, type, maxWeight)
  MySQL.Async.execute(
    'INSERT INTO warehouse (identifier, username, pin, price, lagertype, maxWeight, buyTime) VALUES (?, ?, ?, ?, ?, ?, ?)',
    {xPlayer.identifier, xPlayer.getName(), pin, price, type, maxWeight, os.date('!%Y-%m-%d')})
  TriggerClientEvent('warehouse:refresh', xPlayer.source, 'buy')
end

RegisterNetEvent('qnx-lager:buy')
AddEventHandler('qnx-lager:buy', function(type, pin)
  local xPlayer = ESX.GetPlayerFromId(source)

  if type == 'small' then
    if (moneyChecker(xPlayer.getMoney(), Config.Warehouse.small.price)) then
      xPlayer.removeMoney(Config.Warehouse.small.price)
      ownerCheck(xPlayer, function(hasWarehouse) -- given cb
        if hasWarehouse then
          buyLager(xPlayer, pin, Config.Warehouse.small.price, type, Config.Warehouse.small.maxWeight);
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'buy', 'small')
        else
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'maxWarehouse')
        end
      end)
    else
      TriggerClientEvent('warehouse:notify', xPlayer.source, 'noMoney')
    end
  elseif type == 'medium' then
    if (moneyChecker(xPlayer.getMoney(), Config.Warehouse.medium.price)) then
      xPlayer.removeMoney(Config.Warehouse.medium.price)
      ownerCheck(xPlayer, function(hasWarehouse) -- given cb
        if hasWarehouse then
          buyLager(xPlayer, pin, Config.Warehouse.medium.price, type, Config.Warehouse.medium.maxWeight);
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'buy', 'medium')
        else
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'maxWarehouse')
        end
      end)
    else
      TriggerClientEvent('warehouse:notify', xPlayer.source, 'noMoney')
    end
  elseif type == 'big' then
    if (moneyChecker(xPlayer.getMoney(), Config.Warehouse.big.price)) then
      xPlayer.removeMoney(Config.Warehouse.big.price)
      ownerCheck(xPlayer, function(hasWarehouse) -- given cb
        if hasWarehouse then
          buyLager(xPlayer, pin, Config.Warehouse.big.price, type, Config.Warehouse.big.maxWeight);
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'buy', 'big')
        else
          TriggerClientEvent('warehouse:notify', xPlayer.source, 'maxWarehouse')
        end
      end)
    else
      TriggerClientEvent('warehouse:notify', xPlayer.source, 'noMoney')
    end
  end
end)

ESX.RegisterServerCallback('qnx-lager:getWarehouse', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local warehouse = {}

  MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
    for i = 1, #result do
      local label = '';
      local sellPrice = 0;
      local maxWeight = 0;

      if result[i].lagertype == 'small' then
        label = 'KLEINES LAGER'
        sellPrice = Config.Warehouse.small.sellPrice
        maxWeight = Config.Warehouse.small.maxWeight
      elseif result[i].lagertype == 'medium' then
        label = 'MITTLERES LAGER'
        sellPrice = Config.Warehouse.medium.sellPrice
        maxWeight = Config.Warehouse.medium.maxWeight
      elseif result[i].lagertype == 'big' then
        label = 'GROSSES LAGER'
        sellPrice = Config.Warehouse.big.sellPrice
        maxWeight = Config.Warehouse.big.maxWeight
      end

      table.insert(warehouse, {
        label = label,
        price = result[i].price,
        sellPrice = sellPrice,
        maxWeight = maxWeight
      })

    end
    cb(warehouse)
  end)
end)

RegisterNetEvent('qnx-lager:changePin')
AddEventHandler('qnx-lager:changePin', function(pin)
  local xPlayer = ESX.GetPlayerFromId(source)

  ownerCheck(xPlayer, function(hasWarehouse)
    if not hasWarehouse then
      MySQL.Async.execute('UPDATE warehouse SET pin = ? WHERE identifier = ?', {pin, xPlayer.identifier})
    else
      xPlayer.kick('[qnx Guard] - T1')
    end
  end)
end)

RegisterNetEvent('qnx-lager:sellWarehouse')
AddEventHandler('qnx-lager:sellWarehouse', function(pin)
  local xPlayer = ESX.GetPlayerFromId(source)

  ownerCheck(xPlayer, function(owned)
    if not owned then
      MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
        for i = 1, #result do
          if pin == result[i].pin then
            local sellPrice = 0;

            if result[i].lagertype == 'small' then
              sellPrice = Config.Warehouse.small.sellPrice
            elseif result[i].lagertype == 'medium' then
              sellPrice = Config.Warehouse.medium.sellPrice
            elseif result[i].lagertype == 'big' then
              sellPrice = Config.Warehouse.big.sellPrice
            end

            xPlayer.addAccountMoney('bank', sellPrice)

            MySQL.Async.execute('DELETE FROM warehouse WHERE identifier = ?', {xPlayer.identifier})
            TriggerClientEvent('warehouse:refresh', xPlayer.source, 'buy')
          else
            TriggerClientEvent('warehouse:notify', xPlayer.source, 'invalidPin')
          end
        end
      end)
    else
      xPlayer.kick('[qnx Guard] - T1')
    end
  end)
end)

RegisterNetEvent('qnx-lager:enterWarehouse')
AddEventHandler('qnx-lager:enterWarehouse', function(pin)
  local xPlayer = ESX.GetPlayerFromId(source)

  ownerCheck(xPlayer, function(owned)
    if not owned then
      MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
        for i = 1, #result do
          if pin == result[i].pin then
            TriggerClientEvent('qnx-lager:DisplayMarker', xPlayer.source, owned)
          else
            TriggerClientEvent('warehouse:notify', xPlayer.source, 'invalidPin')
          end
        end
      end)
    else
      xPlayer.kick('[qnx Guard] - T1')
    end
  end)
end)

-- lager items
ESX.RegisterServerCallback('qnx-lager:getWarehouseItems', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  local items = {}

  MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
    local lagerWeight = 0;
    for k, v in pairs(json.decode(result[1].items)) do
      lagerWeight = lagerWeight + v.count

      MySQL.Async
        .execute('UPDATE warehouse SET lagerWeight = ? WHERE identifier = ?', {lagerWeight, xPlayer.identifier})

      table.insert(items, {
        name = v.name,
        label = v.label,
        count = v.count,
        myWeight = lagerWeight,
        maxWeight = result[1].maxWeight
      })
    end
    cb(items)
    print('Current weight: ' .. lagerWeight)
  end)
end)

RegisterNetEvent('qnx-lager:putItem')
AddEventHandler('qnx-lager:putItem', function(name, label, count)
  local xPlayer = ESX.GetPlayerFromId(source)

  local arr = {}

  if string.find(name, 'WEAPON_') then
    if count > 1 then
      TriggerClientEvent('warehouse:notify', xPlayer.source, 'owns')
      return
    end
  end

  ownerCheck(xPlayer, function(owned)
    if not owned then
      MySQL.Async.fetchScalar('SELECT items FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result ~= nil then
          arr = json.decode(result)

          local found = false
          for i, v in ipairs(arr) do
            if v.name == name then
              if count > xPlayer.getInventoryItem(name).count then
                TriggerClientEvent('warehouse:notify', xPlayer.source, 'owns')
                return
              end
              v.count = v.count + count
              table.insert(arr, i, v)
              table.remove(arr, i + 1)
              found = true
              break
            end
          end

          if not found then
            table.insert(arr, {
              name = name,
              label = label,
              count = count
            })
          end
        else
          table.insert(arr, {
            name = name,
            label = label,
            count = count
          })
        end

        local lagerWeight = 0;
        for k, v in pairs(arr) do
          lagerWeight = lagerWeight + v.count
        end
        MySQL.Async.fetchAll('SELECT * FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(res)
          if lagerWeight >= res[1].maxWeight then
            TriggerClientEvent('warehouse:notify', xPlayer.source, 'noSpace')
            return
          end
          MySQL.Async.execute('UPDATE warehouse SET items = ? WHERE identifier = ?',
            {json.encode(arr), xPlayer.identifier})
          TriggerClientEvent('warehouse:refresh', xPlayer.source, 'warehouseitems')

          if string.find(name, 'WEAPON_') then
            xPlayer.removeWeapon(name)
          else
            xPlayer.removeInventoryItem(name, count)
          end
        end)

      end)
    else
      xPlayer.kick('[qnx Guard] - T2')
    end
  end)
end)

RegisterNetEvent('qnx-lager:takeItem')
AddEventHandler('qnx-lager:takeItem', function(name, label, count)
  local xPlayer = ESX.GetPlayerFromId(source)

  local arr = {}

  ownerCheck(xPlayer, function(owned)
    if not owned then
      MySQL.Async.fetchScalar('SELECT items FROM warehouse WHERE identifier = ?', {xPlayer.identifier}, function(result)
        if result ~= nil then
          arr = json.decode(result)

          local found = false
          for i, v in ipairs(arr) do
            if v.name == name then
              if string.find(name, 'WEAPON_') then
                if count > 1 then
                  TriggerClientEvent('warehouse:notify', xPlayer.source, 'owns')
                  return
                end
              end
              if count > v.count then
                TriggerClientEvent('warehouse:notify', xPlayer.source, 'owns')
                return
              end
              v.count = v.count - count
              if v.count <= 0 then
                table.remove(arr, i)
              else
                table.insert(arr, i, v)
                table.remove(arr, i + 1)
              end
              found = true
              break
            end
          end

          if not found then
            print('Item not found in warehouse')
          end
        else
          print('Warehouse is empty')
        end

        MySQL.Async.execute('UPDATE warehouse SET items = ? WHERE identifier = ?',
          {json.encode(arr), xPlayer.identifier})
        TriggerClientEvent('warehouse:refresh', xPlayer.source, 'warehouseitems')

        if string.find(name, 'WEAPON_') then
          xPlayer.addWeapon(name, 60)
        else
          xPlayer.addInventoryItem(name, count)
        end
      end)
    else
      xPlayer.kick('[qnx Guard] - T3')
    end
  end)
end)
