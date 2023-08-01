Config = {}

Notify = function(msg, env)
  if env == 'client' then
    TriggerEvent('notifications', '#f1f1f1', 'INFORMATION', msg)
  end
end

Config.Locales = {
  ['helpNotify'] = 'Drücken sie ~INPUT_PICKUP~ um auf das Lager zuzugreifen',
  ['bought'] = 'Du hast das lager #%s gekauft',
  ['maxWarehouse'] = 'Du kannst maximal nur 1 Lager besitzen',
  ['invalidPin'] = 'Der angegebene Pin ist falsch',
  ['ungleich'] = 'Die beiden angegebenen Pins übereinstimmen nicht',
  ['owns'] = 'So viel besitzt du nicht',
  ['noSpace'] = 'So viel platz hast du in deinem Lager nicht zur verfügung',
  ['noMoney'] = 'So viel geld besitzt du nicht!'
}

Config.marker = {
  type = 21,
  rotate = true,
  drawDistance = 30,
  color = {
    r = 9,
    g = 164,
    b = 241,
    a = 140
  },
  size = {
    x = 1.0,
    y = 1.0,
    z = 1.0
  }
}

Config.Warehouse = {
  location = vector3(658.8372, 593.3145, 129.0512),
  heading = 251.6261,

  small = {
    label = 'KLEINES LAGER',
    price = 50000,
    sellPrice = 55000,
    maxWeight = 20
  },
  medium = {
    label = 'MITTLERES LAGER',
    price = 300000,
    sellPrice = 350000,
    maxWeight = 50
  },
  big = {
    label = 'GROSSES LAGER',
    price = 600000,
    sellPrice = 650000,
    maxWeight = 100
  }
}
