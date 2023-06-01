Config = {}

Config.Core = 'qb' -- qb / esx

Config.InventoryHeight = 160


Config.ImagePath = 'nui://qb-inventory/html/images/'

Config.SellLocations = {
    vector3(387.57, 3585.62, 33.29),
}


Config.Items = {
   ['washedstone'] = {
      label = 'Washed Stone',
      price = 100,
   },
   ['weapon_pistol'] = {
      label = 'Pistol',
      price = 5000,
   },
   ['water'] = {
      label = 'Water',
      price = 200,
   },
   ['wine'] = {
      label = 'Wine',
      price = 200,
   },


}

Config.Lang = {
   Header = 'Sell Item For',
      sell = {
        text = '[E] - Sell Items',
        icon = 'cart-shopping',
        position = 'right-center',
        style = {
          borderRadius = 0,
          backgroundColor  = 'green',
          color = 'white'
        }
      },
      selldistance = {
        text = 'Sell Items',
        icon = 'hand',
        position = 'right-center',
        style = {
          borderRadius = 0,
          backgroundColor  = 'red',
          color = 'white'
        },
      },
      Dialog = {
       Title = 'Sell Items',
       label = 'Number of Item',
       description = 'Enter an Amount Higher then 0',
       icon = 'hashtag'
      },
      ErrorSell = {
         id = 'errorr2',
         title = 'ERROR',
         description = 'There is No Item to Sell',
         position = 'top-right',
         style = {
             backgroundColor = 'red',
             color = 'white',
             ['.description'] = {
               color = 'white'
             }
         },
         icon = 'xmark',
         iconColor = 'white'
       },
       SellItem = {
         id = 'sellItemid',
         title = 'ERROR',
         description = 'U succesfully selled',
         position = 'top-right',
         style = {
             backgroundColor = 'green',
             color = 'white',
             ['.description'] = {
               color = 'white'
             }
         },
         icon = 'check',
         iconColor = 'white'
       }, 
   }
